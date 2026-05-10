class Seat {
  final String id;
  final String label;
  bool isAvailable;
  bool isSelected;

  Seat({
    required this.id, 
    required this.label, 
    this.isAvailable = true, 
    this.isSelected = false
  });
}