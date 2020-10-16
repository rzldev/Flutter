import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  final List<Meal> favoriteMeals;
  final Function toggleFavorite;

  MealDetailScreen(this.favoriteMeals, this.toggleFavorite);

  Widget buildSection(
    BuildContext context,
    String title,
    Meal mealDetail,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).accentColor,
        ),
        color: Theme.of(context).accentColor.withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.title,
          ),
          title == 'Ingredients'
              ? buildSectionList(mealDetail.ingredients)
              : buildSectionList(mealDetail.steps)
        ],
      ),
    );
  }

  Widget buildSectionList(List<String> itemList) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: itemList.map((item) {
          return Container(
            width: double.infinity,
            child: Text('${itemList.indexOf(item) + 1}. ${item}'),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments;

    final mealDetail = DUMMY_MEALS.firstWhere((meal) {
      return meal.id == mealId;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(mealDetail.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Image.network(
                    mealDetail.imageUrl,
                    height: constraints.maxHeight * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        buildSection(context, 'Ingredients', mealDetail),
                        SizedBox(
                          height: 12,
                        ),
                        buildSection(context, 'Steps', mealDetail),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
            favoriteMeals.length > 0 && favoriteMeals.contains(mealDetail)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        // onPressed: () {
        //   Navigator.of(context).pop(mealId);
        // },
        onPressed: () {
          toggleFavorite(mealDetail.id);
        },
      ),
    );
  }
}
