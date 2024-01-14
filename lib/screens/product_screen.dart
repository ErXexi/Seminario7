// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/model/product.dart';
import 'package:seminariovalidacion/providers/product_form_provider.dart';
import 'package:seminariovalidacion/services/products_service.dart';
import 'package:seminariovalidacion/ui/input_decorations.dart';
import 'package:seminariovalidacion/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct),
      child: _ProductScreenBody(productsService: productsService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!productFormProvider.isValidForm()) return;
          await productsService.saveOrCreateProduct(productFormProvider.product);
          Navigator.pop(context);
        },
        child: Icon(Icons.save_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productFormProvider.product.picture),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {},
                    )),
              ],
            ),
            _ProductForm(
              product: productsService.selectedProduct,
            )
          ],
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  final Product product;
  const _ProductForm({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: _FormDecoration(),
        child: Form(
          key: productFormProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.length < 1) return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre:',
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
              ),
              SizedBox(height: 30),
              SwitchListTile.adaptive(
                value: productFormProvider.product.available,
                onChanged: (value) => productFormProvider.updateAvailability(value),
                title: Text('Disponible'),
                activeColor: Colors.indigo,
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _FormDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: Offset(0, 5), blurRadius: 5)]);
  }
}
