import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _navy = Color(0xFF1A237E);
const double _shipping = 20;
const double _tax = 20;

// 1350 -> 1,350
String _fmt(double value) {
  return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => ',',
      );
}

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: Hive.box('cart').listenable(),
        builder: (context, Box box, _) {
          final keys = box.keys.toList();

          // السلة فاضية
          if (keys.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 70, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "السلة فاضية",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // حساب المجموع
          double subtotal = 0;
          for (final key in keys) {
            final item = box.get(key);
            subtotal += (item['price'] as num).toDouble() *
                (item['qty'] as num).toInt();
          }
          final total = subtotal + _shipping + _tax;

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: keys.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _buildItem(box, keys[index]),
                ),
              ),
              _buildSummary(context, box, subtotal, total),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem(Box box, dynamic key) {
    final item = Map<String, dynamic>.from(box.get(key));
    final int qty = (item['qty'] as num).toInt();
    final double price = (item['price'] as num).toDouble();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // الصورة
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(
              item['image'],
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_outlined, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // حذف المنتج من السلة
                    GestureDetector(
                      onTap: () => box.delete(key),
                      child: const Icon(Icons.delete,
                          color: Colors.red, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_fmt(price * qty)} EGP",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        _qtyButton(
                          Icons.remove,
                          Colors.grey.shade300,
                          Colors.black,
                          () {
                            if (qty > 1) {
                              item['qty'] = qty - 1;
                              box.put(key, item);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "$qty",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _qtyButton(
                          Icons.add,
                          _navy,
                          Colors.white,
                          () {
                            item['qty'] = qty + 1;
                            box.put(key, item);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: fg),
      ),
    );
  }

  Widget _buildSummary(
      BuildContext context, Box box, double subtotal, double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Summary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          _summaryRow("Subtotal (EGP)", "${_fmt(subtotal)} EGP"),
          _summaryRow("Shipping (EGP)", "${_fmt(_shipping)} EGP"),
          _summaryRow("Tax (EGP)", "${_fmt(_tax)} EGP"),
          const Divider(height: 20),
          _summaryRow("Total (EGP)", "${_fmt(total)} EGP", bold: true),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => _checkout(context, box, total),
              style: ElevatedButton.styleFrom(
                backgroundColor: _navy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Proceed to Checkout",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 15 : 13,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: bold ? Colors.black : Colors.grey.shade700,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }

  // الدفع الوهمي: رسالة نجاح وبعدين تفضّي السلة
  void _checkout(BuildContext context, Box box, double total) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 70),
            const SizedBox(height: 12),
            const Text(
              "تم الدفع بنجاح",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text("الإجمالي: ${_fmt(total)} EGP"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              box.clear();
            },
            child: const Text("تمام"),
          ),
        ],
      ),
    );
  }
}