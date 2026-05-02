import 'dart:math';
import 'dart:developer' as developer;
import 'package:echo_stock/domain/entities/product.dart';
import 'package:echo_stock/domain/usecases/product/add_product.dart';
import 'package:echo_stock/domain/usecases/product/delete_product.dart';
import 'package:echo_stock/domain/usecases/product/get_all_products.dart';
import 'package:echo_stock/domain/usecases/product/get_archived_product.dart';
import 'package:echo_stock/domain/usecases/product/get_archived_products_by_categories.dart';
import 'package:echo_stock/domain/usecases/product/get_products_by_categories.dart';
import 'package:echo_stock/domain/usecases/product/upgrate_product.dart';
import 'package:echo_stock/presentation/cubit/product/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProducts _getAllProducts;
  final AddProduct _addProduct;
  final UpgrateProduct _upgrateProduct;
  final GetArchivedProduct _getArchivedProduct;
  final GetArchivedProductsByCategories _getArchivedProductsByCategories;
  final DeleteProduct _deleteProduct;
  final GetProductsByCategories _getProductsByCategories;

  ProductCubit(
    this._getAllProducts,
    this._addProduct,
    this._upgrateProduct,
    this._getArchivedProduct,
    this._getArchivedProductsByCategories,
    this._deleteProduct,
    this._getProductsByCategories,
  ) : super(ProductInitial());

  Future<void> loadProducts() async {
    final currentState = state;
    bool wasLowStock = false;
    List<String> lastClasses = [];

    if (currentState is ProductLoaded) {
      wasLowStock = currentState.isLowStockFilter;
      lastClasses = currentState.selectedClassification;
    }

    emit(ProductLoading(categoryId: null, isLowStock: wasLowStock));

    final result = await _getAllProducts();

    result.fold((failure) => emit(ProductError(failure.message)), (products) {
      final maxPrice = products.isEmpty
          ? 0.0
          : products.map((p) => p.price).reduce(max);

      final filtered = _applyFilters(
        products,
        null,
        lastClasses,
        wasLowStock,
        0.0,
        maxPrice,
        ProductOption.nameAz,
        false,
      );

      emit(
        ProductLoaded(
          products,
          filtered,
          null,
          lastClasses,
          wasLowStock,
          false,
          maxPrice,
          0.0,
          maxPrice,
          ProductOption.nameAz,
          false,
        ),
      );
    });
  }

  Future<void> loadProductsByCategories(int? categoryId) async {
    final currentState = state;
    List<String> currentClass = [];
    bool isLowStock = false;

    if (categoryId == null) {
      loadProducts();
      return;
    }
    if (currentState is ProductLoaded) {
      currentClass = currentState.selectedClassification;
      isLowStock = currentState.isLowStockFilter;
    }

    emit(ProductLoading(isLowStock: isLowStock, categoryId: categoryId));
    final result = await _getProductsByCategories(categoryId);

    result.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (products) {
        if (currentState is ProductLoaded) {
          final categoryMaxPrice = products.isEmpty
              ? 0.0
              : products.map((p) => p.price).reduce(max);
          final filtered = _applyFilters(
            products,
            null,
            currentClass,
            isLowStock,
            0,
            categoryMaxPrice,
            currentState.sortOption,
            false,
          );

          emit(
            currentState.copyWith(
              filteredproduct: filtered,
              products: products,
              selectedCategoryId: () => categoryId,
              maxPriceFilter: categoryMaxPrice,
              maxPriceLimit: categoryMaxPrice,
              minPriceFilter: 0,
            ),
          );
        } else {
          final maxPrice = products.isEmpty
              ? 0.0
              : products.map((p) => p.price).reduce(max);
          final filtered = _applyFilters(
            products,
            null,
            currentClass,
            isLowStock,
            0.0,
            maxPrice,
            ProductOption.nameAz,
            false,
          );

          emit(
            ProductLoaded(
              products,
              filtered,
              categoryId,
              currentClass,
              isLowStock,
              true,
              maxPrice,
              0.0,
              maxPrice,
              ProductOption.nameAz,
              false,
            ),
          );
        }
      },
    );
  }

  void changeSortOption(ProductOption sortOption) {
    final currentState = state;

    if (currentState is ProductLoaded) {
      final filtered = _applyFilters(
        currentState.products,
        currentState.selectedCategoryId,
        currentState.selectedClassification,
        currentState.isLowStockFilter,
        currentState.minPriceFilter,
        currentState.maxPriceFilter,
        sortOption,
        currentState.isShowingArchived,
      );

      emit(
        currentState.copyWith(
          filteredproduct: filtered,
          sortOption: sortOption,
        ),
      );
    }
  }

  Future<void> changeCategoryForArchived(int? categoryId) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      if (categoryId == null) {
        await loadProductsAchived();
        return;
      }

      emit(
        ProductLoading(
          isLowStock: currentState.isLowStockFilter,
          categoryId: categoryId,
        ),
      );

      final result = await _getArchivedProductsByCategories(categoryId);
      result.fold(
        (failure) {
          emit(ProductError(failure.message));
        },
        (products) {
          final filtered = _applyFilters(
            products,
            null,
            currentState.selectedClassification,
            currentState.isLowStockFilter,
            currentState.minPriceFilter,
            currentState.maxPriceFilter == 0
                ? 1000000.0
                : currentState.maxPriceFilter,
            currentState.sortOption,
            true,
          );

          emit(
            currentState.copyWith(
              products: products,
              filteredproduct: filtered,
              selectedCategoryId: () => categoryId,
              isShowingArchived: true,
            ),
          );
        },
      );
    }
  }

  void searchProducts(String query) {
    final currentState = state;

    if (currentState is ProductLoaded) {
      final searched = currentState.products.where((p) {
        return p.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      final filtered = _applyFilters(
        searched,
        currentState.selectedCategoryId,
        currentState.selectedClassification,
        currentState.isLowStockFilter,
        currentState.minPriceFilter,
        currentState.maxPriceFilter,
        currentState.sortOption,
        currentState.isShowingArchived,
      );
      emit(currentState.copyWith(filteredproduct: filtered));
    }
  }

  void searchAchivedProducts(String query) {
    final currentState = state;

    if (currentState is ProductLoaded) {
      if (query.isEmpty) {
        final filtered = _applyFilters(
          currentState.products,
          currentState.selectedCategoryId,
          currentState.selectedClassification,
          currentState.isLowStockFilter,
          currentState.minPriceFilter,
          currentState.maxPriceFilter,
          currentState.sortOption,
          currentState.isShowingArchived,
        );
        emit(currentState.copyWith(filteredproduct: filtered));
        return;
      }

      final searched = currentState.products.where((p) {
        return p.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      final filtered = _applyFilters(
        searched,
        currentState.selectedCategoryId,
        currentState.selectedClassification,
        currentState.isLowStockFilter,
        currentState.minPriceFilter,
        currentState.maxPriceFilter,
        currentState.sortOption,
        currentState.isShowingArchived,
      );
      emit(currentState.copyWith(filteredproduct: filtered));
    }
  }

  List<Product> _applyFilters(
    List<Product> products,
    int? categoryId,
    List<String> classifications,
    bool lowStock,
    double minPrice,
    double maxPrice,
    ProductOption sortOption,
    bool isShowingArchived,
  ) {
    final sortList = [...products];
    switch (sortOption) {
      case ProductOption.nameAz:
        sortList.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      case ProductOption.nameZa:
        sortList.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
      case ProductOption.priceHigh:
        sortList.sort((a, b) {
          return b.price.compareTo(a.price);
        });
      case ProductOption.stockLow:
        sortList.sort((a, b) {
          return !isShowingArchived
              ? a.stock.compareTo(b.stock)
              : (a.deletedDate ?? DateTime.now()).compareTo(
                  b.deletedDate ?? DateTime.now(),
                );
        });
    }

    return sortList.where((p) {
      final matchCategory =
          categoryId == null ||
          isShowingArchived ||
          p.categoryId == categoryId ||
          (state is ProductLoaded &&
              (state as ProductLoaded).selectedCategoryId != null);
      final matchClass =
          classifications.isEmpty ||
          classifications.any(
            (c) =>
                c.toLowerCase().trim() ==
                (p.classification?.toLowerCase().trim() ?? 'sin clasificación'),
          );

      final matchPrice = p.price >= minPrice && p.price <= maxPrice;
      final matchStock =
          !lowStock ||
          (isShowingArchived
              ? (p.deletedDate != null &&
                    DateTime.now().difference(p.deletedDate!).inDays <= 30)
              : p.isLowStock);

      return matchCategory && matchClass && matchStock && matchPrice;
    }).toList();
  }

  void toggleLowStockFiltrer(ProductOption sortOption) {
    final currentState = state;

    if (currentState is ProductLoaded) {
      final newValue = !currentState.isLowStockFilter;
      final effectiveSortOption = newValue
          ? sortOption
          : currentState.sortOption == ProductOption.stockLow
          ? ProductOption.nameAz
          : currentState.sortOption;
      developer.log(
        '[toggleLowStockFiltrer] new lowStock=$newValue effectiveSortOption=$effectiveSortOption',
      );

      final filtered = _applyFilters(
        currentState.products,
        currentState.selectedCategoryId,
        currentState.selectedClassification,
        newValue,
        currentState.minPriceFilter,
        currentState.maxPriceFilter,
        effectiveSortOption,
        currentState.isShowingArchived,
      );
      emit(
        currentState.copyWith(
          isLowStockFilter: newValue,
          filteredproduct: filtered,
          sortOption: effectiveSortOption,
          selectedCategoryId: () => currentState.selectedCategoryId,
        ),
      );
    }
  }

  void updatePriceFiltrer(double min, double max) {
    final currentState = state;

    if (currentState is ProductLoaded) {
      final filtered = _applyFilters(
        currentState.products,
        currentState.selectedCategoryId,
        currentState.selectedClassification,
        currentState.isLowStockFilter,
        min,
        max,
        currentState.sortOption,
        currentState.isShowingArchived,
      );
      emit(
        currentState.copyWith(
          filteredproduct: filtered,
          minPriceFilter: min,
          maxPriceFilter: max,
        ),
      );
    }
  }

  void toggleClassificationFilter(List<String> classifications) {
    final currentState = state;
    developer.log(
      '[toggleClassificationFilter] classifications=$classifications, current lowStock=${currentState is ProductLoaded ? (currentState).isLowStockFilter : 'N/A'}',
    );

    if (currentState is ProductLoaded) {
      final filtered = _applyFilters(
        currentState.products,
        currentState.selectedCategoryId,
        classifications,
        currentState.isLowStockFilter,
        currentState.minPriceFilter,
        currentState.maxPriceFilter,
        currentState.sortOption,
        currentState.isShowingArchived,
      );
      developer.log(
        '[toggleClassificationFilter] filtered products count=${filtered.length}',
      );

      emit(
        currentState.copyWith(
          filteredproduct: filtered,
          selectedClassification: classifications,
          isLowStockFilter: currentState.isLowStockFilter,
          sortOption: currentState.sortOption,
          selectedCategoryId: () => currentState.selectedCategoryId,
        ),
      );
    }
  }

  Future<void> addProduct(Product product) async {
    if (state is ProductLoaded) {
      final currentProducts = (state as ProductLoaded).products;
      emit(ProductActionLoading(currentProducts));
    }
    final resutl = await _addProduct(product);

    resutl.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (_) {
        emit(const ProductActionSucces('Producto agregado'));
        loadProducts();
      },
    );
  }

  Future<void> updateProduct(Product product) async {
    if (state is ProductLoaded) {
      final currentProducts = (state as ProductLoaded).products;
      emit(ProductActionLoading(currentProducts));
    }
    final resutl = await _upgrateProduct(product);

    resutl.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (_) {
        emit(const ProductActionSucces('Producto actualizado'));
        loadProducts();
      },
    );
  }

  Future<void> deleteProduct(int id) async {
    if (state is ProductLoaded) {
      final currentProducts = (state as ProductLoaded).products;
      emit(ProductActionLoading(currentProducts));
    }
    final result = await _deleteProduct(id);

    result.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (_) {
        loadProductsAchived();
      },
    );
  }

  Future<void> loadProductsAchived() async {
    emit(ProductInitial());
    emit(ProductLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    final result = await _getArchivedProduct();

    result.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (products) async {
        final now = DateTime.now();

        final productsToDelete = products
            .where(
              (p) =>
                  p.deletedDate != null &&
                  now.difference(p.deletedDate!).inDays > 30,
            )
            .toList();

        await Future.wait(productsToDelete.map((p) => _deleteProduct(p.id!)));

        final cleanProducts = products.where((p) {
          if (p.deletedDate == null) return true;
          return now.difference(p.deletedDate!).inDays <= 30;
        }).toList();

        final maxPrice = cleanProducts.isEmpty
            ? 0.0
            : cleanProducts.map((p) => p.price).reduce(max);

        final filtered = _applyFilters(
          cleanProducts,
          null,
          const [],
          false,
          0.0,
          maxPrice,
          ProductOption.nameAz,
          true,
        );

        emit(
          ProductLoaded(
            cleanProducts,
            filtered,
            null,
            const [],
            false,
            false,
            maxPrice,
            0.0,
            maxPrice,
            ProductOption.nameAz,
            true,
          ),
        );
      },
    );
  }

  Future<void> archivedProcuct(Product product) async {
    if (state is ProductLoaded) {
      emit(ProductActionLoading((state as ProductLoaded).products));
    }
    final archivedProduct = product.copyWith(
      isArchived: true,
      deletedDate: DateTime.now(),
    );

    final result = await _upgrateProduct(archivedProduct);

    result.fold(
      (faiulre) {
        emit(ProductError(faiulre.message));
      },
      (_) {
        loadProducts();
      },
    );
  }

  Future<void> restoreProcuct(Product product) async {
    final archivedProduct = product.copyWith(
      isArchived: false,
      deletedDate: null,
    );

    final result = await _upgrateProduct(archivedProduct);

    result.fold(
      (faiulre) {
        emit(ProductError(faiulre.message));
      },
      (_) {
        loadProductsAchived();
      },
    );
  }
}
