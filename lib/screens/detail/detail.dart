import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_app/constans/colors.dart';
import 'package:coffe_app/constans/select_boys.dart';
import 'package:coffe_app/models/food.dart';
import 'package:coffe_app/screens/cart_page.dart';
import 'package:coffe_app/screens/detail/widget/food_detail.dart';
import 'package:coffe_app/screens/detail/widget/food_img.dart';
import 'package:coffe_app/screens/detail/widget/food_quantity.dart';
import 'package:coffe_app/service/getFood.dart';
import 'package:coffe_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String? foodId;

  DetailPage({this.foodId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Food> foodFuture;
  int quantity = 1;
  double unitPrice = 0;
  double totalPrice = 0;
  Food? food;
  bool isFavorited = false;
  @override
  void initState() {
    super.initState();
    foodFuture = fetchFoodById();
    _checkFavoriteStatus();
  }
  
  Future<void> _checkFavoriteStatus() async {
    if (widget.foodId != null) {
      bool favoriteStatus = await isFavorite(widget.foodId!);
      setState(() {
        isFavorited = favoriteStatus;
      });
    }
  }

  Future<Food> fetchFoodById() async {
    final doc = await FirebaseFirestore.instance
        .collection('foodList')
        .doc(widget.foodId)
        .get();

    if (doc.exists) {
      final food = Food.fromDocument(doc);
      quantity = food.quantity?.toInt() ?? 1;
      unitPrice = food.price?.toDouble() ?? 0.0;
      totalPrice = unitPrice * quantity;
      return food;
    } else {
      throw Exception('Food not found');
    }
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
      totalPrice = unitPrice * quantity;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        totalPrice = unitPrice * quantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Arkaplan için AppBar arkasını transparan yap
      body: Container(
        
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<Food>(
          future: foodFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return Center(child: Text('Kahve bulunamadı'));
            }
      
            final food = snapshot.data!;
            return Column(
              children: [
                // Üst görsel ve app bar
                CustomAppBar(
                  Icons.arrow_back_ios_outlined,
                  isFavorited ? Icons.favorite : Icons.favorite_outline,
                  leftCallback: () => Navigator.of(context).pop(),
                  rightCallback: () => _toggleFavorite(food),
                  rightIconColor: isFavorited ? Colors.red : null,
                ),
                _buildImageSection(food),
                _buildDetailSection(food),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 56,
        child: RawMaterialButton(
          fillColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 30),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  quantity.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            foodFuture.then((food) {
              // Önce sepete ekle
              addToCart(
                context,
                food.name ?? '',
                food.id ?? '',
                food.imgUrl ?? '',
                totalPrice,
                quantity,
              ).then((_) {
                // Sepete ekleme başarılı olduktan sonra modal göster
                _showCartConfirmationDialog(context, food);
              });
            }).catchError((error) {
              print("Veri hatası: $error");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Ürün bilgisi alınamadı")),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildImageSection(Food food) {
    return Container(
      height: 250,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(child: Container()),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                    color: kBackground,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(15),
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: Offset(-1, 10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Image.network(food.imgUrl ?? "", fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(Food food) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height*0.65,
        padding: EdgeInsets.all(25),
        color: kBackground,
        child: Column(
          children: [
            Text(
              food.name ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildIconText(
                  Icons.access_time_outlined,
                  Colors.blue,
                  food.waitTime ?? "",
                ),
                buildIconText(
                  Icons.star_outline,
                  Colors.amber,
                  food.score.toString(),
                ),
                buildIconText(
                  Icons.local_fire_department_outlined,
                  Colors.red,
                  food.cal ?? "",
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.16),
              padding: EdgeInsets.only(left: 20),
             
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                     
                      
                      Text(
                        totalPrice.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                       Text(
                        '₺',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    //width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: decrementQuantity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('-', style: _counterStyle()),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 20,left: 20, top: 7, bottom: 7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: incrementQuantity,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('+', style: _counterStyle()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Şeker Miktarı',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),
            SizeSelector(),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Hakkında',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              food.about ?? "",
              style: TextStyle(wordSpacing: 1.2, height: 1.5, fontSize: 16),
            ),
            //Container(height: 223),
          ],
        ),
      ),
    );
  }

  TextStyle _counterStyle() {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  }

  // Favorilere ekle/çıkar
  Future<void> _toggleFavorite(Food food) async {
    bool result = await toggleFavorite(context, food);
    setState(() {
      isFavorited = result;
    });
  }
  
  // Sepete ekledikten sonra gösterilen onay dialoğu
  void _showCartConfirmationDialog(BuildContext context, Food food) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Başlık ve ikonu
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                SizedBox(height: 15),
                Text(
                  "Sepete Eklendi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Ürün bilgileri
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(food.imgUrl ?? ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name ?? "",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "$quantity adet - ${totalPrice.toStringAsFixed(2)} TL",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Butonlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Alışverişe devam et butonu
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Alışverişe Devam Et",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Siparişi tamamla butonu
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Sepet sayfasına yönlendir
                          Navigator.pop(context); // Dialog'u kapat
                           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
                        },
                        child: Text("Siparişe Git"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildIconText(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
