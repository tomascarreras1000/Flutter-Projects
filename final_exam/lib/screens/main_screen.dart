import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'new_order_screen.dart';

class Table {
  final int number;
  final int state;
  final String order;

  Table({@required this.number, @required this.state, this.order});
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final tables = FirebaseFirestore.instance.collection('tables');

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

  Widget _buildMainScreenPage(QuerySnapshot snapshot) {
    final docs = snapshot.docs;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Testing'),
        ),
        backgroundColor: Colors.deepPurple[50],
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, int index) {
              final item = docs[index];
              return Container(
                child: Column(
                  children: [
                    Container(
                      width: 340,
                      height: 140,
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple[200],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Table number: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item['number'].toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (item['state'] == 1) {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewOrderScreen(),
                                          ),
                                        )
                                        .then(
                                          (order) => {
                                            if (order.toString().isNotEmpty)
                                              item.reference.update(
                                                {'order': order, 'state': 2},
                                              )
                                            else
                                              item.reference.update(
                                                {'order': '', 'state': 1},
                                              )
                                          },
                                        );
                                  }
                                },
                                child: Container(
                                  //Add order button
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (item['state'] == 1
                                            ? Colors.purple[300]
                                            : Colors.grey),
                                        border: Border(
                                          top: BorderSide(width: 2),
                                          bottom: BorderSide(width: 2),
                                          right: BorderSide(width: 2),
                                          left: BorderSide(width: 2),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.note_add,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'State: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (item['state'] == 1)
                                    Text(
                                      'Empty',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  if (item['state'] == 2)
                                    Text(
                                      'Served',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  if (item['state'] == 3)
                                    Text(
                                      'Awaiting bill',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (item['state'] == 2) {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewOrderScreen(),
                                          ),
                                        )
                                        .then(
                                          (order) => {
                                            if (order.toString().isEmpty)
                                              item.reference.update(
                                                  {}) //doesn't change if order isn't changed
                                            else
                                              item.reference.update(
                                                {'order': order, 'state': 2},
                                              )
                                          },
                                        );
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (item['state'] == 2
                                            ? Colors.purple[300]
                                            : Colors.grey),
                                        border: Border(
                                          top: BorderSide(width: 2),
                                          bottom: BorderSide(width: 2),
                                          right: BorderSide(width: 2),
                                          left: BorderSide(width: 2),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Order: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (item['state'] != 1)
                                    Text(
                                      item['order'],
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (item['state'] == 2) {
                                    item.reference.update(
                                      {'state': 3},
                                    );
                                  } else if (item['state'] == 3) {
                                    item.reference.update(
                                      {'state': 1, 'order': ''},
                                    );
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (item['state'] == 1
                                            ? Colors.grey
                                            : Colors.purple[300]),
                                        border: Border(
                                          top: BorderSide(width: 2),
                                          bottom: BorderSide(width: 2),
                                          right: BorderSide(width: 2),
                                          left: BorderSide(width: 2),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.done,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Change this in exam
    final tables = FirebaseFirestore.instance.collection('tables');
    return StreamBuilder(
      stream: tables.orderBy('number').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorPage(snapshot.error.toString());
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoadingPage();
          case ConnectionState.active:
            return _buildMainScreenPage(snapshot.data);
          default: // ConnectionState.none // ConnectionState.done
            return _buildErrorPage("unreachable!!!");
        }
      },
    );
  }
}
