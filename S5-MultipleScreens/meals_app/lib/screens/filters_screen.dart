import 'package:flutter/material.dart';

import '../screens/tabs_screen.dart';
import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Map<String, bool> _filters;
  final Function _setFilter;

  FiltersScreen(this._filters, this._setFilter);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _isGlutenFree = false;
  bool _isVegan = false;
  bool _isVegetarian = false;
  bool _isLactoseFree = false;

  Widget buildSwitchListTile(
      String title, String subtitle, bool value, Function onChangeHandler) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChangeHandler,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _isGlutenFree = widget._filters['isGlutenFree'];
    _isVegan = widget._filters['isVegan'];
    _isVegetarian = widget._filters['isVegetarian'];
    _isLactoseFree = widget._filters['isLactoseFree'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      drawer: MainDrawer(),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        child: Column(
          children: [
            Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.title,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                buildSwitchListTile(
                  'Gluten-Free',
                  'Only include gluten-free meals',
                  _isGlutenFree,
                  (value) {
                    setState(() {
                      _isGlutenFree = value;
                    });
                  },
                ),
                buildSwitchListTile(
                  'Vegan',
                  'Only include vegan meals',
                  _isVegan,
                  (value) {
                    setState(() {
                      _isVegan = value;
                    });
                  },
                ),
                buildSwitchListTile(
                  'Vegetarian',
                  'Only include vegetarian meals',
                  _isVegetarian,
                  (value) {
                    setState(() {
                      _isVegetarian = value;
                    });
                  },
                ),
                buildSwitchListTile(
                  'Lactose-Free',
                  'Only include lactore-free meals',
                  _isLactoseFree,
                  (value) {
                    setState(() {
                      _isLactoseFree = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onPressed: () {
            final _selectedFilters = {
              'isGlutenFree': _isGlutenFree,
              'isVegan': _isVegan,
              'isVegetarian': _isVegetarian,
              'isLactoseFree': _isLactoseFree,
            };

            widget._setFilter(_selectedFilters);

            Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
          },
          child: const Text('Save Settings'),
        ),
      ),
    );
  }
}
