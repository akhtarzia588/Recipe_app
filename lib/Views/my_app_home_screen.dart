import 'package:flutter/material.dart';
import 'package:recipe_app/Utills/constraint.dart';
import 'package:recipe_app/Views/view_all_items.dart';
import 'package:recipe_app/Widget/icon_button.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Widget/banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/Widget/food_item_display.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  String category = "All";
  // Default category is set to "All"

  // Reference to the Firestore collection for categories
  final CollectionReference categoriesitems = FirebaseFirestore.instance
      .collection('category_app');
  Query get filteredRecipes => FirebaseFirestore.instance
      .collection('reciepe_app')
      .where('category', isEqualTo: category);
  // Default filter for "All" category
  Query get allRecipes => FirebaseFirestore.instance.collection('reciepe_app');
  // Reference to the Firestore collection for recipes
  Query get selectedRecipes => category == "All" ? allRecipes : filteredRecipes;
  // Query to fetch recipes based on the selected category
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerParts(),
                    mySearchBar(),

                    //for the banner
                    const BannerToExplare(),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // for Category
                    selectedCategory(),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quick and Easy",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ViewAllItems()),
                            );
                          },
                          child: Text(
                            "View All",
                            style: TextStyle(
                              color: kBannerColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: selectedRecipes.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        final List<DocumentSnapshot> recipes =
                            streamSnapshot.data?.docs ?? [];
                        return Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: recipes
                                  .map(
                                    (e) => FoodItemDisplay(documentsnaphot: e),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
      stream: categoriesitems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        // Error check
        if (streamSnapshot.hasError) {
          return Center(
            child: Text(
              "Firestore Error:\n${streamSnapshot.error}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      category = streamSnapshot.data!.docs[index]['name'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          category == streamSnapshot.data!.docs[index]['name']
                          ? kPrimaryColor
                          : Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      streamSnapshot.data!.docs[index]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight(600),
                        color:
                            category == streamSnapshot.data!.docs[index]['name']
                            ? Colors.white
                            : kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Padding mySearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search for recipes",

          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Iconsax.search_normal_1),

          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Row headerParts() {
    return Row(
      children: [
        const Text(
          'What are you \nCooking today??',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        Spacer(),
        MyIconButton(icon: Iconsax.notification5, Pressed: () {}),
      ],
    );
  }
}
