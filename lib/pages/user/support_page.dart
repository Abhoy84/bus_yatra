import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketbooking/pages/common/color.dart';
import 'package:ticketbooking/pages/common/loadingdialoge.dart';
import 'package:ticketbooking/services/notification_service.dart';
import 'package:ticketbooking/pages/user/bookedTicketlist.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedIssue = 'General Inquiry';
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  final List<String> _issueTypes = [
    'General Inquiry',
    'Booking Issue',
    'Cancellation & Refund',
    'Payment Problem',
    'Technical Support',
    'Other',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitSupportRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Fluttertoast.showToast(msg: "You must be logged in to send a message.");
        return;
      }

      await FirebaseFirestore.instance.collection('support_requests').add({
        'userId': user.uid,
        'userEmail': user.email,
        'issueType': _selectedIssue,
        'message': _messageController.text.trim(),
        'status': 'open',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 1. Local Notification
      await NotificationService().showLocalNotification(
        "Support Request Received",
        "We have received your message regarding '$_selectedIssue'. Our team will contact you shortly.",
      );

      // 2. In-App Notification (Firestore)
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': user.uid,
        'title': "Support Request Received",
        'body':
            "We have received your message regarding '$_selectedIssue'. Our team will contact you shortly.",
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      _messageController.clear();
      setState(() => _selectedIssue = 'General Inquiry');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Request Sent"),
          content: const Text(
            "We have received your message. Our support team will contact you shortly.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to send message: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: C.theamecolor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildFAQTile(
              "How do I reset my password?",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "You can reset your password by logging out and clicking on 'Forgot Password' on the login screen.",
                  ),
                ],
              ),
            ),
            _buildFAQTile(
              "How can I cancel my ticket?",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To cancel a ticket, go to your 'Booked Tickets' list, select the ticket you want to cancel, and click the 'Cancel Booking' button.",
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const bookedticketlist(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: C.theamecolor,
                    ),
                    child: const Text(
                      "Go to Booked Tickets",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            _buildFAQTile(
              "How to book a bus ticket?",
              const Text(
                "1. On the Home screen, enter your Source and Destination.\n"
                "2. Select a Date and search for buses.\n"
                "3. Choose a bus and select your preferred seats.\n"
                "4. Enter passenger details and proceed to payment.\n"
                "5. Once paid, your ticket will be generated instantly.",
              ),
            ),
            _buildFAQTile(
              "Can I change my seat after booking?",
              const Text(
                "Currently, seat changes are not supported after booking. You would need to cancel the current ticket and book a new one.",
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              "Contact Us",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Need more help? Send us a message.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedIssue,
                    decoration: InputDecoration(
                      labelText: "Issue Type",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: _issueTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedIssue = val!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Describe your issue",
                      hintText: "Please provide as much detail as possible...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty)
                        return "Please enter a message";
                      if (val.trim().length < 10) return "Message is too short";
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitSupportRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: C.theamecolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const LoadingDialog()
                          : const Text(
                              "Submit Request",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, Widget answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(alignment: Alignment.centerLeft, child: answer),
          ),
        ],
      ),
    );
  }
}
