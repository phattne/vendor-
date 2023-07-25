class Productmedol {
  Productmedol({
    required this.imageUrl,
    required this.price,
    required this.soluong,
    required this.name,
    required this.quantity,
  });

  final String imageUrl;
  final String name;
  final double price;
  final double soluong;
  int quantity = 1;
}
