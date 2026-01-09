import 'package:flutter/material.dart';
import 'package:ticketbooking/pages/common/color.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ticketbooking/pages/user/location_autocomplete.dart'; // Added Import

import 'package:get/get.dart';
import 'package:ticketbooking/controller/app_controller.dart'; // Import Controller

class AdminSign extends StatefulWidget {
  const AdminSign({super.key});

  @override
  State<AdminSign> createState() => _AdminSignState();
}

class _AdminSignState extends State<AdminSign> {
  // Inject Controller
  final AppController controller = Get.put(AppController());

  // Logic Variables MOVED to Controller
  // String bustyperadiobutton = 'A/C';
  // String uptimestatedropdownvalue = "am";
  // String downtimestatedropdownvalue = "am";

  var uptimestate = ['am', 'pm'];
  var downtimestate = ['am', 'pm'];

  final GlobalKey<FormState> formkey = GlobalKey();

  // String password = ''; // Unused in new logic (controller has text)

  @override
  void initState() {
    super.initState();
  }

  // voidlog MOVED to Controller as createAdminAccount

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: suffixIcon,
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
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Colors.white54, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const Expanded(child: Divider(color: Colors.white54, thickness: 1)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.theamecolor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  // Header Icon (Replaced Image)
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white10,
                    child: Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Animated Title
                  SizedBox(
                    height: 50,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          "Create Admin Account",
                          textStyle: const TextStyle(
                            fontSize: 32.0,
                            fontFamily: 'Horizon',
                            fontWeight: FontWeight.bold,
                          ),
                          colors: [
                            Colors.white,
                            Colors.blueAccent,
                            Colors.yellow,
                            Colors.red,
                          ],
                        ),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Join us to manage your fleet efficiently",
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 30),

                  // --- Admin Details ---
                  _buildSectionHeader("Admin Details"),

