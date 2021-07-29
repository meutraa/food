import 'package:flutter/material.dart';
import 'package:food/data/intake.dart';

import 'data/ingredient.dart';
import 'list_ingredients.dart';
import 'list_intakes.dart';
import 'list_recipes.dart';
import 'objectbox.g.dart';
import 'page_edit_ingredient.dart';
import 'page_edit_recipe.dart';
import 'page_statistics.dart';

class HomePage extends StatefulWidget {
  final Store store;

  const HomePage({
    Key? key,
    required this.store,
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

  void onNewRecipe() async => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditRecipePage(
            store: widget.store,
          ),
        ),
      );

  void onNewIngredient() async => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditIngredientPage(
            store: widget.store,
          ),
        ),
      );

  void onNewIntake() async {
    final intake = Intake(time: DateTime.now(), weight: 50);
    final cashews = Ingredient(
      name: 'cashews',
      mass: 100,
      energy: 624,
      fats: 50.9,
      saturated: 10.1,
      poly: null,
      trans: null,
      mono: null,
      carbohydrates: 18.8,
      sugar: 5.6,
      fibre: 4.3,
      protein: 20.5,
      salt: 0.1,
    );
    intake.consumable.target = cashews;
    widget.store.box<Ingredient>().put(cashews);
    widget.store.box<Intake>().put(intake, mode: PutMode.insert);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (page) {
            setState(() => _currentPage = page);
            _pageController.animateToPage(
              page,
              duration: Duration(milliseconds: 300),
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
            IntakeList(store: widget.store),
            IngredientList(store: widget.store),
            RecipeList(store: widget.store),
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
                child: Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}
