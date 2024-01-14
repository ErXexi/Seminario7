import 'package:flutter/material.dart';
import 'package:seminariovalidacion/model/product.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Product product;
  ProductFormProvider(this.product);

  bool isValidForm() {
    print('nombre' + product.name);
    print('price' + product.price.toString());
    print('available' + product.available.toString());
    return formKey.currentState?.validate() ?? false;
  }

  void updateAvailability(bool value) {
    this.product.available = value;
    notifyListeners();
  }
}
