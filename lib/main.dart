import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<List<String>> board;
  late String currentPlayer;
  late bool gameOver;
  int playerXWins = 0;
  int playerOWins = 0;
  bool isBoardFull = false;
  bool isComputerPlayer = false;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    board = List<List<String>>.generate(3, (_) => List<String>.filled(3, ''));
    currentPlayer = 'X';
    gameOver = false;
    isBoardFull = false;
  }

  void makeMove(int row, int col) {
    if (!gameOver && board[row][col].isEmpty) {
      setState(() {
        board[row][col] = currentPlayer;
        checkGameOver(row, col);
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
        if (isComputerPlayer && !gameOver && currentPlayer == 'O') {
          makeComputerMove();
        }
      });
    }
  }

  void makeComputerMove() {
    // Generate a random move for the computer player
    Random random = Random();
    int row, col;
    do {
      row = random.nextInt(3);
      col = random.nextInt(3);
    } while (board[row][col].isNotEmpty);

    makeMove(row, col);
  }

  void checkGameOver(int row, int col) {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] &&
          board[i][0] == board[i][2] &&
          board[i][0].isNotEmpty) {
        setState(() {
          gameOver = true;
          if (board[i][0] == 'X') {
            playerXWins++;
          } else {
            playerOWins++;
          }
        });
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i] == board[1][i] &&
          board[0][i] == board[2][i] &&
          board[0][i].isNotEmpty) {
        setState(() {
          gameOver = true;
          if (board[0][i] == 'X') {
            playerXWins++;
          } else {
            playerOWins++;
          }
        });
        return;
      }
    }

    // Check diagonals
    if (board[0][0] == board[1][1] &&
        board[0][0] == board[2][2] &&
        board[0][0].isNotEmpty) {
      setState(() {
        gameOver = true;
        if (board[0][0] == 'X') {
          playerXWins++;
        } else {
          playerOWins++;
        }
      });
      return;
    }

    if (board[0][2] == board[1][1] &&
        board[0][2] == board[2][0] &&
        board[0][2].isNotEmpty) {
      setState(() {
        gameOver = true;
        if (board[0][2] == 'X') {
          playerXWins++;
        } else {
          playerOWins++;
        }
      });
      return;
    }

    // Check for a draw
    isBoardFull = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          isBoardFull = false;
          break;
        }
      }
      if (!isBoardFull) {
        break;
      }
    }

    if (isBoardFull && !gameOver) {
      setState(() {
        gameOver = true;
        playerXWins++;
        playerOWins++;
      });
    }
  }

  void resetGame() {
    setState(() {
      startNewGame();
    });
  }

  void resetScoreboard() {
    setState(() {
      playerXWins = 0;
      playerOWins = 0;
    });
  }

  void toggleGameMode() {
    setState(() {
      isComputerPlayer = !isComputerPlayer;
      startNewGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetScoreboard,
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: toggleGameMode,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Player: $currentPlayer',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                final int row = index ~/ 3;
                final int col = index % 3;
                return GestureDetector(
                  onTap: () => makeMove(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        board[row][col],
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            if (gameOver)
              ElevatedButton(
                child: Text('New Game'),
                onPressed: resetGame,
              ),
            SizedBox(height: 20),
            Text(
              'Player X Wins: $playerXWins',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Player O Wins: $playerOWins',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
