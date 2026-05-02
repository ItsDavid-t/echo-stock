import 'package:echo_stock/domain/entities/category.dart';
import 'package:echo_stock/presentation/cubit/category/category_cubit.dart';
import 'package:echo_stock/presentation/cubit/category/category_state.dart';
import 'package:echo_stock/presentation/cubit/product/product_cubit.dart';
import 'package:echo_stock/presentation/cubit/product/product_state.dart';
import 'package:flutter/material.dart';
import 'package:echo_stock/domain/entities/product.dart';
import 'package:echo_stock/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  final _lowStockAlertController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _classificationController = TextEditingController();
  final _distanceController = TextEditingController();
  Category? _selectedFamily;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _stockController.text = widget.product!.stock.toString();
      _priceController.text = widget.product!.price.toString();
      _lowStockAlertController.text = widget.product!.lowStockAlert.toString();
      _descriptionController.text = widget.product!.description ?? '';
      _classificationController.text = widget.product!.classification ?? '';
      _distanceController.text = widget.product!.distance.toString();
    }
    context.read<CategoryCubit>().fetchMainCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _lowStockAlertController.dispose();
    _descriptionController.dispose();
    _classificationController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final stock = int.tryParse(_stockController.text);
    final price = double.tryParse(_priceController.text);
    final lowStockAlert = int.tryParse(_lowStockAlertController.text);
    final distance = double.tryParse(_distanceController.text) ?? 0.0;
    final idProduct = widget.product?.id;

    if (!_formKey.currentState!.validate()) return;

    if (stock == null || price == null || lowStockAlert == null) {
      _showErrorSnackBar('Por favor verifica los campos numéricos');
      return;
    }

    if (_selectedFamily == null) {
      _showErrorSnackBar('Por favor, selecciona una Familia de Categorías');
      return;
    }
    final classificationText = _classificationController.text.trim();
    int idCategory = _selectedFamily!.id!;
    if (classificationText.isNotEmpty) {
      final finalCategoryById = await context
          .read<CategoryCubit>()
          .ensureSubCategory(classificationText, _selectedFamily!.id!);

      if (finalCategoryById != -1) {
        idCategory = finalCategoryById;
      }
    } else {
      idCategory = _selectedFamily!.id!;
    }

    final product = Product(
      name: _nameController.text,
      stock: stock,
      price: price,
      lowStockAlert: lowStockAlert,
      description: _descriptionController.text,
      classification: classificationText.isEmpty ? null : classificationText,
      distance: distance,
      id: idProduct,
      isArchived: false,
      deletedDate: null,
      categoryId: idCategory,
    );

    if (widget.product == null) {
      await context.read<ProductCubit>().addProduct(product);
    } else {
      await context.read<ProductCubit>().updateProduct(product);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.product == null ? 'Agregar' : 'Actualizar';
    return BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductError) {
          _showErrorSnackBar(state.message);
        }

        if (state is ProductActionSucces) {
          Navigator.pop(context, true);

          final message = widget.product == null ? 'agregado' : "actualizado";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Producto $message correctamente')),
          );
        }
      },

      child: Scaffold(
        appBar: AppBar(title: Text('$message Producto'), elevation: 0),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSection(
                  title: 'Información básica',
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
                      label: 'Nombre del producto',
                      prefixIcon: Icons.shopping_bag,
                      validator: _validateRequired,
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      controller: _descriptionController,
                      label: 'Descripción (opcional)',
                      prefixIcon: Icons.description,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          return CircularProgressIndicator();
                        }
                        if (state is CategoryMainLoaded) {
                          return Column(
                            children: [
                              DropdownButtonFormField<Category>(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.category_outlined),
                                ),
                                hint: Text(
                                  'Familia de Categorías',
                                  style: TextStyle(color: Colors.white),
                                ),
                                initialValue: _selectedFamily,
                                items: state.categories.map((
                                  Category category,
                                ) {
                                  return DropdownMenuItem<Category>(
                                    value: category,
                                    child: Text(category.name),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedFamily = newValue;
                                  });
                                },
                              ),
                              SizedBox(height: 15),
                              CustomTextFormField(
                                controller: _classificationController,
                                label: 'Clasificación (opcional)',
                                prefixIcon: Icons.category,
                              ),
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Inventario',
                  children: [
                    CustomTextFormField(
                      controller: _stockController,
                      label: 'Stock actual',
                      prefixIcon: Icons.layers,
                      keyboardType: TextInputType.number,
                      validator: _validateNumber,
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      controller: _lowStockAlertController,
                      label: 'Stock mínimo (alerta)',
                      prefixIcon: Icons.notification_important,
                      keyboardType: TextInputType.number,
                      validator: _validateNumber,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Detalles económicos',
                  children: [
                    CustomTextFormField(
                      controller: _priceController,
                      label: 'Precio',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: _validateNumber,
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      controller: _distanceController,
                      label: 'Distancia (opcional)',
                      prefixIcon: Icons.straighten,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      final isLoading = state is ProductActionLoading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Guardar producto'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ...children,
      ],
    );
  }

  String? _validateRequired(String? value) {
    return (value == null || value.isEmpty) ? 'Campo obligatorio' : null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) return 'Campo obligatorio';
    if (double.tryParse(value) == null) return 'Ingresa un número válido';
    return null;
  }
}
