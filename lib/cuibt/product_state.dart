part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductSuccess extends ProductState {
  final List<ShopingModel> products;

  ProductSuccess(this.products);
}

final class ProductError extends ProductState {
  final String errorMessage;

  ProductError(this.errorMessage);
}
