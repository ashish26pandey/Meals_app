import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal, required this.onSelectMeal});

  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor =
        theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87;
    final backgroundColor = theme.brightness == Brightness.dark
        ? Colors.grey[900]
        : Colors.grey[200];

    return InkWell(
      onTap: () => onSelectMeal(meal),
      child: Card(
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.hardEdge,
        elevation: 4,
        color: backgroundColor,
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  meal.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: Icon(Icons.star)),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 44,
                    ),
                    color: Colors.black54,
                    child: Text(
                      meal.title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.schedule),
                          const SizedBox(width: 4),
                          Text(
                            '${meal.duration} min',
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.work),
                          const SizedBox(width: 4),
                          Text(
                            meal.complexity.name,
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.attach_money),
                          const SizedBox(width: 4),
                          Text(
                            meal.affordability.name,
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  ...meal.ingredients.map(
                    (ingredient) => Text(
                      '• $ingredient',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Steps:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  ...meal.steps.map(
                    (step) =>
                        Text('✓ $step', style: TextStyle(color: textColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
