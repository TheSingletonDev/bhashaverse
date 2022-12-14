import 'package:bhashaverse/ui/home_page.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'bindings.dart';
import 'config/localized_content.dart';
import 'ui/intro_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.black87));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    GetStorage.init().then((_) => runApp(const Bhashaverse()));
  });
}

class Bhashaverse extends StatelessWidget {
  const Bhashaverse({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      Color baseColor = const Color(0XFFF0C0B0);
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        lightColorScheme = lightDynamic.harmonized();
        darkColorScheme = darkDynamic.harmonized();
      } else {
        lightColorScheme = ColorScheme.fromSeed(seedColor: baseColor);
        darkColorScheme = ColorScheme.fromSeed(seedColor: baseColor, brightness: Brightness.dark);
      }

      if (GetStorage().read('isIntroShown') == null) {
        GetStorage().write('isIntroShown', false);
      }
      if (GetStorage().read('userSelectedLangCode') == null) {
        GetStorage().write('userSelectedLangCode', 'en');
        GetStorage().write('userSelectedLang', 'English');
      }
      return GetMaterialApp(
          locale: Locale(GetStorage().read('userSelectedLangCode')),
          translations: LocalizedContent(),
          title: 'Bhashaverse',
          theme: ThemeData(colorScheme: lightColorScheme),
          // darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
          debugShowCheckedModeBanner: false,
          initialBinding: TranslationAppBindings(),
          home: GetStorage().read('isIntroShown') ? const HomePage() : const IntroPages(),
          builder: (context, child) {
            ScreenUtil.init(context, designSize: const Size(540, 1200), minTextAdapt: true);

            final scale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.0);
            return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: scale), child: child!);
          });
    });
  }
}
