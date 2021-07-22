import 'package:flutter/material.dart';

class FavsAttr with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String iamgeUrl;

  FavsAttr({this.id, this.title, this.price, this.iamgeUrl});
}
