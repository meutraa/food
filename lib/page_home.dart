import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:food/style.dart';

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

  void setPage(int? page) {
    setState(() => _currentPage = page ?? 0);
    _pageController.animateToPage(
      page ?? 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicRadio<int>(
                value: 0,
                style: radioStyle,
                groupValue: _currentPage,
                onChanged: setPage,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: const Icon(Icons.category_outlined),
              ),
              NeumorphicRadio<int>(
                value: 1,
                style: radioStyle,
                groupValue: _currentPage,
                onChanged: setPage,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: const Icon(Icons.history_rounded),
              ),
              NeumorphicRadio<int>(
                value: 2,
                style: radioStyle,
                groupValue: _currentPage,
                onChanged: setPage,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: const Icon(Icons.breakfast_dining_rounded),
              ),
              NeumorphicRadio<int>(
                value: 3,
                style: radioStyle,
                groupValue: _currentPage,
                onChanged: setPage,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: const Icon(Icons.dinner_dining_rounded),
              ),
            ],
          ),
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
                key: ValueKey(e.id),
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
                key: ValueKey(e.id),
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
                key: ValueKey(e.id),
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
            : NeumorphicButton(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(16),
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
