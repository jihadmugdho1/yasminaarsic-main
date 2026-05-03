import 'package:get/get.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/core/utils/constants/image_path.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';
import 'package:yasminaarsic/features/home/data/services/vendor_service.dart';
import 'package:yasminaarsic/features/home/models/vendor_model.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/offer_model.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/vendor_carousel_model.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/vendor_details_model.dart';
import 'package:yasminaarsic/features/home/vendor_details/services/offer_service.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/offer_response_model.dart';

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

    _initializeRestaurantDetails();

    // Listen for language changes and re-initialize restaurant details
    final locale = Get.find<LocalizationController>();
    ever(locale.currentLanguage, (_) {
      _initializeRestaurantDetails();
    });

    // Fetch vendor details if userId is passed
    _fetchVendorDetails();
  }

  Future<void> _fetchVendorDetails() async {
    // Get userId from arguments passed through Get.to()
    final String? userId = Get.arguments;

    if (userId == null || userId.isEmpty) {
      AppLoggerHelper.debug('No userId provided to VendorDetailsScreen');
      return;
    }

    isLoading.value = true;
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
          imageUrl: vendor.imageUrl ?? '',
        );

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
          _initializeDefaultOffers();
        }
      } else {
        AppLoggerHelper.error(
          'Failed to fetch vendor details: ${response.errorMessage}',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching vendor details', e);
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

        // Convert OfferItem list to Offer list
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
            isRedeemed: offerItem.redeemedCount > 0,
          );
        }).toList();

        offers.assignAll(offerList);

        // Update carousel with offer thumbnails from API
        final carouselList = offerList
            .where((o) => o.imageUrl.isNotEmpty)
            .map((o) => CarouselItem(imagePath: o.imageUrl))
            .toList();
        if (carouselList.isNotEmpty) {
          carouselItems.assignAll(carouselList);
        }

        AppLoggerHelper.debug('Offers loaded: ${offerList.length} offers');
      } else {
        AppLoggerHelper.error(
          'Failed to fetch offers: ${response.errorMessage}',
        );
        // Fall back to default offers if API fails
        _initializeDefaultOffers();
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching offers', e);
      // Fall back to default offers if error occurs
      _initializeDefaultOffers();
    } finally {
      offersLoading.value = false;
    }
  }

  void _initializeRestaurantDetails() {
    final locale = Get.find<LocalizationController>();

    // Restaurant details as per card example
    final newRestaurant = VendorDetailsModel(
      name: locale.get('bella_vista_restaurant'),
      category: locale.get('dining_category'),
      description: locale.get('vendor_description'),
      location: locale.get('vendor_location'),
      phone: locale.get('vendor_phone'),
      email: locale.get('vendor_email'),
      website: locale.get('vendor_website'),
      hours: {
        locale.get('hours_mon_thu'): locale.get('hours_mon_thu_time'),
        locale.get('hours_fri_sat'): locale.get('hours_fri_sat_time'),
        locale.get('hours_sun'): locale.get('hours_sun_time'),
      },
      imageUrl: ImagePath.imageFive,
    );

    restaurant.value = newRestaurant;

    // Initialize with default offers
    _initializeDefaultOffers();
  }

  void _initializeDefaultOffers() {
    final locale = Get.find<LocalizationController>();

    // Default offer list (used as fallback when API fails)
    final newOffers = [
      Offer(
        title: locale.get('offer_title_1'),
        restaurantName: locale.get('bella_vista_restaurant'),
        description: locale.get('offer_desc_1'),
        location: locale.get('vendor_location'),
        imageUrl: ImagePath.imageFive,
        category: locale.get('dining_category'),
        expiryDate: DateTime(2025, 12, 31),
        isReuseable: false, // One-time offer
      ),
      Offer(
        title: locale.get('offer_title_2'),
        restaurantName: locale.get('bella_vista_restaurant'),
        description: locale.get('offer_desc_2'),
        location: locale.get('vendor_location'),
        imageUrl: ImagePath.imageThree,
        category: locale.get('dining_category'),
        expiryDate: DateTime(2025, 12, 15),
        isReuseable: true, // Reuseable offer
      ),
      Offer(
        title: locale.get('offer_title_3'),
        restaurantName: locale.get('bella_vista_restaurant'),
        description: locale.get('offer_desc_3'),
        location: locale.get('vendor_location'),
        imageUrl: ImagePath.imageTwo,
        category: locale.get('dining_category'),
        expiryDate: DateTime(2025, 12, 25),
        isReuseable: false, // One-time offer
      ),
    ];

    offers.assignAll(newOffers);
  }

  // ✅ Method to update a specific offer
  void updateOfferAtIndex(int index, Offer updatedOffer) {
    if (index >= 0 && index < offers.length) {
      print(
        'Updating offer at index $index - Title: ${updatedOffer.title}, isRedeemed: ${updatedOffer.isRedeemed}',
      );
      offers[index] = updatedOffer;
      offers.refresh(); // Force UI update
      print(
        'Offers list after update: ${offers.map((o) => '${o.title}: ${o.isRedeemed}').toList()}',
      );
    }
  }

  // ✅ Method to mark a specific offer as redeemed
  void markOfferAsRedeemed(int index) {
    if (index >= 0 && index < offers.length) {
      print(
        'Marking offer at index $index as redeemed - Before: ${offers[index].title}, isRedeemed: ${offers[index].isRedeemed}',
      );
      final updatedOffer = offers[index].copyWith(isRedeemed: true);
      print(
        'Created updated offer - Title: ${updatedOffer.title}, isRedeemed: ${updatedOffer.isRedeemed}',
      );
      updateOfferAtIndex(index, updatedOffer);
    }
  }

  /// Fetch detailed offer information by offer ID
  Future<void> fetchOfferDetails(String offerId) async {
    offerDetailLoading.value = true;
    try {
      final response = await _offerService.getOfferById(offerId);

      if (response.isSuccess && response.responseData != null) {
        selectedOfferDetail.value =
            response.responseData as Map<String, dynamic>;
        AppLoggerHelper.debug(
          'Offer details fetched: ${selectedOfferDetail.value?['title']}',
        );
      } else {
        AppLoggerHelper.error(
          'Failed to fetch offer details: ${response.errorMessage}',
        );
        selectedOfferDetail.value = null;
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching offer details', e);
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
          imageUrl: vendor.imageUrl ?? '',
        );

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
          _initializeDefaultOffers();
        }
      } else {
        AppLoggerHelper.error(
          'Failed to refresh vendor details: ${response.errorMessage}',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error refreshing vendor details', e);
    } finally {
      isLoading.value = false;
    }
  }
}
