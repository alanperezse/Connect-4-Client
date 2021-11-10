import 'package:http/http.dart' as http;
import 'package:connect4/parser.dart';

class WebClient {
  static const String defaultURL= 'http://cheon.atwebpages.com/c4/';
  final String url;

  WebClient(this.url);

  bool isValidURL(url) {
    try {
      return Uri.parse(url).isAbsolute;
    } catch (e) {
      return false;
    }
  }

  getInfo() async {
    var response;
    try {
      response = await http.get(Uri.parse(url + '/info'));
    } catch(e) {
      throw HTTPException('Exception while getting HTTP response');
    }
    return Parser.parseInfo(response);
  }

  getPID(strategy) async {
    var response;
    try {
      response = await http.get(Uri.parse(url + '/new/?strategy=' + strategy));
    } catch(e) {
      throw HTTPException('Exception while getting HTTP response');
    }
    return Parser.parsePID(response);
  }

  getMove(pid, move) async {
    var response;
    try {
      response = await http.get(Uri.parse(
          url + '/play/?pid=' + '$pid' + '&' + 'move=' + '${move - 1}'));
    } catch(e) {
      throw HTTPException('Exception while getting HTTP response');
    }
    return Parser.parseRound(response);
  }
}

class HTTPException implements Exception {
  String cause;
  HTTPException(this.cause);

  @override
  String toString() {
    return cause;
  }
}