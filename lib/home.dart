import 'dart:convert';

import 'package:adviceMe/model/advice.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;

var uri = Uri.parse('https://api.adviceslip.com/advice');
final String assetName = 'images/advice.svg';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Widget svg = SvgPicture.asset(assetName, semanticsLabel: 'Acme Logo');
  Future<Advice> advice;
  @override
  void initState() {
    super.initState();
    advice = fetchAdvice();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: svg,
                  height: 200,
                  width: 200,
                ),
              ),
              Text(
                'Free Advice for you',
                style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
              ),
              SizedBox(
                height: 25,
              ),
              FutureBuilder<Advice>(
                future: advice,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        elevation: 10,
                        color: Colors.teal,
                        child: ListTile(
                          tileColor: Colors.white,
                          title: Text(
                              snapshot.data.slip.advice ?? 'default value',
                              style: GoogleFonts.lato(fontSize: 25)),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    });
                  },
                  child: Text("Refresh"))
            ],
          ),
        ),
      ),
    );
  }
}

Future<Advice> fetchAdvice() async {
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print(data);
    print(data['slip']['id']);

    return Advice.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Advice');
  }
}
