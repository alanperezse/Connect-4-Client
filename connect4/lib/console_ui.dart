import 'dart:io';

class ConsoleUI {
  void welcome() {
    showMessageln('Welcome to C4!');
  }

  // Request server URL
  promptForServer(defaultURL) {
    String inputUrl = '';

    showMessage('Enter the server URL [default: $defaultURL] ');
    inputUrl = getUserInput(); // Get user input

    // If given an empty String
    if(inputUrl == '') inputUrl = defaultURL;

    return inputUrl;
  }

  // Request one of the given strategies
  promptStrategy(strategies) {
    const defaultIdx = 1;
    int idx = defaultIdx;

    showMessage('Select the server strategy: ');
    for (int i = 0; i < strategies.length; i++) {
      showMessage('${i + 1}. ${strategies[i]} ');
    }
    showMessage('[default: 1] ');

    String line = getUserInput()!;

    // int was not given
    try {
      idx = line == '' ? defaultIdx : int.parse(line);
    } on FormatException {
      throw InvalidInput('Must provide integer. Please try again');
    }

    // Invalid selection
    if(idx < 1 || strategies.length < idx) throw InvalidInput('Invalid selection: $idx');

    return idx;
  }

  promptForSlot(width) {
    int slot;

    showMessage('Select a slot [1 - $width] ');

    String line = getUserInput()!;

    // int was not given
    try {
      slot = int.parse(line);
    } on FormatException {
      throw InvalidInput('Must provide integer. Please try again');
    }

    // Invalid selection
    if(slot < 1 || width < slot) throw InvalidInput('Invalid selection: $slot');

    return slot;
  }

  void showMessage(String msg) {
    stdout.write(msg);
  }

  void showMessageln(String msg) {
    print(msg);
  }

  getUserInput() {
    return stdin.readLineSync()!;
  }
}

class InvalidInput implements Exception {
  String cause;
  InvalidInput(this.cause);

  @override
  String toString() {
    return cause;
  }
}