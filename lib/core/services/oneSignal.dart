import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalHandler{

  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> initPlatformState() async {
    //if (!mounted) return;

    //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    //OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {});

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {});

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {});

    await OneSignal.shared
        .init("aec762a9-5e5e-45c5-9bab-fe4d48d396fe", iOSSettings: settings);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }
}