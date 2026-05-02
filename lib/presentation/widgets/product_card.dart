import 'package:flutter/material.dart';
import 'package:echo_stock/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onDelete;
  final bool onReadonly;

  const ProductCard({
    super.key,
    required this.product,
    this.onDelete,
    required this.onReadonly,
  });

  @override
  Widget build(BuildContext context) {
    int remainingDays = product.deletedDate != null
        ? 30 - DateTime.now().difference(product.deletedDate!).inDays
        : 0;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade700,
          child: Text(
            product.name.isNotEmpty ? product.name.toUpperCase()[0] : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stock: ${product.stock} | Precio: \$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: product.isLowStock ? Colors.red : Colors.grey,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              if (onReadonly)
                remainingDays > 0
                    ? remainingDays == 1
                          ? Text(
                              'Se elimina mañana',
                              style: TextStyle(color: Colors.red),
                            )
                          : Text(
                              'Se elimina en $remainingDays días',
                              style: TextStyle(
                                color: remainingDays <= 7
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            )
                    : Text(
                        'Se elimina hoy',
                        style: TextStyle(color: Colors.red),
                      ),
            ],
          ),
        ),
        trailing: onReadonly
            ? null
            : product.isLowStock
            ? const Icon(Icons.warning, color: Colors.red)
            : const Icon(Icons.inventory, color: Colors.green),
      ),
    );
  }
}
