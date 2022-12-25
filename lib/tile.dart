import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String value;
  final String hint;
  final double size;
  final Function onSelected;
  final bool isSelected;

  const Tile({
    Key? key,
    required this.value,
    required this.size,
    required this.onSelected,
    required this.isSelected,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => value == "0" ? onSelected() : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.3),
          color: isSelected ? Colors.blueAccent.shade100.withAlpha(100) : Colors.transparent,
        ),
        child: Center(
            child: Text(
          value == "0" ? hint : value,
          style: TextStyle(color: value == "0" ? Colors.black12 : Colors.black),
        )),
      ),
    );
  }
}
