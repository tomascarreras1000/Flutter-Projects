import 'package:flutter/material.dart';
import 'package:project_2048/screens/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late SharedPreferences preferences;
  final double _fontSize = 30.0;
  int _size = 4;

  @override
  void initState() {
    super.initState();
    _getScreenSettingsFromPreferences();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getScreenSettingsFromPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  String _getStringFromSize(int size) {
    if (size == 3)
      return 'Small (3x3)';
    else if (size == 5)
      return 'Large (5x5)';
    else
      return 'Classic (4x4)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset('assets/4x4.png'),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: IconButton(
                      padding: const EdgeInsets.all(25),
                      color: Colors.white,
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      splashColor: Colors.white,
                      disabledColor: Colors.white,
                      highlightColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          if (_size == 4)
                            _size--;
                          else if (_size == 3)
                            _size = 5;
                          else
                            _size = 4;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_left,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      _getStringFromSize(_size),
                      style: TextStyle(fontSize: _fontSize * 1.20),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: IconButton(
                      padding: const EdgeInsets.all(25),
                      color: Colors.white,
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      splashColor: Colors.white,
                      disabledColor: Colors.white,
                      highlightColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          if (_size == 4)
                            _size = 5;
                          else if (_size == 5)
                            _size = 3;
                          else
                            _size = 4;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_right,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 25,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FloatingActionButton(
                        heroTag: 'StartGameButton',
                        backgroundColor: Colors.red[200],
                        child: Text(
                          'Start Game',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _fontSize,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => const GameScreen(),
                                  settings: RouteSettings(
                                    arguments: (_size),
                                  ),
                                ),
                              )
                              .then(
                                (_) {},
                              );
                        },
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: FloatingActionButton(
                        heroTag: 'HighScoresButton',
                        backgroundColor: Colors.red[200],
                        child: Text(
                          'High Scores',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _fontSize * 0.8,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
