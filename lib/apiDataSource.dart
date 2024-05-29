import 'package:coba_responsi2/models/mealsModel.dart';
import 'package:coba_responsi2/models/detailMealsModel.dart';
import 'baseNetwork.dart';
import 'package:coba_responsi2/models/categoriesModel.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();
  Future<CategoriesResponse> loadCategories() async {
    final jsonResponse = await BaseNetwork.get("categories.php");
    return CategoriesResponse.fromJson(jsonResponse);
  }

  Future<MealsResponse> loadMeals(String category) async {
    final jsonResponse = await BaseNetwork.get("filter.php?c=$category");
    return MealsResponse.fromJson(jsonResponse);
  }

  Future<MealResponse> loadMealsDetail(String idDiterima) async {
    final jsonResponse = await BaseNetwork.get("lookup.php?i=$idDiterima");
    return MealResponse.fromJson(jsonResponse);
  }
}
