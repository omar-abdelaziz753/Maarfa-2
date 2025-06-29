import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as trans;
import 'package:my_academy/bloc/auth/provider/auth_provider_cubit.dart';
// import 'package:my_academy/bloc/auth/show_delete_and_payment./injection.dart'
//     as di;
import 'package:my_academy/bloc/auth/show_delete_and_payment/injection.dart';
import 'package:my_academy/bloc/auth/show_delete_and_payment/injection.dart'
    as di;
import 'package:my_academy/bloc/bookmark/bookmark_cubit.dart';
import 'package:my_academy/bloc/lessons/lessons_cubit.dart';
import 'package:my_academy/bloc/pay/pay_cubit.dart';
import 'package:my_academy/bloc/search_bloc/search_bloc.dart';
import 'package:my_academy/constants.dart';
import 'package:my_academy/layout/activity/splash/splash_screen.dart';
import 'package:my_academy/layout/view/home/user/data/cubit/home_cubit.dart';
import 'package:my_academy/repository/common/cities/cities_repository.dart';
import 'package:my_academy/repository/common/nationalities/nationalities_repository.dart';
import 'package:my_academy/repository/common/search/search_repository.dart';
import 'package:my_academy/repository/provider/auth_provider/auth_provider_repository.dart';
import 'package:my_academy/repository/user/courses/courses_repository.dart';
import 'package:my_academy/repository/user/edit_profile/user_repository.dart';
import 'package:my_academy/repository/user/subscriptions/subscriptions_repository.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/service/local/share_prefs_service.dart';
import 'package:overlay_support/overlay_support.dart';

// import 'bloc/auth/show_delete_and_payment./show_delete_and_paymnet_cubit.dart';
import 'bloc/auth/show_delete_and_payment/show_delete_and_paymnet_cubit.dart';
import 'bloc/bottom_bar/bottom_bar_cubit.dart';
import 'bloc/cities/cities_cubit.dart';
import 'bloc/content/content_cubit.dart';
import 'bloc/course_subject/course_subject_cubit.dart';
import 'bloc/live/live_cubit.dart';
import 'bloc/nations/nations_cubit.dart';
import 'bloc/next_previous/next_previous_cubit.dart';
import 'bloc/profile/user/user_cubit.dart';
import 'bloc/provider_appointments/provider_appointments_cubit.dart';
import 'bloc/show_provider_details/provider_info_cubit.dart';
import 'bloc/splash/splash_cubit.dart';
import 'bloc/subscribe/subscribe_cubit.dart';
import 'repository/live/live_repository.dart';
import 'repository/provider/lessons/lessons_repository.dart';
import 'repository/user/show_providers/show_providers_repository.dart';
import 'res/injector/dependecy_injection.dart';
import 'service/notification/notification_serivce.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await NotificationService.instance!.initNotificationService();
  await EasyLocalization.ensureInitialized();
  await di.initSL();
  Injector().cofigure(Flavor.Prod);
  await sl<ShowDeleteAndPaymnetCubit>().getDeleteStatus();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Set the system UI mode to manual, displaying all system UI overlays.
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  // Apply a dark style to the system UI overlays for better visibility.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  SharedPrefService prefService = SharedPrefService();

  final result = await prefService.getBool("has_bank_account");

  result.fold((failure) => print("Error: $failure"), (value) {
    print("has_bank_account: $value");
    hasBankAccount = value;
    print("hasBankAccount: $hasBankAccount");
  });

  runApp(
    Phoenix(
      child: EasyLocalization(
          supportedLocales: const [Locale('ar'), Locale('en')],
          path: "assets/translate",
          saveLocale: true,
          startLocale: const Locale("ar"),
          useOnlyLangCode: true,
          child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Builder(
        // designSize: const Size(375, 812),
        builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ShowDeleteAndPaymnetCubit>(
            create: (BuildContext context) => sl<ShowDeleteAndPaymnetCubit>(),
          ),
          BlocProvider<SplashCubit>(
            create: (BuildContext context) => SplashCubit(),
          ),
          BlocProvider<BottomBarCubit>(
            create: (BuildContext context) => BottomBarCubit(),
          ),
          BlocProvider<AuthProviderCubit>(
            create: (BuildContext context) =>
                AuthProviderCubit(AuthProviderRepository()),
          ),
          BlocProvider<UserCubit>(
            create: (BuildContext context) =>
                UserCubit(UserRepository())..getCacheUser(),
          ),
          BlocProvider<BookmarkCubit>(
            create: (BuildContext context) => BookmarkCubit(),
          ),
          BlocProvider<PayCubit>(
            create: (BuildContext context) => PayCubit(),
          ),
          BlocProvider<ContentCubit>(
            create: (BuildContext context) => ContentCubit(
              ProviderLessonsRepository(),
            ),
          ),
          BlocProvider<LessonsCubit>(
            create: (BuildContext context) => LessonsCubit(),
          ),
          BlocProvider<SubscribeCubit>(
            create: (BuildContext context) =>
                SubscribeCubit(SubscriptionsRepository()),
          ),
          BlocProvider<CourseSubjectCubit>(
            create: (BuildContext context) =>
                CourseSubjectCubit(CoursesRepository()),
          ),
          BlocProvider<ProviderAppointmentsCubit>(
            create: (BuildContext context) => ProviderAppointmentsCubit(),
          ),
          BlocProvider<SearchBloc>(
            create: (BuildContext context) => SearchBloc(SearchRepository()),
          ),
          BlocProvider<LiveCubit>(
            create: (BuildContext context) => LiveCubit(LiveRepository()),
          ),
          BlocProvider<NextPreviousCubit>(
            create: (BuildContext context) => NextPreviousCubit(),
          ),
          BlocProvider<ProviderInfoCubit>(
            create: (BuildContext context) =>
                ProviderInfoCubit(ShowProvidersRepository()),
          ),
          BlocProvider<CitiesCubit>(
            create: (BuildContext context) => CitiesCubit(CitiesRepository()),
          ),
          BlocProvider(
              create: (BuildContext context) =>
                  NationsCubit(NationalitiesRepository())),
          BlocProvider(
              create: (BuildContext context) =>
                  Home2Cubit()..getAllSpecializations()),
        ],
        child: OverlaySupport(
          child: GetMaterialApp(
            // useInheritedMediaQuery: true,
            // builder: DevicePreview.appBuilder,
            defaultTransition: trans.Transition.circularReveal,
            title: "Maarfa",
            theme: ThemeData(
                fontFamily: "Shamel",
                scaffoldBackgroundColor: scaffoldBackgroundColor,
                appBarTheme: AppBarTheme(
                  surfaceTintColor: Colors.white,
                )),
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            fallbackLocale: context.fallbackLocale,
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            home: Builder(builder: (context) {
              ScreenUtil.init(context, designSize: const Size(428, 926));
              return const SplashScreen();
            }),
          ),
        ),
      );
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('onEvent -- ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onTransition(Bloc bloc, dynamic transition) {
    super.onTransition(bloc, transition);
    log('onTransition -- ${bloc.runtimeType}, $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('onClose -- ${bloc.runtimeType}');
  }
}