                  _buildTextField(
                    controller: controller.adminnamecontroller,
                    hint: "Enter Full Name",
                    label: "Full Name",
                    icon: Icons.person_outline,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                  ),
                  _buildTextField(
                    controller: controller.adminphonecontroller,
                    hint: "Enter Phone Number",
                    label: "Phone Number",
                    icon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                  ),
                  _buildTextField(
                    controller: controller.adminemailcontroller,
                    hint: "Enter Email Address",
                    label: "Email",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty) return "Required";
                      if (!val.contains('@')) return "Invalid Email";
                      return null;
                    },
                  ),
                  Obx(
                    () => _buildTextField(
                      // Wrapped in Obx
                      controller: controller.adminpasswordcontroller,
                      hint: "Create Password",
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscureText: controller
                          .isPasswordVisible
                          .value, // Used controller value
                      validator: (val) =>
                          (val!.length < 6) ? "Min 6 characters" : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white60,
                        ),
                        onPressed: () => controller
                            .togglePasswordVisibility(), // Controller method
                      ),
                    ),
                  ),
                  Obx(
                    () => _buildTextField(
                      // Wrapped in Obx
                      controller: controller.adminconfirmpasswordcontroller,
                      hint: "Confirm Password",
                      label: "Confirm Password",
                      icon: Icons.lock_outline,
                      obscureText: controller
                          .isConfirmPasswordVisible
                          .value, // Used controller value
                      validator: (val) {
                        if (val != controller.adminpasswordcontroller.text)
                          return "Passwords do not match";
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white60,
                        ),
                        onPressed: () => controller
                            .toggleConfirmPasswordVisibility(), // Controller method
                      ),
                    ),
                  ),

                  // --- Bus Details ---
                  _buildSectionHeader("Bus Details"),

                  _buildTextField(
                    controller: controller.busnamecontroller,
                    hint: "Enter Bus Name",
                    label: "Bus Name",
                    icon: Icons.directions_bus_outlined,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                  ),
                  _buildTextField(
                    controller: controller.busnocontroller,
                    hint: "e.g. AB 12 CD 3456",
                    label: "Registration Number",
                    icon: Icons.confirmation_number_outlined,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.busseatcapacitycontroller,
                          hint: "Seats",
                          label: "Capacity",
                          icon: Icons.event_seat_outlined,
                          keyboardType: TextInputType.number,
                          validator: (val) => val!.isEmpty ? "Req" : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTextField(
                          controller: controller.busticketpricecontroller,
                          hint: "Price",
                          label: "Ticket Price",
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (val) => val!.isEmpty ? "Req" : null,
                        ),
                      ),
                    ],
                  ),

                  // Bus Type Section
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Bus Type",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        Obx(
                          () => Row(
                            // Wrapped in Obx
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  title: const Text(
                                    "A/C",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  value: "A/C",
                                  groupValue: controller
                                      .bustyperadiobutton
                                      .value, // Controller value
                                  activeColor: Colors.blueAccent,
                                  onChanged: (val) => controller.setBusType(
                                    val.toString(),
                                  ), // Controller method
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  title: const Text(
                                    "Non A/C",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  value: "Non A/C",
                                  groupValue: controller
                                      .bustyperadiobutton
                                      .value, // Controller value
                                  activeColor: Colors.blueAccent,
                                  onChanged: (val) => controller.setBusType(
                                    val.toString(),
                                  ), // Controller method
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Note: Keeping it simple for the depot/time selection for now.
                  // In a real refactor, these should also be improved, but I'll replicate the core fields needed for 'voidlog' to work.
                  // Ideally, I would add the depot/time pickers here as well if they are critical.
                  // Looking at the original code, there were MANY fields for time. I should probably include them or simplify.
                  // For the sake of this task "UI beautification", I will focus on the main fields provided above.
                  // However, 'voidlog' expects 'updepot', 'uptime', 'downdepot', 'downtime'.
                  // I must add simplified fields for these or the logic will break/pass empty strings.
                  _buildSectionHeader("Route Details"),
                  LocationAutocomplete(
                    controller: controller.updepotsearchController,
                    hint: "Start Depot",
                    label: "From",
                    icon: Icons.location_on_outlined,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    isLoading: controller.isLoadingUp,
                    onSearch: (query) => controller.fetchLocations(
                      query,
                      controller.isLoadingUp,
                    ),
                  ),
                  Row(
                    // Up Time
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.busuptimecontroller,
                          hint: "HH",
                          label: "Hour",
                          icon: Icons.access_time,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          controller: controller.bustravleminuptimecontroller,
                          hint: "MM",
                          label: "Min",
                          icon: Icons.access_time,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Obx(
                            () => DropdownButton<String>(
                              // Wrapped in Obx
                              value: controller
                                  .uptimestatedropdownvalue
                                  .value, // Controller value
                              dropdownColor: C.theamecolor,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              items: uptimestate.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                controller.setUpTimeState(
                                  newValue!,
                                ); // Controller method
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: controller.bustravlehruptimecontroller,
                    hint: "e.g. 5 Hours 30 Mins",
                    label: "Travel Duration (Up)",
                    icon: Icons.timer,
                  ),

                  const SizedBox(height: 10),
                  LocationAutocomplete(
                    controller: controller.downdepotsearchController,
                    hint: "End Depot",
                    label: "To",
                    icon: Icons.location_on_outlined,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    isLoading: controller.isLoadingDown,
                    onSearch: (query) => controller.fetchLocations(
                      query,
                      controller.isLoadingDown,
                    ),
                  ),
                  Row(
                    // Down Time
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.busdowntimecontroller,
                          hint: "HH",
                          label: "Hour",
                          icon: Icons.access_time,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          controller: controller.bustravlemindowntimecontroller,
                          hint: "MM",
                          label: "Min",
                          icon: Icons.access_time,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Obx(
                            () => DropdownButton<String>(
                              // Wrapped in Obx
                              value: controller
                                  .downtimestatedropdownvalue
                                  .value, // Controller value
                              dropdownColor: C.theamecolor,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              items: downtimestate.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                controller.setDownTimeState(
                                  newValue!,
                                ); // Controller method
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: controller.bustravlehrdowntimecontroller,
                    hint: "e.g. 5 Hours 30 Mins",
                    label: "Travel Duration (Down)",
                    icon: Icons.timer,
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          controller.createAdminAccount(context);
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please fill all required fields",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
