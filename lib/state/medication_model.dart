class Medication {
  String name;
  String mg;
  String time;
  bool taken;

  Medication({
    required this.name,
    required this.mg,
    required this.time,
    this.taken = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'mg': mg,
        'time': time,
        'taken': taken,
      };

  factory Medication.fromJson(Map<String, dynamic> json,
      {bool resetTaken = false}) {
    return Medication(
      name: json['name'] ?? '',
      mg: json['mg'] ?? '',
      time: json['time'] ?? '',
      taken: resetTaken ? false : (json['taken'] ?? false),
    );
  }
}
