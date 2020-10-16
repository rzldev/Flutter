import 'package:flutter/material.dart';
import '../screens/category_meals_screen.dart';

class CategoryItem extends StatelessWidget {
  final String categoryId;
  final String categoryTitle;
  final Color categoryColor;

  const CategoryItem({
    Key key,
    @required this.categoryId,
    @required this.categoryTitle,
    @required this.categoryColor,
  }) : super(key: key);

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(CategoryMealsScreen.routeName, arguments: {
      'id': categoryId,
      'title': categoryTitle,
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(12),
      onTap: () => selectCategory(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Text(
          categoryTitle,
          style: Theme.of(context).textTheme.title,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                categoryColor.withOpacity(0.7),
                categoryColor,
              ]),
        ),
      ),
    );
  }
}
