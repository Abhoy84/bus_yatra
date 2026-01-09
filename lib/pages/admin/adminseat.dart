import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticketbooking/controller/app_controller.dart';
import 'package:ticketbooking/pages/common/color.dart';

class AdminSeatSelection extends StatelessWidget {
  final String busId;
  const AdminSeatSelection({super.key, required this.busId});

  @override
  Widget build(BuildContext context) {
    // Find the controller (it should be alive since we are in the app flow)
    final AppController controller = Get.find<AppController>();
    Color containerColor = const Color.fromARGB(255, 100, 102, 102);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.theamecolor,
        title: const Text('Manage Seat'),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              controller.inactiveSeats.clear();
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: containerColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Active",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Inactive",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Long Press on seat to toggle Active/Inactive",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Driver Icon
                    Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset("asset/image/driver.png", width: 40),
                    ),
                    const Divider(thickness: 2),
                    Expanded(
                      child: Obx(() {
                        final inactiveSet = controller.inactiveSeats.toSet();

                        return GridView.builder(
                          key: ValueKey(
                            inactiveSet.length,
                          ), // Force rebuild if set changes (redundant with Obx but safe)
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: controller.totalCols.value + 1,
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount:
                              controller.totalRows.value *
                              (controller.totalCols.value + 1),
                          itemBuilder: (context, index) {
                            bool isInactive = inactiveSet.contains(index);

                            return InkWell(
                              onLongPress: () =>
                                  controller.toggleSeatStatus(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: isInactive
                                      ? Colors.transparent
                                      : containerColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: isInactive
                                      ? Border.all(
                                          color: Colors.grey.withOpacity(0.3),
                                        )
                                      : null,
                                ),
                                child: isInactive
                                    ? const Icon(
                                        Icons.block,
                                        color: Colors.grey,
                                        size: 15,
                                      )
                                    : Image.asset(
                                        "asset/image/backseat.png",
                                        color: Colors.white,
                                      ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => controller.saveSeatLayout(context, busId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: C.theamecolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "UPDATE LAYOUT",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
