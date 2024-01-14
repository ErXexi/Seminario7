// ignore_for_file: unused_local_variable, prefer_const_constructors, unnecessary_new
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/model/product.dart';
import 'package:seminariovalidacion/screens/screens.dart';
import 'package:seminariovalidacion/services/services.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    if (productsService.isLoading) return LoadingScreen();
    return Scaffold(
        appBar: AppBar(
          title: Text("Productos"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            productsService.selectedProduct = new Product(
              available: false,
              name: '',
              price: 0.00,
            );
            await Navigator.pushNamed(context, 'product');

            // Después de regresar de 'product', recarga la lista de productos
            await productsService.reload();
          },
        ),
        body: ListView.builder(
            itemCount: productsService.products.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    productsService.selectedProduct =
                        productsService.products[index].copy();
                    Navigator.pushNamed(context, 'product')
                        .then((_) => productsService.reload());
                  },
                  child: ProductCard(
                    product: productsService.products[index],
                  ),
                )));
  }
}
