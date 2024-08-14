import 'package:flutter/material.dart';

class ScreenSettings {
  late bool isDarkMode;
  late double fontSize;

  ScreenSettings(this.isDarkMode, this.fontSize);
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final ScreenSettings _screenSettings =
      ModalRoute.of(context)!.settings.arguments as ScreenSettings;
  late bool _isDarkMode = _screenSettings.isDarkMode;
  late double _fontSize = _screenSettings.fontSize;

  @override
  void initState() {
    super.initState();
  }

  Widget _selectionIconBuilder(bool isSelected) {
    if (isSelected) {
      return const Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.circle_outlined,
            size: 25,
          ),
          Icon(
            Icons.circle,
            size: 15,
          ),
        ],
      );
    }
    return const Icon(
      Icons.circle_outlined,
      size: 25,
    );
  }

  String _getTextFromFontSize(double size) {
    if (size == 15.0)
      return "Pequeño";
    else if (size == 20.0)
      return "Mediano";
    else if (size == 25.0)
      return "Grande";
    else
      return "Error";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: _isDarkMode
              ? const Color.fromARGB(255, 40, 40, 40)
              : Colors.white,
          title: Text(
            'Ajustes',
            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        backgroundColor: _isDarkMode
            ? Colors.black
            : const Color.fromARGB(255, 236, 236, 236),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
              child: Container(
                decoration: const BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 75,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: TextStyle(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                                color:
                                    _isDarkMode ? Colors.white : Colors.black),
                            'Tema'),
                        Text(
                            style: TextStyle(
                                fontSize: _fontSize * 0.80,
                                fontWeight: FontWeight.w300,
                                color:
                                    _isDarkMode ? Colors.white : Colors.black),
                            'Modo Noche'),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Spacer(),
                    Switch(
                      value: _isDarkMode,
                      onChanged: (Null) => setState(() {
                        _isDarkMode = !_isDarkMode;
                      }),
                    ),
                    const SizedBox(
                      width: 75,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => AlertDialog(
                    title: const Text('Tamaño de fuente'),
                    actions: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(15.0);
                            },
                            child: Container(
                              decoration: const BoxDecoration(),
                              child: Row(
                                children: [
                                  _selectionIconBuilder(_fontSize == 15.0),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    style: TextStyle(
                                        fontSize: _fontSize * 0.80,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                    'Pequeño',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(20.0);
                            },
                            child: Container(
                              decoration: const BoxDecoration(),
                              child: Row(
                                children: [
                                  _selectionIconBuilder(_fontSize == 20.0),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    style: TextStyle(
                                        fontSize: _fontSize * 0.80,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                    "Mediano",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(25.0);
                            },
                            child: Container(
                              decoration: const BoxDecoration(),
                              child: Row(
                                children: [
                                  _selectionIconBuilder(_fontSize == 25.0),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    style: TextStyle(
                                        fontSize: _fontSize * 0.80,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                    'Grande',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).then(
                  (value) => {
                    if (value != null)
                      {
                        setState(
                          () {
                            _fontSize = value;
                          },
                        )
                      }
                  },
                );
              },
              child: Container(
                decoration:
                    const BoxDecoration(), //This empty decoration makes the GestureDetection take it all into consideration, not just the filled parts
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 75,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: TextStyle(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                                color:
                                    _isDarkMode ? Colors.white : Colors.black),
                            'Tamaño de fuente'),
                        Text(
                            style: TextStyle(
                                fontSize: _fontSize * 0.80,
                                fontWeight: FontWeight.w300,
                                color:
                                    _isDarkMode ? Colors.white : Colors.black),
                            _getTextFromFontSize(_fontSize)),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 75,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_screenSettings);
                  },
                  child: const Text('Cancelar'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(ScreenSettings(_isDarkMode, _fontSize));
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
