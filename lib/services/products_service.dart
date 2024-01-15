// ignore_for_file: unused_field, unused_local_variable, non_constant_identifier_names, unnecessary_this

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seminariovalidacion/model/product.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProductsService extends ChangeNotifier {
  bool isLoading = false;
  bool isSaving = false;
  final String _baseUrl = 'flutter-varios-15c4c-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  late Product selectedProduct;
  File? newPictureFile;

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

  Future deleteProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.delete(url);
    final decodedData = jsonDecode(resp.body);

    this.products.remove(product);
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

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtvrvsao1/image/upload?upload_preset=oal8ztve');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Ha habido un error');
      print(resp.body);
      return null;
    }

    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
