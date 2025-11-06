import 'package:bloc/bloc.dart';
import 'package:my_academy/repository/common/notifications/notifications_repository.dart';

import '../../model/provider/notification_provider/notification_provider_model.dart';
import '../../model/user/notification_user/notification_user_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.notificationsRepository)
      : super(NotificationsInitial());
  NotificationsRepository notificationsRepository;

  getNotificationsProvider() {
    notificationsRepository.providerNotifications().then((value) {
      return emit(NotificationsProviderLoadedState(data: value.data));
    });
  }

  getNotificationsUser() {
    notificationsRepository.userNotifications().then((value) {
      return emit(NotificationsUserLoadedState(data: value.data));
    });
  }
}