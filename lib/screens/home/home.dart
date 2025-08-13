import 'package:coffe_app/constans/colors.dart';
import 'package:coffe_app/models/food.dart';
import 'package:coffe_app/models/restaurant.dart';
import 'package:coffe_app/screens/cart_page.dart';
import 'package:coffe_app/screens/home/widget/food_item.dart';
import 'package:coffe_app/screens/home/widget/food_list.dart';
import 'package:coffe_app/screens/home/widget/restaurant_info.dart';
import 'package:coffe_app/service/getFood.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  var selected = 0;
  final restaurant = Restaurant.generateRestaurant();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";
  
  late Future<List<Food>> _futureFoods;
  List<Food> _allFoods = [];
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _futureFoods = _loadFoods();
    
    // Kategorileri al
    _categories = restaurant.menu.keys.toList();
    
    // Arama metin alanı değişikliklerini dinle
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  // RouteAware metodları - detay sayfasından geri dönüldüğünde arama temizle
  @override
  void didPopNext() {
    // Detay sayfasından geri dönüldüğünde arama state'ini temizle
    if (_searchQuery.isNotEmpty) {
      setState(() {
        _searchController.clear();
        _searchQuery = "";
      });
    }
    super.didPopNext();
  }
  
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }
  
  Future<List<Food>> _loadFoods() async {
    final foods = await fetchFoods();
    _allFoods = foods;
    return foods;
  }
  
  // Seçilen kategoriye ve arama sorgusuna göre filtrelenmiş yemekleri döndürür
  List<Food> _getFilteredFoods() {
    // Önce seçilen kategoriye göre filtrele
    List<Food> categoryFiltered = _allFoods;
    
    if (_categories.isNotEmpty && selected < _categories.length) {
      String selectedCategory = _categories[selected];
      categoryFiltered = _allFoods.where((food) => 
        food.category?.toLowerCase() == selectedCategory.toLowerCase()
      ).toList();
    }
    
    // Sonra arama sorgusuna göre filtrele
    if (_searchQuery.isEmpty) {
      return categoryFiltered;
    }
    
    return categoryFiltered
        .where((food) {
          final query = _searchQuery.toLowerCase().trim();
          final name = (food.name?.toLowerCase() ?? '').trim();
          final about = (food.about?.toLowerCase() ?? '').trim();
          final desc = (food.desc?.toLowerCase() ?? '').trim();
          
          bool nameMatch = name.contains(query);
          bool aboutMatch = about.contains(query);
          bool descMatch = desc.contains(query);
          
          bool isMatch = nameMatch || aboutMatch || descMatch;
          

          
          return isMatch;
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Başka bir yere tıklandığında arama kutusunun focus'unu kaldır
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: kBackground,
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(height:70),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            hintText: "Kahve veya içecek ara",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          RestaurantInfo(),
          FoodList(selected, (int index) {
            setState(() {
              selected = index;
            });
          }, restaurant),
          
          Expanded(
            child: FutureBuilder<List<Food>>(
              future: _futureFoods,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Ürün bulunamadı'));
                }

                // Filtrelenmiş ürünleri al
                final filteredFoods = _getFilteredFoods();
                
                // Hem arama sonucu hem de kategori filtresi sonucunda ürün yoksa
                if (filteredFoods.isEmpty) {
                  String message = _searchQuery.isNotEmpty 
                      ? '"$_searchQuery" için sonuç bulunamadı'
                      : (_categories.isNotEmpty && selected < _categories.length) 
                          ? '${_categories[selected]} kategorisinde ürün bulunamadı' 
                          : 'Ürün bulunamadı';
                          
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 50, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          message,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 02),
                  itemCount: filteredFoods.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/detail", arguments: food.id);
                      },
                      child: FoodItem(food),
                    );
                  },
                );
              },
            ),
          ),
          // Sayfa göstergeci kaldırıldı
          SizedBox(height: 30),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        },
        backgroundColor: kPrimaryColor,
        elevation: 2,
        child: Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 30),
      ),
      ),
    );
  }
}
