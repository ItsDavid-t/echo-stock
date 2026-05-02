import 'package:echo_stock/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

enum ProductOption { nameAz, nameZa, priceHigh, stockLow }

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductLoading extends ProductState {
  final int? categoryId;
  final bool isLowStock;

  const ProductLoading({this.categoryId, this.isLowStock = false});

  @override
  List<Object?> get props => [categoryId, isLowStock];
}

class ProductInitial extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredproduct;
  final int? selectedCategoryId;
  final List<String> selectedClassification;
  final bool isLowStockFilter;
  final bool isCategoryFiltered;
  final double maxPriceLimit;
  final double minPriceFilter;
  final double maxPriceFilter;
  final ProductOption sortOption;
  final bool isShowingArchived;

  const ProductLoaded(
    this.products,
    this.filteredproduct,
    this.selectedCategoryId,
    this.selectedClassification,
    this.isLowStockFilter,
    this.isCategoryFiltered,
    this.maxPriceLimit,
    this.minPriceFilter,
    this.maxPriceFilter,
    this.sortOption,
    this.isShowingArchived,
  );
  @override
  List<Object?> get props => [
    products,
    filteredproduct,
    selectedCategoryId,
    selectedClassification,
    isLowStockFilter,
    isCategoryFiltered,
    maxPriceLimit,
    minPriceFilter,
    maxPriceFilter,
    sortOption,
    isShowingArchived,
  ];

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredproduct,
    int? Function()? selectedCategoryId,
    List<String>? selectedClassification,
    bool? isLowStockFilter,
    bool? isCategoryFiltered,
    double? maxPriceLimit,
    double? minPriceFilter,
    double? maxPriceFilter,
    ProductOption? sortOption,
    bool? isShowingArchived,
  }) {
    return ProductLoaded(
      products ?? this.products,
      filteredproduct ?? this.filteredproduct,
      selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      selectedClassification ?? this.selectedClassification,
      isLowStockFilter ?? this.isLowStockFilter,
      isCategoryFiltered ?? this.isCategoryFiltered,
      maxPriceLimit ?? this.maxPriceLimit,
      minPriceFilter ?? this.minPriceFilter,
      maxPriceFilter ?? this.maxPriceFilter,
      sortOption ?? this.sortOption,
      isShowingArchived ?? this.isShowingArchived,
    );
  }
}

class ProductActionSucces extends ProductState {
  final String message;
  const ProductActionSucces(this.message);
}

class ProductActionLoading extends ProductState {
  final List<Product> products;
  const ProductActionLoading(this.products);
  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
