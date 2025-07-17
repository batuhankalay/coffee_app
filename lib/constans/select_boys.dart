import 'package:flutter/material.dart';

class SizeOption {
  final String label;
  final String image;

  SizeOption(this.label, this.image);
}

class SizeSelector extends StatefulWidget {
  @override
  _SizeSelectorState createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  int selectedIndex = 0;

  final List<SizeOption> sizes = [
    SizeOption("Şekersiz", "assets/images/ske.png"),
    SizeOption("Az Şeker", "assets/images/ske.png"),
    SizeOption("Orta Şeker", "assets/images/ske.png"),
    SizeOption("Çok Şeker", "assets/images/ske.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sizes.length,
        separatorBuilder: (_, index) => SizedBox(width: 15),
        itemBuilder: (context, index) {
          final size = sizes[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              // Seçilen boyuta göre işlem yapabilirsin
              //print("Selected size: ${size.label}");
              
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isSelected ? Color(0xFFFEC907) : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    size.image,
                    width: 52,
                    height: 52,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 5),
                  Text(
                    size.label,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
