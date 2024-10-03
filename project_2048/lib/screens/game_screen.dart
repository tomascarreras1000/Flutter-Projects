import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final int _gridSize = ModalRoute.of(context)!.settings.arguments as int;
  late SharedPreferences _preferences;

  bool _isGameWon = false;
  bool _hasDragged = false;

  var _startingDragPosition;
  var _position;

  num _score = 0;
  late var _highScore = 0;

  List _grid = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0]
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getPreferences();
      _restartGameState();
    });
  }

  void _getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    int? score = _preferences.getInt('highScore');
    if (score != null) {
      setState(() {
        _highScore = score;
      });
    }
  }

  void _generateNewTile() {
    var tile = _getRandomEmptyTile();
    _grid[tile[0]][tile[1]] = 2 + (Random().nextInt(2) * 2);

    setState(() {});
  }

  List<int> _getRandomEmptyTile() {
    List<List<int>> emptyTiles = List.empty(growable: true);
    for (int x = 0; x < _gridSize; x++) {
      for (int y = 0; y < _gridSize; y++) {
        if (_grid[x][y] == 0) {
          emptyTiles.add([x, y]);
        }
      }
    }
    if (emptyTiles.isEmpty) return [-1, -1];

    return emptyTiles[Random().nextInt(emptyTiles.length)];
  }

  Color _getTileColor(int value) {
    if (value == 0) {
      return Colors.grey[300]!;
    }

    double logValue = log(value) / log(2); // log base 2

    Color colorValue2 = const Color(0xFFF7F4E8);
    Color colorValue64 = const Color.fromARGB(255, 237, 94, 28);
    Color colorValue128 = const Color.fromARGB(255, 228, 218, 104);
    Color colorValue2048 = const Color.fromARGB(255, 241, 207, 15);

    double minLogValue = 1; // log2(2)
    double maxLogValue = 11; // log2(2048)

    double normalizedValue =
        (logValue - minLogValue) / (maxLogValue - minLogValue);

    if (normalizedValue <= 0.5) {
      return Color.lerp(colorValue2, colorValue64, normalizedValue * 2)!;
    } else {
      return Color.lerp(
          colorValue128, colorValue2048, (normalizedValue - 0.5) * 2)!;
    }
  }

  bool _hasTileCombined(int y, x, List<List<int>> usedTiles) {
    return usedTiles.any((tile) => tile[0] == y && tile[1] == x);
  }

  bool _isGameOver() {
    // Checks for a possible move or for a completed 2048
    for (int y = 0; y < _gridSize; y++) {
      for (int x = 1; x < _gridSize; x++) {
        if (_grid[y][x] > 0) {
          if (_grid[y][x] == 2048) {
            _isGameWon = true;
            return true;
          } else if (_grid[y][x - 1] == 0) {
            return false;
          } else if (_grid[y][x] == _grid[y][x - 1]) {
            return false;
          }
        }
      }
    }

    for (int y = 0; y < _gridSize; y++) {
      for (int x = _gridSize - 2; x >= 0; x--) {
        if (_grid[y][x] > 0) {
          if (_grid[y][x] == 2048) {
            _isGameWon = true;
            return true;
          } else if (_grid[y][x + 1] == 0) {
            return false;
          } else if (_grid[y][x] == _grid[y][x + 1]) {
            return false;
          }
        }
      }
    }

    for (int y = 1; y < _gridSize; y++) {
      for (int x = 0; x < _gridSize; x++) {
        if (_grid[y][x] > 0) {
          if (_grid[y][x] > 0) {
            if (_grid[y][x] == 2048) {
              _isGameWon = true;
              return true;
            } else if (_grid[y - 1][x] == 0) {
              return false;
            } else if (_grid[y][x] == _grid[y - 1][x]) {
              return false;
            }
          }
        }
      }
    }

    for (int y = _gridSize - 2; y >= 0; y--) {
      for (int x = 0; x < _gridSize; x++) {
        if (_grid[y][x] > 0) {
          if (_grid[y][x] > 0) {
            if (_grid[y][x] == 2048) {
              _isGameWon = true;
              return true;
            } else if (_grid[y + 1][x] == 0) {
              return false;
            } else if (_grid[y][x] == _grid[y + 1][x]) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  void _setScore(var score) {
    setState(() {
      _score = score;
      if (_score > _highScore) {
        _highScore = score;
        _preferences.setInt('highScore', _highScore);
      }
    });
  }

  void _handleInput(List<int> direction) {
    bool isNewTileNeeded = false;
    bool hasChanged = true;
    List gridBuffer = _grid;
    List<List<int>> usedTiles = List.empty(growable: true);

    switch (direction) {
      case [-1, 0]:
        {
          while (hasChanged) {
            hasChanged = false;
            for (int y = 0; y < _gridSize; y++) {
              for (int x = 1; x < _gridSize; x++) {
                // Starts at 1 cause we can't move a leftmost tile to the left
                if (gridBuffer[y][x] > 0) {
                  if (gridBuffer[y][x - 1] == 0) {
                    isNewTileNeeded = hasChanged = true;
                    gridBuffer[y][x - 1] = gridBuffer[y][x];
                    gridBuffer[y][x] = 0;
                  } else if (gridBuffer[y][x] == gridBuffer[y][x - 1] &&
                      !_hasTileCombined(y, x, usedTiles) &&
                      !_hasTileCombined(y, x - 1, usedTiles)) {
                    isNewTileNeeded = hasChanged = true;
                    gridBuffer[y][x - 1] *= 2;
                    gridBuffer[y][x] = 0;
                    _setScore(_score + gridBuffer[y][x - 1]);
                    usedTiles.add([y, x - 1]);
                  }
                }
              }
            }
          }

          break;
        }
      case [1, 0]:
        {
          while (hasChanged) {
            hasChanged = false;
            for (int y = 0; y < _gridSize; y++) {
              for (int x = _gridSize - 2; x >= 0; x--) {
                if (gridBuffer[y][x] > 0) {
                  if (gridBuffer[y][x + 1] == 0) {
                    isNewTileNeeded = hasChanged = true;
                    gridBuffer[y][x + 1] = gridBuffer[y][x];
                    gridBuffer[y][x] = 0;
                  } else if (gridBuffer[y][x] == gridBuffer[y][x + 1] &&
                      !_hasTileCombined(y, x, usedTiles) &&
                      !_hasTileCombined(y, x + 1, usedTiles)) {
                    isNewTileNeeded = hasChanged = true;
                    gridBuffer[y][x + 1] *= 2;
                    gridBuffer[y][x] = 0;
                    _setScore(_score + gridBuffer[y][x + 1]);
                    usedTiles.add([y, x + 1]);
                  }
                }
              }
            }
          }

          break;
        }
      case [0, -1]: //up
        {
          while (hasChanged) {
            hasChanged = false;
            for (int y = 1; y < _gridSize; y++) {
              for (int x = 0; x < _gridSize; x++) {
                if (gridBuffer[y][x] > 0) {
                  if (gridBuffer[y - 1][x] == 0) {
                    isNewTileNeeded = hasChanged = true;
                    gridBuffer[y - 1][x] = gridBuffer[y][x];
                    gridBuffer[y][x] = 0;
                  } else if (gridBuffer[y][x] == gridBuffer[y - 1][x] &&
                      !_hasTileCombined(y, x, usedTiles) &&
                      !_hasTileCombined(y - 1, x, usedTiles)) {
                    isNewTileNeeded = hasChanged = true;
                    gridBuffer[y - 1][x] *= 2;
                    gridBuffer[y][x] = 0;
                    _setScore(_score + gridBuffer[y - 1][x]);
                    usedTiles.add([y - 1, x]);
                  }
                }
              }
            }
          }

          break;
        }
      case [0, 1]: //down
        {
          while (hasChanged) {
            hasChanged = false;
            for (int y = _gridSize - 2; y >= 0; y--) {
              for (int x = 0; x < _gridSize; x++) {
                if (gridBuffer[y][x] > 0) {
                  if (gridBuffer[y + 1][x] == 0) {
                    isNewTileNeeded = hasChanged = true;
                    gridBuffer[y + 1][x] = gridBuffer[y][x];
                    gridBuffer[y][x] = 0;
                  } else if (gridBuffer[y][x] == gridBuffer[y + 1][x] &&
                      !_hasTileCombined(y, x, usedTiles) &&
                      !_hasTileCombined(y + 1, x, usedTiles)) {
                    isNewTileNeeded = hasChanged = true;
                    gridBuffer[y + 1][x] *= 2;
                    gridBuffer[y][x] = 0;
                    _setScore(_score + gridBuffer[y + 1][x]);
                    usedTiles.add([y + 1, x]);
                  }
                }
              }
            }
          }

          break;
        }
      default:
        {
          _generateNewTile();
          break;
        }
    }

    _grid = gridBuffer;

    if (isNewTileNeeded) {
      _generateNewTile();
    } else {
      setState(() {});
    }
  }

  List<dynamic> _generateEmptyMap() {
    List ret = List.empty(growable: true);

    if (_gridSize == 3) {
      ret = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ];
    } else if (_gridSize == 5) {
      ret = [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0]
      ];
    } else {
      ret = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
      ];
    }
    return ret;
  }

  void _restartGameState() {
    _isGameWon = false;
    _setScore(0);
    _grid = _generateEmptyMap();
    _generateNewTile();
    _generateNewTile();
  }

  void _showEndgamePopup() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                _isGameWon ? 'You Win!' : 'Game Over!',
                style: const TextStyle(color: Colors.white, fontSize: 60),
              ),
            ),
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 1,
                child: Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      _isGameWon ? 'Play Again' : 'Try Again',
                      style: const TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).then(
      (restart) => {
        if (restart == true)
          {
            _restartGameState(),
          },
      },
    );
  }

  List<Widget> _drawTiles(
      double tileSize, double tileBorderRadius, double tileBorderSize) {
    List<Widget> ret = List.empty(growable: true);
    for (int y = 0; y < _gridSize; y++) {
      for (int x = 0; x < _gridSize; x++) {
        ret.add(Positioned(
          top: y * tileSize,
          left: x * tileSize,
          //curve: Curves.easeInOut,
          child: Container(
            width: tileSize,
            height: tileSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _getTileColor(_grid[y][x]),
              borderRadius: BorderRadius.circular(tileBorderRadius),
              border: Border.all(
                color: const Color.fromARGB(255, 165, 153, 149),
                width: tileBorderSize,
              ),
            ),
            child: Text(
              _grid[y][x] == 0 ? '' : '${_grid[y][x]}',
              style: TextStyle(
                fontSize: 35,
                color: _grid[y][x] > 4
                    ? Colors.white
                    : const Color.fromARGB(255, 98, 98, 98),
              ),
            ),
          ),
        ));
      }
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 20.0;
    final double availableStackWidth =
        MediaQuery.of(context).size.width - (padding * 2);
    double tileSize = availableStackWidth / _gridSize;
    double tileBorderSize = 4;
    double tileBorderRadius = 10;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '2048',
                                style: TextStyle(fontSize: 60),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: const Color.fromARGB(
                                            255, 120, 120, 120)),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'SCORE',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 197, 197, 197),
                                          ),
                                        ),
                                        Text(
                                          _score.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: const Color.fromARGB(
                                            255, 120, 120, 120)),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'HIGH SCORE',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 197, 197, 197),
                                          ),
                                        ),
                                        Text(
                                          _highScore.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              GestureDetector(
                                onTap: () {
                                  _restartGameState();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: const Color.fromARGB(
                                          255, 120, 120, 120)),
                                  child: const Icon(
                                    Icons.restart_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onPanStart: (details) async {
                        _hasDragged = false;
                        _startingDragPosition = [
                          details.localPosition.dx,
                          details.localPosition.dy
                        ];
                      },
                      onPanUpdate: (details) async {
                        if (_hasDragged) return;
                        _position = [
                          details.localPosition.dx,
                          details.localPosition.dy
                        ];
                        if (_position[0] - _startingDragPosition[0] > 45) {
                          _handleInput([1, 0]);
                          if (_isGameOver()) {
                            _showEndgamePopup();
                          }
                          _hasDragged = true;
                        } else if (_position[0] - _startingDragPosition[0] <
                            -45) {
                          _handleInput([-1, 0]);
                          if (_isGameOver()) {
                            _showEndgamePopup();
                          }
                          _hasDragged = true;
                        }
                        if (_position[1] - _startingDragPosition[1] > 45) {
                          _handleInput([0, 1]);
                          if (_isGameOver()) {
                            _showEndgamePopup();
                          }
                          _hasDragged = true;
                        }
                        if (_position[1] - _startingDragPosition[1] < -45) {
                          _handleInput([0, -1]);
                          if (_isGameOver()) {
                            _showEndgamePopup();
                          }
                          _hasDragged = true;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 165, 153, 149),
                          borderRadius:
                              BorderRadius.circular(tileBorderRadius / 2),
                          border: Border.all(
                              color: const Color.fromARGB(255, 165, 153, 149),
                              width: tileBorderSize),
                        ),
                        child: SizedBox(
                          width: availableStackWidth,
                          height: availableStackWidth,
                          child: Stack(
                            children: [
                              // Background grid
                              for (int y = 0; y < _gridSize; y++)
                                for (int x = 0; x < _gridSize; x++)
                                  Positioned(
                                    top: y * tileSize,
                                    left: x * tileSize,
                                    child: Container(
                                      width: tileSize,
                                      height: tileSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            tileBorderRadius),
                                        color: Colors.grey[300],
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 165, 153, 149),
                                          width: tileBorderSize,
                                        ),
                                      ),
                                    ),
                                  ),
                            ]..addAll(_drawTiles(
                                tileSize, tileBorderRadius, tileBorderSize)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
