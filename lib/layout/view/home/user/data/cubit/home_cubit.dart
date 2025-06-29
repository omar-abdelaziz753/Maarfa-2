import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:my_academy/layout/activity/user_screens/home/home_screen.dart';
import 'package:my_academy/layout/activity/user_screens/main/main_screen.dart';
import 'package:my_academy/layout/view/home/user/data/cubit/home_state.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_all_best_teachers_data_model.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_all_specializations_data_model.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_all_teachers_data_model.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_teacher_details_data_model.dart';
import 'package:my_academy/layout/view/home/user/teacher_details/booking_confirmation_dialog.dart';
import 'package:my_academy/service/network/dio/dio_service.dart';

import '../../../../../../model/common/search/search_db_response.dart';

//
// // class HomeCubit extends Cubit<HomeState> {
// //   HomeCubit() : super(HomeInitial());
// //
//   final DioService _dioService = DioService();
// //   List<Provider> allTeachers = [];
// //   int currentPage = 1;
// //   bool hasMoreData = true;
// //   bool isLoadingMore = false;
// //
// //   // Get all teachers with pagination
// //   Future<void> getAllTeachers({bool isLoadMore = false}) async {
// //     if (isLoadMore) {
// //       if (isLoadingMore || !hasMoreData) return;
// //       emit(GetAllTeachersLoadingMoreState());
// //       isLoadingMore = true;
// //     } else {
// //       emit(GetAllTeachersLoadingState());
// //       currentPage = 1;
// //       allTeachers.clear();
// //       hasMoreData = true;
// //     }
// //
// //     try {
// //       final Either<String, dynamic> result = await _dioService.get(
// //         '/clients/providers/list',
// //         queryParams: {
// //           'page': currentPage.toString(),
// //         },
// //       );
// //
// //       result.fold(
// //             (error) {
// //           isLoadingMore = false;
// //           emit(GetAllTeachersErrorState(errorMessage: error));
// //         },
// //             (response) {
// //           if (response['success'] == true && response['data'] != null) {
// //             final List<dynamic> teachersData = response['data']['providers'] ?? [];
// //             final List<Provider> newTeachers = teachersData
// //                 .map((json) => Provider.fromJson(json))
// //                 .toList();
// //
// //             if (isLoadMore) {
// //               allTeachers.addAll(newTeachers);
// //             } else {
// //               allTeachers = newTeachers;
// //             }
// //
// //             // Check if there's more data based on the response
// //             // You might need to adjust this based on your API response structure
// //             hasMoreData = newTeachers.isNotEmpty && newTeachers.length >= 10; // Assuming 10 items per page
// //             currentPage++;
// //
// //             isLoadingMore = false;
// //             emit(GetAllTeachersLoadedState());
// //           } else {
// //             isLoadingMore = false;
// //             emit(GetAllTeachersErrorState(
// //                 errorMessage: response['messages']?.toString() ?? 'Unknown error occurred'
// //             ));
// //           }
// //         },
// //       );
// //     } catch (e) {
// //       isLoadingMore = false;
// //       emit(GetAllTeachersErrorState(errorMessage: e.toString()));
// //     }
// //   }
// //
// //   // Load more teachers
// //   Future<void> loadMoreTeachers() async {
// //     await getAllTeachers(isLoadMore: true);
// //   }
// // }
// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeInitial());
//
//   final DioService _dioService = DioService();
//   List<Provider> allTeachers = [];
//   int currentPage = 1;
//   bool hasMoreData = true;
//   bool isLoadingMore = false;
//
//   // Get all teachers with pagination
//   Future<void> getAllTeachers({bool isLoadMore = false}) async {
//     if (isLoadMore) {
//       if (isLoadingMore || !hasMoreData) return;
//       emit(GetAllTeachersLoadingMoreState());
//       isLoadingMore = true;
//     } else {
//       emit(GetAllTeachersLoadingState());
//       currentPage = 1;
//       allTeachers.clear();
//       hasMoreData = true;
//     }
//
//     try {
//       final Either<String, dynamic> result = await _dioService.get(
//         '/clients/providers/list/2',
//         queryParams: {
//           'page': currentPage.toString(),
//         },
//       );
//
//       result.fold(
//             (error) {
//           isLoadingMore = false;
//           emit(GetAllTeachersErrorState(errorMessage: error));
//         },
//             (response) {
//           if (response['success'] == true && response['data'] != null) {
//             final List<dynamic> teachersData = response['data']['providers'] ?? [];
//             final List<Provider> newTeachers = teachersData
//                 .map((json) => Provider.fromJson(json))
//                 .toList();
//
//             if (isLoadMore) {
//               allTeachers.addAll(newTeachers);
//             } else {
//               allTeachers = newTeachers;
//             }
//
//             // Check if there's more data based on the response
//             // You might need to adjust this based on your API response structure
//             hasMoreData = newTeachers.isNotEmpty && newTeachers.length >= 10; // Assuming 10 items per page
//             currentPage++;
//
//             isLoadingMore = false;
//             emit(GetAllTeachersLoadedState());
//           } else {
//             isLoadingMore = false;
//             emit(GetAllTeachersErrorState(
//                 errorMessage: response['messages']?.toString() ?? 'Unknown error occurred'
//             ));
//           }
//         },
//       );
//     } catch (e) {
//       isLoadingMore = false;
//       emit(GetAllTeachersErrorState(errorMessage: e.toString()));
//     }
//   }
//
//   // Load more teachers
//   Future<void> loadMoreTeachers() async {
//     await getAllTeachers(isLoadMore: true);
//   }
// }

