import 'package:flutter/material.dart';

import './dummy_data.dart';

import './models/meal.dart';

// import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/meal_detail_screen.dart';
// import './screens/favorites_screen.dart';
import './screens/tabs_screen.dart';
import './screens/filters_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'isGlutenFree': false,
    'isVegan': false,
    'isVegetarian': false,
    'isLactoseFree': false,
  };

  List<Meal> _availableMeal = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filters) {
    setState(() {
      _filters = filters;

      _availableMeal = DUMMY_MEALS.where((meal) {
        if (_filters['isGlutenFree'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['isVegan'] && !meal.isVegan) {
          return false;
        }
        if (_filters['isVegetarian'] && !meal.isVegetarian) {
          return false;
        }
        if (_filters['isLactoseFree'] && !meal.isLactoseFree) {
          return false;
        }

        return true;
      }).toList();

      // print(_availableMeal.length);
    });
  }

  void _toggleFavorite(String mealId) {
    final selectedIndex =
        _favoriteMeals.indexWhere((meal) => meal.id == mealId);

    // print(selectedIndex.id);

    if (selectedIndex >= 0) {
      setState(() {
        print('remove');
        _favoriteMeals.removeAt(selectedIndex);
      });
    } else {
      setState(() {
        print('add');
        _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }

    print(_favoriteMeals.length);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                color: const Color.fromRGBO(20, 51, 51, 1),
              ),
              body2: TextStyle(
                color: const Color.fromRGBO(20, 51, 51, 1),
              ),
              title: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      initialRoute: '/',
      routes: {
        TabsScreen.routeName: (context) => TabsScreen(_favoriteMeals),
        // CategoriesScreen.routeName: (context) => CategoriesScreen(),
        // FavoritesScreen.routeName: (context) => FavoritesScreen(),
        CategoryMealsScreen.routeName: (context) =>
            CategoryMealsScreen(_availableMeal),
        MealDetailScreen.routeName: (context) =>
            MealDetailScreen(_favoriteMeals, _toggleFavorite),
        FiltersScreen.routeName: (context) => FiltersScreen(
              _filters,
              _setFilters,
            ),
      },
    );
  }
}
