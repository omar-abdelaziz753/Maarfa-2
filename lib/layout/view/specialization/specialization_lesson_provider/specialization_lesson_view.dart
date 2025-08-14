import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/content/content_cubit.dart';
import '../../../../model/common/subjects/subjects_model.dart';
import '../../../../repository/provider/lessons/lessons_repository.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/dropdown/content/content_dropdown.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/loader/loader.dart';
import '../../../../widget/space/space.dart';

class SpecializationLessonView extends StatefulWidget {
  final int id;
  final VoidCallback Function(dynamic)? subjectTap;
  final dynamic subjectValue;
  final SubjectModel? subjectModel;
  final bool isEdit;
  const SpecializationLessonView(
      {super.key,
      required this.id,
      this.subjectTap,
      this.subjectValue,
      required this.isEdit,
      this.subjectModel});

  @override
  State<SpecializationLessonView> createState() =>
      _SpecializationLessonViewState();
}

class _SpecializationLessonViewState extends State<SpecializationLessonView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContentCubit, ContentState>(
        listener: (context, state) {},
        builder: (context, state) {
          final bloc = context.watch<ContentCubit>();
          final specialization = bloc.subjectModel;
          if (specialization.isNotEmpty) {
            return SpecializationView(
                isEdit: widget.isEdit,
                subjectModel: widget.subjectModel,
                data: specialization,
                subjectTap: widget.subjectTap,
                subjectValue: widget.subjectValue);
          } else if (state is SubjectErrorState) {
            return const ErrorPage();
          } else {
            return const Loading();
          }
        });
  }
}

class SpecializationView extends StatefulWidget {
  const SpecializationView(
      {super.key,
      required this.data,
      this.subjectTap,
      this.subjectValue,
      this.subjectModel,
      required this.isEdit});
  final List<SubjectModel> data;
  final VoidCallback Function(dynamic)? subjectTap;
  final dynamic subjectValue;
  final SubjectModel? subjectModel;
  final bool isEdit;
  @override
  State<SpecializationView> createState() => _SpecializationViewState();
}

class _SpecializationViewState extends State<SpecializationView> {
  @override
  void initState() {
    super.initState();
    if (widget.subjectModel != null && widget.isEdit) {
      final selected = widget.data
          .firstWhere((element) => element.id == widget.subjectModel!.id);
      widget.subjectTap!(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            ContentCubit(ProviderLessonsRepository())..initSubject(widget.data),
        child: BlocConsumer<ContentCubit, ContentState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = ContentCubit.get(context);
              return Column(
                children: [
                  ContentDropDown(
                    isExpanded: true,
                    value: bloc.subjectModel.contains(widget.subjectValue)
                        ? widget.subjectValue
                        : null,
                    onChange: widget.subjectTap,
                    items: bloc.subjectModel
                        .map<DropdownMenuItem<SubjectModel>>(
                            (SubjectModel value) {
                      return DropdownMenuItem<SubjectModel>(
                          value: value,
                          child: Center(
                              child: Text("${value.name}",
                                  style: TextStyles.appBarStyle
                                      .copyWith(color: mainColor))));
                    }).toList(),
                    hint: tr("subject"),
                    image: "",
                  ),
                  const Space(
                    boxHeight: 15,
                  ),
                ],
              );
            }));
  }
}
