import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ticketbooking/models/Example2.dart';
import 'package:ticketbooking/pages/user/newpage.dart';

class detailspage extends StatefulWidget {
  const detailspage({super.key});

  @override
  State<detailspage> createState() => detailspageState();
}

class detailspageState extends State<detailspage> {
  bool isVerified = false;
  List<Example2> demo = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alldata"), centerTitle: true),
      body: FutureBuilder(
        future: getalldata(newpageState.id!),
        builder: (BuildContext cntext, AsyncSnapshot data) {
          if (data.hasData) {
            return ListView.builder(
              itemCount: demo.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {},
                  child: demo[index].id.toString() == newpageState.id
                      ? Container(
                          child: Card(
                            elevation: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    demo[index].image,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text("id:${demo[index].id}"),
                                const SizedBox(height: 10),
                                Text("id:${demo[index].title}"),
                                const SizedBox(height: 10),
                                Text("id:${demo[index].price}"),
                                const SizedBox(height: 10),
                                Text("id:${demo[index].description}"),
                                const SizedBox(height: 10),
                                Text("id:${demo[index].category}"),
                                const SizedBox(height: 10),
                                Text(
                                  "id:${demo[index].rating.rate}/${demo[index].rating.count}",
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(height: 1),
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

  Future<List<Example2>> getalldata(String uid) async {
    var respond = await http.get(
      Uri.parse("https://fakestoreapi.com/products/"),
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
