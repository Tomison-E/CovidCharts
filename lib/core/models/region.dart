class Region {
  final int infected;
  final int position;
  final String name;

  Region(
      {this.infected,
      this.name,
      this.position});

  Region.fromMap(Map<dynamic, dynamic> map)
      : infected = map["infected"],
        position = map["position"],
        name = map["name"];

  Map<String, dynamic> toJson() => {
        'infected': infected,
        'positon': position,
        'name': name
      };

  Region.fromJson(Map<String, dynamic> json)
      : infected = json['infected'],
        position = json['position'],
        name = json['name'];
}

class Day {
  List<Region> regions;
  Day({this.regions});

  Day.fromMap(Map<String, dynamic> maps) {
    var list = maps["corona"] as List;
    regions = list.map<Region>((j) {
      return Region.fromMap(j);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'regions': regions.map((i) => i.toJson()).toList(),
      };
}

class AnimationData {
  final List<Day> days;
  AnimationData({this.days});

  AnimationData.fromMap(List<dynamic> maps)
      : days = maps.map((i) {
          return Day.fromMap(i);
        }).toList();
}
