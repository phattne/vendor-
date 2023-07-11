// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

class Product {
  Product({
    required this.price,
    this.id,
    required this.rollno,
    required this.name,
    
  });

  String? id;
  final int rollno;
  final String name;
  final num price;

}
