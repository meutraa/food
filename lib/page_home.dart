import 'package:flutter/material.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'item_ingredient.dart';
import 'item_intake.dart';
import 'item_recipe.dart';
import 'list_data.dart';
import 'modal_intake.dart';
import 'objectbox.g.dart';
import 'page_edit_ingredient.dart';
import 'page_edit_recipe.dart';
import 'page_statistics.dart';

class HomePage extends StatefulWidget {
  final Store store;

  const HomePage({
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onNewRecipe() => Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => EditRecipePage(
            store: widget.store,
          ),
        ),
      );

  void onNewIngredient() => Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => EditIngredientPage(
            store: widget.store,
          ),
        ),
      );

  void onNewIntake() => showIntakeDialog(context, store: widget.store);

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          onTap: (page) {
            setState(() => _currentPage = page);
            _pageController.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          currentIndex: _currentPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              label: 'Log',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.breakfast_dining_outlined),
              label: 'Foods',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dinner_dining_outlined),
              label: 'Recipes',
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            StatisticsPage(store: widget.store),
            DataList<Portion>(
              store: widget.store,
              condition: Portion_.time.notNull(),
              orderField: Portion_.id,
              itemBuilder: (context, e) => PortionItem(
                portion: e,
                store: widget.store,
              ),
              searchString: (e) => e.on(
                ingredient: (e) => e.name,
                recipe: (e) => e.name,
              ),
              hint: 'Hummous',
            ),
            DataList<Ingredient>(
              store: widget.store,
              orderField: Ingredient_.id,
              itemBuilder: (context, e) => IngredientItem(
                ingredient: e,
                store: widget.store,
              ),
              searchString: (e) => e.name,
              hint: 'Kiwi',
            ),
            DataList<Recipe>(
              store: widget.store,
              orderField: Recipe_.id,
              itemBuilder: (context, e) => RecipeItem(
                recipe: e,
                store: widget.store,
              ),
              searchString: (e) => e.name,
              hint: 'Dahl',
            ),
          ],
        ),
        floatingActionButton: _currentPage == 0
            ? null
            : FloatingActionButton(
                onPressed: () {
                  switch (_currentPage) {
                    case 1:
                      return onNewIntake();
                    case 2:
                      return onNewIngredient();
                    case 3:
                      return onNewRecipe();
                  }
                },
                child: const Icon(Icons.add),
              ),
      );
}
