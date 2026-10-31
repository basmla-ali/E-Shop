import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/shoping_model.dart';
import 'package:flutter_application_1/widgets/card_products.dart';
import 'package:hive_flutter/adapters.dart';

class Favorate extends StatelessWidget {
  const Favorate({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (context, Box box, _) {
          final products = box.values
              .map(
                (e) => ShopingModel(
                  title: e['title'],
                  image: e['image'],
                  price: (e['price'] as num).toDouble(),
                ),
              )
              .toList();

          if (products.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد منتجات في المفضلة بعد",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return CardProducts(shopingModel: products[index]);
            },
          );
        },
      ),
    );
  }
}
