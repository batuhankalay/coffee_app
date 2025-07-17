import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final IconData leftIcon;
  final IconData rightIcon;
  final Function? leftCallback;
  final Function? rightCallback;
  final Color? rightIconColor;
  
  CustomAppBar(
    this.leftIcon,
    this.rightIcon, {
    this.leftCallback,
    this.rightCallback,
    this.rightIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 25,
        right: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: leftCallback != null ? () => leftCallback!() : null ,
            child: _buildIcon(leftIcon),
          ),
          GestureDetector(
            onTap: rightCallback != null ? () => rightCallback!() : null,
            child: _buildIcon(rightIcon, color: rightIconColor),
          ),
      ],),
    );
  }

  Widget _buildIcon(IconData icon, {Color? color}) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Icon(icon, color: color),
    );
  }
}