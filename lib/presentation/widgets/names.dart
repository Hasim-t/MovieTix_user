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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: TextStyle(
              color: MyColor().white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: MyColor().white,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
              softWrap: true,
              overflow: TextOverflow.fade,
             maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}