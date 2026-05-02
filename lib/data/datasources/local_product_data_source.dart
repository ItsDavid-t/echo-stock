import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:echo_stock/domain/entities/product.dart';
import 'package:echo_stock/domain/entities/category.dart';

class LocalProductDataSource {
  static final LocalProductDataSource _instance =
      LocalProductDataSource._internal();
  Database? _database;

  static const String _tableProduct = 'producto';
  static const String _tableCategory = 'categoria';
  static const String _dbProduct = 'data_producto.db';
  static const int _dbVersion = 2;

  LocalProductDataSource._internal();

  factory LocalProductDataSource() {
    return _instance;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _dbProduct);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableCategory(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        parent_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableProduct(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT,
        stock INTEGER,
        price REAL,
        distance REAL,
        lowStockAlert INTEGER,
        name TEXT NOT NULL,
        classification TEXT,
        category_id INTEGER,
        isArchived INTEGER,
        deletedDate INTEGER,
        FOREIGN KEY(category_id) REFERENCES $_tableCategory(id)
      )
    ''');

    await db.execute(
      '''INSERT INTO $_tableCategory (name)  VALUES ('Plomería'), ('Ciclismo'), ('Ferrería') , ('Electricidad') , ('Herramientas') , ('Otros')
 ''',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $_tableCategory(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE NOT NULL,
               parent_id INTEGER
        )
      ''');

      await db.execute(
        'ALTER TABLE $_tableProduct ADD COLUMN category_id INTEGER',
      );

      final List<Map<String, dynamic>> products = await db.query(_tableProduct);
      for (var row in products) {
        final classification = row['classification'] as String?;
        if (classification != null && classification.isNotEmpty) {
          final catId = await _ensureCategory(db, classification);
          await db.update(
            _tableProduct,
            {'category_id': catId},
            where: 'id = ?',
            whereArgs: [row['id']],
          );
        }
      }
    }
  }

  Future<int> _ensureCategory(Database db, String name) async {
    final cleanName = name.trim();

    final existing = await db.query(
      _tableCategory,
      where: 'name = ? COLLATE NOCASE',
      whereArgs: [cleanName],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      return existing.first['id'] as int;
    }

    return await db.insert(_tableCategory, {'name': cleanName});
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert(_tableCategory, category.toMap());
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableCategory,
      orderBy: 'name',
    );
    return maps.map((m) => Category.fromMap(m)).toList();
  }

  Future<List<Category>> getMainCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableCategory,
      where: 'parent_id IS NULL',
      orderBy: 'name',
    );
    return maps.map((m) => Category.fromMap(m)).toList();
  }

  Future<List<Category>> getSubCategories(int parentId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableCategory,
      where: 'parent_id = ?',
      whereArgs: [parentId],
      orderBy: 'name',
    );
    return maps.map((m) => Category.fromMap(m)).toList();
  }

  Future<List<Product>> getProductsByCategories(int categoryId) async {
    final db = await database;
    List<Category> categories = await getSubCategories(categoryId);

    List<int> ids = categories.map((c) => c.id!).toList();
    List<int> allIds = [categoryId, ...ids];

    final List<Map<String, dynamic>> maps = await db.query(
      _tableProduct,
      where:
          'category_id IN(${List.filled(allIds.length, '?').join(',')}) AND isArchived = 0',
      whereArgs: allIds,
      orderBy: 'name',
    );
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  Future<Category?> getCategoryById(int id) async {
    final db = await database;
    final maps = await db.query(
      _tableCategory,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Category.fromMap(maps.first);
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableProduct,
      where: 'isArchived = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<List<Product>> getArchivedProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableProduct,
      where: 'isArchived = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<List<Product>> getArchivedProductsByCategories(int categoryId) async {
    final db = await database;
    List<Category> categories = await getSubCategories(categoryId);

    List<int> ids = categories.map((c) => c.id!).toList();
    List<int> allIds = [categoryId, ...ids];

    final List<Map<String, dynamic>> maps = await db.query(
      _tableProduct,
      where:
          'category_id IN(${List.filled(allIds.length, '?').join(',')}) AND isArchived = 1',
      whereArgs: allIds,
      orderBy: 'name',
    );
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert(
      _tableProduct,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      _tableProduct,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(_tableProduct, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> closeDatabase() async {
    await _database?.close();
    _database = null;
  }
}
