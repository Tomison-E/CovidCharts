import 'dart:io';
import 'dart:ui';
import 'package:covid_charts/core/services/backgroundFetch.dart';
import 'package:covid_charts/core/services/oneSignal.dart';
import 'package:covid_charts/core/services/permission.dart';
import 'package:covid_charts/ui/widgets/info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:covid_charts/core/models/region.dart';

import 'package:covid_charts/core/models/location.dart';
import 'package:covid_charts/core/services/sharedPref.dart';
import 'package:covid_charts/core/viewModels/locationVM.dart';
import 'package:covid_charts/ui/widgets/pieChart.dart';
import 'package:covid_charts/ui/widgets/background.dart';
import 'package:covid_charts/utils/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:covid_charts/ui/widgets/barChart.dart';
import 'package:covid_charts/ui/widgets/lineChart.dart';
import 'package:covid_charts/ui/widgets/animate.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;
  LocationVM locationVM = LocationVM();
  bool loading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    try {
      loadSharedPrefs();
      loadData().then((value) {
        setState(() {
          loading = false;
        });
        if (value == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              showInSnackBar("Confirm Connection : Unable to load data"));
        }
      });
      PermissionService.hasLocationPermission().then((val) {
        if (val) {
          registerLocation();
          BackgroundProcess.initPlatformState();
        }
      });
      OneSignalHandler.initPlatformState();
    } catch (exception) {}
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async =>
        (await SharedPref.getInt("appLaunch") ?? 0) == 0
            ? initLoadPermissions()
            : loadPermissions(context));
  }

  Future<bool> loadData() async {
    var valB = false;
    bool valC = false;
    await locationVM.getLocationData()
        ? valB = await locationVM.getRegionalData()
        : print("");
    if (valB) {
      valC = await locationVM.getHistoryData();
      if (valC) {
        SharedPref.save("location", locationVM.location);
      }
    }
    return valC;
  }

  loadSharedPrefs() async {
    try {
      Location location = Location.fromJson(await SharedPref.read("location"));
      Locations locations =
          Locations.fromMap(await SharedPref.read("locations"));
      AnimationData animationData =
          AnimationData.fromMap(await SharedPref.read("animationData"));

      if (locations != null && location != null && animationData != null) {
        setState(() {
          locationVM.location = location;
          locationVM.locations = locations;
          locationVM.animationData = animationData;
          loading = false;
        });
      }
    } catch (Exception) {}
  }

  reload() async {
    setState(() {
      loading = true;
    });
    bool check = await loadData();
    setState(() {
      loading = false;
    });
    if (check == false) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => showInSnackBar("Confirm Connection : Unable to load data"));
    }
  }

  void openFile() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final file = File('$tempPath/locations.txt');
    await OpenFile.open(file.path);
  }

  void registerLocation() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final file = File('$tempPath/locations.txt');
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    file.writeAsString(
        ' LOCATION: ${position.toString()} ; TIME :  ${position.timestamp} \r\n\n',
        mode: FileMode.append);
  }

  void initLocationFile() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final file = File('$tempPath/locations.txt');
    file.writeAsString('LOCATIONS DATA: \r\n\n', mode: FileMode.append);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return loading
        ? loader()
        : Scaffold(
            key: _scaffoldKey,
            appBar: locationVM.locations == null
                ? null
                : AppBar(
                    title: Text("Covid Charts",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    centerTitle: false,
                    backgroundColor: Color.fromRGBO(245, 89, 37, 1.0),
                    elevation: 0,
                    leading: Text(""),
                    actions: <Widget>[
                      SizedBox(width: 10.0),
                      IconButton(
                          icon: Icon(Icons.location_on), onPressed: openFile)
                    ],
                  ),
            body: locationVM.locations == null ||
                    locationVM.animationData.days.isEmpty
                ? Info(
                    image: "assets/images/IMG_9645.PNG",
                    title: "No Data Found",
                    detail:
                        "There is an error trying to access this information",
                    label: "Try Again",
                    highlightColor: Color.fromRGBO(245, 89, 37, 1.0),
                    action: () => reload())
                : Container(
                    child: SingleChildScrollView(
                        child: SizedBox(
                            child: Stack(children: [
                              Base(topFlex: 3),
                              Column(children: <Widget>[
                                ConstrainedBox(
                                    child: TabBarView(children: [
                                      BarChartSample2(
                                          locations:
                                              locationVM.locations.location),
                                      PieChartSample2(locationVM.location),
                                      LineChartSample1(
                                          location:
                                              locationVM.locations.location),
                                    ], controller: _tabController),
                                    constraints: BoxConstraints.tightFor(
                                        height: SizeConfig.blockSizeVertical *
                                                    35 >
                                                250
                                            ? SizeConfig.blockSizeVertical * 35
                                            : 250)),
                                SizedBox(
                                    height: SizeConfig.blockSizeVertical * 3),
                                Material(
                                  child: Container(
                                    width: 250,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white),
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(Icons.insert_chart,
                                                color: _tabController.index == 0
                                                    ? Color.fromRGBO(
                                                        245, 89, 37, 1.0)
                                                    : Colors.black45),
                                            onPressed: () {
                                              _tabController.animateTo(0,
                                                  curve: Curves.elasticIn);
                                              setState(() {});
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.pie_chart,
                                                color: _tabController.index == 1
                                                    ? Color.fromRGBO(
                                                        245, 89, 37, 1.0)
                                                    : Colors.black45),
                                            onPressed: () {
                                              _tabController.animateTo(1,
                                                  curve: Curves.elasticIn);
                                              setState(() {});
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.show_chart,
                                                color: _tabController.index == 2
                                                    ? Color.fromRGBO(
                                                        245, 89, 37, 1.0)
                                                    : Colors.black45),
                                            onPressed: () {
                                              _tabController.animateTo(2,
                                                  curve: Curves.elasticIn);
                                              setState(() {});
                                            }),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                    ),
                                  ),
                                  elevation: 20,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                Expanded(
                                    child: Animate(
                                        days: locationVM.animationData.days)),
                              ])
                            ]),
                            height: (locationVM
                                        .animationData.days[0].regions.length *
                                    50.0 +
                                50.0 +
                                SizeConfig.blockSizeVertical * 63))),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Color.fromRGBO(245, 89, 37, 1.0),
                          Colors.white
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter))),
            backgroundColor: Colors.white);
  }

  loader() {
    return Container(
      constraints: BoxConstraints.expand(),
      child: SpinKitRipple(color: Colors.white, size: 150.0),
      color: Color.fromRGBO(245, 89, 37, 1.0),
    );
  }

  void showCustomDialogWithImage(BuildContext context, String image,
      String title, String detail, String label) {
    Dialog dialogWithImage = Dialog(
        child: Container(
      height: SizeConfig.blockSizeVertical * 80,
      width: SizeConfig.blockSizeHorizontal * 80,
      child: Info(
          image: image,
          title: title,
          detail: detail,
          label: label,
          highlightColor: Color.fromRGBO(245, 89, 37, 1.0),
          action: () => PermissionService.openSettings()),
    ));
    showDialog(
        context: context, builder: (BuildContext context) => dialogWithImage);
  }

  void loadPermissions(BuildContext context) async {
    bool permissionA = await SharedPref.getBool("notificationPermission");
    bool permissionB = await SharedPref.getBool("locationPermission");
    int appLaunch = await SharedPref.getInt("appLaunch");
    if (permissionA == false) {
      bool permission = await PermissionService.hasNotificationPermission();
      if (appLaunch % 3 == 1 && permission == false) {
        showCustomDialogWithImage(
            context,
            "assets/images/IMG_9645.PNG",
            "Notifications Permission\n",
            "Kindly allow Covid Charts to send you notifications regarding the current status of the COVID-19 virus. ",
            "Allow");
      }
    }

    if (permissionB == false) {
      bool permission = await PermissionService.hasLocationPermission();
      if (appLaunch % 5 == 1 && permission == false) {
        showCustomDialogWithImage(
            context,
            "assets/images/IMG_9646.PNG",
            "Location Permission\n",
            "Kindly Allow Covid Charts to store your location data on your device as a means to flatten the curve",
            "Allow");
      }
    }
    SharedPref.storeInt("appLaunch", ++appLaunch);
  }

  void initLoadPermissions() {
    initLocationFile();
    PermissionService.requestPermission();
    SharedPref.storeInt("appLaunch", 1);
  }
}
