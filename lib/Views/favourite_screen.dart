import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/providers/favourite_providers.dart';
import 'package:recipe_app/Utills/constraint.dart';

class FavouriteScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavouriteProviders.of(context);
    final favouriteitems = provider.favourites;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        centerTitle: true,
        title: Text(
          'Favourite Recipes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: favouriteitems.isEmpty
          ? Center(
              child: Text(
                'No favourite Yet !!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favouriteitems.length,
              itemBuilder: (context, index) {
                String favourite = favouriteitems[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('reciepe_app')
                      .doc(favourite)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: kBannerColor),
                      );
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                        child: Text(
                          'Error Loading Favourite',
                          style: TextStyle(),
                        ),
                      );
                    }
                    var favouriteItem = snapshot.data!;
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        favouriteItem['image'],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      favouriteItem['name'],
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Icon(
                                          Iconsax.flash_1,
                                          size: 14,
                                          color: Colors.grey,
                                        ),

                                        Text(
                                          "${favouriteItem['cal']} Cal",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 7),

                                        Icon(
                                          Iconsax.clock,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          "${favouriteItem['time']} Min",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 20,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                provider.toggleFavourite(favouriteItem);
                              });
                            },
                            icon: Icon(Iconsax.trash, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
