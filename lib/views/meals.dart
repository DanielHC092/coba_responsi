import 'package:coba_responsi2/models/mealsModel.dart';
import 'package:coba_responsi2/views/detailMeals.dart';
import 'package:flutter/material.dart';
import 'package:coba_responsi2/apiDataSource.dart';

class MealsPage extends StatefulWidget {
  final String category;
  const MealsPage({super.key, required this.category});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  late Future<MealsResponse> futureMeals;

  @override
  void initState() {
    super.initState();
    futureMeals = ApiDataSource.instance.loadMeals(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Meals for ${widget.category}"),
      ),
      body: _buildListMeals(),
    );
  }

  Widget _buildListMeals() {
    return Container(
      child: FutureBuilder<MealsResponse>(
        future: futureMeals,
        builder: (BuildContext context, AsyncSnapshot<MealsResponse> snapshot) {
          if (snapshot.hasError) {
            return _buildError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.hasData) {
            return _buildSuccess(snapshot.data!);
          }
          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Text("Error loading meals"),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccess(MealsResponse mealsResponse) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8, // Aspect ratio for each item
      ),
      itemCount: mealsResponse.meals.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(mealsResponse.meals[index]);
      },
    );
  }

  Widget _buildItem(Meals meals) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailPage(mealId: meals.idMeal),
          )),
      child: Card(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              child: Image.network(
                meals.strMealThumb,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              meals.strMeal,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
