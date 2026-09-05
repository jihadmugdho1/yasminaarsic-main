import 'package:get/get.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/home/data/services/vendor_service.dart';
import 'package:vendora/features/home/models/vendor_model.dart';
import 'package:vendora/features/home/vendor_details/models/offer_model.dart';
import 'package:vendora/features/home/vendor_details/models/vendor_carousel_model.dart';
import 'package:vendora/features/home/vendor_details/models/vendor_details_model.dart';
import 'package:vendora/features/home/vendor_details/services/offer_service.dart';
import 'package:vendora/features/home/vendor_details/models/offer_response_model.dart';

class VendorDetailsController extends GetxController {
  final currentIndex = 0.obs;
  final isLoading = false.obs;
  final offersLoading = false.obs;
  final offerDetailLoading = false.obs;
  final VendorService _vendorService = VendorService();
  final OfferService _offerService = OfferService();
  final Rx<Map<String, dynamic>?> selectedOfferDetail =
      Rx<Map<String, dynamic>?>(null);

  final RxList<CarouselItem> carouselItems = <CarouselItem>[].obs;

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  late Rx<VendorDetailsModel> restaurant;
  late RxList<Offer> offers;
  late Rx<VendorModel?> vendorData;

  @override
  void onInit() {
    super.onInit();

    // Initialize the reactive variables first
    restaurant = VendorDetailsModel(
      name: '',
      category: '',
      description: '',
      location: '',
      phone: '',
      email: '',
      website: '',
      hours: {},
      imageUrl: '',
    ).obs;
    offers = <Offer>[].obs;
    vendorData = Rx<VendorModel?>(null);

    // Start in loading state
    isLoading.value = true;
    offersLoading.value = true;

    // Fetch vendor details if userId is passed
    _fetchVendorDetails();
  }

