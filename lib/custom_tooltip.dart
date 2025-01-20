import 'package:flutter/material.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip({
    super.key,
    required this.productDetails,
    required this.productValues,
  });

  final List<String> productDetails;
  final List<String> productValues;

  Widget _buildRichText(
      BuildContext context, String categoriesName, String categoriesValue) {
    final TextStyle textStyle = DefaultTextStyle.of(context).style;
    return RichText(
      text: TextSpan(
        text: categoriesName,
        style: textStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        children: <TextSpan>[
          TextSpan(
            text: ' $categoriesValue',
            style: textStyle.copyWith(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 8.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(
          productDetails.length,
          (int index) {
            return _buildRichText(
              context,
              productDetails[index],
              productValues[index],
            );
          },
        ),
      ),
    );
  }
}
