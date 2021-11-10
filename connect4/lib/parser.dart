import 'dart:convert';
import 'package:connect4/info.dart';
import 'package:connect4/round.dart';
import 'package:connect4/coordinates.dart';

class Parser {
  static parseInfo(response) {
    try {
      var infoMap = json.decode(response.body);
      return Info(infoMap['width'], infoMap['height'], infoMap['strategies']);
    } catch(e) {
      throw UnrecognizedJSON('Could not obtain expected info JSON string');
    }
  }

  static parsePID(response) {
    Map pidMap;
    try {
      pidMap = json.decode(response.body);
    } catch(e) {
      throw UnrecognizedJSON('Could not obtain expected pid JSON string');
    }

    // Server denied request
    if(pidMap['response'] == false) throw FailedRequest(pidMap['cause']);

    // Return PID
    try {
      return pidMap['pid'];
    } catch(e) {
      throw UnrecognizedJSON('Could not obtain expected pid JSON string');
    }
  }

  static parseRound(response) {
    Map<String, dynamic> moveMap;

    try {
      moveMap = json.decode(response.body);
    } catch(e) {
      throw UnrecognizedJSON('Could not obtain expected round JSON string');
    }

    // Server denied request
    if(moveMap['response'] == false) throw FailedRequest(moveMap['cause']);

    // Return move
    try {
      // Parse ack_move as playerMove
      Map<String, dynamic> playerMove = Map();
      playerMove['slot'] = moveMap['ack_move']['slot'] + 1;
      playerMove['isWin'] = moveMap['ack_move']['isWin'];
      playerMove['isDraw'] = moveMap['ack_move']['isDraw'];
      playerMove['row'] = [];
      /*for(int elem in moveMap['ack_move']['row']) {
        playerMove['row'].add(elem);
      }
       */
      for(int i = 0; i < moveMap['ack_move']['row'].length; i += 2) {
        playerMove['row'].add(Coordinates(moveMap['ack_move']['row'][i] + 1,
                                          moveMap['ack_move']['row'][i + 1] + 1));
      }

      // Parse move as machineMove
      Map<String, dynamic>? machineMove;

      // Define machineMove only if player did not make the last possible move
      if(!playerMove['isWin'] && !playerMove['isDraw']) {
        machineMove = Map();
        machineMove['slot'] = moveMap['move']['slot'] + 1;
        machineMove['isWin'] = moveMap['move']['isWin'];
        machineMove['isDraw'] = moveMap['move']['isDraw'];
        machineMove['row'] = [];
        /*
        for(int elem in moveMap['move']['row']) {
          machineMove['row'].add(elem);
        }
         */

        for(int i = 0; i < moveMap['move']['row'].length; i += 2) {
          machineMove['row'].add(Coordinates(moveMap['move']['row'][i] + 1,
                                             moveMap['move']['row'][i + 1] + 1));
        }
      }
      return Round(playerMove, machineMove);
    } catch(e) {
      throw UnrecognizedJSON('Could not obtain expected JSON string');
    }
  }
}

class FailedRequest implements Exception {
  String cause;
  FailedRequest(this.cause);

  @override
  String toString() {
    return cause;
  }
}

class UnrecognizedJSON implements Exception {
  String cause;
  UnrecognizedJSON(this.cause);

  @override
  String toString() {
    return cause;
  }
}

