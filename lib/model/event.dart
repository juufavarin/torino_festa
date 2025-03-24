class Event {
  String name;
  String link;
  String latInitial;
  String longInitial;
  String latEnd;
  String longEnd;
  DateTime startDate;
  DateTime endDate;

  Event({
    required this.name,
    required this.link,
    required this.latInitial,
    required this.longInitial,
    required this.latEnd,
    required this.longEnd,
    required this.startDate,
    required this.endDate,
  });

  // Método para converter um JSON em um objeto Event
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      link: json['link'],
      latInitial: json['latInitial'],
      longInitial: json['longItial'],
      latEnd: json['latEnd'],
      longEnd: json['longEnd'],
      startDate: DateTime.parse(json["dateStart"]),
      endDate: DateTime.parse(json["dataEnd"]),
    
    );
  }
}
