import 'package:app_store/models/product.dart';
import 'package:app_store/provider/products.dart';
import 'package:app_store/widget/feeds_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class CategoriesFeedsScreen extends StatelessWidget {
  static const routeName = '/CategoriesFeedsScreen';

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    final categoryName = ModalRoute.of(context).settings.arguments as String;
    print(categoryName);
    final productsList = productsProvider.findByCategory(categoryName);
    return Scaffold(
      body: productsList.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Feather.database,
                    size: 80,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'No product related to this category',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            )
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 240 / 420,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: List.generate(productsList.length, (index) {
                return ChangeNotifierProvider.value(
                  value: productsList[index],
                  child: FeedProducts(),
                );
              }),
            ),
      //GridView.count(
      //crossAxisCount: 2,
      //childAspectRatio: 240 / 290,
      //crossAxisSpacing: 8,
      //mainAxisSpacing: 8,
      //children: List.generate(100, (index) {
      //return FeedProducts();
      //}),
      // )
      //);
    );
  }
}
