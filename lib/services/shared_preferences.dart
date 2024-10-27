// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPreferencesService {
//   SharedPreferencesService();
//   Future<SharedPreferences> prefs = SharedPreferences.getInstance();
//
//   getPreferences<T>({required T typeValue, required String nameValue}) async {
//     var awaitPrefs = await prefs;
//     if (typeValue is int) {
//       return awaitPrefs.getInt(nameValue);
//     } else if (typeValue is bool) {
//       return awaitPrefs.getBool(nameValue);
//     } else if (typeValue is double) {
//       return awaitPrefs.getDouble(nameValue);
//     } else if (typeValue is String) {
//       return awaitPrefs.getString(nameValue);
//     } else if (typeValue is List<String>) {
//       return awaitPrefs.getStringList(nameValue);
//     } else {
//       throw ArgumentError(
//           'Tipo di dato non supportato');
//     }
//   }
//
//   setPreferences<T>({required String nameValue, required T value}) async {
//     var awaitPrefs = await prefs;
//     if (value is int) {
//       return awaitPrefs.setInt(nameValue, value) ?? value;
//     } else if (value is bool) {
//       return awaitPrefs.setBool(nameValue, value) ?? value;
//     } else if (value is double) {
//       return awaitPrefs.setDouble(nameValue, value) ?? value;
//     } else if (value is String) {
//       return awaitPrefs.setString(nameValue, value) ?? value;
//     } else if (value is List<String>) {
//       return awaitPrefs.setStringList(nameValue, value) ?? value;
//     } else {
//       throw ArgumentError(
//           'Tipo di dato non supportato: ${value.runtimeType}');
//     }
//   }
// }
