import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchService {
  Future<bool> searchAuthor(String person, BuildContext context) async {
    String _url = "https://www.google.com/search?q=";
    String _queryString = person.replaceAll(" ", "+");
    var uri = Uri.parse(_url + _queryString).toString();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      await launch(
        uri,
        forceSafariVC: false,
        forceWebView: false,
      );
      return true;
    }
    return false;
  }
}
