import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/features/home/controller/pop_up_controller.dart';
import 'package:yasminaarsic/features/home/models/pop_up_offer_model.dart';

class PopupOfferWidget extends StatelessWidget {
  final PopupOfferController controller;

  const PopupOfferWidget({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isVisible.value) return SizedBox.shrink();

      PopupOfferModel model = controller.offerModel;

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F2C7),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 14),
                      child: Icon(
                        Icons.warning_rounded,
                        color: Colors.amber[700],
                        size: 30.h,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.title,
                            style: TextStyle(
                              fontFamily: "poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            model.trialDuration,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.hidePopup(),
                      child: Icon(Icons.close, color: Colors.black54, size: 22),
                    ),
                  ],
                ),
                // Positioned(
                //   right: 0,
                //   bottom: 0,
                //   child: GestureDetector(
                //     onTap: () {
                //       // Handle "Sign Up" pressed, e.g. navigate or do action
                //       controller.hidePopup();
                //     },
                //     child: Text(
                //       model.actionLabel,
                //       style: TextStyle(
                //         color: Colors.deepPurple,
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //         decoration: TextDecoration.underline,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      );
    });
  }
}
