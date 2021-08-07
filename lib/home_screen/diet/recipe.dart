import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// import '../../splash_screen.dart';
// import 'package:fluttersns/splash_screen.dart';

class Recipe extends StatefulWidget {
  final String name;
  Recipe({Key key, @required this.name}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new _RecipeState();
}

class _RecipeState extends State<Recipe> {
  Directory appDocDir;
  @override
  void initState() {
    getImage(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference recipe =
        FirebaseFirestore.instance.collection('Recipe');

    return Container(
        child: FutureBuilder<DocumentSnapshot>(
            future: recipe.doc(widget.name).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data.data();

                return Scaffold(
                    body: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.jpg'),
                          fit: BoxFit.cover,
                          alignment: Alignment.center)),
                  child: CustomScrollView(slivers: [
                    SliverAppBar(
                      expandedHeight: 250.0,
                      floating: true,
                      pinned: true,
                      snap: false,
                      iconTheme: IconThemeData(
                        color: Colors.white, //change your color here
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Hero(
                              tag: 'recipe_name${data['Name']}',
                              child: Text(
                                data['Name'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          background: Hero(
                              tag: 'recipe${data['Name']}.jpg',
                              child: Column(
                                children: [
                                  if (File(
                                          '${appDocDir.path}/${data['Name']}.jpg')
                                      .existsSync())
                                    Image.file(
                                      new File(
                                          '${appDocDir.path}/${data['Name']}.jpg'),
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      colorBlendMode: BlendMode.darken,
                                      fit: BoxFit.cover,
                                    )
                                  else
                                    Image.asset(
                                      'assets/images/logo.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                ],
                              ))),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Ingredients : ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[900]),
                                  ),
                                ),
                                for (var ing
                                    in data['Ingredients'].keys.toList()
                                      ..sort())
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(18, 5, 5, 5),
                                    child: Row(children: [
                                      Text('•  '),
                                      Flexible(
                                        child: Text(
                                          ing + "  :  ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Text(
                                        data['Ingredients'][ing],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ]),
                                  ),
                                Divider(
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Method : ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[900]),
                                  ),
                                ),
                                for (var method in data['Method'].split('.'))
                                  if (method != '')
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 8.0, 20.0, 8.0),
                                        child: Row(
                                          children: [
                                            new Text('-   '),
                                            Flexible(
                                              child: new Text(
                                                method,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        )),
                              ]),
                        ),
                      ),
                    ),
                  ]),
                ));
              }
              return Container();
            }));
  }

  Future<void> getImage(name) async {
    appDocDir = await getApplicationDocumentsDirectory();
  }
}
