import 'package:covid_charts/core/models/location.dart';
import 'package:covid_charts/core/models/region.dart';
import 'package:covid_charts/core/services/api.dart';
import 'package:covid_charts/core/services/sharedPref.dart';

 class LocationVM{
  Api _api = Api();
  Location location;
  Locations locations;
  AnimationData animationData;


  Future<bool> getLocationData() async{
    bool status = false;
   try{

    var result = await _api.getLatest();
    if (result == null) {
      throw "Error connecting.";
    }
    else if (result.statusCode == 200) {
    location = Location(number:result.data["infected"],name: "Nigeria",deaths: result.data["deceased"],discharged: result.data["recovered"],active: result.data["activeCases"] );
    status = location.number > 0 ? true : false;
    }
    else {
      throw "Error getting data";
    }
   }
   catch(e){
   }

    return status;
  }


  Future<bool> getHistoryData() async{
    bool status = false;
    try{

      var result = await _api.getHistorical();
      if (result == null) {
        throw "Error connecting.";
      }
      else if (result.statusCode == 200) {
        locations = Locations.fromMap(result.data);
        SharedPref.save("locations", result.data);
         status = locations.location.isNotEmpty ? true : false;
      }
      else {
        throw "Error getting data";
      }
    }
    catch(e){
    }

    return status;
  }

  Future<bool> getRegionalData() async{
    bool status = false;
    try{

      var result = await _api.getRegional();
      if (result == null) {
        throw "Error connecting.";
      }
      else if (result.statusCode == 200) {
        animationData = AnimationData.fromMap(result.data);
        SharedPref.save("animationData", result.data);
        status = animationData.days[0].regions.isNotEmpty ? true : false;
      }
      else {
        throw "Error getting data";
      }
    }
    catch(e){
    }

    return status;
  }

 }