  Future<void> _fetchVendorDetails() async {
    // Get userId from arguments passed through Get.to()
    final String? userId = Get.arguments;

    if (userId == null || userId.isEmpty) {
      AppLoggerHelper.debug('No userId provided to VendorDetailsScreen');
      isLoading.value = false;
      offersLoading.value = false;
      return;
    }

    isLoading.value = true;
    offersLoading.value = true;

    try {
      final response = await _vendorService.getVendorById(userId);

      if (response.isSuccess && response.responseData != null) {
        final vendor = response.responseData as VendorModel;
        vendorData.value = vendor;

        // Update restaurant details with vendor data
        restaurant.value = VendorDetailsModel(
          name: vendor.vendorProfile?.businessName ?? vendor.name,
          category: vendor.vendorProfile?.category?.name ?? '',
          description: '',
          location: vendor.vendorProfile?.city ?? '',
          phone: vendor.phone ?? '',
          email: vendor.email,
          website: '',
          hours: {},
          imageUrl: vendor.vendorProfile?.logoUrl ?? vendor.imageUrl ?? '',
        );

        // Build carousel from vendorProfile images + logoUrl
        _buildCarouselFromProfile(vendor.vendorProfile);

        AppLoggerHelper.debug(
          'Vendor details loaded: ${vendor.vendorProfile?.businessName ?? vendor.name}',
        );

        // Fetch offers for this vendor using vendorProfile ID
        final vendorProfileId = vendor.vendorProfile?.id;
        if (vendorProfileId != null && vendorProfileId.isNotEmpty) {
          await _fetchVendorOffers(vendorProfileId);
        } else {
          AppLoggerHelper.error(
            'No vendorProfile ID available for fetching offers',
          );
          offers.clear();
          offersLoading.value = false;
        }
      } else {
        AppLoggerHelper.error(
          'Failed to fetch vendor details: ${response.errorMessage}',
        );
        offers.clear();
        offersLoading.value = false;
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching vendor details', e);
      offers.clear();
      offersLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchVendorOffers(String vendorId) async {
    offersLoading.value = true;
    try {
      final response = await _offerService.getVendorOffers(
        vendorId: vendorId,
        page: 1,
        limit: 10,
      );

      if (response.isSuccess && response.responseData != null) {
        final offerResponse = response.responseData as OfferResponse;

        // Convert OfferItem list to Offer list with real IDs
        final offerList = offerResponse.data.offers.map((offerItem) {
          return Offer(
            id: offerItem.id,
            title: offerItem.title,
            restaurantName:
                vendorData.value?.vendorProfile?.businessName ??
                vendorData.value?.name ??
                '',
            description: offerItem.description,
            location: vendorData.value?.vendorProfile?.city ?? '',
            imageUrl: offerItem.thumbnail ?? '',
            category: offerItem.type,
            expiryDate: offerItem.validUntil,
            isReuseable: offerItem.isReusable,
          );
        }).toList();

        offers.assignAll(offerList);
        AppLoggerHelper.debug(
          'Loaded ${offerList.length} real offers for vendor $vendorId',
        );
      } else {
        AppLoggerHelper.error(
          'Failed to fetch offers: ${response.errorMessage}',
        );
        offers.clear();
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching offers', e);
      offers.clear();
    } finally {
      offersLoading.value = false;
    }
  }

  void _buildCarouselFromProfile(VendorProfileModel? profile) {
    final List<String> urls = [];
    if (profile != null) {
      urls.addAll(profile.images);
      if (profile.logoUrl != null && profile.logoUrl!.isNotEmpty) {
        urls.add(profile.logoUrl!);
      }
    }
    if (urls.isNotEmpty) {
      carouselItems.assignAll(urls.map((url) => CarouselItem(imagePath: url)));
    }
  }

  // ✅ Method to update a specific offer
  void updateOfferAtIndex(int index, Offer updatedOffer) {
    if (index >= 0 && index < offers.length) {
      offers[index] = updatedOffer;
      offers.refresh(); // Force UI update
    }
  }

  /// Fetch detailed offer information by offer ID: GET /api/v1/offer/:offerId
  Future<void> fetchOfferDetails(String offerId) async {
    offerDetailLoading.value = true;
    selectedOfferDetail.value = null; // Clear previous state
    try {
      AppLoggerHelper.debug('Calling GET offer details API for offer ID: $offerId');
      final response = await _offerService.getOfferById(offerId);

      if (response.isSuccess && response.responseData != null) {
        selectedOfferDetail.value =
            response.responseData as Map<String, dynamic>;
        AppLoggerHelper.debug(
          'Offer details fetched successfully: id=${selectedOfferDetail.value?['id']}, title=${selectedOfferDetail.value?['title']}',
        );
      } else {
        AppLoggerHelper.error(
          'Failed to fetch offer details for ID $offerId: ${response.errorMessage}',
        );
        selectedOfferDetail.value = null;
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching offer details for ID $offerId', e);
      selectedOfferDetail.value = null;
    } finally {
      offerDetailLoading.value = false;
    }
  }

  Future<void> refreshVendorDetails() async {
    // Get userId from arguments passed through Get.to()
    final String? userId = Get.arguments;

    if (userId == null || userId.isEmpty) {
      AppLoggerHelper.debug('No userId provided to VendorDetailsScreen');
      return;
    }

    isLoading.value = true;
    offersLoading.value = true;
    try {
      final response = await _vendorService.getVendorById(userId);

      if (response.isSuccess && response.responseData != null) {
        final vendor = response.responseData as VendorModel;
        vendorData.value = vendor;

        // Update restaurant details with vendor data
        restaurant.value = VendorDetailsModel(
          name: vendor.vendorProfile?.businessName ?? vendor.name,
          category: vendor.vendorProfile?.category?.name ?? '',
          description: '',
          location: vendor.vendorProfile?.city ?? '',
          phone: vendor.phone ?? '',
          email: vendor.email,
          website: '',
          hours: {},
          imageUrl: vendor.vendorProfile?.logoUrl ?? vendor.imageUrl ?? '',
        );

        // Rebuild carousel from vendorProfile images + logoUrl
        _buildCarouselFromProfile(vendor.vendorProfile);

        AppLoggerHelper.debug(
          'Vendor details refreshed: ${vendor.vendorProfile?.businessName ?? vendor.name}',
        );

        // Fetch offers for this vendor using vendorProfile ID
        final vendorProfileId = vendor.vendorProfile?.id;
        if (vendorProfileId != null && vendorProfileId.isNotEmpty) {
          await _fetchVendorOffers(vendorProfileId);
        } else {
          AppLoggerHelper.error(
            'No vendorProfile ID available for fetching offers',
          );
          offers.clear();
          offersLoading.value = false;
        }
      } else {
        AppLoggerHelper.error(
          'Failed to refresh vendor details: ${response.errorMessage}',
        );
        offersLoading.value = false;
      }
    } catch (e) {
      AppLoggerHelper.error('Error refreshing vendor details', e);
      offersLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
