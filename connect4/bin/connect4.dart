import 'dart:io';
import 'package:connect4/game.dart';
import 'package:connect4/console_ui.dart';
import 'package:connect4/parser.dart';
import 'package:connect4/web_client.dart';
import 'package:connect4/info.dart';
import 'package:connect4/round.dart';

void main(List<String> arguments) {
  Controller().start();
}

class Controller {
  start() async {
    var ui = ConsoleUI();
    ui.welcome();

    // Request URL
    var url = ui.promptForServer(WebClient.defaultURL);

    ui.showMessageln('Connecting to server...');

    // Create WebClient
    var web = WebClient(url);

    // Check URL validity
    if(!web.isValidURL(url)) {
      ui.showMessageln('Invalid URL');
      exit(1);
    }

    // Get info from Connect4 server
    Info info;
    try {
      info = await web.getInfo();
    } catch (e) {
      ui.showMessageln('$e');
      ui.showMessageln('Could not connect to the server');
      exit(1);
    }

    // Ask for strategy
    int strategyIdx;
    while(true) {
      try {
        strategyIdx = ui.promptStrategy(info.strategies);
        break;
      } on InvalidInput catch(e) {
        ui.showMessageln('$e');
      }
    }

    ui.showMessageln('Selected strategy: ${info.strategies[strategyIdx - 1]}');

    // Get new pid
    String pid;
    try {
      pid = await web.getPID(info.strategies[strategyIdx - 1]);
    } on FailedRequest catch(e) {
      ui.showMessageln('$e');
      exit(1);
    } on UnrecognizedJSON catch(e) {
      ui.showMessageln('$e');
      exit(1);
    } on HTTPException catch(e) {
      ui.showMessageln('$e');
      exit(1);
    }

    // Create new game
    Game game = Game(info.width, info.height, 'X', 'O');

    // Enter game rounds
    bool playerWon = false;
    bool machineWon = false;
    while(true) {
      try {
        ui.showMessage('$game');

        // Request slot
        int slot = ui.promptForSlot(info.width);

        // Attempt to make player move
        if(!game.makePlayerMove(slot)) throw InvalidInput('Could not place slot in indicated column: $slot');

        // Request server response
        Round round = await web.getMove(pid, slot);

        // Check tie or win. Break if so
        if(playerWon = round.playerMove['isWin']) {
          game.winRow = round.playerMove['row'];
          break;
        }
        if(round.playerMove['isDraw']) break;

        // Make machine move
        // Server should always return a valid slot
        if(!game.makeMachineMove(round.machineMove['slot'])) throw ServerMismatch('Fatal error. Server return invalid column');

        // Check tie or win. Break if so
        if(machineWon = round.machineMove['isWin']) {
          game.winRow = round.machineMove['row'];
          break;
        }
        if(round.machineMove['isDraw']) break;

      } on InvalidInput catch(e) {
        ui.showMessageln('\n$e');
      } on FailedRequest catch(e) {
        ui.showMessageln('\n$e');
        exit(1);
      } on UnrecognizedJSON catch(e) {
        ui.showMessageln('\n$e');
        exit(1);
      } on HTTPException catch(e) {
        ui.showMessageln('\n$e');
        exit(1);
      }

      // Should never happen
      on ServerMismatch catch(e) {
        ui.showMessageln('\n$e');
        exit(1);
      }

      // Any other kind of exceptions
      catch(e) {
        ui.showMessageln('$e');
        exit(1);
      }
    }

    // Print game and outcome
    ui.showMessage('\n$game');
    if(playerWon) {
      ui.showMessageln('Player won!');
    } else if(machineWon) {
      ui.showMessageln('Machine won!');
    } else {
      ui.showMessageln('Tie!');
    }
  }
}

class ServerMismatch implements Exception {
  String cause;
  ServerMismatch(this.cause);

  @override
  String toString() {
    return cause;
  }
}