import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../containers/circular_container.dart';

/// A customized choice chip that can act like a radio button.
class BaakasChoiceChip extends StatelessWidget {
  /// Create a chip that acts like a radio button.
  ///
  /// Parameters:
  ///   - text: The label text for the chip.
  ///   - selected: Whether the chip is currently selected.
  ///   - onSelected: Callback function when the chip is selected.
  const BaakasChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Use a transparent canvas color to match the existing styling.
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        // Use this function to get Colors as a Chip
        avatar: BaakasHelperFunctions.getColor(text) != null
            ? BaakasCircularContainer(
                width: 50,
                height: 50,
                backgroundColor: BaakasHelperFunctions.getColor(text)!)
            : null,
        selected: selected,
        onSelected: onSelected,
        backgroundColor: BaakasHelperFunctions.getColor(text),
        labelStyle: TextStyle(color: selected ? BaakasColors.white : null),
        shape: BaakasHelperFunctions.getColor(text) != null
            ? const CircleBorder()
            : null,
        label: BaakasHelperFunctions.getColor(text) == null
            ? Text(text)
            : const SizedBox(),
        padding: BaakasHelperFunctions.getColor(text) != null
            ? const EdgeInsets.all(0)
            : null,
        labelPadding: BaakasHelperFunctions.getColor(text) != null
            ? const EdgeInsets.all(0)
            : null,
      ),
    );
  }
}
