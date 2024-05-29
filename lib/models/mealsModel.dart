class Meals {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  Meals({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
    );
  }
}

class MealsResponse {
  final List<Meals> meals;

  MealsResponse({required this.meals});

  factory MealsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['meals'] as List;
    List<Meals> mealsList = list.map((i) => Meals.fromJson(i)).toList();
    return MealsResponse(meals: mealsList);
  }
}
