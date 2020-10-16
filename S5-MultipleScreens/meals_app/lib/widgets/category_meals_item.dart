import 'package:flutter/material.dart';
import 'package:meals_app/screens/meal_detail_screen.dart';

import '../models/meal.dart';

class CategoryMealsItem extends StatelessWidget {
  final Meal meal;
  final Function removeItem;

  CategoryMealsItem({@required this.meal, this.removeItem});

  String get mealComplexity {
    switch (meal.complexity) {
      case Complexity.Simple:
        return 'Simple';
      case Complexity.Challenging:
        return 'Challenging';
      case Complexity.Hard:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }

  String get mealAffordability {
    switch (meal.affordability) {
      case Affordability.Affordable:
        return 'Affordable';
      case Affordability.Pricey:
        return 'Pricey';
      case Affordability.Luxurious:
        return 'Luxurious';
      default:
        return 'Unknown';
    }
  }

  void selectMeal(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MealDetailScreen.routeName, arguments: meal.id)
        .then((value) {
      if (value != null) {
        removeItem(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => selectMeal(context),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: EdgeInsets.all(12),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          meal.imageUrl,
                          height: MediaQuery.of(context).size.width > 400
                              ? 240
                              : 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      Positioned(
                        bottom:
                            MediaQuery.of(context).size.width > 400 ? 20 : 10,
                        right: 0,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth * 0.8,
                          ),
                          padding: EdgeInsets.all(12),
                          color: Colors.black54,
                          child: Text(
                            meal.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule),
                            SizedBox(width: 8),
                            Text('${meal.duration}'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.work),
                            SizedBox(width: 6),
                            Text('${mealComplexity}'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.attach_money),
                            SizedBox(width: 4),
                            Text('${mealAffordability}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
