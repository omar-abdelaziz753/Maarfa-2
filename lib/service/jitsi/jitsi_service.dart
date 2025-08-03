import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import '../network/dio/dio_service.dart';

class JitsiService {
  joinMeeting({
    required String roomNo,
    required String token,
    required int userId,
    required int timeId,
  }) async {
    try {
      var jitsiMeet = JitsiMeet();

      Map<String, Object> featureFlagEnum = {};
      featureFlagEnum[FeatureFlag.iosRecordingEnabled.key] = false;
      featureFlagEnum[FeatureFlag.welcomePageEnabled.key] = false;
      featureFlagEnum[FeatureFlag.meetingPasswordEnabled.key] = false;
      featureFlagEnum[FeatureFlag.chatEnabled.key] = true;
      featureFlagEnum[FeatureFlag.inviteEnabled.key] = false;
      featureFlagEnum[FeatureFlag.addPeopleEnabled.key] = false;
      featureFlagEnum[FeatureFlag.callIntegrationEnabled.key] = false;
      featureFlagEnum[FeatureFlag.toolboxAlwaysVisible.key] = false;
      featureFlagEnum[FeatureFlag.recordingEnabled.key] = false;
      featureFlagEnum[FeatureFlag.liveStreamingEnabled.key] = false;
      featureFlagEnum[FeatureFlag.kickOutEnabled.key] = false;
      featureFlagEnum[FeatureFlag.videoShareButtonEnabled.key] = false;
      featureFlagEnum[FeatureFlag.audioOnlyButtonEnabled.key] = false;
      featureFlagEnum[FeatureFlag.closeCaptionsEnabled.key] = false;
      featureFlagEnum[FeatureFlag.liveStreamingEnabled.key] = false;

      var options = JitsiMeetConferenceOptions(
        room: roomNo,
        serverURL: "https://meeting.maarefa.app/",
        // subject: "",
        token: token,
        configOverrides: {
          "startWithAudioMuted": false,
          "startWithVideoMuted": false,
          "subject": "",
        },
        // isAudioMuted: true,
        // isAudioOnly: true,
        // isVideoMuted: true,
        // userDisplayName: userId.toString(),
        // userEmail: "myemail@email.com",
        featureFlags: featureFlagEnum,
      );

      await jitsiMeet.join(
        options,
        JitsiMeetEventListener(
            conferenceWillJoin: (url) =>
                debugPrint("onConferenceWillJoin: url: $url"),
            conferenceJoined: (url) =>
                debugPrint("onConferenceJoined: url: $url"),
            readyToClose: () async => await DioService().get(
                  '/provider/time/end/$timeId',
                ),
            conferenceTerminated: (url, error) async =>
                await DioService().get(
                  '/provider/time/end/$timeId',
                ),
            participantLeft: (participantId) async => await DioService().get(
                  '/provider/time/end/$timeId',
                )),
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  joinUserMeeting({
    required String roomNo,
    required String token,
    required int userId,
  }) async {
    try {
      Map<String, Object> featureFlagEnum = {};
      featureFlagEnum[FeatureFlag.iosRecordingEnabled.key] = false;
      featureFlagEnum[FeatureFlag.welcomePageEnabled.key] = false;
      featureFlagEnum[FeatureFlag.meetingPasswordEnabled.key] = false;
      featureFlagEnum[FeatureFlag.chatEnabled.key] = true;
      featureFlagEnum[FeatureFlag.inviteEnabled.key] = false;
      featureFlagEnum[FeatureFlag.addPeopleEnabled.key] = false;
      featureFlagEnum[FeatureFlag.callIntegrationEnabled.key] = false;
      featureFlagEnum[FeatureFlag.toolboxAlwaysVisible.key] = false;
      featureFlagEnum[FeatureFlag.recordingEnabled.key] = false;
      featureFlagEnum[FeatureFlag.liveStreamingEnabled.key] = false;
      featureFlagEnum[FeatureFlag.kickOutEnabled.key] = false;
      featureFlagEnum[FeatureFlag.videoShareButtonEnabled.key] = false;
      featureFlagEnum[FeatureFlag.audioOnlyButtonEnabled.key] = false;
      featureFlagEnum[FeatureFlag.closeCaptionsEnabled.key] = false;
      featureFlagEnum[FeatureFlag.liveStreamingEnabled.key] = false;
// share
// enable lobby mode
// start rcording , start live strem
// share a youtube video
// mute everyone
// disable camera
// invite others

      var options = JitsiMeetConferenceOptions(
        room: roomNo,
        serverURL: "https://meeting.maarefa.app/",
        // subject: "",
        token: token,
        configOverrides: {
          "startWithAudioMuted": false,
          "startWithVideoMuted": false,
          "subject": "",
        },
        // isAudioMuted: true,
        // isVideoMuted: true,
        // userDisplayName: userId.toString(),
        // userEmail: "myemail@email.com",
        featureFlags: featureFlagEnum,
      );
      var jitsiMeet = JitsiMeet();
      await jitsiMeet.join(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }
}

enum FeatureFlag {
  addPeopleEnabled('add-people.enabled'),
  audioFocusDisabled('audio-focus.disabled'),
  audioMuteButtonEnabled('audio-mute.enabled'),
  audioOnlyButtonEnabled('audio-only.enabled'),
  breakoutRoomsButtonEnabled('breakout-rooms.enabled'),
  calendarEnabled('calendar.enabled'),
  callIntegrationEnabled('call-integration.enabled'),
  carModeEnabled('car-mode.enabled'),
  closeCaptionsEnabled('close-captions.enabled'),
  conferenceTimerEnabled('conference-timer.enabled'),
  chatEnabled('chat.enabled'),
  filmstripEnabled('filmstrip.enabled'),
  fullscreenEnabled('fullscreen.enabled'),
  helpButtonEnabled('help.enabled'),
  inviteEnabled('invite.enabled'),
  inviteDialInEnabled('invite-dial-in.enabled'),
  iosRecordingEnabled('ios.recording.enabled'),
  iosScreenSharingEnabled('ios.screensharing.enabled'),
  androidScreenSharingEnabled('android.screensharing.enabled'),
  speakerStatsEnabled('speakerstats.enabled'),
  kickOutEnabled('kick-out.enabled'),
  liveStreamingEnabled('live-streaming.enabled'),
  lobbyModeEnabled('lobby-mode.enabled'),
  meetingNameEnabled('meeting-name.enabled'),
  meetingPasswordEnabled('meeting-password.enabled'),
  notificationsEnabled('notifications.enabled'),
  overflowMenuEnabled('overflow-menu.enabled'),
  participantsEnabled('participants.enabled'),
  pipEnabled('pip.enabled'),
  prejoinPageEnabled('prejoinpage.enabled'),
  prejoinPageHideDisplayName('prejoinpage.hideDisplayName'),
  raiseHandEnabled('raise-hand.enabled'),
  reactionsEnabled('reactions.enabled'),
  recordingEnabled('recording.enabled'),
  replaceParticipant('replace.participant'),
  resolution('resolution'),
  securityOptionsEnabled('security-options.enabled'),
  serverUrlChangeEnabled('server-url-change.enabled'),
  settingsEnabled('settings.enabled'),
  tileViewEnabled('tile-view.enabled'),
  toolboxAlwaysVisible('toolbox.alwaysVisible'),
  toolboxEnabled('toolbox.enabled'),
  unsafeRoomWarning('unsaferoomwarning.enabled'),
  videoMuteButtonEnabled('video-mute.enabled'),
  videoShareButtonEnabled('video-share.enabled'),
  welcomePageEnabled('welcomepage.enabled');

  final String key;
  const FeatureFlag(this.key);
}
