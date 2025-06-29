import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/contact_us/contact_us_cubit.dart';
import 'package:my_academy/repository/static_pages/contact_us/contact_us_repository.dart';
import 'package:my_academy/res/drawable/image/images.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/res/value/style/textstyles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../bloc/social/cubit/social_cubit.dart';
import '../../../../repository/common/socail/socail_repository.dart';
import '../../../../widget/app_bar/default_app_bar/default_app_bar.dart';
import '../../../../widget/buttons/master_load/master_load_button.dart';
import '../../../../widget/space/space.dart';
import '../../../../widget/textfield/master/master_textfield.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ContactUsCubit(ContactUsRepository()),
      child: BlocConsumer<ContactUsCubit, ContactUsState>(
          listener: (context, state) {},
          builder: (context, state) {
            final bloc = ContactUsCubit.get(context);
            return Stack(
              alignment: FractionalOffset.topCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    staticBackground,
                    fit: BoxFit.fill,
                  ),
                ),
                Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: DefaultAppBar(
                        title: tr("contact_us"), centerTitle: false),
                    body: Column(
                      children: [
                        BlocProvider<SocialCubit>(
                          create: (BuildContext context) =>
                              SocialCubit(SocialRepository())..fGetSocial(),
                          child: BlocBuilder<SocialCubit, SocialState>(
                            builder: (context, state) {
                              if (state is SocialLoading) {
                                return const Center(
                                    child:
                                        CircularProgressIndicator.adaptive());
                              }
                              final socailMediaIcon =
                                  context.watch<SocialCubit>().socailMediaIcon;
                              final contactUsResponse = context
                                  .watch<SocialCubit>()
                                  .contactUsResponse;
                              return Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...List.generate(
                                            contactUsResponse!.data.length,
                                            (index) {
                                          if (contactUsResponse
                                              .data[index].value.isEmpty) {
                                            return const SizedBox();
                                          }
                                          return GestureDetector(
                                            onTap: () async {
                                              if (contactUsResponse
                                                      .data[index].key ==
                                                  "whatsapp") {
                                                final Uri phoneUri = Uri.parse(
                                                    "whatsapp://send?phone=${(contactUsResponse.data[index].value)}");

                                                await launchUrl(phoneUri);
                                                return;
                                                // final Uri phoneUri = Uri.parse(
                                                //     "whatsapp://send?phone=${contactUsResponse.data.rawyPhoneNumber}");
                                                // launchUrl(phoneUri);
                                                // return;
                                              }
                                              _launchUrl(
                                                  url: contactUsResponse
                                                      .data[index].value);
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Image.asset(
                                                  socailMediaIcon[
                                                          contactUsResponse
                                                              .data[index]
                                                              .key] ??
                                                      "facebook"),
                                            ),
                                          );
                                        })
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Center(
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(tr("or"),
                                  textAlign: TextAlign.center,
                                  style: TextStyles.textView16Bold
                                      .copyWith(color: white)),
                            ),
                            Expanded(
                                child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(12)),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              Space(boxHeight: 10.h),
                              MasterTextField(
                                controller: bloc.name,
                                sidePadding: 35,
                                hintText: tr("name"),
                                errorText: bloc.validators[0],
                                onChanged: (val) => bloc.validate(val, 0),
                              ),
                              Space(
                                boxHeight: 30.h,
                              ),
                              MasterTextField(
                                controller: bloc.phone,
                                sidePadding: 35,
                                hintText: tr("phone2"),
                                errorText: bloc.validators[1],
                                onChanged: (val) => bloc.validate(val, 1),
                                keyboardType: TextInputType.phone,
                              ),
                              Space(
                                boxHeight: 30.h,
                              ),
                              MasterTextField(
                                controller: bloc.email,
                                sidePadding: 35,
                                hintText: tr("email"),
                                errorText: bloc.validators[2],
                                onChanged: (val) => bloc.validate(val, 2),
                              ),
                              Space(
                                boxHeight: 30.h,
                              ),
                              MasterTextField(
                                controller: bloc.message,
                                sidePadding: 35,
                                hintText: tr("messege"),
                                maxLines: 5,
                                minLines: 5,
                                fieldHeight: 210,
                                errorText: bloc.validators[3],
                                onChanged: (val) => bloc.validate(val, 3),
                                // isError: bloc.validators[3] == null ? false : true,
                                // onChanged: (val) => bloc.validate(val, 3),
                              ),
                              Space(
                                boxHeight: 30.h,
                              ),
                              MasterLoadButton(
                                buttonController: bloc.authController,
                                sidePadding: 35,
                                buttonText: tr("send"),
                                onPressed: () => bloc.contactUs(),
                              ),
                              // MasterButton(
                              //     onPressed: ()=> bloc.contactUs(),
                              //     sidePadding: 35,
                              //     buttonText: tr("send")),
                              const Space(
                                boxHeight: 100,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            );
          }),
    );
  }
}

Future<void> _launchUrl({required String url}) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}
