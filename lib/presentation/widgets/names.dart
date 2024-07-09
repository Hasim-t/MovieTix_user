import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';

class CoustomNameRow extends StatelessWidget {
  final String label;
  final String value;

  const CoustomNameRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: TextStyle(
              color: MyColor().white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: MyColor().white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}