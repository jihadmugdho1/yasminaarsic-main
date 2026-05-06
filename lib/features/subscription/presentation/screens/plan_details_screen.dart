import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/utils/constants/colors.dart';
import 'package:yasminaarsic/features/subscription/controller/subscription_controller.dart';
import 'package:yasminaarsic/features/subscription/data/subscription_plan_model.dart';
import 'package:yasminaarsic/core/common/widgets/custom_button.dart';

class PlanDetailsScreen extends StatefulWidget {
  final SubscriptionPlanModel plan;

  const PlanDetailsScreen({super.key, required this.plan});

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  late final SubscriptionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<SubscriptionController>()
        ? Get.find<SubscriptionController>()
        : Get.put(SubscriptionController());
    _controller.openPlanDetails(widget.plan);
  }

  @override
  void dispose() {
    _controller.closePlanDetails();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final basePrice = double.tryParse(widget.plan.price) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Plan Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card

              // Plan Information Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plan Name
                      _buildDetailRow(
                        icon: Icons.card_membership_outlined,
                        label: 'Plan Name',
                        value: widget.plan.name,
                      ),
                      SizedBox(height: 16.h),
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      SizedBox(height: 16.h),

                      // Description
                      _buildDetailRow(
                        icon: Icons.description_outlined,
                        label: 'Description',
                        value: widget.plan.description,
                      ),
                      SizedBox(height: 16.h),
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      SizedBox(height: 16.h),

                      // Duration
                      _buildDetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Duration',
                        value: '${widget.plan.durationInDays} Days',
                      ),
                      SizedBox(height: 16.h),
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      SizedBox(height: 16.h),

                      // Base Price
                      _buildDetailRow(
                        icon: Icons.attach_money_outlined,
                        label: 'Base Price',
                        value:
                            '${widget.plan.currency} ${basePrice.toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 16.h),
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      SizedBox(height: 16.h),

                      // Current Price Display
                      _buildDetailRow(
                        icon: Icons.local_offer_outlined,
                        label: 'Current Price',
                        value: widget.plan.currentPriceDisplay,
                      ),
                      SizedBox(height: 16.h),
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      SizedBox(height: 16.h),

                      // Status
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4A5565),
                                    fontFamily: 'Arial',
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.plan.isActive
                                        ? const Color(0xFFF4DB35)
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    widget.plan.isActive
                                        ? 'Active'
                                        : 'Inactive',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Promo Code Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Have a Promo Code?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Arial',
                        color: const Color(0xFF101828),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(() {
                      final isApplied = _controller.isPromoApplied.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller.promoCodeController,

                                  decoration: InputDecoration(
                                    hintText: 'Enter promo code',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14.sp,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF3F3F5),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 12.h,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6C63FE),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              CustomButton(
                                text: 'Apply',
                                textColor: Colors.white,
                                backgroundColor: isApplied
                                    ? Colors.green
                                    : const Color(0xFF6C63FE),
                                type: ButtonType.filled,
                                minWidth: 80.w,
                                borderRadius: 8.r,
                                height: 45.h,
                                onPressed: () {
                                  _controller.applyPromoCode();
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              Obx(
                () => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Applied Promo Code: ${_controller.isPromoApplied.value ? _controller.appliedPromoCode.value : 'None'}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),

              // Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Obx(() {
                      final isCheckingOut = _controller.isCheckingOut.value;
                      return CustomButton(
                        text: isCheckingOut
                            ? 'Processing...'
                            : 'Proceed to Checkout',
                        textColor: Colors.white,
                        backgroundColor: const Color(0xFF6C63FE),
                        type: ButtonType.filled,
                        minWidth: double.infinity,
                        borderRadius: 8.r,
                        height: 48.h,
                        onPressed: isCheckingOut
                            ? null
                            : _controller.checkoutSelectedPlan,
                      );
                    }),
                    SizedBox(height: 12.h),
                    CustomButton(
                      text: 'Cancel',
                      textColor: const Color(0xFF6C63FE),
                      backgroundColor: Colors.white,
                      type: ButtonType.outlined,
                      minWidth: double.infinity,
                      borderRadius: 8.r,
                      height: 48.h,
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey[600]),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4A5565),
                  fontFamily: 'Arial',
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Arial',
                  color: const Color(0xFF101828),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
