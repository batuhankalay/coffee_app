import 'package:coffe_app/constans/colors.dart';
import 'package:coffe_app/service/getFood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final String userId = "demo_user_123";
  bool isLoading = true;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('card')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        cartItems = cartSnapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  'docId': doc.id,
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Sepet yüklenirken hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sepet yüklenemedi')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeFromCart(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('card')
          .doc(docId)
          .delete();

      setState(() {
        cartItems.removeWhere((item) => item['docId'] == docId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün sepetten kaldırıldı')),
      );
    } catch (e) {
      print('Ürün kaldırılırken hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün kaldırılamadı')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice =
        cartItems.fold(0, (sum, item) => sum + (item['price'] ?? 0) * (item['quantity'] ?? 1));

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text('Sepetim'),
        backgroundColor: kBackground,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text('Sepetiniz boş', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(bottom: 12),
                      child: Dismissible(
                        key: Key(item['docId'] ?? 'item_$index'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _removeFromCart(item['docId']);
                        },
                        child: ListTile(
                          leading: item['imageUrl'] != null
                              ? Image.network(
                                  item['imageUrl'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                )
                              : Icon(Icons.coffee, size: 50),
                          title: Text(item['name'] ?? 'Ürün', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text('${item['quantity'] ?? 1} adet'),
                          trailing: Text(
                              '${((item['price'] ?? 0) as num).toStringAsFixed(2)} TL',
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Toplam:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${totalPrice.toStringAsFixed(2)} TL', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              onPressed: cartItems.isEmpty ? null : () async {
                // Yükleniyor göster
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(child: CircularProgressIndicator()),
                );
                
                try {
                  // Siparişi tamamla
                  await completeOrder(
                    context,
                    userId,
                    cartItems,
                    totalPrice,
                  );
                  
                  // Yükleniyor dialogunu kapat
                  Navigator.of(context).pop();
                  
                  // Başarılı dialog göster
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                        // Sepeti yeniden yükle
                        _loadCartItems();
                      });

                      return Center(
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 60),
                                SizedBox(height: 16),
                                Text(
                                  'Sipariş Oluşturuldu',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } catch (e) {
                  // Yükleniyor dialogunu kapat
                  Navigator.of(context).pop();
                  
                  // Hata mesajı göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sipariş oluşturulamadı: $e')),
                  );
                }
              },
              child: Center(
                child: Text('Siparişi Tamamla', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }
}
