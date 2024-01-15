// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
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
            final String? imageUrl = await productsService.uploadImage();

            if (imageUrl != null) {
              productsService.selectedProduct.picture = imageUrl;
            }
            await productsService.saveOrCreateProduct(productFormProvider.product);
            Navigator.pop(context);
          },
          child: productsService.isSaving
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Icon(Icons.save_outlined)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        onPressed: () async {
                          productsService.isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Icon(Icons.camera_alt_outlined);
                          String? urlImage = await _processImage();
                          productsService.updateSelectedProductImage(urlImage!);
                        },
                      )),
                  Positioned(
                    top: 57,
                    right: 80,
                    child: IconButton(
                      icon: Icon(
                        Icons.image_search,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () async {
                        productsService.isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Icon(Icons.camera_alt_outlined);
                        String? urlImage = await _processImageFromGallery();
                        productsService.updateSelectedProductImage(urlImage!);
                      },
                    ),
                  ),
                ],
              ),
              _ProductForm(
                product: productsService.selectedProduct,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _processImage() async {
    final _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (pickedFile == null) {
      print('No seleccionó nada');
      return null;
    } else {
      print('Tenemos imagen ${pickedFile.path}');
      return pickedFile.path;
    }
  }

  Future<String?> _processImageFromGallery() async {
    final _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile == null) {
      return null;
    } else {
      return pickedFile.path;
    }
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
              SizedBox(
                height: 30,
              ),
              _datePicker(context),
              SizedBox(height: 30),
              SwitchListTile.adaptive(
                value: productFormProvider.product.available,
                onChanged: (value) => productFormProvider.updateAvailability(value),
                title: Text('Disponible'),
                activeColor: Colors.indigo,
              ),
              SizedBox(
                height: 100,
              ),
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

  TextFormField _datePicker(BuildContext context) {
    return TextFormField(
      initialValue: product.date,
      decoration: InputDecoration(
        labelText: 'Fecha de Registro',
        filled: true,
        prefixIcon: Icon(Icons.calendar_today),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      ),
      readOnly: true,
    );
  }
}
