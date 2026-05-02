import 'dart:developer' as developer;
import 'package:echo_stock/data/datasources/local_product_data_source.dart';
import 'package:echo_stock/domain/core/failures.dart';
import 'package:echo_stock/domain/entities/product.dart';
import 'package:echo_stock/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final LocalProductDataSource _localDataSource;

  ProductRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final data = await _localDataSource.getAllProducts();
      return Right(data);
    } catch (e, stackTrace) {
      developer.log(
        'Error en getAllProducts: ',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(DatabaseFailure('Error al cargar los Productos'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategories(
    int categoryId,
  ) async {
    try {
      final data = await _localDataSource.getProductsByCategories(categoryId);
      return Right(data);
    } catch (e, stackTrace) {
      developer.log(
        'Error en getProductsByCategories: ',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(DatabaseFailure('Error al cargar los Productos'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getArchivedProducts() async {
    try {
      final data = await _localDataSource.getArchivedProducts();
      return Right(data);
    } catch (e, stackTrace) {
      developer.log(
        'Error en getArchivedProducts: ',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(DatabaseFailure('Error al cargar los Productos Archivados'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getArchivedProductsByCategories(
    int categoryId,
  ) async {
    try {
      final data = await _localDataSource.getArchivedProductsByCategories(
        categoryId,
      );
      return Right(data);
    } catch (e, stackTrace) {
      developer.log(
        'Error en getArchivedProductsByCategories: ',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(DatabaseFailure('Error al cargar los Productos Archivados'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addProduct(Product product) async {
    try {
      await _localDataSource.insertProduct(product);
      return Right(unit);
    } catch (e, stackTrace) {
      developer.log('Error en addProduct: ', error: e, stackTrace: stackTrace);
      if (e.toString().contains('UNIQUE')) {
        return Left(ValidationFailure('Ese nombre de producto ya existe'));
      }
      return Left(DatabaseFailure('Error al agregar el producto'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(int id) async {
    if (id <= 0) {
      return Left(ValidationFailure("ID del producto inválido"));
    }
    try {
      await _localDataSource.deleteProduct(id);
      return Right(unit);
    } catch (e, stackTrace) {
      developer.log(
        'Error en deleteProduct: ',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(DatabaseFailure('Error al borrar el producto'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(Product product) async {
    try {
      await _localDataSource.updateProduct(product);
      return Right(unit);
    } catch (e, stackTrace) {
      developer.log(
        'Error en updateProduct: ',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(DatabaseFailure('Error al actualizar el producto'));
    }
  }
}
