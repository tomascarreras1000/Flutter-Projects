import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'world_screen.dart';

class CharacterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CharacterState();
}

class CharacterState extends State<CharacterScreen> {
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
                        builder: (context) => MainScreen(),
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
              'Character\nSelection',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 400,
            height: 425,
            decoration: BoxDecoration(
              color: Colors.pink[200],
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WorldScreen(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              width: 148,
                              height: 148,
                              child: Image.asset('assets/malecharacter.png'),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(10),
                              width: 252,
                              height: 148,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(bottom: 5),
                                    width: 232,
                                    height: 64,
                                    child: Text(
                                      'James Bond',
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(top: 5),
                                    width: 232,
                                    height: 64,
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(right: 5),
                                          width: 116,
                                          height: 59,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                size: 37,
                                                color: Colors.redAccent[700],
                                              ),
                                              Icon(
                                                Icons.favorite,
                                                size: 37,
                                                color: Colors.redAccent[700],
                                              ),
                                              Icon(
                                                Icons.favorite_outline,
                                                size: 37,
                                                color: Colors.redAccent[700],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            backgroundBlendMode:
                                                BlendMode.color,
                                          ),
                                          alignment: Alignment.center,
                                          //padding: EdgeInsets.only(left: 5),
                                          width: 116,
                                          height: 59,
                                          child: Text(
                                            '22h:22m:22s',
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
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              _colorstar = !_colorstar;
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(3, 3, 0, 0),
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
                    ],
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
