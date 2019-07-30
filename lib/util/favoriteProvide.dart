import 'package:flutter/material.dart';

class FavoriteProvide with ChangeNotifier {
  bool _isFavorite = false;

  bool get value => _isFavorite;

  FavoriteProvide();

  void changeFavorite(bool isFavorite) {
    _isFavorite = isFavorite;
    notifyListeners();
  }
}
