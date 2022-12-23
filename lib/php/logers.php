<?php

require ('./config.php');

$_POST = json_decode($_POST['user_logs']);


$Messages = array(
   "Login_Succes" => "Good",
   "Login_Failed" => "Bad",
) ;

if (isset($_POST)) {
    foreach ($_POST as $index => $value) { // Recupération encore plus rapides des valeurs  ;
    ${$index} = $value ;
  }
}

    $link = mysqli_connect (SERVEUR,NOM,PWD,BASE);    // connexion a la base  
    $witchUser = "SELECT agent_matricule, agent_password  FROM Agents 
    WHERE  Agents.agent_matricule = '$agent_matricule' AND Agents.agent_password = '$agent_password'; "; 
    
    $exist = mysqli_num_rows(mysqli_query($link, $witchUser));  
    
    if ( $exist == 1 ) {
      echo  json_encode($Messages['Login_Succes']);
    } else {
      echo  json_encode($Messages['Login_Failed']);
    }
