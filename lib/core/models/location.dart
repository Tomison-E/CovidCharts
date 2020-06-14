
class Location {
  final int number;
  final int discharged;
  final int deaths;
  final int active;
  DateTime date;
  final String name;

  Location({this.number,this.name = "nigeria",this.deaths,this.discharged,this.active});

  Location.fromMap(Map<dynamic, dynamic> map)
      : number = value(map["infected"]),
        discharged = value(map["recovered"]),
        deaths = value(map["deceased"]),
        active =  (value(map["infected"])  - value(map["recovered"]) + value(map["deceased"])) ,
        date= DateTime.parse(map["lastUpdatedAtApify"]),
        name = "Nigeria";

static int value(dynamic val){
  String number = val.toString();
  String a = number.replaceFirst(">", "");
  return int.parse(a);
}

  Map<String, dynamic> toJson() => {
    'number': number,
    'discharged': discharged,
    'deaths': deaths,
    'active': active,
    'date': date,
    'name':name
  };

  Location.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        deaths = json['deaths'],
        date = json['date'],
        active = json['active'],
        name = json['name'],
        discharged = json['discharged'];

}


class Locations {
  final List<Location> location;
  Locations({this.location});


  Locations.fromMap(List<dynamic> maps):
    location = maps.map((i)=> Location.fromMap(i)).toList();

  Map<String, dynamic> toJson() => {
    'location': location.map((i)=> i.toJson()).toList(),
  };

  Locations.fromJson(List<dynamic> json)
      : location = json.map((i)=> Location.fromJson(i)).toList();

}
