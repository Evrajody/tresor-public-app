<?php

include("./config.php");

/** Les donnes recu de l'application sont decodes et ranger
* dans la superglobales POST **/

$_POST = json_decode( $_POST['data']); 

/**  Repuration encore plus rapides des valeurs  ;
* A chaque cle du tableau de donnes associe un variable du mme non
* puis lui affecte sa valeur **/

if (isset($_POST)) {
    foreach ($_POST as $index => $value) { 
    ${$index} = $value ;
  }
}

$Messages = array(
   "Login_Succes" => "Good",
   "Login_Failed" => "Bad",
) ;

// connexion a la base
$link = mysqli_connect(SERVEUR,NOM,PWD,BASE);  

// on defini les valeurs a ranger dans la base de donnée 

// Requete d'insertion dans la base de donnée 
$inserTools = " INSERT INTO Agents (`agent_matricule`, `agent_name`, `agent_surname`, `agent_service_date`, `agent_birthday`, 
    `agent_phone`, `agent_email`, `agent_ifu`, `agent_password`)
    VALUES  ('$agent_matricule', '$agent_name', '$agent_surname', STR_TO_DATE('$agent_service_date', '%d-%m-%Y'), 
    STR_TO_DATE('$agent_birthday', '%d-%m-%Y') , '$agent_phone', '$agent_email', '$agent_ifu', '$agent_password');" ;   

// on lance la requete et on recupère le resultat (ici une confimation de succes)
  $results_of_query_1 = mysqli_query($link, $inserTools);  
  
  
    if ( $results_of_query_1 ) {
      echo  json_encode($Messages['Login_Succes']);
    } else {
      echo  json_encode($Messages['Login_Failed']);
    }


