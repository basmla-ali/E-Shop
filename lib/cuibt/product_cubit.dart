import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/shoping_model.dart';
import 'package:flutter_application_1/service/data_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> getproduct() async {
    emit(ProductLoading());
    try {
      List<ShopingModel> products = await DataService().getproduct();
      emit(ProductSuccess(products));
    } catch (e) {
      emit(ProductError("Error"));
    }
  }
}
