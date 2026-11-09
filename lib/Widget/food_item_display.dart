import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Views/Recipe_detail_screen.dart';
import 'package:recipe_app/providers/favourite_providers.dart';

class FoodItemDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentsnaphot;
  const FoodItemDisplay({super.key, required this.documentsnaphot});

  @override
  Widget build(BuildContext context) {
    final provider = FavouriteProviders.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecipeDetailScreen(documentSnapshot: documentsnaphot),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 210,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: documentsnaphot['image'],
                  child: Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(documentsnaphot['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  documentsnaphot['name'],
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Iconsax.flash_1, size: 16, color: Colors.grey),

                    Text(
                      "${documentsnaphot['cal']} Cal",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      ' . ',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                      ),
                    ),
                    Icon(Iconsax.clock, size: 16, color: Colors.grey),
                    SizedBox(width: 3),
                    Text(
                      "${documentsnaphot['time']} Min",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // for favourite button
            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: InkWell(
                  onTap: () {
                    provider.toggleFavourite(documentsnaphot);
                  },
                  child: Icon(
                    provider.isExit(documentsnaphot)
                        ? Iconsax.heart5
                        : Iconsax.heart,
                    color: provider.isExit(documentsnaphot)
                        ? Colors.red
                        : Colors.black,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
