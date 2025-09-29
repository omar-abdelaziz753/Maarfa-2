import 'package:bloc/bloc.dart';
import 'package:my_academy/layout/view/profile/models/contact_support_data_model.dart';
import 'package:my_academy/layout/view/profile/models/get_all_polls_data_model.dart';
import 'package:my_academy/service/network/dio/dio_service.dart';

part 'contact_support_service_state.dart';

class ContactSupportServiceCubit extends Cubit<ContactSupportServiceState> {
  ContactSupportServiceCubit() : super(ContactSupportServiceInitial());

  ContactSupportDataModel? supportData;
  GetAllPollsDataModel? pollsData;
  final List<int> submittedQuestions = [];


  // Future<void> getAllSupportData() async {
  //   emit(GetAllContactSupportServiceLoadingState());
  //
  //   try {
  //     final response = await DioService().get(
  //       '/client/support',
  //     );
  //     // final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       supportData = ContactSupportDataModel.fromJson(jsonData);
  //       emit(GetAllContactSupportServiceSuccessState(
  //           staticMessage: supportData!.staticMessage!, data: supportData!.data!));
  //     } else {
  //       emit(GetAllContactSupportServiceErrorState(
  //         errorMessage: 'Error: ${response.statusCode}',
  //       ));
  //     }
  //   } catch (e) {
  //     emit(GetAllContactSupportServiceErrorState(
  //       errorMessage: e.toString(),
  //     ));
  //   }
  // }
  Future<void> getAllSupportData() async {
    emit(GetAllContactSupportServiceLoadingState());

    try {
      final response = await DioService().get('/client/support');

      // print('Response: $response');
      // print('Response type: ${response.runtimeType}');

      // Handle Either type response
      response.fold(
        (error) {
          // Left side - error case
          // print('API Error: $error');
          emit(GetAllContactSupportServiceErrorState(
            errorMessage: error.toString(),
          ));
        },
        (success) {
          // Right side - success case
          // print('API Success: $success');
          // print('Success data type: ${success.runtimeType}');

          try {
            Map<String, dynamic> jsonData;

            // Handle different possible success response types
            if (success is Map<String, dynamic>) {
              jsonData = success;
            } else if (success.data is Map<String, dynamic>) {
              jsonData = success.data;
            } else {
              throw Exception('Unexpected response format');
            }

            // print('JSON Data: $jsonData');
            // print('Static Message: ${jsonData['Static_Message']}');
            // print('Data: ${jsonData['data']}');

            // Try to parse the model
            try {
              supportData = ContactSupportDataModel.fromJson(jsonData);
              // print('Model parsed successfully');
              // print('Static Message from model: ${supportData!.staticMessage}');
              // print('Data from model: ${supportData!.data}');

              emit(GetAllContactSupportServiceSuccessState(
                  staticMessage: supportData!.staticMessage!,
                  data: supportData!.data!));
            } catch (modelError) {

              // Fallback: Parse manually if model fails
              final staticMessage = jsonData['Static_Message'] as String? ??
                  'Hello! How can I help you?';
              final dataList = jsonData['data'] as List<dynamic>? ?? [];

              // Convert to QuestionData objects manually
              List<QuestionData> questions = dataList.map((item) {
                return QuestionData(
                  id: item['id'],
                  question: item['question'],
                  answer: item['answer'],
                  createdAt: item['created_at'],
                  updatedAt: item['updated_at'],
                );
              }).toList();

              emit(GetAllContactSupportServiceSuccessState(
                  staticMessage: staticMessage, data: questions));
            }
          } catch (parseError) {
            emit(GetAllContactSupportServiceErrorState(
              errorMessage: parseError.toString(),
            ));
          }
        },
      );
    } catch (e) {

      emit(GetAllContactSupportServiceErrorState(
        errorMessage: e.toString(),
      ));
    }
  }

  // Future<void> getAllPolls() async {
  //   emit(GetAllPollsLoadingState());
  //   try {
  //     final response = await DioService().get('/frontend/survey/questions');
  //     response.fold(
  //           (error) {
  //         emit(GetAllPollsErrorState(errorMessage: error.toString()));
  //       },
  //           (success) {
  //         final data = success.data;
  //         final questions = (data['questions'] as List)
  //             .map((e) => Questions.fromJson(e))
  //             .toList();
  //         final answers = (data['answers'] as List)
  //             .map((e) => Answers.fromJson(e))
  //             .toList();
  //
  //         emit(GetAllPollsSuccessState(
  //           questions: questions,
  //           answers: answers,
  //         ));
  //       },
  //     );
  //   } catch (e) {
  //     emit(GetAllPollsErrorState(errorMessage: e.toString()));
  //   }
  // }
  Future<void> getAllPolls() async {
    emit(GetAllPollsLoadingState());
    try {
      final response = await DioService().get('/frontend/survey/questions');
      response.fold(
            (error) {
          emit(GetAllPollsErrorState(errorMessage: error.toString()));
        },
            (success) {
          try {
            final Map<String, dynamic> jsonData = success is Map<String, dynamic>
                ? success
                : success.data;

            final data = jsonData['data'] as Map<String, dynamic>;

            final questions = (data['questions'] as List)
                .map((e) => Questions.fromJson(e))
                .toList();

            final answers = (data['answers'] as List)
                .map((e) => Answers.fromJson(e))
                .toList();

            emit(GetAllPollsSuccessState(
              questions: questions,
              answers: answers,
            ));
          } catch (e) {
            emit(GetAllPollsErrorState(errorMessage: e.toString()));
          }
        },
      );
    } catch (e) {
      emit(GetAllPollsErrorState(errorMessage: e.toString()));
    }
  }


