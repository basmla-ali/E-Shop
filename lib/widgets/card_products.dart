import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/shoping_model.dart';
import 'package:hive_flutter/adapters.dart';

class CardProducts extends StatefulWidget {
  final ShopingModel shopingModel;
  const CardProducts({super.key, required this.shopingModel});

  @override
  State<CardProducts> createState() => _CardProductsState();
}

class _CardProductsState extends State<CardProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: NetworkImage(widget.shopingModel.image),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.shopingModel.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder(
                valueListenable: Hive.box('favorites').listenable(),
                builder: (context, Box box, _) {
                  final isFav = box.containsKey(widget.shopingModel.title);
                  return GestureDetector(
                    onTap: () {
                      if (isFav) {
                        box.delete(widget.shopingModel.title);
                      } else {
                        box.put(widget.shopingModel.title, {
                          'title': widget.shopingModel.title,
                          'price': widget.shopingModel.price,
                          'image': widget.shopingModel.image,
                        });
                      }
                    },
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                  );
                },
              ),
              Expanded(
                child: Text(
                  "${widget.shopingModel.price} EGP",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  final cart = Hive.box('cart');
                  final key = widget.shopingModel.title;

                  if (cart.containsKey(key)) {
                    final item = Map<String, dynamic>.from(cart.get(key));
                    item['qty'] = item['qty'] + 1;
                    cart.put(key, item);
                  } else {
                    cart.put(key, {
                      'title': widget.shopingModel.title,
                      'price': widget.shopingModel.price,
                      'image': widget.shopingModel.image,
                      'qty': 1,
                    });
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تمت الإضافة للسلة"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 142, 147, 207),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
