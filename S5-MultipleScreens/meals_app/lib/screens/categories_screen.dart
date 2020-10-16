import 'package:flutter/material.dart';

import '../dummy_data.dart';

import '../models/meal.dart';

import '../widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: DUMMY_CATEGORIES.map((category) {
          return CategoryItem(
            categoryId: category.id,
            categoryTitle: category.title,
            categoryColor: category.color,
          );
        }).toList(),
      ),
    );
  }
}
