import 'dart:convert';
import 'package:http/http.dart' as httptool;
import 'package:tresor_public/Tools/data_colector.dart';

// cette classe propose des services https
// Elle a une methode qui se charge de poster les informations ;
/* String name, String surname, String email, String password,
      String matricule, String filiere */

class HttpService {
  static Future savingUser(PostingModel model) async {
    final reponse = await httptool.post(Uri.parse(UrLinks.postUrl), body: {
      "data": jsonEncode(model.dataResolverToJson()),
    });
    if (reponse.statusCode == 200) {
      print(reponse.body); // Ligne de debogage 
    }
    return jsonDecode(reponse.body);
  }

  static Future loginUser(PostingModelForConnexion model) async {
    final reponse = await httptool.post(Uri.parse(UrLinks.logUrl), body: {
      "user_logs": jsonEncode(model.dataResolverToJson()),
    });
    var message;
    if (reponse.statusCode == 200) {
      message = reponse.body;
    }
    return jsonDecode(message);
  }

  // Recupération brute des données ;
  static fetchedUsers() async {
    final reponse = await httptool.get(Uri.parse(UrLinks.getUrl));
    var data;
    if (reponse.statusCode == 200) {
      data = reponse.body;
    }
    return jsonDecode(data);
  }
}

class UrLinks {
  static final String postUrl =
      "https://marinsta.000webhostapp.com/TresorPublic/apiParser.php";

  static final String getUrl =
      "https://marinsta.000webhostapp.com/TresorPublic/fetching.php";

  static final String logUrl =
      "https://marinsta.000webhostapp.com/TresorPublic/logers.php";
}
