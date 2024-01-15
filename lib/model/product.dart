// ignore_for_file: unnecessary_this

import 'dart:convert';

class Product {
  String? id;
  bool available;
  String name;
  String? picture;
  double price;
  String date;

  Product({this.id, required this.available, required this.name, this.picture, required this.price, required this.date});

  Product copy() => Product(available: this.available, name: this.name, picture: this.picture, price: this.price, id: this.id, date: this.date);

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) =>
      Product(id: json["id"], available: json["available"], name: json["name"], picture: json["picture"], price: json["price"].toDouble(), date: json["date"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };
}
