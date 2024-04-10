// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final items = FirebaseFirestore.instance.collection('items');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildErrorPage(String message) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoadingPage() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildMainPage(QuerySnapshot? snapshot) {
    final docs = snapshot?.docs;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'This will be the list:',
            style: TextStyle(fontSize: 20),
          ),
        ),
        backgroundColor: Colors.blue[900],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              child: Text(
                'Match List:',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              width: 400,
              height: 425,
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
              child: ListView.builder(
                itemCount: docs?.length,
                itemBuilder: (context, int index) {
                  final item = docs?[index];

                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            color: Colors.deepOrangeAccent[100],
                          ),
                          height: 150,
                          child: Text(
                            item?['Name'],
                            style: TextStyle(
                              fontSize: 50,
                              color: Color.fromARGB(255, 37, 187, 167),
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = FirebaseFirestore.instance.collection('items');
    return StreamBuilder(
      stream: items.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorPage(snapshot.error.toString());
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoadingPage();
          case ConnectionState.active:
            return _buildMainPage(snapshot.data);
          default: // ConnectionState.none // ConnectionState.done
            return _buildErrorPage("unreachable!!!");
        }
      },
    );
  }
}
