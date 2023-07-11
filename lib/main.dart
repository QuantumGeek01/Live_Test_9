import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application3/recipe_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RecipeListWidget(),
    );
  }
}

class RecipeListWidget extends StatefulWidget {
  @override
  _RecipeListWidgetState createState() => _RecipeListWidgetState();
}

class _RecipeListWidgetState extends State<RecipeListWidget> {
  late Future<List<Recipe>> _futureRecipes;

  @override
  void initState() {
    super.initState();
    _futureRecipes = fetchRecipes();
  }

  Future<List<Recipe>> fetchRecipes() async {
    String jsonString = await rootBundle.loadString('Json/recipes.json');
    final List<dynamic> data = json.decode(jsonString)['recipes'];
    return data.map((json) => Recipe.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load recipes'));
          } else if (snapshot.hasData) {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  title: Text(recipe.title),
                );
              },
            );
          } else {
            return Center(child: Text('No recipes found'));
          }
        },
      ),
    );
  }
}
