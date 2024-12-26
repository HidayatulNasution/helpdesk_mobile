import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend_helpdesk/constants/Theme.dart';
// import api service untuk panggil logic
import '../constants/api_service.dart';
//widgets
import 'package:frontend_helpdesk/widgets/navbar.dart';
import 'package:frontend_helpdesk/widgets/drawer.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _apiService = ApiService();
  List<dynamic> _profile = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      final profile = await _apiService.getProfile();
      setState(() {
        _profile = profile;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          title: "Profile",
          transparent: true,
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: ArgonDrawer(currentPage: "Profile"),
        body: Stack(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage("assets/img/profile-screen-bg.png"),
                      fit: BoxFit.fitWidth))),
          SafeArea(
              child: ListView.builder(
            itemCount: _profile.length,
            itemBuilder: (context, index) {
              final profile = _profile[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: .0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 100, bottom: 30.0),
                              child: Column(
                                children: [
                                  Align(
                                    child: Text(
                                      profile['username'],
                                      style: TextStyle(
                                        color: Color.fromRGBO(50, 50, 93, 1),
                                        fontSize: 28.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Align(
                                    child: Text(
                                      profile['email'],
                                      style: TextStyle(
                                        color: Color.fromRGBO(50, 50, 93, 1),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 40.0,
                                    thickness: 1.5,
                                    indent: 32.0,
                                    endIndent: 32.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: Align(
                                      child: Text(
                                        "${profile['address'] ?? 'Address Kosong'}, ${profile['city'] ?? ''}, ${profile['country'] ?? ''}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color.fromRGBO(82, 95, 127, 1),
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40.0),
                                  Align(
                                    child: Text(
                                      "${profile['about'] ?? 'About Kosong'}",
                                      style: TextStyle(
                                        color: ArgonColors.primary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 25.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FractionalTranslation(
                          translation: Offset(0.0, -0.5),
                          child: Align(
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/img/42.png",
                              ),
                              radius: 65.0,
                            ),
                            alignment: FractionalOffset(0.5, 0.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ))
        ]));
  }
}
