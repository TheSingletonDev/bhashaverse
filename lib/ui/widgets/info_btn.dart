import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_constants.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.bottomSheet(
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 0.30.sh,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppConstants.STANDARD_BLACK.withOpacity(0.97),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 0.05.sw, bottom: 0.05.sw, left: 0.05.sw, right: 0.05.sw),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.h), color: AppConstants.STANDARD_OFF_WHITE.withOpacity(0.5)),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                AppConstants.DEVELOPED_BY_LABEL.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.kodchasan(fontSize: 25.h, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w700),
                              ),
                              10.verticalSpace,
                              AutoSizeText(
                                AppConstants.DEVELOPED_BY.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.comfortaa(fontSize: 20.h, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.h), color: AppConstants.STANDARD_OFF_WHITE.withOpacity(0.5)),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                AppConstants.DEVELOPED_BY_ORG_LABEL.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.kodchasan(fontSize: 25.h, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w700),
                              ),
                              10.verticalSpace,
                              AutoSizeText(
                                AppConstants.DEVELOPED_BY_ORG_CONTENT.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.comfortaa(fontSize: 20.h, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.h), color: AppConstants.STANDARD_OFF_WHITE.withOpacity(0.5)),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                AppConstants.APPLICATION_VERSION_LABEL.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.kodchasan(fontSize: 25.h, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w700),
                              ),
                              10.verticalSpace,
                              AutoSizeText(
                                AppConstants.APPLICATION_VERSION.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.comfortaa(fontSize: 20.h, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        overlayColor: MaterialStateProperty.all(AppConstants.STANDARD_OFF_WHITE.withOpacity(0.5)),
        padding: MaterialStateProperty.all(EdgeInsets.only(top: 5.h, bottom: 5.h)),
      ),
      child: Icon(Icons.info_outline_rounded, color: AppConstants.STANDARD_BLACK.withOpacity(0.7), size: 30.w),
    );
  }
}
