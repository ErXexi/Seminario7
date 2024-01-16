// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:intl/intl.dart';

class Product {
  String? id;
  bool available;
  String name;
  String? picture;
  double price;
  String date;

  Product(
      {this.id,
      required this.available,
      required this.name,
      this.picture,
      required this.price,
      required this.date});

  Product copy() => Product(
      available: this.available,
      name: this.name,
      picture: this.picture,
      price: this.price,
      id: this.id,
      date: this.date);

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"] ??
            "", // Puedes usar otro valor predeterminado si lo prefieres
        available: json["available"] ?? false,
        name: json["name"] ?? "",
        picture: json["picture"] ?? "",
        price: json["price"]?.toDouble() ?? 0.0,
        date: json["date"] ??
            DateFormat('dd/MM/yyyy').format(
                DateTime.now()),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };
}
