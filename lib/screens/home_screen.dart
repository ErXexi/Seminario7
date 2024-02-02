import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/model/product.dart';
import 'package:seminariovalidacion/screens/screens.dart';
import 'package:seminariovalidacion/services/services.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _handleLogout(context, authService);
              }),
        ],
      ),
      body: ListView.builder(
        itemCount: productsService.products.length + 1,
        itemBuilder: (context, index) {
          if (index == productsService.products.length) {
            return Container();
          }

          final product = productsService.products[index];

          return Dismissible(
            key: Key(product.id ?? index.toString()),
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            confirmDismiss: (direction) async {
              return await _showDeleteConfirmationDialog(context, productsService, product);
            },
            onDismissed: (direction) {},
            child: GestureDetector(
              onTap: () {
                productsService.selectedProduct = product.copy();
                Navigator.pushNamed(context, 'product').then(
                  (_) => productsService.reload(),
                );
              },
              child: ProductCard(product: product),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          productsService.selectedProduct = Product(available: false, name: '', price: 0.00, date: _formatDate(DateTime.now()));
          await Navigator.pushNamed(context, 'product');
          await productsService.reload();
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, ProductsService productsService, Product product) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres eliminar este producto?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                productsService.deleteProduct(product);
                Navigator.of(context).pop(true);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _handleLogout(BuildContext context, AuthService authService) async {
    await authService.logout();
    Navigator.pushReplacementNamed(context, 'login');
  }
}
