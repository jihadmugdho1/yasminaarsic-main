import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/features/home/data/services/category_service.dart';
import 'package:yasminaarsic/features/home/data/services/hero_slider_service.dart';
import 'package:yasminaarsic/features/home/data/services/offer_service.dart';
import 'package:yasminaarsic/features/home/data/services/vendor_service.dart';
import 'package:yasminaarsic/features/home/models/carousel_model.dart';
import 'package:yasminaarsic/features/home/models/category_model.dart';
import 'package:yasminaarsic/features/home/models/offer_model.dart';
import 'package:yasminaarsic/features/home/models/offer_api_model.dart';
import 'package:yasminaarsic/features/home/models/vendor_model.dart'
    as vendor_models;
import 'package:yasminaarsic/routes/app_routes.dart';

OfferModel _toOfferModel(OfferApiModel api, String categoryLabel) {
  return OfferModel(
    imagePath: api.thumbnail.isNotEmpty ? api.thumbnail : ImagePath.imageFive,
    title: api.title,
    location: api.vendorProfile?.city ?? '',
    categoryLabel: categoryLabel,
    isNetworkImage: api.thumbnail.isNotEmpty,
    offerApiData: api,
  );
}

class HomeController extends GetxController {
  late LocalizationController locale;

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  final RxList<vendor_models.VendorModel> searchResults =
      <vendor_models.VendorModel>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool showSearchResults = false.obs;

  // Carousel images
  final RxList<CarouselModel> carouselItems = [
    CarouselModel(imagePath: ImagePath.imageFive),
    CarouselModel(imagePath: ImagePath.imageSix),
    CarouselModel(imagePath: ImagePath.imageOne),
    CarouselModel(imagePath: ImagePath.imageThree),
    CarouselModel(imagePath: ImagePath.imageFour),
    CarouselModel(imagePath: ImagePath.imageTwo),
  ].obs;
  final RxList<String> sliderImageUrls = <String>[].obs;
  final RxBool isLoadingSlider = true.obs;

  late RxList<OfferModel> trendingOffers;
  late RxList<OfferModel> newOffers;

  final RxInt selectedCategory = 0.obs;
  final RxInt currentIndex = 0.obs;

  late RxList<CategoryModel> categories;
  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingOffers = false.obs;

  // Pagination
  final RxInt newOffersPage = 1.obs;
  final RxInt trendingOffersPage = 1.obs;
  final RxBool hasMoreNewOffers = true.obs;
  final RxBool hasMoreTrendingOffers = true.obs;
  final RxBool isLoadingMoreNew = false.obs;
  final RxBool isLoadingMoreTrending = false.obs;

  final CategoryService _categoryService = CategoryService();
  final OfferService _offerService = OfferService();
  final VendorService _vendorService = VendorService();
  final HeroSliderService _heroSliderService = HeroSliderService();

  @override
  void onInit() {
    super.onInit();
    locale = Get.find<LocalizationController>();

    trendingOffers = <OfferModel>[].obs;
    newOffers = <OfferModel>[].obs;
    categories = <CategoryModel>[].obs;

    _loadCategories();
    _loadSliderImages();
  }

