import 'package:echo_stock/presentation/cubit/product/product_cubit.dart';
import 'package:echo_stock/presentation/cubit/product/product_state.dart';
import 'package:echo_stock/presentation/widgets/classification_filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductFiltrerPanel extends StatefulWidget {
  const ProductFiltrerPanel({super.key});

  @override
  State<ProductFiltrerPanel> createState() => _ProductFiltrerPanelState();
}

class _ProductFiltrerPanelState extends State<ProductFiltrerPanel> {
  String _getSortOptionText(ProductOption option, bool flag) {
    switch (option) {
      case ProductOption.nameAz:
        return 'Nombre A-Z';
      case ProductOption.nameZa:
        return 'Nombre Z-A';
      case ProductOption.priceHigh:
        return 'Precio Mayor';
      case ProductOption.stockLow:
        return !flag ? 'Stock Menor' : 'Días Restantes';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<ProductCubit>().state;
    if (productState is! ProductLoaded) {
      return const SizedBox.shrink();
    }

    final productLoaded = productState;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Theme(
          data: Theme.of(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Filtros de búsqueda',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Theme.of(context).dividerColor.withAlpha(179)),
              const SizedBox(height: 12),
              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is! ProductLoaded) {
                    return const SizedBox.shrink();
                  }
                  return Card(
                    elevation: 0,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: DropdownButtonFormField<ProductOption>(
                        initialValue: state.sortOption,
                        decoration: const InputDecoration(
                          labelText: 'Ordenar por',
                          border: InputBorder.none,
                        ),
                        items: ProductOption.values.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(
                              _getSortOptionText(
                                option,
                                state.isShowingArchived,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            context.read<ProductCubit>().changeSortOption(
                              value,
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is! ProductLoaded) {
                    return SizedBox.shrink();
                  }
                  return Card(
                    elevation: 0,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      title: !state.isShowingArchived
                          ? Text('Poco Stock')
                          : Text('Pocos Días'),
                      value: state.isLowStockFilter,
                      onChanged: (value) {
                        context.read<ProductCubit>().toggleLowStockFiltrer(
                          ProductOption.stockLow,
                        );
                      },
                    ),
                  );
                },
              ),
              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is! ProductLoaded) {
                    return SizedBox.shrink();
                  }

                  final double min = 0.0;
                  final double max = state.maxPriceLimit == 0
                      ? 1.0
                      : state.maxPriceLimit;
                  final values = RangeValues(
                    state.minPriceFilter,
                    state.maxPriceFilter,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${state.minPriceFilter.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '\$${state.maxPriceFilter.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            RangeSlider(
                              values: values,
                              min: min,
                              max: max,
                              labels: RangeLabels(
                                '\$${values.start.toStringAsFixed(0)}',
                                '\$${values.end.toStringAsFixed(0)}',
                              ),
                              onChanged: (newValues) {
                                context.read<ProductCubit>().updatePriceFiltrer(
                                  newValues.start,
                                  newValues.end,
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${min.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  '\$${max.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clasificaciones',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      productLoaded.products.isNotEmpty
                          ? ClassificationFilterList(
                              tags: productLoaded.products
                                  .map(
                                    (p) =>
                                        (p.classification == null ||
                                            p.classification!.trim().isEmpty)
                                        ? 'sin clasificación'
                                        : p.classification!
                                              .toLowerCase()
                                              .trim(),
                                  )
                                  .toSet()
                                  .toList()
                                  .cast<String>(),
                              selectedClassifications:
                                  productLoaded.selectedClassification,
                              onSelected: (tag, selected) {
                                final updateList = List<String>.from(
                                  productLoaded.selectedClassification,
                                );

                                if (selected) {
                                  updateList.add(tag.toLowerCase().trim());
                                } else {
                                  updateList.remove(tag.toLowerCase().trim());
                                }
                                context
                                    .read<ProductCubit>()
                                    .toggleClassificationFilter(updateList);
                              },
                            )
                          : Text(
                              'No hay clasificaciones disponibles',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
