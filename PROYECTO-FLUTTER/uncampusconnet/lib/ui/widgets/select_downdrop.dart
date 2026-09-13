import 'package:flutter/material.dart';

const Color primaryRed = Color(0xFF931212);
const Color darkRed = Color(0xFF941818);

class MultiSelectDropdown extends StatefulWidget {
  final String hintText;
  final List<String> options;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;

  const MultiSelectDropdown({
    super.key,
    required this.hintText,
    required this.options,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  bool isOpen = false;

  void toggleOption(String option) {
    final List<String> updatedItems = List<String>.from(widget.selectedItems);

    if (updatedItems.contains(option)) {
      updatedItems.remove(option);
    } else {
      updatedItems.add(option);
    }

    widget.onChanged(updatedItems);
  }

  String get displayText {
    if (widget.selectedItems.isEmpty) {
      return widget.hintText;
    }

    return widget.selectedItems.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDarkMode
        ? const Color(0xFF2A2A2A)
        : Colors.white;

    final Color textColor = isDarkMode ? Colors.white : Colors.grey;

    final Color hintColor = isDarkMode ? Colors.white60 : Colors.grey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ==================================================
        // CAMPO
        // ==================================================

        GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: Container(
            height: 38,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.selectedItems.isEmpty
                          ? hintColor
                          : textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 22,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ),

        // ==================================================
        // OPCIONES
        // ==================================================
        if (isOpen)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: widget.options.map((option) {
                final bool isSelected = widget.selectedItems.contains(option);

                return InkWell(
                  onTap: () {
                    toggleOption(option);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(fontSize: 12, color: textColor),
                          ),
                        ),

                        Checkbox(
                          value: isSelected,
                          activeColor: primaryRed,
                          onChanged: (_) {
                            toggleOption(option);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
