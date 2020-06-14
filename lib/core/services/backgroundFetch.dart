import 'dart:async';
import 'dart:io';
import 'package:covid_charts/core/services/permission.dart';
import 'package:geolocator/geolocator.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:path_provider/path_provider.dart';

class BackgroundProcess {
  static void backgroundFetchHeadlessTask(String taskId) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final file =   File('$tempPath/locations.txt');
    final position =  await PermissionService.hasLocationPermission()? await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.medium): Position(latitude: 0.0,longitude: 0.0,timestamp: DateTime.now());
    file.writeAsString(' LOCATION: ${position.toString()} ; TIME :  ${position.timestamp} \r\n\n', mode: FileMode.append);
    //print('[BackgroundFetch] Headless event received.');
    BackgroundFetch.finish(taskId);
  }

  static Future<Position> _displayCurrentLocation() async {
    return await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
  }

  static void _onBackgroundFetch(String taskId) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final file =   File('$tempPath/text.txt');
    final position =  await _displayCurrentLocation();
    file.writeAsString(' LOCATION: ${position.toString()} ; TIME :  ${position.timestamp} \r\n\n', mode: FileMode.append);
    BackgroundFetch.finish(taskId);
  }

 static Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), _onBackgroundFetch).then((int status) {
      //print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
    });

    // Optionally query the current BackgroundFetch status.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
   // if (!mounted) return;
  }

}
