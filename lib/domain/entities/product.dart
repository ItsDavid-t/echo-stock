class Product {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? classification;
  final int? categoryId;
  final double? distance;
  final int lowStockAlert;
  final bool isArchived;
  final DateTime? deletedDate;

  const Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.classification,
    this.categoryId,
    this.distance,
    required this.lowStockAlert,
    required this.isArchived,
    this.deletedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'stock': stock,
      'price': price,
      'distance': distance ?? 0.0,
      'name': name,
      'classification': classification?.trim().toLowerCase(),
      'category_id': categoryId,
      'lowStockAlert': lowStockAlert,
      'isArchived': isArchived ? 1 : 0,
      'deletedDate': deletedDate?.millisecondsSinceEpoch,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      description: map['description'] as String?,
      stock: (map['stock'] ?? 0) as int,
      price: (map['price'] ?? 0.0) as double,
      distance: (map['distance'] ?? 0.0) as double?,
      lowStockAlert: (map['lowStockAlert'] ?? 0) as int,
      name: map['name'] as String,
      classification: map['classification'] as String?,
      categoryId: map['category_id'] as int?,
      isArchived: map['isArchived'] == 1,
      deletedDate: map['deletedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deletedDate'])
          : null,
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? classification,
    int? categoryId,
    double? distance,
    int? lowStockAlert,
    bool? isArchived,
    DateTime? deletedDate,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      classification: classification ?? this.classification,
      categoryId: categoryId ?? this.categoryId,
      distance: distance ?? this.distance,
      lowStockAlert: lowStockAlert ?? this.lowStockAlert,
      isArchived: isArchived ?? this.isArchived,
      deletedDate: deletedDate ?? this.deletedDate,
    );
  }

  bool get isLowStock => stock < lowStockAlert;

  @override
  String toString() =>
      'Product(id: $id, name: $name, price: $price, stock: $stock)';
}
