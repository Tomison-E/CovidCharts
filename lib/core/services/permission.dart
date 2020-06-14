import 'package:covid_charts/core/services/sharedPref.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService{

  static void requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
      Permission.notification,
    ].request();
    if (statuses[Permission.locationAlways]!= PermissionStatus.granted) {
      SharedPref.storeBool("locationPermission",false);
    }
    else {
      SharedPref.storeBool("locationPermission",true);
    }
    if (statuses[Permission.notification]!= PermissionStatus.granted) {
      SharedPref.storeBool("notificationPermission",false);
    }
    else {
      SharedPref.storeBool("notificationPermission",true);
    }
   return;
  }


  static Future<bool> requestNotificationPermission() async {
    return await Permission.notification.request().isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    return await Permission.locationAlways.request().isGranted;
  }

  static Future<bool> hasNotificationPermission() async {
    return _hasPermission(Permission.notification);
  }

  static Future<bool> hasLocationPermission() async {
    return _hasPermission(Permission.locationAlways);
  }

  static Future<bool> _hasPermission(Permission permission) async {
    var permissionStatus =
    await permission.isGranted;
    return permissionStatus;
  }

  static openSettings() {
    openAppSettings();
  }
}