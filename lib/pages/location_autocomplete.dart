import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'color.dart'; // To access C.theamecolor

class LocationAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  // New props for flexible logic
  final RxBool isLoading;
  final Future<List<String>> Function(String) onSearch;

  const LocationAutocomplete({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.icon,
    this.validator,
    required this.isLoading,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              // Use passed callback
              return await onSearch(textEditingValue.text);
            },
            onSelected: (String selection) {
              controller.text = selection;
            },
            fieldViewBuilder:
                (
                  BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  // Sync external controller
                  if (controller.text.isNotEmpty &&
                      fieldTextEditingController.text.isEmpty) {
                    fieldTextEditingController.text = controller.text;
                  }
                  fieldTextEditingController.addListener(() {
                    controller.text = fieldTextEditingController.text;
                  });

                  return TextFormField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    validator: validator,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon: Icon(icon, color: Colors.white70),
                      suffixIcon: Obx(
                        () =>
                            isLoading
                                .value // Use passed observable
                            ? Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      labelText: label,
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: hint,
                      hintStyle: const TextStyle(color: Colors.white30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      errorStyle: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                },
            optionsViewBuilder:
                (
                  BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options,
                ) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      color: C.theamecolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.white24),
                      ),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: 200,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return ListTile(
                              title: Text(
                                option,
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
          );
        },
      ),
    );
  }
}
