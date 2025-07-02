enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
}

class Meal {
  const Meal({
    required this.id,
    required this.categories,
    required this.title,
    required this.affordability,
    required this.complexity,
    required this.imageUrl,
    required this.duration,
    required this.ingredients,
    required this.steps,
    this.isGlutenFree = false,
    this.isLactoseFree = false,
    this.isVegan = false,
    this.isVegetarian = false,
  });

  final String id;
  final List<String> categories;
  final String title;
  final Affordability affordability;
  final Complexity complexity;
  final String imageUrl;
  final int duration;
  final List<String> ingredients;
  final List<String> steps;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;

  // 👇 Needed for favorites to work properly with .contains() and .where()
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Meal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
