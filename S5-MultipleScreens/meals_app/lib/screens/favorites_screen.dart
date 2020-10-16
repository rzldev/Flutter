import 'package:flutter/material.dart';

import '../models/meal.dart';

import '../widgets/category_meals_item.dart';

class FavoritesScreen extends StatelessWidget {
  static const routeName = '/favorites';

  final List<Meal> favoriteMeals;

  FavoritesScreen(this.favoriteMeals);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: favoriteMeals.length,
        itemBuilder: (context, index) {
          return CategoryMealsItem(
            meal: favoriteMeals[index],
          );
        },
      ),
    );
  }
}
