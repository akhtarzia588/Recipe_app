import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteProviders extends ChangeNotifier {
  List<String> _favouriteids = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favourites => _favouriteids;

  FavouriteProviders() {
    loadFavourites();
  }

  void toggleFavourite(DocumentSnapshot product) async {
    String productId = product.id;

    if (_favouriteids.contains(productId)) {
      _favouriteids.remove(productId);
      await _removeFavourite(productId);
    } else {
      _favouriteids.add(productId);
      await _addFavourite(productId);
    }
    notifyListeners();
  }

  bool isExit(DocumentSnapshot product) {
    return _favouriteids.contains(product.id);
  }

  Future<void> _addFavourite(String productId) async {
    try {
      await _firestore.collection('UserFavourite').doc(productId).set({
        'isFavourite': true,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _removeFavourite(String productId) async {
    try {
      await _firestore.collection('UserFavourite').doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadFavourites() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('UserFavourite')
          .get();
      _favouriteids = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  static FavouriteProviders of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavouriteProviders>(context, listen: listen);
  }
}
