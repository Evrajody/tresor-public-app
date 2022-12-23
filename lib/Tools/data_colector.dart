class DataColector {
  // Pour l'Enrégistrement
  static String matricule = '';
  static String name = '';
  static String surname = '';
  static String serviceDate = '';
  static String birthday = '';
  static String phone = '';
  static String email = '';
  static String ifu = '';
  static String password = '';

  // Pour la connexion
  static String loginMatricule = '';
  static String loginPassword = '';
}

// On parse les informations en Jsons avant de les envoyer ou les recuperer
class PostingModel {
// Pour l'Enrégistrement
  String? matricule;
  String? name;
  String? surname;
  String? serviceDate;
  String? birthday;
  String? phone;
  String? email;
  String? ifu;
  String? password;
  String? confirmPassword;

  PostingModel({
    this.matricule,
    this.name,
    this.surname,
    this.serviceDate,
    this.birthday,
    this.phone,
    this.email,
    this.ifu,
    this.password,
  });

  /* Cette fonction convertit les données du serveur venu en format Json au
  // format objet !  
  // De facon plus clair le constructeur en voir un parsing json des donnée grace au factory !*/
  // Pour l'Enrégistrement
  // Json (Element tel que ecrit dans la base de donnes )
  factory PostingModel.fromJson(Map<String, dynamic> json) {
    return PostingModel(
      matricule: json["agent_matricule"],
      name: json["agent_name"],
      surname: json["agent_surname"],
      serviceDate: json["agent_service_date"],
      birthday: json["agent_birthday"],
      phone: json["agent_phone"],
      email: json["agent_email"],
      ifu: json["agent_ifu"],
      password: json["agent_password"],
    );
  }

  /* Cette fonction envoie les données sur le serveur en le parsant du format objet au format json */
  // Pour l'Enrégistrement
  // Ici c'est Model equivalent tel que ecrit dans le base de donnees et variable objet associé
  Map<String, dynamic> dataResolverToJson() {
    return {
      "agent_matricule": matricule,
      "agent_name": name,
      "agent_surname": surname,
      "agent_service_date": serviceDate,
      "agent_birthday": birthday,
      "agent_phone": phone,
      "agent_email": email,
      "agent_ifu": ifu,
      "agent_password": password,
    };
  }
}


class PostingModelForConnexion {
  // Pour la connexion
  String? loginMatricule;
  String? loginPassword;
  String? message;

  PostingModelForConnexion({
    this.loginMatricule,
    this.loginPassword,
  });

  factory PostingModelForConnexion.fromJson(Map<String, dynamic> json) {
    return PostingModelForConnexion(
      loginMatricule: json["agent_matricule"],
      loginPassword: json["agent_password"],
    );
  }

  Map<String, dynamic> dataResolverToJson() {
    return {
      "agent_matricule": loginMatricule,
      "agent_password": loginPassword,
    };
  }
}
 
class PostingModelForFile {
  // Pour les fichiers de l'utilisateur
  String? fileName;
  String? dateConcern;


  PostingModelForFile({
    this.fileName,
    this.dateConcern,
  });

  factory PostingModelForFile.fromJson(Map<String, dynamic> json) {
    return PostingModelForFile(
      fileName: json["agent_fiche_name"],
      dateConcern: json["date_fiche"],
    );
  }
}
