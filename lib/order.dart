class Order {
  int? id;
  String? productName;

  Order({this.id, this.productName});

  // Convert an Order object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
    };
  }

  // A method to convert the map back to an Order object
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      productName: map['productName'],
    );
  }
}
