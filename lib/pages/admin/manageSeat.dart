import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketbooking/pages/common/color.dart';
import 'package:ticketbooking/pages/common/loadingdialoge.dart';

class manageSeat extends StatefulWidget {
  const manageSeat({super.key});

  @override
  State<manageSeat> createState() => _manageSeatState();
}

class _manageSeatState extends State<manageSeat> {
  // State Variables
  int totalCapacity = 0; // Fetched from admin profile
  int seatsRemaining = 0;

  // Storage for layout: Index -> SeatLabel (e.g., 5 -> "1A")
  Map<int, String> placedSeats = {};

  // Bus Grid Dimensions
  int gridRows = 15;
  int gridCols = 5; // Default for 2+2
  String layoutType = "2+2"; // "2+2" or "2+3"

  bool isLoading = true;
  String? busId;

  @override
  void initState() {
    super.initState();
    _fetchBusDetails();
  }

  Future<void> _fetchBusDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        busId = user.uid;
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('buses')
            .doc(busId)
            .get();

        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          setState(() {
            // Parse seat capacity
            // Handle both string and int just in case
            var seatNoData = data['seatno'];
            if (seatNoData is String) {
              totalCapacity = int.tryParse(seatNoData) ?? 40;
            } else if (seatNoData is int) {
              totalCapacity = seatNoData;
            } else {
              totalCapacity = 40; // Default
            }

            // Load layout type
            if (data.containsKey('layout_type')) {
              layoutType = data['layout_type'];
              if (layoutType == "2+3") {
                gridCols = 6;
              } else {
                gridCols = 5;
              }
            }

            // Load existing layout if present
            if (data.containsKey('layout_map')) {
              Map<String, dynamic> rawMap = data['layout_map'];
              placedSeats = rawMap.map(
                (key, value) => MapEntry(int.parse(key), value.toString()),
              );
            }

            seatsRemaining = totalCapacity - placedSeats.length;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // --- Logic Helpers ---

  void _onSeatDropped(int index, {String? label}) {
    if (placedSeats.containsKey(index)) return; // Already occupied
    if (seatsRemaining <= 0) {
      Fluttertoast.showToast(msg: "Max capacity reached!");
      return;
    }

    setState(() {
      // Default label if none provided: just a number based on current count + 1
      // Or we can try to be smart, but simple is better for now.
      String newLabel = label ?? (placedSeats.length + 1).toString();
      placedSeats[index] = newLabel;
      seatsRemaining--;
    });
  }

  void _removeSeat(int index) {
    if (placedSeats.containsKey(index)) {
      setState(() {
        placedSeats.remove(index);
        seatsRemaining++;
      });
    }
  }

  Future<void> _editSeatLabel(int index) async {
    TextEditingController labelController = TextEditingController(
      text: placedSeats[index],
    );
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Seat Number"),
        content: TextField(
          controller: labelController,
          decoration: const InputDecoration(hintText: "e.g., 1A, L1"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _removeSeat(index); // Option to remove
              Navigator.pop(context);
            },
            child: const Text(
              "Remove Seat",
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String newText = labelController.text.trim();
              if (newText.isNotEmpty) {
                setState(() {
                  placedSeats[index] = newText;

                  // Smart Renumbering Logic
                  int? startNum = int.tryParse(newText);
                  if (startNum != null) {
                    // It is a number, so we try to sequence subsequent seats
                    // 1. Get all occupied indices sorted (visual order)
                    List<int> sortedIndices = placedSeats.keys.toList()..sort();

                    // 2. Find where the current seat is in this list
                    int currentIndexPos = sortedIndices.indexOf(index);

                    // 3. Iterate through subsequent seats and update their numbers
                    if (currentIndexPos != -1 &&
                        currentIndexPos < sortedIndices.length - 1) {
                      int currentNum = startNum;
                      for (
                        int i = currentIndexPos + 1;
                        i < sortedIndices.length;
                        i++
                      ) {
                        int nextIndex = sortedIndices[i];
                        currentNum++;
                        placedSeats[nextIndex] = currentNum.toString();
                      }
                    }
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _editCapacity() async {
    TextEditingController capController = TextEditingController(
      text: totalCapacity.toString(),
    );
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Total Capacity"),
        content: TextField(
          controller: capController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Enter total seats"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              int? newCap = int.tryParse(capController.text.trim());
              if (newCap != null && newCap > 0) {
                setState(() {
                  if (newCap < placedSeats.length) {
                    // Trimming Logic: Remove keys with the highest values (last seats)
                    int seatsToRemove = placedSeats.length - newCap;
                    List<int> sortedKeys = placedSeats.keys.toList()
                      ..sort((a, b) => b.compareTo(a)); // Descending

                    for (int i = 0; i < seatsToRemove; i++) {
                      placedSeats.remove(sortedKeys[i]);
                    }

                    Fluttertoast.showToast(
                      msg: "Removed $seatsToRemove excess seats from layout",
                    );
                  }

                  totalCapacity = newCap;
                  seatsRemaining = totalCapacity - placedSeats.length;
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveLayout() async {
    if (busId == null) return;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) => const LoadingDialog(),
    );

    try {
      // Convert int keys to String for Firestore Map compatibility
      Map<String, String> saveMap = placedSeats.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      await FirebaseFirestore.instance.collection('buses').doc(busId).update({
        'layout_map': saveMap,
        'layout_type': layoutType,
        'seatno': totalCapacity,
      });

      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Layout Saved Successfully!");
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Save Failed: $e");
    }
  }

  // --- UI Widgets ---

  Widget _buildLayoutSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Bus Layout:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: layoutType,
            items: const [
              DropdownMenuItem(value: "2+2", child: Text("2+2 (Standard)")),
              DropdownMenuItem(value: "2+3", child: Text("2+3 (Heavier)")),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  layoutType = val;
                  if (layoutType == "2+2") {
                    gridCols = 5;
                  } else {
                    gridCols = 6;
                  }
                  // Optional: Clear seats if layout changes to avoid corruption
                  // placedSeats.clear();
                  // seatsRemaining = totalCapacity;
                  // For now, preservation is safer, though visuals shift.
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSeatPool() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Seat Pool",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.confirmation_number,
                size: 24,
                color: Colors.black54,
              ),
              const SizedBox(width: 5),
              Text(
                "Total: $totalCapacity",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: _editCapacity,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_seat, size: 32, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Text(
                "Remaining: $seatsRemaining",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Drag seat to the grid below",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          // Draggable Source
          Draggable<String>(
            data: "new_seat",
            feedback: const Material(
              color: Colors.transparent,
              child: Icon(Icons.event_seat, size: 40, color: Colors.blue),
            ),
            childWhenDragging: const Icon(
              Icons.event_seat,
              size: 40,
              color: Colors.grey,
            ),
            child: const Icon(
              Icons.event_seat,
              size: 40,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: Colors.grey.shade200,
        border: Border.all(color: Colors.black45, width: 2),
        borderRadius: BorderRadius.circular(30), // Bus shape
      ),
      child: Column(
        children: [
          // Steering Wheel Area
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 20.0, bottom: 20),
                child: Icon(Icons.trip_origin, size: 30, color: Colors.black54),
              ), // Steering wheel approx
            ],
          ),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCols,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: gridRows * gridCols,
            itemBuilder: (context, index) {
              int rowIndex = index ~/ gridCols;
              int colIndex = index % gridCols;

              // Aisle Logic: Middle column (2) is aisle, unless it's the last row
              bool isAisle = (colIndex == 2) && (rowIndex != gridRows - 1);

              // Only hide aisle if it's NOT occupied by ghost data
              if (isAisle && !placedSeats.containsKey(index)) {
                return Container(
                  decoration: BoxDecoration(
                    // color: Colors.grey.withOpacity(0.1), // Optional: aisle visual
                    border: Border.all(color: Colors.transparent),
                  ),
                );
              }

              bool isOccupied = placedSeats.containsKey(index);

              return DragTarget<String>(
                onWillAccept: (data) => !isOccupied && seatsRemaining > 0,
                onAccept: (data) {
                  // data could be "new_seat" or moved seat logic if we implement move
                  _onSeatDropped(index);
                },
                builder: (context, candidateData, rejectedData) {
                  if (isOccupied) {
                    return InkWell(
                      onTap: () => _editSeatLabel(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Center(
                          child: Text(
                            placedSeats[index]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        color: candidateData.isNotEmpty
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seat Layout Editor"),
        backgroundColor: C.theamecolor,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveLayout),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildLayoutSelector(),
                _buildSeatPool(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildBusGrid(),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: C.theamecolor,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _saveLayout,
                            child: const Text(
                              "SAVE LAYOUT",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
