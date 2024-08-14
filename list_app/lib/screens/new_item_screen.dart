import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:list_app/screens/settings_screen.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  late TextEditingController _textNameController;
  late TextEditingController _textDateController;
  late TextEditingController _textDateLimitController;
  DateTime _dateTime = DateTime.now();
  late ScreenSettings screenSettings =
      ModalRoute.of(context)!.settings.arguments as ScreenSettings;

  @override
  void initState() {
    _textNameController = TextEditingController();
    _textDateController = TextEditingController();
    _textDateLimitController = TextEditingController();
    _textDateController.text =
        '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}';
    super.initState();
  }

  void _showDatePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateTime = value;
          controller.text = _dmyDate(_dateTime);
        });
      }
    });
  }

  String _dmyDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: screenSettings.isDarkMode
              ? const Color.fromARGB(255, 40, 40, 40)
              : Colors.white,
          title: Text(
            'Nuevo artículo',
            style: TextStyle(
                color: screenSettings.isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        backgroundColor: screenSettings.isDarkMode
            ? Colors.black
            : const Color.fromARGB(255, 236, 236, 236),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: TextField(
                    style: TextStyle(
                        color: screenSettings.isDarkMode
                            ? Colors.white
                            : Colors.black),
                    controller: _textNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  right: 10,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _textNameController.clear();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _textNameController.text.isEmpty
                              ? const Color.fromARGB(40, 255, 255, 255)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Stack(
              children: [
                Center(
                  child: TextFormField(
                    onTap: () {
                      _showDatePicker(_textDateController);
                    },
                    readOnly: true,
                    style: TextStyle(
                        color: screenSettings.isDarkMode
                            ? Colors.white
                            : Colors.black),
                    controller: _textDateController,
                    decoration: const InputDecoration(
                      labelText: 'De cuándo es',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  right: 10,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _textDateController.clear();
                          _textDateController.text =
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _textDateController.text ==
                                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
                              ? Color.fromARGB(40, 255, 255, 255)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Center(
              child: Stack(
                children: [
                  TextFormField(
                    onTap: () {
                      _showDatePicker(_textDateLimitController);
                    },
                    readOnly: true,
                    style: TextStyle(
                        color: screenSettings.isDarkMode
                            ? Colors.white
                            : Colors.black),
                    controller: _textDateLimitController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha Límite',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    right: 10,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _textDateLimitController.clear();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _textDateLimitController.text.isEmpty
                                ? const Color.fromARGB(40, 255, 255, 255)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(['']);
                  },
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_textNameController.text.isNotEmpty) {
                      Navigator.of(context)
                          .pop([_textNameController.text, _dateTime]);
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          title: const Text('You need to add a name'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