  // Future<void> submitPollAnswer({
  //   required int questionId,
  //   required int answerId,
  // }) async {
  //   if (submittedQuestions.contains(questionId)) {
  //     emit(SubmitPollAnswerErrorState(
  //       errorMessage: 'لقد قمت بالرد على هذا السؤال مسبقاً',
  //     ));
  //     return;
  //   }
  //
  //   emit(SubmitPollAnswerLoadingState());
  //
  //   try {
  //     final response = await DioService().post(
  //       '/frontend/survey/responses',
  //       body: {
  //         'question_id': questionId,
  //         'answer_id': answerId,
  //       },
  //     );
  //
  //     response.fold(
  //           (error) {
  //         emit(SubmitPollAnswerErrorState(errorMessage: error.toString()));
  //       },
  //           (success) {
  //         final data = success.data;
  //         if (data['success'] == true) {
  //           submittedQuestions.add(questionId);
  //         }
  //
  //         final message = data['messages'] ??
  //             data['message'] ??
  //             'Answer submitted successfully';
  //
  //         emit(SubmitPollAnswerSuccessState(message: message));
  //
  //         // ✅ ما تعملش reload للأسئلة
  //         // getAllPolls();
  //       },
  //     );
  //   } catch (e) {
  //     emit(SubmitPollAnswerErrorState(errorMessage: e.toString()));
  //   }
  // }


// Future<void> submitPollAnswer({
  //   required int questionId,
  //   required int answerId,
  // }) async {
  //   if (submittedQuestions.contains(questionId)) {
  //     emit(SubmitPollAnswerErrorState(
  //       errorMessage: 'لقد قمت بالرد على هذا السؤال مسبقاً',
  //     ));
  //     return;
  //   }
  //
  //   emit(SubmitPollAnswerLoadingState());
  //
  //   try {
  //     final response = await DioService().post(
  //       '/frontend/survey/responses',
  //       body: {
  //         'question_id': questionId,
  //         'answer_id': answerId,
  //       },
  //     );
  //
  //     response.fold(
  //           (error) {
  //         emit(SubmitPollAnswerErrorState(errorMessage: error.toString()));
  //       },
  //           (success) {
  //         final data = success.data;
  //         if (data['success'] == true) {
  //           submittedQuestions.add(questionId);
  //         }
  //
  //         final message = data['messages'] ??
  //             data['message'] ??
  //             'Answer submitted successfully';
  //
  //         emit(SubmitPollAnswerSuccessState(message: message));
  //         getAllPolls();
  //       },
  //     );
  //   } catch (e) {
  //     emit(SubmitPollAnswerErrorState(errorMessage: e.toString()));
  //   }
  // }

  Future<void> submitAllPollAnswers(Map<int, int> selectedAnswers) async {
    // ✅ لو مفيش إجابات مختارة
    if (selectedAnswers.isEmpty) {
      emit(SubmitPollAnswerErrorState(
        errorMessage: 'من فضلك اختر إجابة واحدة على الأقل',
      ));
      return;
    }

    emit(SubmitPollAnswerLoadingState());

    try {
      // ✅ جهز البيانات في ليست
      final answersList = selectedAnswers.entries.map((entry) {
        return {
          'question_id': entry.key,
          'answer_id': entry.value,
        };
      }).toList();

      final response = await DioService().post(
        '/frontend/survey/responses/multiple', // غير الـ endpoint حسب الـ API عندك
        body: {
          'answers': answersList,
        },
      );

      response.fold(
            (error) {
          emit(SubmitPollAnswerErrorState(errorMessage: error.toString()));
        },
            (success) {
          final data = success; // ✅ ده Map جاهز

          if (data['success'] == true) {
            // ✅ ضيف الأسئلة اللي اتجاوبت لقائمة submittedQuestions
            for (var entry in selectedAnswers.entries) {
              submittedQuestions.add(entry.key);
            }
          }

          final message = data['messages'] ??
              data['message'] ??
              data['data']?['message'] ?? // ✅ خد message من جوة data كمان
              'تم إرسال كل الإجابات بنجاح';

          emit(SubmitPollAnswerSuccessState(message: message));
        },
      );
    } catch (e) {
      emit(SubmitPollAnswerErrorState(errorMessage: e.toString()));
    }
  }


}
