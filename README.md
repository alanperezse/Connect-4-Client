# Connect-4 Client
This Connect 4 client is meant to be used in conjunction with the Connect 4 server made with PHP, also found on my github on its own repository.

The Model-Control-View model was used to develop this project.

From this, you will be able to play a Connect4 game against a CPU. The modes and the behavior of the CPU on each mode is defined by the server. Slots placed by the player are marked as X's. Slots placed by the machine are marked as O's. To keep the player in track of the latest movement, there will be a '*' symbol below the board that indicates the column where the last slot was placed.

A winner will be declared as indicated by the server.

A tie will be declared as indicated by the server.

### Running project:
The project can be imported and IntelliJ and ran from there (assuming the Dart plugin is present). The file to be run is /bin/connect4.dart

There will be indications of how to play on the console. The PHP server should be instantiated prior to playing the game.

### To play:
Simply run the project. When prompted for information, you may enter an empty string to select the default option (assuming there is one). When prompted for an URL, provide the URL where the server is running. Follow the instructions in the Connect-4-Server for more details on this.
