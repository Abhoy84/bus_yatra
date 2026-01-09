import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticketbooking/controller/app_controller.dart';
import 'package:ticketbooking/models/adminmodel.dart';
import 'package:ticketbooking/pages/common/color.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class admindetails extends StatelessWidget {
  final Admin admin;
  admindetails(this.admin, {super.key});

  final AppController controller = Get.put(AppController());
  final GlobalKey<FormState> formkey = GlobalKey();

  // Observable booleans for enabling editing
  final RxBool nameEnabled = false.obs;
  final RxBool phoneEnabled = false.obs;
  final RxBool emailEnabled = false.obs;
  final RxBool passcodeEnabled = false.obs;

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with current admin data
    final TextEditingController adminnamecontroller = TextEditingController(
      text: admin.name,
    );
    final TextEditingController adminphonecontroller = TextEditingController(
      text: admin.phone,
    );
    final TextEditingController adminemailcontroller = TextEditingController(
      text: admin.email,
    );
    final TextEditingController adminpasscodecontroller = TextEditingController(
      text: admin.passcode,
    );
    final TextEditingController adminconfirmpasscodecontroller =
        TextEditingController(text: admin.passcode);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: C.textfromcolor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: C.theamecolor,
          centerTitle: true,
          title: Text(
            "Admin Details",
            style: TextStyle(color: C.textfromcolor),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 255,
                          left: 20,
                          right: 20,
                        ),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 233, 230, 230),
                        ),
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 8, left: 10),
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: C.theamecolor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                      255,
                                      105,
                                      105,
                                      105,
                                    ).withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Name Field
                                  _buildLabel("User name"),
                                  _buildField(
                                    controller: adminnamecontroller,
                                    enabled: nameEnabled,
                                    icon: Icons.person_2_sharp,
                                    validator: (value) => value!.isEmpty
                                        ? 'Cannot be blank!'
                                        : null,
                                  ),

                                  // Phone Field
                                  _buildLabel("Phone no."),
                                  _buildField(
                                    controller: adminphonecontroller,
                                    enabled: phoneEnabled,
                                    icon: Icons.phone_android,
                                    validator: (value) => value!.isEmpty
                                        ? 'Cannot be blank!'
                                        : null,
                                  ),

                                  // Email Field
                                  _buildLabel("E-mail"),
                                  _buildField(
                                    controller: adminemailcontroller,
                                    enabled: emailEnabled,
                                    icon: Icons.email,
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return 'Cannot be blank!';
                                      if (!GetUtils.isEmail(value))
                                        return 'Enter valid email';
                                      return null;
                                    },
                                  ),

                                  // Passcode Field
                                  _buildLabel("Passcode"),
                                  _buildField(
                                    controller: adminpasscodecontroller,
                                    enabled: passcodeEnabled,
                                    icon: Icons.lock,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty)
                                        return 'Password Required!';
                                      if (value.trim().length <= 3)
                                        return "At least 4 numbers";
                                      return null;
                                    },
                                    inputType: TextInputType.visiblePassword,
                                    obscureText: controller.isPasswordVisible,
                                    onToggleVisibility:
                                        controller.togglePasswordVisibility,
                                  ),

                                  // Confirm Passcode Field
                                  _buildLabel("Confirm passcode"),
                                  _buildField(
                                    controller: adminconfirmpasscodecontroller,
                                    enabled: passcodeEnabled,
                                    icon: Icons.mobile_friendly,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Field required';
                                      if (value != adminpasscodecontroller.text)
                                        return 'Passwords do not match';
                                      return null;
                                    },
                                    inputType: TextInputType.visiblePassword,
                                    showEditButton: false,
                                    obscureText:
                                        controller.isConfirmPasswordVisible,
                                    onToggleVisibility: controller
                                        .toggleConfirmPasswordVisibility,
                                  ),
                                ],
                              ),
                            ),

                            // Update Button
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: 140,
                              height: 55,
                              decoration: BoxDecoration(
                                color: C.theamecolor,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(15),
                                  right: Radius.circular(15),
                                ),
                              ),
                              child: Obx(
                                () => TextButton(
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "UPDATE",
                                          style: TextStyle(
                                            color: C.textfromcolor,
                                            fontFamily: "mogra",
                                            fontSize: 29,
                                          ),
                                        ),
                                  onPressed: () {
                                    if (controller.isLoading.value) return;

                                    if (formkey.currentState!.validate()) {
                                      // Check if passcode is modified
                                      if (adminpasscodecontroller.text !=
                                          admin.passcode) {
                                        _showCurrentPasswordDialog(
                                          context,
                                          adminnamecontroller.text,
                                          adminphonecontroller.text,
                                          adminemailcontroller.text,
                                          adminpasscodecontroller.text,
                                        );
                                      } else {
                                        // Passcode unchanged, proceed directly
                                        controller.updateAdminProfile(
                                          name: adminnamecontroller.text,
                                          phone: adminphonecontroller.text,
                                          email: adminemailcontroller.text,
                                          passcode:
                                              adminpasscodecontroller.text,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bus Image Header
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: C.theamecolor, width: 5),
                            right: const BorderSide(),
                          ),
                          color: C.theamecolor,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "asset/image/bus48.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),

                      // Avatar
                      Positioned(
                        top: 120,
                        left: 130,
                        child: CircleAvatar(
                          backgroundColor: C.theamecolor,
                          radius: 65,
                          child: const CircleAvatar(
                            backgroundImage: AssetImage(
                              "asset/image/bus48.jpg",
                            ),
                            backgroundColor: Colors.black,
                            radius: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      margin: const EdgeInsets.only(
        right: 178,
      ), // Keeping original layout roughly
      width: 150, // Adjusted width
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required RxBool enabled,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType inputType = TextInputType.name,
    bool showEditButton = true,
    RxBool? obscureText,
    VoidCallback? onToggleVisibility,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          padding: const EdgeInsets.only(bottom: 5),
          child: Obx(
            () => TextFormField(
              enabled: enabled.value,
              // If obscureText is provided, use its value. Otherwise false.
              obscureText: obscureText?.value ?? false,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              controller: controller,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: inputType,
              decoration: InputDecoration(
                fillColor: const Color.fromARGB(0, 255, 255, 255),
                filled: true,
                prefixIcon: Icon(
                  icon,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                suffixIcon: onToggleVisibility != null
                    ? IconButton(
                        icon: Icon(
                          (obscureText?.value ?? false)
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: onToggleVisibility,
                      )
                    : null,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 255, 255),
                    width: 3,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 255, 255),
                    width: 3,
                  ),
                ),
                disabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 1),
                ),
              ),
            ),
          ),
        ),
        if (showEditButton)
          IconButton(
            onPressed: () {
              enabled.value = !enabled.value;
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          )
        else
          const SizedBox(width: 48), // Spacer to keep alignment
      ],
    );
  }

  void _showCurrentPasswordDialog(
    BuildContext context,
    String name,
    String phone,
    String email,
    String newPasscode,
  ) {
    TextEditingController currentPassController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Change"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter your CURRENT password to confirm changes."),
              const SizedBox(height: 10),
              TextField(
                controller: currentPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Current Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (currentPassController.text == admin.passcode) {
                  Navigator.pop(context); // Close Dialog
                  // Proceed with Update
                  controller.updateAdminProfile(
                    name: name,
                    phone: phone,
                    email: email,
                    passcode: newPasscode,
                  );
                } else {
                  Fluttertoast.showToast(msg: "Incorrect Current Password!");
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
