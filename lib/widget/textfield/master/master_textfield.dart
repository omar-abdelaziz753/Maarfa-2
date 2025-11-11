import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../side_padding/side_padding.dart';

class MasterTextField extends StatelessWidget {
  final double? sidePadding;
  final double? fieldHeight;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool? autofocus;
  final bool? cursor;
  final bool readOnly;
  final bool isChange;
  final Color? borderColor;
  final String? errorText;
  final String hintText;
  final TextStyle? hintStyle;

  final double? borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixIcon;
  final Color? prefixIconColor;
  final String? suffixIcon;
  final Widget? suffix;
  final Color? suffixColor;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final int? minLength;
  final VoidCallback? suffixTap;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const MasterTextField({
    super.key,
    this.autofocus,
    this.prefixIconColor,
    this.hintStyle,
    this.suffix,
    this.borderColor,
    this.controller,
    this.fieldHeight,
    this.errorText,
    required this.hintText,
    this.borderRadius,
    this.isPassword = false,
    this.inputFormatters,
    this.isChange = false,
    this.readOnly = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixColor,
    this.sidePadding,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.minLength,
    this.onChanged,
    this.suffixTap,
    this.onTap,
    this.cursor,
    this.validator,
    // this.initValue
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SidePadding(
          sidePadding: sidePadding ?? 0,
          child: LimitedBox(
            maxHeight: fieldHeight == null ? 70.h : fieldHeight!.h,
            child: TextFormField(
              inputFormatters: inputFormatters,
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              readOnly: readOnly,
              keyboardType: keyboardType,
              obscureText: isPassword,
              maxLines: maxLines ?? 1,
              minLines: minLines ?? 1,
              maxLength: maxLength,
              maxLengthEnforcement:
                  MaxLengthEnforcement.truncateAfterCompositionEnds,
              autofocus: autofocus ?? false,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              showCursor: cursor,
              // initialValue: initValue,
              style: TextStyles.textView14SemiBold.copyWith(color: black),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                isDense: true,
                // contentPadding: EdgeInsets.only(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        borderRadius == null ? 10.r : borderRadius!.r)),
                    borderSide: BorderSide(
                      color: textfieldColor,
                      width: 1.w,
                      style: BorderStyle.solid,
                    )),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        borderRadius == null ? 10.r : borderRadius!.r)),
                    borderSide: BorderSide(
                      color: textfieldColor,
                      width: 1.w,
                      style: BorderStyle.solid,
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        borderRadius == null ? 10.r : borderRadius!.r)),
                    borderSide: BorderSide(
                      color: textfieldColor,
                      width: 1.w,
                      style: BorderStyle.solid,
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        borderRadius == null ? 10.r : borderRadius!.r)),
                    borderSide: BorderSide(
                      color: borderColor ?? mainColor,
                      width: 1.w,
                      style: BorderStyle.solid,
                    )),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        borderRadius == null ? 10.r : borderRadius!.r)),
                    borderSide: BorderSide(
                      color: errorText != null ? red : textfieldColor,
                      width: 1.w,
                      style: BorderStyle.solid,
                    )),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        borderRadius == null ? 10.r : borderRadius!.r)),
                    borderSide: BorderSide(
                      color: errorText != null ? red : textfieldColor,
                      width: 1.w,
                      style: BorderStyle.solid,
                    )),
                hintText: hintText,
                hintStyle: hintStyle ??
                    TextStyles.textView14SemiBold.copyWith(color: mainColor),

                // labelText: hintText,
                // labelStyle: TextStyles.appBarStyle.copyWith(color: mainColor),
                suffixIcon: isChange
                    ? TextButton(
                        onPressed: onTap,
                        child: Text(
                          tr("change"),
                          style: TextStyles.textView14SemiBold.copyWith(
                              color: mainColor,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    : suffixIcon == "sar"
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            child: Text(
                              tr("sar"),
                              style: TextStyles.hintStyle,
                            ),
                          )
                        : suffixIcon == "hour"
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                child: Text(
                                  tr("hour"),
                                  style: TextStyles.hintStyle,
                                ),
                              )
                            : suffixIcon == "people"
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.h),
                                    child: Text(
                                      tr("people"),
                                      style: TextStyles.hintStyle,
                                    ),
                                  )
                                : isChange == false && suffixIcon == "eye"
                                    ? InkWell(
                                        onTap: suffixTap,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 20.h, bottom: 20.h),
                                          child: Image.asset(
                                              isPassword == false ? eye : blind,
                                              color: isPassword == false
                                                  ? mainColor
                                                  : grey,
                                              height: 20.h,
                                              width: 15.w,
                                              fit: BoxFit.contain),
                                        ))
                                    : suffix,
                prefixIcon: prefixIcon == null
                    ? null
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.h),
                            child: Image.asset(prefixIcon!,
                                color: prefixIconColor,
                                height: 20.h,
                                fit: BoxFit.contain),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        errorText != null
            ? Padding(
                padding: EdgeInsets.only(
                  left: sidePadding ?? 0,
                  right: sidePadding ?? 0,
                  top: 14.h
                ),
                child: Text(
                  errorText!,
                  textAlign: TextAlign.start,
                  style: TextStyles.errorStyle,
                ),
              )
            : Container(),
      ],
    );
  }
}
