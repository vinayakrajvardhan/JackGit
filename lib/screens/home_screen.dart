import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jakeworthrestapi/models/gits_data.dart';
import 'package:http/http.dart' as http;
import 'package:jakeworthrestapi/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GitsData> gitList = [];

  Future<List<GitsData>> getApi() async {
    var url =
        "https://api.github.com/users/JakeWharton/repos?page=1&per_page=15";
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (var element in data) {
        gitList.add(GitsData.fromJson(element));
      }
      return gitList;
    }
    return gitList;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut().whenComplete(
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    ),
                  );
            },
            icon: Icon(
              Icons.logout_outlined,
              size: 30,
            ),
          )
        ],
        title: const Text(
          "Jake's Git",
          style: TextStyle(
            letterSpacing: 2.0,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                    future: getApi(),
                    builder: (context, AsyncSnapshot<List<GitsData>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepOrange,
                          ),
                        );
                      } else {
                        return ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                                  thickness: 3.0,
                                ),
                            itemCount: gitList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: size.height / 7,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.book,
                                          size: 80,
                                          color: Colors.black,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                gitList[index]
                                                    .language
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                gitList[index]
                                                    .description
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.arrow_back_ios,
                                                    size: 16,
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    gitList[index]
                                                        .language
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(Icons.ac_unit, size: 16),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    gitList[index]
                                                        .stargazersCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(Icons.person, size: 16),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    gitList[index]
                                                        .forksCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