class Home2Cubit extends Cubit<Home2State> {
  Home2Cubit() : super(HomeInitial());

  List<Providers> allTeachers = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  List<SpecializationData> allSpecializations = [];
  GetTeacherDetailsDataModel? teacherDetailsDataModel;
  GetAllBestTeacherDataModel? bestTeacherDataModel;
  List<ProvidersMM> bestTeachers = [];

  /// Get All Best Teachers Function
  // Future<void> getAllBestTeachers() async {
  //   emit(GetAllBestTeachersLoadingState());
  //   try {
  //     final response = await DioService().get('/clients/providers/best-list');
  //     response.fold((error) {
  //       emit(GetAllBestTeachersErrorState(errorMessage: error));
  //     }, (data) {
  //       teacherDetailsDataModel = GetTeacherDetailsDataModel.fromJson(data);
  //       print('teacherDetailsDataModel');
  //       print(teacherDetailsDataModel?.data?.provider ?? 'null');
  //       print('teacherDetailsDataModel');
  //
  //       // Extract provider details for best teachers
  //       bestTeachers = teacherDetailsDataModel?.data?.provider != null
  //           ? [teacherDetailsDataModel!.data!.provider!]
  //           : [];
  //
  //       emit(GetAllBestTeachersSuccessState());
  //     });
  //   } catch (e) {
  //     emit(GetAllBestTeachersErrorState(errorMessage: e.toString()));
  //   }
  // }
  Future<void> getAllBestTeachers() async {
    emit(GetAllBestTeachersLoadingState());
    try {
      final response = await DioService().get('/clients/providers/best-list');
      response.fold((error) {
        emit(GetAllBestTeachersErrorState(errorMessage: error));
      }, (data) {
        bestTeacherDataModel = GetAllBestTeacherDataModel.fromJson(data);
        print('Full response: $data');
        print('Parsed provider: ${bestTeacherDataModel?.data?.providers}');

        if (bestTeacherDataModel?.data?.providers != null) {
          // provider is a single object, so wrap it into a list
          bestTeachers = bestTeacherDataModel!.data!.providers!;
        } else {
          bestTeachers = [];
        }

        emit(GetAllBestTeachersSuccessState());
      });
    } catch (e) {
      emit(GetAllBestTeachersErrorState(errorMessage: e.toString()));
    }
  }

