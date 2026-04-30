import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/core/utils/constants/image_path.dart';
import 'package:yasminaarsic/features/home/data/services/category_service.dart';
import 'package:yasminaarsic/features/home/data/services/offer_service.dart';
import 'package:yasminaarsic/features/home/data/services/vendor_service.dart';
import 'package:yasminaarsic/features/home/models/carousel_model.dart';
import 'package:yasminaarsic/features/home/models/category_model.dart';
import 'package:yasminaarsic/features/home/models/offer_model.dart';
import 'package:yasminaarsic/features/home/models/offer_api_model.dart';
import 'package:yasminaarsic/features/home/models/vendor_model.dart'
    as vendor_models;
import 'package:yasminaarsic/routes/app_routes.dart';

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

  @override
  void onInit() {
    super.onInit();
    locale = Get.find<LocalizationController>();

    // Initialize the lists as empty first
    trendingOffers = <OfferModel>[].obs;
    newOffers = <OfferModel>[].obs;
    categories = <CategoryModel>[].obs;

    _initializeOffers();
    _loadCategories();

    // Listen for language changes and re-initialize offers
    ever(locale.currentLanguage, (_) {
      _initializeOffers();
    });
  }

  void _initializeOffers() {
    // Pass translation keys instead of translated strings
    trendingOffers.assignAll(
      List.generate(5, (index) {
        return OfferModel(
          imagePath: ImagePath.imageSeven,
          title: 'food_drinks',
          location: 'downtown_city_center',
          categoryLabel: 'dining',
        );
      }),
    );

    newOffers.assignAll(
      List.generate(5, (index) {
        return OfferModel(
          imagePath: ImagePath.imageFive,
          title: 'food_drinks',
          location: 'downtown_city_center',
          categoryLabel: 'dining',
        );
      }),
    );
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
    final selectedCat = categories[categoryIndex];

    try {
      // If "All Offers" is selected, fetch from all actual categories
      if (selectedCat.id == 'all') {
        final actualCategories = categories
            .skip(1)
            .toList(); // Skip "All Offers"
        final List<OfferApiModel> allNewOffers = [];
        final List<OfferApiModel> allTrendingOffers = [];

        for (var cat in actualCategories) {
          // Fetch newest offers for each category
          final newestResponse = await _offerService.getNewestOffers(
            categoryId: cat.id,
            limit: 50, // Load more for all
          );

          if (newestResponse.isSuccess && newestResponse.responseData != null) {
            allNewOffers.addAll(
              newestResponse.responseData as List<OfferApiModel>,
            );
          }

          // Fetch trending offers for each category
          final trendingResponse = await _offerService.getTrendingOffers(
            categoryId: cat.id,
            limit: 50, // Load more for all
          );

          if (trendingResponse.isSuccess &&
              trendingResponse.responseData != null) {
            allTrendingOffers.addAll(
              trendingResponse.responseData as List<OfferApiModel>,
            );
          }
        }

        // Convert to OfferModel and assign
        newOffers.assignAll(
          allNewOffers.map((apiOffer) {
            final hasValidThumbnail = apiOffer.thumbnail.isNotEmpty;
            return OfferModel(
              imagePath: hasValidThumbnail
                  ? 'https://yasminaarsic-server.onrender.com${apiOffer.thumbnail}'
                  : ImagePath.imageFive,
              title: apiOffer.title,
              location: apiOffer.vendorProfile?.city ?? 'Unknown',
              categoryLabel: apiOffer.vendorProfile?.categoryId ?? 'All',
              isNetworkImage: hasValidThumbnail,
              offerApiData: apiOffer,
            );
          }).toList(),
        );

        trendingOffers.assignAll(
          allTrendingOffers.map((apiOffer) {
            final hasValidThumbnail = apiOffer.thumbnail.isNotEmpty;
            return OfferModel(
              imagePath: hasValidThumbnail
                  ? 'https://yasminaarsic-server.onrender.com${apiOffer.thumbnail}'
                  : ImagePath.imageSeven,
              title: apiOffer.title,
              location: apiOffer.vendorProfile?.city ?? 'Unknown',
              categoryLabel: apiOffer.vendorProfile?.categoryId ?? 'All',
              isNetworkImage: hasValidThumbnail,
              offerApiData: apiOffer,
            );
          }).toList(),
        );
        // For "all", no more loading
        hasMoreNewOffers.value = false;
        hasMoreTrendingOffers.value = false;
      } else {
        // Fetch newest offers for specific category
        final newestResponse = await _offerService.getNewestOffers(
          categoryId: selectedCat.id,
          limit: 10,
          page: newOffersPage.value,
        );

        // Fetch trending offers for specific category
        final trendingResponse = await _offerService.getTrendingOffers(
          categoryId: selectedCat.id,
          limit: 10,
          page: trendingOffersPage.value,
        );

        if (newestResponse.isSuccess && newestResponse.responseData != null) {
          final newestOffersApi =
              newestResponse.responseData as List<OfferApiModel>;
          newOffers.assignAll(
            newestOffersApi.map((apiOffer) {
              final hasValidThumbnail = apiOffer.thumbnail.isNotEmpty;
              return OfferModel(
                imagePath: hasValidThumbnail
                    ? 'https://yasminaarsic-server.onrender.com${apiOffer.thumbnail}'
                    : ImagePath.imageFive,
                title: apiOffer.title,
                location: apiOffer.vendorProfile?.city ?? 'Unknown',
                categoryLabel: selectedCat.name,
                isNetworkImage: hasValidThumbnail,
                offerApiData: apiOffer,
              );
            }).toList(),
          );
          hasMoreNewOffers.value = newestOffersApi.length == 10;
        } else {
          newOffers.clear();
          hasMoreNewOffers.value = false;
        }

        if (trendingResponse.isSuccess &&
            trendingResponse.responseData != null) {
          final trendingOffersApi =
              trendingResponse.responseData as List<OfferApiModel>;
          trendingOffers.assignAll(
            trendingOffersApi.map((apiOffer) {
              final hasValidThumbnail = apiOffer.thumbnail.isNotEmpty;
              return OfferModel(
                imagePath: hasValidThumbnail
                    ? 'https://yasminaarsic-server.onrender.com${apiOffer.thumbnail}'
                    : ImagePath.imageSeven,
                title: apiOffer.title,
                location: apiOffer.vendorProfile?.city ?? 'Unknown',
                categoryLabel: selectedCat.name,
                isNetworkImage: hasValidThumbnail,
                offerApiData: apiOffer,
              );
            }).toList(),
          );
          hasMoreTrendingOffers.value = trendingOffersApi.length == 10;
        } else {
          trendingOffers.clear();
          hasMoreTrendingOffers.value = false;
        }
      }
    } catch (e) {
      print('Error loading offers: $e');
      newOffers.clear();
      trendingOffers.clear();
    } finally {
      isLoadingOffers.value = false;
    }
  }

  Future<void> loadMoreNewOffers() async {
    if (!hasMoreNewOffers.value ||
        isLoadingMoreNew.value ||
        selectedCategory.value == 0)
      return;

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
        final newOffersApi = response.responseData as List<OfferApiModel>;
        final newModels = newOffersApi.map((apiOffer) {
          final hasValidThumbnail = apiOffer.thumbnail.isNotEmpty;
          return OfferModel(
            imagePath: hasValidThumbnail
                ? 'https://yasminaarsic-server.onrender.com${apiOffer.thumbnail}'
                : ImagePath.imageFive,
            title: apiOffer.title,
            location: apiOffer.vendorProfile?.city ?? 'Unknown',
            categoryLabel: selectedCat.name,
            isNetworkImage: hasValidThumbnail,
            offerApiData: apiOffer,
          );
        }).toList();
        newOffers.addAll(newModels);
        hasMoreNewOffers.value = newOffersApi.length == 10;
      } else {
        hasMoreNewOffers.value = false;
      }
    } catch (e) {
      print('Error loading more new offers: $e');
      hasMoreNewOffers.value = false;
    } finally {
      isLoadingMoreNew.value = false;
    }
  }

  Future<void> loadMoreTrendingOffers() async {
    if (!hasMoreTrendingOffers.value ||
        isLoadingMoreTrending.value ||
        selectedCategory.value == 0)
      return;

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
        final newOffersApi = response.responseData as List<OfferApiModel>;
        final newModels = newOffersApi.map((apiOffer) {
          final hasValidThumbnail = apiOffer.thumbnail.isNotEmpty;
          return OfferModel(
            imagePath: hasValidThumbnail
                ? 'https://yasminaarsic-server.onrender.com${apiOffer.thumbnail}'
                : ImagePath.imageSeven,
            title: apiOffer.title,
            location: apiOffer.vendorProfile?.city ?? 'Unknown',
            categoryLabel: selectedCat.name,
            isNetworkImage: hasValidThumbnail,
            offerApiData: apiOffer,
          );
        }).toList();
        trendingOffers.addAll(newModels);
        hasMoreTrendingOffers.value = newOffersApi.length == 10;
      } else {
        hasMoreTrendingOffers.value = false;
      }
    } catch (e) {
      print('Error loading more trending offers: $e');
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
      print('Error searching vendors: $e');
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
