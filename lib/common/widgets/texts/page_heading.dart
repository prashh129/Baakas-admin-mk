import 'package:flutter/material.dart';

class BaakasPageHeading extends StatelessWidget {
  const BaakasPageHeading({
    super.key,
    required this.heading,
    this.rightSideWidget,
  });

  final String heading;
  final Widget? rightSideWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(heading, style: Theme.of(context).textTheme.headlineLarge),
        rightSideWidget ?? const SizedBox(),
      ],
    );
  }
}
