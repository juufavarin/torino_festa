class Event {
  String name;
  String link;
  String latInitial;
  String longInitial;
  String latEnd;
  String longEnd;

  Event({
    required this.name,
    required this.link,
    required this.latInitial,
    required this.longInitial,
    required this.latEnd,
    required this.longEnd,
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
    );
  }
}
