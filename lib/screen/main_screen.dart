import 'package:app_store/screen/upload_product_form.dart';
import 'package:app_store/screen/bottom_bar.dart';
import 'package:app_store/screen/landing_page.dart';
import 'package:flutter/material.dart';

class MainScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [BottomBarScreen(), UploadProductForm()],
    );
  }
}
