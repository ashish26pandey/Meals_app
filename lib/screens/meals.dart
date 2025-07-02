import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/meal_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import '../providers/favorites_provider.dart'; // Import Favorites Provider

class MealsScreen extends StatefulWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    required this.onSelectMeal,
    required Map favoriteMeals,
  });

  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal) onSelectMeal;

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late List<Meal> _filteredMeals;

  @override
  void initState() {
    super.initState();
    _filteredMeals = widget.meals;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMeals(String query) {
    setState(() {
      _filteredMeals = widget.meals
          .where(
              (meal) => meal.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyContent = _filteredMeals.isEmpty
        ? const Center(
            child: Text(
              'No meals found for your search.',
              style: TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: _filteredMeals.length,
            itemBuilder: (ctx, index) => MealItem(
              meal: _filteredMeals[index],
              onSelectMeal: widget.onSelectMeal,
            ),
          );

    final appBar = AppBar(
      title: _isSearching
          ? Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search meals...',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  icon: const Icon(Icons.search),
                  // Removed suffixIcon here
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16,
                ),
                onChanged: _filterMeals,
              ),
            )
          : Text(widget.title ?? 'Meals'),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _searchController.clear();
                _filterMeals('');
              }
              _isSearching = !_isSearching;
            });
          },
        ),
        // Added star button here
        Consumer(
          builder: (context, ref, child) {
            final favoriteMeals = ref.watch(favoriteMealsProvider);
            final currentMeal = _filteredMeals.isNotEmpty
                ? _filteredMeals[0]
                : null; // Fix empty
            final isFavorite =
                currentMeal != null && favoriteMeals.contains(currentMeal);
            return IconButton(
              icon: Icon(isFavorite ? Icons.star : Icons.star_border),
              onPressed: () {
                if (currentMeal != null) {
                  final wasAdded = ref
                      .read(favoriteMealsProvider.notifier)
                      .toggleMealFavoriteStatus(currentMeal);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        wasAdded
                            ? 'Added ${currentMeal.title} to favorites.'
                            : 'Removed ${currentMeal.title} from favorites.',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          },
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: bodyContent,
    );
  }
}
