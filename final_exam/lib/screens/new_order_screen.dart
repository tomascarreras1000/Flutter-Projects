import 'package:flutter/material.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Order'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: TextField(
                controller: _textController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Order',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop('');
                },
                child: Text('Cancel'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  if (_textController.text.isNotEmpty)
                    Navigator.of(context).pop(_textController.text);
                  else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        title: Text('You need to add an order'),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Accept'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
