import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../widgets/meal_item_trait.dart';

class MealDetailScreen extends ConsumerWidget {
  const MealDetailScreen({super.key, required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(favoriteMealsProvider).contains(meal);
    final theme = Theme.of(context);
    final textColor =
        theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          // 🔍 Search icon
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Optional: implement search logic here
            },
          ),

          // ⭐ Favorites icon
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              final wasAdded = ref
                  .read(favoriteMealsProvider.notifier)
                  .toggleMealFavoriteStatus(meal);

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasAdded
                        ? 'Added to favorites.'
                        : 'Removed from favorites.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: Icon(Icons.image_not_supported, size: 48),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            Text(
              meal.title,
              style: theme.textTheme.headlineSmall!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MealItemTrait(
                    icon: Icons.schedule, label: '${meal.duration} min'),
                const SizedBox(width: 12),
                MealItemTrait(icon: Icons.work, label: meal.complexity.name),
                const SizedBox(width: 12),
                MealItemTrait(
                    icon: Icons.attach_money, label: meal.affordability.name),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Ingredients',
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            ...meal.ingredients.map(
              (ingredient) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child:
                    Text('• $ingredient', style: TextStyle(color: textColor)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Steps',
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            ...meal.steps.map(
              (step) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text('✓ $step', style: TextStyle(color: textColor)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
