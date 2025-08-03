import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_academy/layout/view/profile/models/contact_support_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:my_academy/service/network/dio/dio_service.dart';

part 'contact_support_service_state.dart';

class ContactSupportServiceCubit extends Cubit<ContactSupportServiceState> {
  ContactSupportServiceCubit() : super(ContactSupportServiceInitial());

  ContactSupportDataModel? supportData;

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

      print('Response: $response');
      print('Response type: ${response.runtimeType}');

      // Handle Either type response
      response.fold(
            (error) {
          // Left side - error case
          print('API Error: $error');
          emit(GetAllContactSupportServiceErrorState(
            errorMessage: error.toString(),
          ));
        },
            (success) {
          // Right side - success case
          print('API Success: $success');
          print('Success data type: ${success.runtimeType}');

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

            print('JSON Data: $jsonData');
            print('Static Message: ${jsonData['Static_Message']}');
            print('Data: ${jsonData['data']}');

            // Try to parse the model
            try {
              supportData = ContactSupportDataModel.fromJson(jsonData);
              print('Model parsed successfully');
              print('Static Message from model: ${supportData!.staticMessage}');
              print('Data from model: ${supportData!.data}');

              emit(GetAllContactSupportServiceSuccessState(
                  staticMessage: supportData!.staticMessage!,
                  data: supportData!.data!));
            } catch (modelError) {
              print('Model parsing error: $modelError');

              // Fallback: Parse manually if model fails
              final staticMessage = jsonData['Static_Message'] as String? ?? 'Hello! How can I help you?';
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
                  staticMessage: staticMessage,
                  data: questions));
            }
          } catch (parseError) {
            print('Parse error: $parseError');
            emit(GetAllContactSupportServiceErrorState(
              errorMessage: parseError.toString(),
            ));
          }
        },
      );
    } catch (e) {
      print('General error: $e');
      print('Error type: ${e.runtimeType}');
      emit(GetAllContactSupportServiceErrorState(
        errorMessage: e.toString(),
      ));
    }
  }}
