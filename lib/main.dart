import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newton/models/tournament_group.dart';

import 'models/tournament.dart';
import 'stream_socket.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List> futureData;
  final List loadedTournamentGroups = [];

  Future<List> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://test-micros1.play-online.com/missions/tournaments/list?tenant_id=2'));

    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);

      return jsonresponse;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B151F),
      body: StreamBuilder(
        stream: streamSocket.getResponse,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data != null) {
            futureData = fetchData();
          }
          return FutureBuilder<List>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var tournaments = snapshot.data;
                var noOfTournaments = snapshot.data!.length;

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      itemCount: noOfTournaments,
                      itemBuilder: (BuildContext ctx, index) {
                        return (TournamentGroup.fromJson(tournaments![index])
                                .tournaments
                                .isNotEmpty)
                            ? Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.40,
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 20,
                                            color: Color(0x33000000),
                                            offset: Offset(-10, 10),
                                          )
                                        ],
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF152232),
                                            Color(0xFF2B1850)
                                          ],
                                          stops: [0, 1],
                                          begin: AlignmentDirectional(0, -1),
                                          end: AlignmentDirectional(0, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: const Color(0xFF364152),
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                              TournamentGroup.fromJson(
                                                      tournaments[index])
                                                  .name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: List.generate(
                                                  TournamentGroup.fromJson(
                                                          tournaments[index])
                                                      .tournaments
                                                      .length, (rowIndex) {
                                                var tournamentResponse =
                                                    TournamentGroup.fromJson(
                                                            tournaments[index])
                                                        .tournaments[rowIndex];

                                                var tournament =
                                                    Tournament.fromJson(
                                                        tournamentResponse);

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          tournament.name,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                      Image.network(
                                                        tournament.photoUrl,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      (tournament.enrolled)
                                                          ? Container(
                                                              width: 80,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border:
                                                                    Border.all(
                                                                  color: const Color(
                                                                      0xFF364152),
                                                                ),
                                                              ),
                                                              child: const Text(
                                                                  'Preview',
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF364152))),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                width: 80,
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white),
                                                                  color: const Color(
                                                                      0xFF152232),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                alignment:
                                                                    const AlignmentDirectional(
                                                                        0, 0),
                                                                child:
                                                                    const Text(
                                                                  'Enroll',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                );
                                              })),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 20,
                                                  color: Color(0x33000000),
                                                  offset: Offset(-10, 10),
                                                )
                                              ],
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF152232),
                                                  Color(0xFF2B1850)
                                                ],
                                                stops: [0, 1],
                                                begin:
                                                    AlignmentDirectional(0, -1),
                                                end: AlignmentDirectional(0, 1),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              border: Border.all(
                                                color: const Color(0xFF364152),
                                                width: 2,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Text(
                                                    TournamentGroup.fromJson(
                                                            tournaments[index])
                                                        .name,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Image.asset(
                                                  'assets/flash.png',
                                                  width: 80,
                                                )
                                              ],
                                            )))
                                  ]);
                      }),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          );
        },
      ),
    );
  }
}
