import 'package:dio/dio.dart';
import 'package:flutter_application_1/model/shoping_model.dart';

class DataService {
  final Dio dio = Dio();

  Future<List<ShopingModel>> getproduct() async {
    final response = await dio.get("https://fakestoreapi.com/products");

    // 👈 1. الرابط يعيد المصفوفة مباشرة دون الحاجة لكمة ['products']
    List productsList = response.data; 
    
    List<ShopingModel> product = [];
    
    // 👈 2. غيرنا اسم المتغير لـ item لتفادي تكرار التسمية والتضارب
    for (var item in productsList) { 
      product.add(
        ShopingModel(
          title: item['title'], 
          image: item['image'],
          // 👈 3. تحويل السعر لـ double بشكل آمن ليطابق الموديل
          price: double.parse(item['price'].toString()), 
        ),
      );
    }
    return product;
  }
}
