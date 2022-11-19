import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_constants.dart';
import '../../controllers/localization_controller.dart';

class LangSwitchButton extends StatelessWidget {
  const LangSwitchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizationController) {
        return ElevatedButton(
          onPressed: () {
            Get.bottomSheet(
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 0.38.sh,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppConstants.STANDARD_BLACK.withOpacity(0.97),
                  ),
                  child: GridView.builder(
                    itemCount: AppConstants.AVAILABLE_LOCALIZATION_LANGUAGES.length,
                    itemBuilder: (context, index) {
                      String eachLanguage = AppConstants.AVAILABLE_LOCALIZATION_LANGUAGES_MAP['language_codes']![index]['language_name'].toString();
                      String newLocale = AppConstants.getLanguageCodeOrName(
                          value: eachLanguage,
                          returnWhat: LANGUAGE_MAP.languageCode,
                          lang_code_map: AppConstants.AVAILABLE_LOCALIZATION_LANGUAGES_MAP);

                      return InkWell(
                        onTap: () {
                          localizationController.changeLocalization(newLocale: newLocale);
                          localizationController.changeCurrentSelectedLocalizationLangInUI(eachLanguage);
                          GetStorage().write('userSelectedLangCode', newLocale);
                          GetStorage().write('userSelectedLang', eachLanguage);
                          // Delay for better User Experience. User tap shows a splash effect.
                          Future.delayed(const Duration(milliseconds: 300)).then((_) => Get.back());
                        },
                        child: Center(
                          child: AutoSizeText(
                            eachLanguage,
                            minFontSize: (15.w).toInt().toDouble(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.kodchasan(fontSize: 25.w, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w300),
                          ),
                        ),
                      );
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
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
            padding: MaterialStateProperty.all(
              EdgeInsets.only(top: 5.h, bottom: 5.h, left: 5.w, right: 5.w),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AutoSizeText(
                  localizationController.getCurrentSelectedLocalizationLangInUI,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  maxFontSize: (30.w).toInt().toDouble(),
                  style: GoogleFonts.kodchasan(color: AppConstants.STANDARD_BLACK.withOpacity(0.7), fontSize: 20.w, fontWeight: FontWeight.w700),
                ),
              ),
              10.horizontalSpace,
              Icon(Icons.settings_outlined, color: AppConstants.STANDARD_BLACK.withOpacity(0.7), size: 30.w),
              20.horizontalSpace,
            ],
          ),
        );
      },
    );
  }
}
