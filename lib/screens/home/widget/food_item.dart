import 'package:coffe_app/constans/colors.dart';
import 'package:coffe_app/models/food.dart';
import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final Food food;
  FoodItem(this.food);

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(left: 20,right: 20),
     
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: 110,
            height: 110,
            child: Image.network(food.imgUrl??"",
            fit: BoxFit.fitHeight,),
          ),
          Expanded(
            child: Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(food.name??"",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),),
                    Icon(Icons.arrow_forward_ios_outlined,
                    size: 15,)
                  ],
                ),
                Text(food.desc??"",
                style: TextStyle(
                  color:  kPrimaryColor,
                  height: 1.5,
                ),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text('${food.price}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                     Text(' TL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ],
                )
              ],
            ),
                      ))
        ],
      ),
    );
  }
}