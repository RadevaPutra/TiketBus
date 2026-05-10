class BusSchedule {
  final String operatorName;
  final String departureTime;
  final String duration;
  final String origin;
  final String destination;
  final int price;
  final int availableSeats;
  final String classType;
  final List<String> facilities;

  BusSchedule({
    required this.operatorName,
    required this.departureTime,
    required this.duration,
    required this.origin,
    required this.destination,
    required this.price,
    required this.availableSeats,
    this.classType = "Executive",
    this.facilities = const ["AC", "WiFi"],
  });
}
