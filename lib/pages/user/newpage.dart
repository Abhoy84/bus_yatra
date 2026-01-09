import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ticketbooking/models/Example2.dart';
import 'package:ticketbooking/pages/user/detailspage.dart';

class newpage extends StatefulWidget {
  const newpage({super.key});

  @override
  State<newpage> createState() => newpageState();
}

class newpageState extends State<newpage> {
  static String? id;
  List<Example2> demo = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("data"), centerTitle: true),
      body: FutureBuilder(
        future: getdata(),
        builder: (BuildContext cntext, AsyncSnapshot data) {
          if (data.hasData) {
            return ListView.builder(
              itemCount: demo.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    print(demo.length);
                    id = demo[index].id.toString();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const detailspage(),
                      ),
                    );
                  },
                  child: Container(
                    child: Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text("id:${demo[index].id}"),
                          const SizedBox(height: 10),
                          Text("id:${demo[index].title}"),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<Example2>> getdata() async {
    var respond = await http.get(
      Uri.parse("https://fakestoreapi.com/products"),
    );
    var result = jsonDecode(respond.body.toString());
    if (respond.statusCode == 200) {
      demo.clear();
      for (Map<String, dynamic> index in result) {
        demo.add(Example2.fromJson(index));
      }
      return demo;
    } else {
      return demo;
    }
  }
}
