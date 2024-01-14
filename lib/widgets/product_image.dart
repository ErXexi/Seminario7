// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;
  const ProductImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
          width: double.infinity,
          height: 450,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ]),
          child: Opacity(
            opacity: 0.9,
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
                child: url == null
                    ? Image(
                        image: AssetImage('assets/no-image.png'),
                        fit: BoxFit.cover,
                      )
                    : FadeInImage(
                        placeholder: AssetImage('assets/jar-loading.gif'),
                        image: NetworkImage(url!),
                        fit: BoxFit.cover,
                      )),
          )),
    );
  }
}