  Future<void> _loadSliderImages() async {
    isLoadingSlider.value = true;
    try {
      final response = await _heroSliderService.getActiveSliders();
      if (response.isSuccess && response.responseData != null) {
        final urls = response.responseData as List<String>;
        if (urls.isNotEmpty) {
          final context = Get.context;
          if (context != null) {
            await Future.wait(
              urls.map((url) => precacheImage(NetworkImage(url), context)),
            );
          }
          sliderImageUrls.assignAll(urls);
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Error loading slider images', e);
    } finally {
      isLoadingSlider.value = false;
    }
  }

  Future<void> _loadCategories() async {
    isLoadingCategories.value = true;
    try {
      final response = await _categoryService.getCategories();
      if (response.isSuccess && response.responseData != null) {
        final apiCategories = response.responseData as List<CategoryModel>;
        // Always include "All Offers" as the first category
        categories.assignAll([
          CategoryModel(
            id: 'all',
            name: 'All Offers',
            icon: IconPath.offerIcon,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          ...apiCategories,
        ]);
      } else {
        // If API fails, show only "All Offers"
        categories.assignAll([
          CategoryModel(
            id: 'all',
            name: 'All Offers',
            icon: IconPath.offerIcon,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ]);
      }
    } catch (e) {
      // If error, show only "All Offers"
      categories.assignAll([
        CategoryModel(
          id: 'all',
          name: 'All Offers',
          icon: IconPath.offerIcon,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ]);
    } finally {
      isLoadingCategories.value = false;
      // Load offers for the default selected category after categories are loaded
      _loadOffersByCategory(selectedCategory.value);
    }
  }

  void setSelectedCategory(int index) {
    selectedCategory.value = index;
    // Reset pagination
    newOffersPage.value = 1;
    trendingOffersPage.value = 1;
    hasMoreNewOffers.value = true;
    hasMoreTrendingOffers.value = true;
    _loadOffersByCategory(index);
  }

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> _loadOffersByCategory(int categoryIndex) async {
    if (categoryIndex >= categories.length) return;

    isLoadingOffers.value = true;
    newOffers.clear();
    trendingOffers.clear();

    final selectedCat = categories[categoryIndex];

    try {
      if (selectedCat.id == 'all') {
        // Single call for all offers — no category filter
        final response = await _offerService.getOffers(
          limit: 10,
          page: 1,
        );
        if (response.isSuccess && response.responseData != null) {
          final data = response.responseData as Map<String, dynamic>;
          final offers = data['offers'] as List<OfferApiModel>;
          final totalPages = data['totalPages'] as int;
          newOffers.assignAll(offers.map((o) => _toOfferModel(o, 'All')));
          trendingOffers.assignAll(offers.map((o) => _toOfferModel(o, 'All')));
          hasMoreNewOffers.value = totalPages > 1;
          hasMoreTrendingOffers.value = totalPages > 1;
        } else {
          hasMoreNewOffers.value = false;
          hasMoreTrendingOffers.value = false;
        }
      } else {
        final results = await Future.wait([
          _offerService.getNewestOffers(
            categoryId: selectedCat.id,
            limit: 10,
            page: newOffersPage.value,
          ),
          _offerService.getTrendingOffers(
            categoryId: selectedCat.id,
            limit: 10,
            page: trendingOffersPage.value,
          ),
        ]);

        final newestResponse = results[0];
        final trendingResponse = results[1];

        if (newestResponse.isSuccess && newestResponse.responseData != null) {
          final data = newestResponse.responseData as Map<String, dynamic>;
          final offers = data['offers'] as List<OfferApiModel>;
          final totalPages = data['totalPages'] as int;
          newOffers.assignAll(offers.map((o) => _toOfferModel(o, selectedCat.name)));
          hasMoreNewOffers.value = newOffersPage.value < totalPages;
        } else {
          hasMoreNewOffers.value = false;
        }

        if (trendingResponse.isSuccess && trendingResponse.responseData != null) {
          final data = trendingResponse.responseData as Map<String, dynamic>;
          final offers = data['offers'] as List<OfferApiModel>;
          final totalPages = data['totalPages'] as int;
          trendingOffers.assignAll(offers.map((o) => _toOfferModel(o, selectedCat.name)));
          hasMoreTrendingOffers.value = trendingOffersPage.value < totalPages;
        } else {
          hasMoreTrendingOffers.value = false;
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Error loading offers', e);
    } finally {
      isLoadingOffers.value = false;
    }
  }

  Future<void> loadMoreNewOffers() async {
    if (!hasMoreNewOffers.value || isLoadingMoreNew.value || selectedCategory.value == 0) return;

    isLoadingMoreNew.value = true;
    newOffersPage.value++;

    final selectedCat = categories[selectedCategory.value];
    try {
      final response = await _offerService.getNewestOffers(
        categoryId: selectedCat.id,
        limit: 10,
        page: newOffersPage.value,
      );
      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;
        final offers = data['offers'] as List<OfferApiModel>;
        final totalPages = data['totalPages'] as int;
        newOffers.addAll(offers.map((o) => _toOfferModel(o, selectedCat.name)));
        hasMoreNewOffers.value = newOffersPage.value < totalPages;
      } else {
        hasMoreNewOffers.value = false;
      }
    } catch (e) {
      AppLoggerHelper.error('Error loading more new offers', e);
      hasMoreNewOffers.value = false;
    } finally {
      isLoadingMoreNew.value = false;
    }
  }

  Future<void> loadMoreTrendingOffers() async {
    if (!hasMoreTrendingOffers.value || isLoadingMoreTrending.value || selectedCategory.value == 0) return;

    isLoadingMoreTrending.value = true;
    trendingOffersPage.value++;

    final selectedCat = categories[selectedCategory.value];
    try {
      final response = await _offerService.getTrendingOffers(
        categoryId: selectedCat.id,
        limit: 10,
        page: trendingOffersPage.value,
      );
      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;
        final offers = data['offers'] as List<OfferApiModel>;
        final totalPages = data['totalPages'] as int;
        trendingOffers.addAll(offers.map((o) => _toOfferModel(o, selectedCat.name)));
        hasMoreTrendingOffers.value = trendingOffersPage.value < totalPages;
      } else {
        hasMoreTrendingOffers.value = false;
      }
    } catch (e) {
      AppLoggerHelper.error('Error loading more trending offers', e);
      hasMoreTrendingOffers.value = false;
    } finally {
      isLoadingMoreTrending.value = false;
    }
  }

  // Search functionality
  void onSearchChanged(String query) {
    if (query.isEmpty) {
      showSearchResults.value = false;
      searchResults.clear();
      return;
    }

    showSearchResults.value = true;
    _performSearch(query);
  }

  void clearSearch() {
    searchController.clear();
    showSearchResults.value = false;
    searchResults.clear();
  }

  Future<void> _performSearch(String query) async {
    if (query.length < 2) return; // Minimum 2 characters for search

    isSearching.value = true;
    try {
      final response = await _vendorService.searchVendors(query);
      if (response.isSuccess && response.responseData != null) {
        final vendors =
            response.responseData as List<vendor_models.VendorModel>;
        // Filter results by business name (case-insensitive)
        final filtered = vendors.where((v) {
          final business = v.vendorProfile?.businessName ?? '';
          return business.toLowerCase().contains(query.toLowerCase());
        }).toList();
        searchResults.assignAll(filtered);
      } else {
        searchResults.clear();
      }
    } catch (e) {
      AppLoggerHelper.error('Error searching vendors', e);
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void onSearchVendorTap(vendor_models.VendorModel vendor) {
    // Navigate to vendor details
    Get.toNamed(AppRoute.vendorDetailsScreen, arguments: vendor.id);
    clearSearch(); // Clear search after navigation
  }
}
