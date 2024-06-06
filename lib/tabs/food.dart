import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:permission_handler/permission_handler.dart';

class Food {
  final String name;
  final String image;
  final String rating;
  final String description;
  final String category;
  final LatLng location;

  Food(this.name, this.image, this.rating, this.description, this.category,
      this.location);
}

class FoodTab extends StatefulWidget {
  @override
  _FoodTabState createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> {
  late String selectedCategory;
  late List<Food> foods;
  late List<Food> filteredFoods;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
    selectedCategory = "All";
    foods = [
      Food(
          "Pizza",
          "assets/pizza.jpg",
          "4.9",
          "Delicious pizza with various toppings",
          "Makanan Barat",
          LatLng(-7.576246022128153, 110.93330490550812)),
      Food("Pasta", "assets/pasta.jpg", "4.9", "Homemade pasta with rich sauce",
          "Makanan Barat", LatLng(-7.576246022128153, 110.93330490550812)),
      Food(
          "Keripik Pisang",
          "assets/keripikpisang.jpg",
          "4.9",
          "Keripik pisang well!",
          "Makanan Ringan",
          LatLng(-7.560149449711748, 110.826453298266036)),
      Food(
          "Roti Tawar",
          "assets/rotitawar.jpg",
          "4.9",
          "Classic Indonesian bread",
          "Roti/Kue",
          LatLng(-7.562953693285234, 110.83561067573916)),
      Food("Roti Pisang", "assets/rotipisang.jpg", "4.9", "Banana bread",
          "Roti/Kue", LatLng(-7.566859116671038, 110.86981803176027)),
      Food("Tomato", "assets/tomato.jpg", "4.5", "Fresh and ripe tomato",
          "Bahan Makanan", LatLng(-7.561707747317485, 110.83583811834859)),
    ];
    filteredFoods = foods;
  }

  Future<void> _checkLocationPermissions() async {
    PermissionStatus status = await Permission.location.status;

    if (status != PermissionStatus.granted) {
      await Permission.location.request();
    }
  }

  List<Food> filterFoodsByCategory(String category) {
    return foods.where((food) => food.category == category).toList();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radiusOfEarth = 6371;
    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(degreesToRadians(lat1)) *
            Math.cos(degreesToRadians(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);

    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    double distance = radiusOfEarth * c;

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (Math.pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 400,
            child: OpenStreetMapSearchAndPick(
              center: LatLong(-7.562953693285234, 110.83561067573916),
              buttonColor: Color.fromARGB(255, 226, 100, 124),
              buttonText: 'Cari Makanan berdasarkan lokasi',
              onPicked: (pickedData) {
                double pickedLatitude = pickedData.latLong.latitude;
                double pickedLongitude = pickedData.latLong.longitude;

                List<Food> nearbyFoods = foods.where((food) {
                  double distance = calculateDistance(
                      pickedLatitude,
                      pickedLongitude,
                      food.location.latitude,
                      food.location.longitude);
                  return distance <= 5.0;
                }).toList();
                setState(() {
                  filteredFoods = nearbyFoods;
                });
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search for food...',
                          suffixIcon: Icon(Icons.search),
                        ),
                        onChanged: (query) {
                          List<Food> searchResults = filteredFoods
                              .where((food) =>
                                  food.name.toLowerCase().contains(query.toLowerCase()))
                              .toList();

                          setState(() {
                            filteredFoods = searchResults;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: [
                      "All",
                      "Makanan Barat",
                      "Makanan Ringan",
                      "Roti/Kue",
                      "Bahan Makanan"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 0.6,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedCategory == "All"
                        ? filteredFoods.length
                        : filteredFoods.length,
                    itemBuilder: (context, index) {
                      final foodItem = filteredFoods[index];
                      return InkWell(
                        onTap: () {},
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    foodItem.image,
                                    height: 250,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  foodItem.name,
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
                                      foodItem.rating,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  foodItem.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
