// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_element

import 'package:flutter/material.dart';
import 'package:seminariovalidacion/model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 400,
        margin: EdgeInsets.fromLTRB(0, 30, 0, 50),
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(
              url: product.picture,
            ),
            _ProductDetails(title: product.name, subtitle: product.id),
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(product: product),
            ),
            if (!product.available)
              Positioned(
                top: 0,
                left: 0,
                child: _NotAvailable(),
              )
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 7),
          blurRadius: 10,
        ),
      ],
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 400,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: url == null
                ? Image(
                    image: AssetImage('assets/no-image.png'),
                    fit: BoxFit.cover,
                  )
                : FadeInImage(
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(url!),
                    fit: BoxFit.cover,
                  )));
  }
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _ProductDetails({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        decoration: _buildBoxDecoration(),
        height: 70,
        width: double.infinity,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle!,
              style: TextStyle(fontSize: 15, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ));
  }
}

class _PriceTag extends StatelessWidget {
  final Product product;
  const _PriceTag({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            '${product.price.toStringAsFixed(2)}€',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(color: Color(0xfff9a825), borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'No disponible',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
