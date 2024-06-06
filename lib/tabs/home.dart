import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_project/widget/menu.dart';

class Food {
  final String name;
  final String image;
  final String rating;
  final String description;
  final String category;

  Food(this.name, this.image, this.rating, this.description, this.category);
}

class HomeTab extends StatefulWidget {
  final User? user;
  final bool isUserLoggedIn;

  HomeTab({
    this.user,
    this.isUserLoggedIn = true,
  });

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Food> searchResults = [];
  bool isSearching = false;

  List<Food> fetchedFoods = [
    Food("Pizza", "assets/pizza.jpg", "4.9","Delicious pizza with various toppings", "Makanan Barat"),
    Food("Pasta", "assets/pasta.jpg", "4.9", "Homemade pasta with rich sauce","Makanan Barat"),
    Food("Keripik Pisang", "assets/keripikpisang.jpg", "4.9","Keripik pisang well!", "Makanan Ringan"),
    Food("Roti Tawar", "assets/rotitawar.jpg", "4.9","Classic Indonesian bread", "Roti/Kue"),
    Food("Roti Pisang", "assets/rotipisang.jpg", "4.9", "Banana bread","Roti/Kue"),
    Food("Tomato", "assets/tomato.jpg", "4.5", "Fresh and ripe tomato","Bahan Makanan"),
  ];

@override
  void initState() {
    searchResults = fetchedFoods;
    super.initState();
  }

  void performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
    } else {
      List<Food> matchingFoods = fetchedFoods
          .where(
              (foodfilter) => foodfilter.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        isSearching = true;
        searchResults = matchingFoods;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 226, 100, 124),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    widget.user != null && widget.isUserLoggedIn
                        ? "Hi, ${widget.user!.displayName ?? "Guest"}"
                        : "Hi, Guest",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (query) {
                      performSearch(query);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Kategori Section
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Category",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 130,
                  child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryContainer("Makanan Barat", "assets/barat.png"),
                  CategoryContainer("Makanan Ringan", "assets/snack.png"),
                  CategoryContainer("Roti/Kue", "assets/roti.png"),
                  CategoryContainer("Bahan Makanan", "assets/bahan.png"),
                ],
              ),
                ),
              ],
            ),
          ),
          // Recent Food
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 15.0),
                child: Text(
                  "Recommended Food",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.6,
                  ),
                  itemCount:
                      isSearching ? searchResults.length : fetchedFoods.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final foodfilter = isSearching ? searchResults[index] : fetchedFoods[index];
                    return InkWell(
                      onTap: () {
                        // Add action for tapping on a food item
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                foodfilter.image,
                                height: 250,
                                width: 200,
                                fit: BoxFit.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  foodfilter.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    Text(
                                      foodfilter.rating,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  foodfilter.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final String categoryName;
  final String categoryImage;

  CategoryContainer(this.categoryName,this.categoryImage);
  @override
  Widget build(BuildContext context) {
    return InkWell(
     onTap: () {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MenuScreen(
                  currentIndex: 1,
                )),
      );
      },
      child: Container(
        width: 140,
        child: Card(
          elevation: 2,
          margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 8.0),
          color: Color.fromARGB(255, 226, 100, 124),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  categoryImage,
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
