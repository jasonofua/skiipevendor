import 'package:shared_preferences/shared_preferences.dart';

class DataVault {
  addStringToSF(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  removeValues(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(value);
  }
}
