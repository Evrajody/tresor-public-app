import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tresor_public/Screens/FirstStepSaving.dart';
import 'package:tresor_public/Screens/SndStepSaving.dart';
import 'package:tresor_public/Screens/TresorPublicLogin.dart';
import 'package:tresor_public/Screens/userInterface.dart';
import 'package:tresor_public/Tools/data_colector.dart';
import 'package:tresor_public/Tools/http_services.dart';

Widget toolbarDisplayer(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue[900],
      image: DecorationImage(
        image: AssetImage("assets/bkg.png"),
        repeat: ImageRepeat.repeatX,
      ),
    ),
    width: double.infinity,
    height: 136,
    padding: EdgeInsets.only(top: 35),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => TresorPublicLogin(),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.arrow_back_ios_new),
                color: Colors.white,
              ),
              Image.asset("assets/dgtcp-1_tiny-new.png"),
            ],
          ),
        ),
        Text(
          "Décentalisation des bulletins de Paie",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 5.0,
              ),
            ],
          ),
          height: 12,
          child: Row(
            children: [
              Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width / 3,
              ),
              Container(
                color: Colors.yellow,
                width: MediaQuery.of(context).size.width / 3,
              ),
              Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width / 3,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget boxContentForLogin(
  BuildContext context,
  GlobalKey<FormState> login,
) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 6.0,
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          'Se connecter',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black87.withOpacity(0.67),
          ),
        ),
        SizedBox(height: 5),
        Form(
          key: login,
          child: Column(
            children: [
              TextFormField(
                onChanged: (enterMat) => DataColector.loginMatricule = enterMat,
                validator: (enterMat) {
                  if (enterMat == '') {
                    return "Renseigner votre matricule";
                  }
                },
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black87.withOpacity(0.67),
                    size: 20,
                  ),
                  hintText: "Matricule",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                onChanged: (pwd) => DataColector.loginPassword = pwd,
                validator: (pwd) {
                  if (pwd == '') {
                    return "Renseigner votre mot de passe";
                  }
                },
                obscureText: true,
                style: TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.black87.withOpacity(0.67),
                    size: 20,
                  ),
                  hintText: "Mot de passe",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xff1545d66),
                        ),
                      ),
                      onPressed: () async {
                        AlertDialog alert = AlertDialog(
                          title: Text("Erreur d'authentification"),
                          content: Text(
                            "Identifiants Incorrects",
                            style: TextStyle(fontSize: 20),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Ressayer",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        );
                        AlertDialog loading = AlertDialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 125),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 40, horizontal: 38),
                          clipBehavior: Clip.antiAlias,
                          content: Container(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        var postConnect = PostingModelForConnexion(
                          loginMatricule: DataColector.loginMatricule,
                          loginPassword: DataColector.loginPassword,
                        );
                        //print(await HttpService.loginUser(postConnect));
                        if (login.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return loading;
                            },
                          );
                          HttpService.loginUser(postConnect).then((value) {
                            if (value == "Good") {
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => UserInterface(),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return alert;
                                },
                              );
                            }
                          });
                        }
                      },
                      child: Text(
                        "CONNEXION",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => TresorPublicRegisterStepOne(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xff5984b6),
                        ),
                      ),
                      child: Text(
                        "S'ENREGISTRER",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                "Email erroné ? ",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green[900],
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Mot de passe oublié ? ",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green[900],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget boxContentForRegisterStepOne(
    BuildContext context, GlobalKey<FormState> login) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 6.0,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enregistrement des Agents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87.withOpacity(0.67),
              ),
            ),
            Text(
              ' (1/2)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 28),
        Form(
          key: login,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Matricule *",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                onChanged: (enterMat) => DataColector.matricule = enterMat,
                validator: (enterMat) {
                  if (enterMat == '') {
                    return "Renseigner votre matricule";
                  }
                },
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Entrer votre matricule",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Nom *",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                onChanged: (entername) => DataColector.name = entername,
                validator: (entername) {
                  if (entername == '') {
                    return "Renseigner votre Nom";
                  }
                },
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 18),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Entrer votre nom",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Prénom *",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                onChanged: (prenom) => DataColector.surname = prenom,
                validator: (prenom) {
                  if (prenom == '') {
                    return "Renseigner votre prénom";
                  }
                },
                cursorColor: Colors.black,
                keyboardType: TextInputType.name,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Entrer votre prénom",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Date de prise de service *",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                onChanged: (workdate) => DataColector.serviceDate = workdate,
                validator: (workdate) {
                  if (workdate == '') {
                    return "Renseigner votre date de prise de service";
                  }
                },
                cursorColor: Colors.black,
                keyboardType: TextInputType.datetime,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Entrer votre date de prise de service",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Date de naissance *",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                onChanged: (born) => DataColector.birthday = born,
                validator: (born) {
                  if (born == '') {
                    return "Renseigner votre date de naissance";
                  }
                },
                cursorColor: Colors.black,
                keyboardType: TextInputType.datetime,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Entrer votre date de naissance",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.lock,
              size: 15,
              color: Colors.green,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TresorPublicLogin(),
                  ),
                );
              },
              child: Text(
                "Se connecter",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green[900],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (login.currentState!.validate()) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TresorPublicRegisterStepSnd(),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color(0xff545d66),
                ),
              ),
              child: Text(
                "Suivant",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget boxContentForRegisterStepSnd(
    BuildContext context, GlobalKey<FormState> login) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 6.0,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enregistrement des Agents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87.withOpacity(0.67),
              ),
            ),
            Text(
              ' (2/2)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 28),
        Form(
          key: login,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Téléphone *",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                onChanged: (phone) => DataColector.phone = phone,
                validator: (phone) {
                  if (phone == '') {
                    return "Renseigner votre téléphone";
                  }
                },
                cursorColor: Colors.black,
                keyboardType: TextInputType.phone,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Entrer votre telephone",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Email *",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                onChanged: (mail) => DataColector.email = mail,
                validator: (mail) {
                  if (mail == '') {
                    return "Renseigner votre email";
                  }
                },
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 18),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Entrer votre email",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "IFU Personnel",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                onChanged: (ifu) => DataColector.ifu = ifu,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Entrer votre IFU",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Mot de passe *",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                onChanged: (pwd) {
                  DataColector.password = pwd;
                },
                validator: (pwd) {
                  if (pwd == '') {
                    return "Renseigner votre email";
                  }
                },
                cursorColor: Colors.black,
                obscureText: true,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Entrer votre mot de passe",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Confirmer mot de passe *",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withOpacity(0.67),
                ),
              ),
              TextFormField(
                validator: (cnf) {
                  if (cnf == '') {
                    return "Confirmer votre mot de passe";
                  } else if (cnf != DataColector.password) {
                    return "Mot de passe non conforme";
                  }
                },
                cursorColor: Colors.black,
                obscureText: true,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Confirmer votre mot de passe ",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.lock,
              size: 15,
              color: Colors.green,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TresorPublicLogin(),
                  ),
                );
              },
              child: Text(
                "Se connecter",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green[900],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (login.currentState!.validate()) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.symmetric(horizontal: 125),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 38),
                        clipBehavior: Clip.antiAlias,
                        content: Container(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  );
                  HttpService.savingUser(
                    PostingModel(
                      matricule: DataColector.matricule,
                      name: DataColector.name,
                      surname: DataColector.surname,
                      serviceDate: DataColector.serviceDate,
                      birthday: DataColector.birthday,
                      phone: DataColector.phone,
                      email: DataColector.email,
                      ifu: DataColector.ifu,
                      password: DataColector.password,
                    ),
                  ).then((value) {
                    print(value);
                    if (value == "Good") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog( 
                                content: Text(
                                  "Enrégistrement Reussie",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                TresorPublicLogin(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Continuer",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )),
                                ]);
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: Text(
                                  "Votre enrégistrement a échoué",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        // On revient a la premiere etape
                                      },
                                      child: Text(
                                        "Recommencer",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )),
                                ]);
                          });
                    }
                  });
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.green[900],
                ),
              ),
              child: Text(
                "Enregistrer",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget eServicesDisplayer(
    BuildContext context, String? nature, Widget movingTo) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => movingTo,
        ),
      );
    },
    child: Container(
      height: 125,
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage("assets/element_by.png"),
          alignment: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Image.asset("assets/receipt.png"),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          SizedBox(width: 15),
          Container(
            child: Text(
              nature.toString(),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 23,
                color: Color(0xff344051),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