  /// Get All Specializations Function
  Future<void> getAllSpecializations() async {
    emit(GetAllSpecializationsLoadingState());
    try {
      final response = await DioService().get('/specializations');

      response.fold((error) {
        emit(GetAllSpecializationsErrorState(errorMessage: error));
      }, (data) {
        // allSpecializations = (data['data'] as List)
        //     .map((e) => Data.fromJson(e))
        //     .toList();
        allSpecializations = (data['data'] as List)
            .map((e) => SpecializationData.fromJson(e))
            .toList();
        emit(GetAllSpecializationsSuccessState());
      });
    } catch (e) {
      emit(GetAllSpecializationsErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> getAllTeachers({required int specialityId}) async {
    emit(GetAllTeachersLoadingState());
    try {
      _currentPage = 1;
      _hasMore = true;
      allTeachers = await fetchTeachers(
          page: _currentPage, limit: _limit, specialityId: specialityId);
      emit(GetAllTeachersSuccessState());
    } catch (e) {
      emit(GetAllTeachersErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> loadMoreTeachers({required int specialityId}) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    emit(GetAllTeachersLoadingMoreState());

    try {
      _currentPage++;
      final List<Providers> moreTeachers = await fetchTeachers(
        page: _currentPage,
        limit: _limit,
        specialityId: specialityId,
      );

      if (moreTeachers.isEmpty) {
        _hasMore = false;
      } else {
        allTeachers.addAll(moreTeachers);
      }

      emit(GetAllTeachersSuccessState());
    } catch (e) {
      _currentPage--; // revert on failure
      emit(GetAllTeachersErrorState(errorMessage: e.toString()));
    }

    _isLoadingMore = false;
  }

  // Mock function (replace with real API call)
  Future<List<Providers>> fetchTeachers(
      {required int page,
      required int limit,
      required int specialityId}) async {
    final response = await DioService().get(
      '/clients/providers/list/$specialityId',
      queryParams: {
        'page': page,
        'limit': limit,
      },
    );

    return response.fold((error) {
      throw Exception(error);
    }, (data) {
      final List<dynamic> providersJson = data['data']['providers'];
      return providersJson.map((json) => Providers.fromJson(json)).toList();
    });
  }

  /// Get Teacher Details Function
  Future<void> getTeacherDetails({required int providerId}) async {
    emit(GetTeacherDetailsLoadingState());
    try {
      final response =
          await DioService().get('/clients/providers/$providerId/show');
      response.fold((error) {
        emit(GetTeacherDetailsErrorState(errorMessage: error));
      }, (data) {
        teacherDetailsDataModel = GetTeacherDetailsDataModel.fromJson(data);
        emit(GetTeacherDetailsSuccessState());
      });
    } catch (e) {
      emit(GetTeacherDetailsErrorState(errorMessage: e.toString()));
    }
  }

  /// Make Book Function
  Future<void> makeBook({
    required String teacherId,
    required String clientId,
    required String date,
    required String timeFrom,
    required String timeTo,
    required String type, // lesson, course, etc.
    required BuildContext context, // lesson, course, etc.
  }) async {
    emit(MakeBookLoadingState());
    try {
      final response = await DioService().post(
        '/clients/providers/request-lesson/$teacherId',
        body: {
          "client_id": clientId,
          "date": date,
          "time_from": timeFrom,
          "time_to": timeTo,
          "type": type,
        },
      );

      response.fold((error) {
        emit(MakeBookErrorState(errorMessage: error));
      }, (data) {
        // Assuming the API returns success: true on successful booking
        if (data['success'] == true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking confirmed successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          emit(MakeBookSuccessState());
        } else {
          Navigator.of(context).pop();

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${data['message']}' ?? 'Booking failed. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );


          emit(MakeBookErrorState(
              errorMessage: data['message'] ?? 'Booking failed'));
        }
      });
    } catch (e) {
      emit(MakeBookErrorState(errorMessage: e.toString()));
    }
  }
}
