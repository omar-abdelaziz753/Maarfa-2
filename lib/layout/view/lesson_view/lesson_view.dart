// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../bloc/bookmark/bookmark_cubit.dart';
// import '../../../models/common/lessons/lesson_model.dart';
// import '../../../res/value/dimenssion/dimenssions.dart';
// import '../../../widget/master_list/custom_list.dart';
// import '../../card_view/subject/subject_card.dart';

// class LessonView extends StatelessWidget {
//   final List<LessonDetails> data;
//   final int yearId, stageId, count;

//   const LessonView({
//     Key? key,
//     required this.count,
//     required this.data,
//     required this.yearId,
//     required this.stageId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomList(
//       listHeight: 100000000000000,
//       listWidth: screenWidth,
//       scroll: const NeverScrollableScrollPhysics(),
//       axis: Axis.vertical,
//       count: count,
//       child: (context, index) => SubjectCard(
//         onTap: () =>
//                                       BlocProvider.of<BookmarkCubit>(context)
//                                           .addToBookMark(
//                                               id: data[index].id!,
//                                               type: 'lesson'),
//         isBlue: data[index].isBookmarked!,
//         lessonDetails: data[index],
//         yearId: yearId,
//         stageId: stageId,
//       ),
//     );
//   }
// }
