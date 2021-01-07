import 'package:flutter/material.dart';
import 'character_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Game',
          style: TextStyle(
            fontSize: 100,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CharacterScreen(),
                  ),
                );
              },
              child: Text(
                'Play',
                style: TextStyle(
                  fontSize: 60,
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Options',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Exit',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
