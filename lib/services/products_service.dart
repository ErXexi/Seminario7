// ignore_for_file: unused_field, unused_local_variable, non_constant_identifier_names, unnecessary_this

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seminariovalidacion/model/product.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  bool isLoading = false;
  bool isSaving = false;
  final String _baseUrl =
      'flutter-varios-15c4c-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  late Product selectedProduct;

  ProductsService() {
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, '/products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });

    this.isLoading = false;
    print("sale");
    notifyListeners();
    print(products);

    return this.products;
  }

  Future<List<Product>> reload() async {
    products.clear();
    return loadProducts();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    return product.id!;
  }

    Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());
    final decodedData = resp.body;

    return '';
  }

  Future saveOrCreateProduct(Product product) async {
    print('entra a crear/editar');
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      await this.createProduct(product);
    } else {
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }
}
