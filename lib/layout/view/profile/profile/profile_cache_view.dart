import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/bloc/auth/show_delete_and_payment/show_delete_and_paymnet_cubit.dart';
import 'package:my_academy/layout/activity/provider_screens/account_data/account_data_screen.dart';
import 'package:my_academy/layout/activity/provider_screens/account_data/edit_account_information_screen.dart';

import '../../../../../widget/error/page/error_page.dart';
import '../../../../bloc/auth/provider/auth_provider_cubit.dart';
import '../../../../bloc/profile/provider/provider_cubit.dart';
import '../../../../bloc/profile/user/user_cubit.dart';
import '../../../../repository/provider/auth_provider/auth_provider_repository.dart';
import '../../../../repository/user/edit_profile/user_repository.dart';
import '../../../../res/drawable/icon/icons.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/alert/delete/delete_alert.dart';
import '../../../../widget/buttons/profile/profile_button.dart';
import '../../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../../widget/loader/loader.dart';
import '../../../activity/provider_screens/bank_account/bank_account_screen.dart';
import '../../../activity/static/about_us/about_us_screen.dart';
import '../../../activity/static/contact_us/contact_us_screen.dart';
import '../../../activity/static/privacy/privacy_screen.dart';
import '../../../activity/static/terms_conditions/terms_conditions_screen.dart';
import '../../../activity/user_screens/wallet/wallet_screen.dart';

class ProfileCacheView extends StatelessWidget {
  final bool isUser;
  const ProfileCacheView({super.key, required this.isUser});
  @override
  Widget build(final BuildContext context) {
    return isUser
        ? BlocProvider(
            create: (BuildContext context) =>
                UserCubit(UserRepository())..getProfileCache(),
            child: BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is UserApiLoadedState) {
                    final data = state.data;
                    return profileView(context, data);
                  } else if (state is ErrorUserState) {
                    return const ErrorPage();
                  } else {
                    return Center(child: const Loading());
                  }
                }))
        : BlocProvider(
            create: (BuildContext context) =>
                ProviderCubit(UserRepository())..getCacheProvider(),
            child: BlocConsumer<ProviderCubit, ProviderState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is ProviderLoadedState) {
                    final data = state.data;
                    return profileView(context, data);
                  } else if (state is ErrorProviderState) {
                    return const ErrorPage();
                  } else {
                    return Center(child: const Loading());
                  }
                }));
  }

  profileView(context, data) {
    return BlocProvider(
        create: (BuildContext context) =>
            AuthProviderCubit(AuthProviderRepository()),
        child: BlocConsumer<AuthProviderCubit, AuthProviderState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = AuthProviderCubit.get(context);
              if (data.data == null) {
                return const CircularProgressIndicator();
              }
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () => isUser
                                ? Get.to(() => AccountDataScreen(
                                      isUser: true,
                                      user: data.data,
                                    ))
                                : Get.to(
                                    () =>
                                        EditAccountInformation(data: data.data),
                                  ),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white, // Background white
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle, color: white),
                                    child: CachedImage(
                                      imageUrl: isUser
                                          ? data.data?.image
                                          : data.data?.imagePath ?? "",
                                      fit: BoxFit.contain,
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(tr("my_account"),
                                      style: TextStyles.appBarStyle.copyWith(
                                          color: primaryText,
                                          fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios,
                                      color: mainColor),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ProfileButton(
                            title: tr("wallet"),
                            image: walletMore,
                            onTap: () {
                              isUser
                                  ? Get.to(() => WalletCharging(
                                        isUser: true,
                                        walletCredit: data.data.wallet,
                                      ))
                                  : Get.to(
                                      () => BankAccount(
                                        balance: data.data.wallet,
                                        deservedAmount:
                                            data.data.expectedAmount,
                                        appRatio: data.data.appRatio,
                                        bankData: data.data.bankAccount,
                                      ),
                                    );
                              // Get.to(const WalletCharging());
                            }),
                        ProfileButton(
                            title: tr(
                              "privacy",
                            ),
                            image: privacyMore,
                            onTap: () => Get.to(const PrivacyScreen())),
                        ProfileButton(
                            title: tr("terms"),
                            image: termsMore,
                            onTap: () => Get.to(TermsScreen(isUser: isUser))),
                        ProfileButton(
                            title: tr("contact_us"),
                            image: contactusMore,
                            onTap: () {
                              Get.to(() => const ContactUsScreen());
                            }),
                        ProfileButton(
                            title: tr("about_us"),
                            image: whousMore,
                            onTap: () => Get.to(const AboutUsScreen())),
                        ProfileButton(
                            title: tr("language"),
                            image: languageMore,
                            onTap: () => bloc.changeLocale(context)),
                        if (context
                            .read<ShowDeleteAndPaymnetCubit>()
                            .showDeleteAccount)
                          ProfileButton(
                              title: tr("delete_account"),
                              image: deleteMore,
                              onTap: () => deleteAlert(deleteTap: () {
                                    bloc.deleteAccount();
                                  })),
                        ProfileButton(
                            title: tr("logout"),
                            image: logoutMore,
                            isLogout: true,
                            onTap: () => bloc.logout()),
                        const SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
