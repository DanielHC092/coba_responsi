import 'package:coba_responsi2/models/detailMealsModel.dart';
import 'package:coba_responsi2/models/mealsModel.dart';
import 'package:flutter/material.dart';
import 'package:coba_responsi2/apiDataSource.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class MealDetailPage extends StatefulWidget {
  final String mealId;

  const MealDetailPage({Key? key, required this.mealId}) : super(key: key);

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  late Future<MealResponse> futureMeal;

  @override
  void initState() {
    super.initState();
    futureMeal = ApiDataSource.instance.loadMealsDetail(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Detail"),
      ),
      body: FutureBuilder<MealResponse>(
        future: futureMeal,
        builder: (BuildContext context, AsyncSnapshot<MealResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error loading meal detail"),
            );
          } else if (snapshot.hasData) {
            return _buildMealDetail(snapshot.data!.meal[0]);
          } else {
            return Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }

  Widget _buildMealDetail(Meal meal) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            meal.strMealThumb,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.strMeal,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Category: ${meal.strCategory}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "Instructions:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  meal.strInstructions,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = meal.strYoutube;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // Handle the error if the URL can't be launched
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Could not open the link")),
                        );
                      }
                    },
                    child: Text("Watch on YouTube"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
