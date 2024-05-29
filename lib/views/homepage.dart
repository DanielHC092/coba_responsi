import 'package:coba_responsi2/models/categoriesModel.dart';
import 'package:flutter/material.dart';
import 'package:coba_responsi2/apiDataSource.dart';
import 'package:coba_responsi2/views/meals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<CategoriesResponse> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = ApiDataSource.instance.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Categories"),
      ),
      body: _buildListCategories(),
    );
  }

  Widget _buildListCategories() {
    return Container(
      child: FutureBuilder<CategoriesResponse>(
        future: futureCategories,
        builder:
            (BuildContext context, AsyncSnapshot<CategoriesResponse> snapshot) {
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
      child: Text("Error loading categories"),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccess(CategoriesResponse categoriesResponse) {
    return ListView.builder(
      itemCount: categoriesResponse.categories.length,
      itemBuilder: (BuildContext context, index) {
        return _buildItem(categoriesResponse.categories[index]);
      },
    );
  }

  Widget _buildItem(Category category) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealsPage(category: category.strCategory),
          )),
      child: Card(
        child: Column(
          children: [
            Container(
              width: 175,
              child: Image.network(category.strCategoryThumb),
            ),
            SizedBox(width: 15),
            Text(
              category.strCategory,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              category.strCategoryDescription,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
