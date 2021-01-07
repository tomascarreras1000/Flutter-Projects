import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:structure_delivery02/screens/character_screen.dart';

class WorldScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WorldState();
}

class WorldState extends State<WorldScreen> {
  bool _colorstar;

  @override
  void initState() {
    super.initState();
    _colorstar = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CharacterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Trash',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '  World  \nSelection',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
              bottom: 30,
            ),
            width: 400,
            height: 425,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(10),
                          width: 400,
                          height: 148,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(
                                        () {
                                          _colorstar = !_colorstar;
                                        },
                                      );
                                    },
                                    child: Container(
                                      child: Stack(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 35,
                                            color: (_colorstar
                                                ? Colors.yellowAccent
                                                : Colors.grey),
                                          ),
                                          Icon(
                                            Icons.star_border,
                                            size: 36,
                                            color: Colors.black,
                                            // color: (_colorstar
                                            //     ? Colors.grey
                                            //     : Colors.yellowAccent),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 10),
                                    width: 334,
                                    height: 59,
                                    child: Text(
                                      'London',
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 380,
                                height: 59,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                      ),
                                      alignment: Alignment.center,
                                      width: 120,
                                      height: 59,
                                      child: Center(
                                        child: Text(
                                          'Expert',
                                          style: TextStyle(
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                      ),
                                      alignment: Alignment.center,
                                      width: 120,
                                      height: 59,
                                      child: Center(
                                        child: Text(
                                          'Large',
                                          style: TextStyle(
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                      ),
                                      alignment: Alignment.center,
                                      width: 120,
                                      height: 59,
                                      child: Text(
                                        '05/02/2020',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'New',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
