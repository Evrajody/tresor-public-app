<?php

include("./config.php");

// connexion a la base
$link = mysqli_connect(SERVEUR,NOM,PWD,BASE);  

/* expression de la requete de selection de données */ 
$selecTools = " SELECT * FROM Agents " ;   

// on lance la requete et on recupère le resultat (ici une les informations de la base de donnée)
$results_of_query_2 = mysqli_query($link, $selecTools);  // on lance la requete et on recupère le resultat !

$rows = mysqli_num_rows($results_of_query_2);

echo '[';
if (!empty($results_of_query_2)){
    foreach($results_of_query_2 as $agent){
     $rows--;
     if($rows != 0) {
      echo json_encode($agent).','; //Encode les informations au format Json !  
     } else{
      echo json_encode($agent); //Encode les informations au format Json ! 
     }
        
   }
}
echo ']';



