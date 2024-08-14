import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:list_app/screens/settings_screen.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';

import 'new_item_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isDescend = true;
  String _orderedBy = "Abc";
  late SharedPreferences preferences;
  ScreenSettings _screenSettings = ScreenSettings(true, 20);

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

    bool? dMode = preferences.getBool('darkMode');
    double? fSize = preferences.getDouble('fontSize');

    if (dMode != null) _screenSettings.isDarkMode = dMode;
    if (fSize != null) _screenSettings.fontSize = fSize;
  }

  Widget _buildErrorPage(String message) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoadingPage() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String _dmyDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _weekdayString(int weekday) {
    String ret = '';

    switch (weekday) {
      case 1:
        {
          ret = 'Lunes';
        }
      case 2:
        {
          ret = 'Martes';
        }
      case 3:
        {
          ret = 'Miércoles';
        }
      case 4:
        {
          ret = 'Jueves';
        }
      case 5:
        {
          ret = 'Viernes';
        }
      case 6:
        {
          ret = 'Sábado';
        }
      case 7:
        {
          ret = 'Domingo';
        }
    }

    return ret;
  }

  Color _getColorFromDate(DateTime date) {
    Color ret = Colors.green;

    if (DateTime.now().subtract(const Duration(days: 5)).isAfter(date)) {
      ret = Colors.red;
    } else if (DateTime.now().subtract(const Duration(days: 3)).isAfter(date)) {
      ret = Colors.orange;
    }
    return ret;
  }

  Widget _buildMainPage(QuerySnapshot? snapshot) {
    final docs = snapshot?.docs;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              _screenSettings.isDarkMode ? Colors.black : Colors.white,
          title: PopupMenuButton(
            popUpAnimationStyle:
                AnimationStyle(duration: const Duration(milliseconds: 500)),
            color: _screenSettings.isDarkMode
                ? const Color.fromARGB(255, 78, 78, 78)
                : const Color.fromARGB(255, 251, 232, 255),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Abc',
                child: Text(
                  'Abc',
                  style: TextStyle(
                    fontSize: _screenSettings.fontSize,
                    color: _screenSettings.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'Fecha',
                child: Text(
                  'Fecha',
                  style: TextStyle(
                    fontSize: _screenSettings.fontSize,
                    color: _screenSettings.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
            initialValue: _orderedBy,
            onSelected: (value) {
              setState(() {
                if (_orderedBy == value) {
                  _isDescend = !_isDescend;
                } else {
                  _orderedBy = value;
                  _isDescend = false;
                }
              });
            },
            child: Row(
              children: [
                Text(
                  _orderedBy,
                  style: TextStyle(
                    fontSize: _screenSettings.fontSize,
                    color: _screenSettings.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Icon(
                  _isDescend ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color:
                      _screenSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              child: const Icon(Icons.settings),
              onTap: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                    settings: RouteSettings(
                      arguments: (_screenSettings),
                    ),
                  ),
                )
                    .then(
                  (item) {
                    setState(() {
                      if (item != null) {
                        _screenSettings = item;
                        preferences.setBool(
                            'darkMode', _screenSettings.isDarkMode);
                        preferences.setDouble(
                            'fontSize', _screenSettings.fontSize);
                      }
                      ;
                    });
                  },
                );
              },
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        backgroundColor: _screenSettings.isDarkMode
            ? Colors.black
            : const Color.fromARGB(255, 236, 236, 236),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: ListView.builder(
            itemCount: docs!.length + 1,
            itemBuilder: (context, int index) {
              if (index == docs.length) {
                return const SizedBox(height: 70);
              }
              final item = docs[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: _screenSettings.isDarkMode
                          ? const Color.fromARGB(255, 40, 40, 40)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['Name'],
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: _screenSettings.fontSize,
                                  color: _screenSettings.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              'De ${timeago.format(item['From'].toDate(), locale: 'es', allowFromNow: true)}',
                              style: TextStyle(
                                fontSize: _screenSettings.fontSize,
                                color: _getColorFromDate(item['From'].toDate()),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('asd'),
                            Text(
                              'Del ${_weekdayString(item['From'].toDate().weekday)} ${_dmyDate(item['From'].toDate())}',
                              style: TextStyle(
                                fontSize: _screenSettings.fontSize,
                                color: _screenSettings.isDarkMode
                                    ? Colors.white
                                    : const Color.fromARGB(255, 137, 137, 137),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => const NewItemScreen(),
                    settings: RouteSettings(
                      arguments: _screenSettings,
                    ),
                  ),
                )
                .then(
                  (item) => {
                    if (item[0].toString().isNotEmpty)
                      {
                        FirebaseFirestore.instance.collection('items').add(
                          {
                            'Name': item[0],
                            'From': item[1],
                            'Deadline': item[2]
                          },
                        )
                      }
                  },
                );
          },
          child: const Icon(Icons.note_add),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var items = FirebaseFirestore.instance
        .collection('items')
        .orderBy('From', descending: _isDescend);
    if (_orderedBy == 'Abc') {
      items = FirebaseFirestore.instance
          .collection('items')
          .orderBy('Name', descending: _isDescend);
    } else if (_orderedBy == 'Fecha') {
      items = FirebaseFirestore.instance
          .collection('items')
          .orderBy('From', descending: _isDescend);
    }

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
