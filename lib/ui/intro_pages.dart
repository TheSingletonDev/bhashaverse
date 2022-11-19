import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_constants.dart';
import '../config/loacale_fonts.dart';
import '../config/size_config.dart';
import 'home_page.dart';
import 'widgets/info_btn.dart';
import 'widgets/localization_btn.dart';
// import 'home_screen.dart';

class IntroPages extends StatefulWidget {
  const IntroPages({Key? key}) : super(key: key);

  @override
  IntroPagesState createState() => IntroPagesState();
}

class IntroPagesState extends State<IntroPages> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Get.off(() => const HomePage());
  }

  // Widget _buildImageMono(String assetName, [double width = 20]) {
  //   return ColorFiltered(
  //     colorFilter:
  //         const ColorFilter.matrix([0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]),
  //     child: Image.asset(
  //       '${AppConstants.IMAGE_ASSETS_PATH}$assetName',
  //       width: width,
  //       fit: BoxFit.fitWidth,
  //     ),
  //   );
  // }

  Widget _buildImageColor(String assetName, [double width = 20]) {
    return Image.asset(
      '${AppConstants.IMAGE_ASSETS_PATH}$assetName',
      width: width,
      fit: BoxFit.fitWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context: context);

    var pageDecoration = PageDecoration(
      // titleTextStyle: GoogleFonts.lobsterTwo(fontSize: SizeConfig.blockSizeHorizontal * 10, fontWeight: FontWeight.bold),
      titleTextStyle:
          LocaleFonts.pageHeadingTextLocaleBasedFont(locale: Get.locale ?? const Locale('en'), fontSize: 55.w, fontWeight: FontWeight.bold),
      bodyTextStyle: GoogleFonts.kalam(fontSize: 28.w),
      titlePadding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 5),
      bodyPadding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
      // pageColor: const Color.fromARGB(255, 240, 240, 240),
      pageColor: Colors.transparent,
    );

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(height: double.infinity, width: double.infinity, color: const Color.fromARGB(255, 240, 240, 240)),
        _getBgImage(imagePath: '${AppConstants.IMAGE_ASSETS_PATH}intro_page_bg_top.webp', imageAlignment: Alignment.topCenter, opacity: 0.06),
        _getBgImage(imagePath: '${AppConstants.IMAGE_ASSETS_PATH}intro_page_bg_bottom.webp', imageAlignment: Alignment.bottomCenter, opacity: 0.1),
        IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.transparent,
          globalHeader: Align(
            alignment: Alignment.center,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 8,
                ),
                child: Column(
                  children: [
                    AutoSizeText(AppConstants.APP_NAME.tr,
                        style: LocaleFonts.appNameLocaleBasedFont(locale: Get.locale ?? const Locale('en'), fontSize: 65.w)),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(AppConstants.APP_NAME_SUB.tr, style: GoogleFonts.frederickaTheGreat(fontSize: 30.w)),
                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1.5),
                        _buildImageColor('bhashini-tp-logo.webp', SizeConfig.blockSizeHorizontal * 25),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          globalFooter: SizedBox(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical * 6,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppConstants.STANDARD_GREEN.withOpacity(0.8)),
              ),
              child: AutoSizeText(
                AppConstants.INTRO_PAGE_DIRECT_BTN_TEXT.tr,
                style: GoogleFonts.kodchasan(fontSize: 30.w, color: AppConstants.STANDARD_BLACK),
              ),
              onPressed: () => _onIntroEnd(context),
            ),
          ),
          pages: [
            PageViewModel(
              title: AppConstants.INTRO_PAGE_1_HEADER_TEXT.tr,
              body: AppConstants.INTRO_PAGE_1_SUB_HEADER_TEXT.tr,
              image: _buildImageColor('intro_screen_img1.webp', SizeConfig.blockSizeHorizontal * 95),
              decoration: pageDecoration.copyWith(
                imageAlignment: Alignment.bottomCenter,
                imageFlex: 5,
                bodyFlex: 3,
              ),
            ),

            PageViewModel(
              title: AppConstants.INTRO_PAGE_2_HEADER_TEXT.tr,
              body: AppConstants.INTRO_PAGE_2_SUB_HEADER_TEXT.tr,
              image: _buildImageColor('intro_screen_img2.webp', SizeConfig.blockSizeHorizontal * 95),
              decoration: pageDecoration.copyWith(
                imageAlignment: Alignment.bottomCenter,
                imageFlex: 5,
                bodyFlex: 3,
              ),
            ),

            PageViewModel(
              title: AppConstants.INTRO_PAGE_3_HEADER_TEXT.tr,
              body: AppConstants.INTRO_PAGE_3_SUB_HEADER_TEXT.tr,
              image: _buildImageColor('intro_screen_img3.webp', SizeConfig.blockSizeHorizontal * 95),
              decoration: pageDecoration.copyWith(
                imageAlignment: Alignment.bottomCenter,
                imageFlex: 5,
                bodyFlex: 3,
              ),
            ),

            // To go to the first page
            //   footer: ElevatedButton(
            //     onPressed: () {
            //       introKey.currentState?.animateScroll(0);
            //     },
          ],
          onDone: () => _onIntroEnd(context),
          showSkipButton: false,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: true,
          back: Icon(Icons.arrow_back, color: AppConstants.STANDARD_BLACK, size: SizeConfig.blockSizeHorizontal * 6),
          next: Icon(Icons.arrow_forward, color: AppConstants.STANDARD_BLACK, size: SizeConfig.blockSizeHorizontal * 6),
          done: Text(AppConstants.INTRO_PAGE_DONE_BTN_TEXT.tr,
              style: GoogleFonts.comfortaa(
                  color: AppConstants.STANDARD_BLACK, fontSize: SizeConfig.blockSizeHorizontal * 4, fontWeight: FontWeight.bold)),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: EdgeInsets.only(
            right: SizeConfig.blockSizeHorizontal * 4,
            left: SizeConfig.blockSizeHorizontal * 4,
            bottom: SizeConfig.blockSizeVertical * 2,
          ),
          dotsDecorator: DotsDecorator(
            size: Size(SizeConfig.blockSizeHorizontal * 2.5, SizeConfig.blockSizeHorizontal * 2.5),
            color: AppConstants.STANDARD_BLACK.withOpacity(0.3),
            activeColor: AppConstants.STANDARD_GREEN,
            activeSize: Size(SizeConfig.blockSizeHorizontal * 8, SizeConfig.blockSizeHorizontal * 2.5),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 1)),
            ),
          ),
          dotsContainerDecorator: ShapeDecoration(
            color: AppConstants.STANDARD_ORANGE.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 3)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: SizedBox(
              width: 0.20.sw,
              height: 0.045.sh,
              child: Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: const InfoButton(),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              width: 0.3.sw,
              height: 0.045.sh,
              child: Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: const LangSwitchButton(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _getBgImage({required String imagePath, required Alignment imageAlignment, required double opacity}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: imageAlignment,
            image: AssetImage(imagePath),
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(opacity), BlendMode.dstATop)
            // centerSlice: Rect.fromCenter(center: Offset(50, 50), width: 10, height: 10),
            ),
      ),
    );
  }
}
