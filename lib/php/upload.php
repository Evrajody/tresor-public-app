<?php

/**  $_FILES est un Tableau de tableau qui sauvegarde tout les fichier soumis dans le formulaire
 * Pour chaque fichier uploader, il retient : 
 *  => le nom (nom de soumission du fichier dans le formulaire [index principale]);
 *  => name (le nom d'origine du fichier);
 *  => type (le type du fichier [nature/extentions]);
 *  => tmp_name (le chemin temporaire de sauvegarde de l'image);
 *  => error (notification d'erreur de chargement du fichier);
 *  => size (Taille du fichier uploader);
 */

 require ("./config.php");

 if ((isset($_POST) && !empty($_POST)) && (isset($_FILES) && !empty($_FILES))) {
    foreach ($_POST as $index => $value) { // Recupération encore plus rapides des valeurs  ;
        ${$index} = $value ;
     }
    foreach ($_FILES as $index => $value) { // Recupération caractéristiques du fichier uploader  ;
         ${$index} = $value ;
    }
 }
  
 function sendNotification(){
     
    define( 'API_ACCESS_KEY', "AAAAi19Xz34:APA91bFaHzxd7q4V_sNgG6xLSggFnJIAry056I8ykCH0mPNn9zlXNuVRrp95NZsIlXg5_
    UWXep_aVgTeWEShtdCE9snSJuN9RfbD5DjX96Rmqnefo1S41lDTYFSaxaisbts0jJo_aHIi");
    
    $msg = array (
     'body'   =>"Votre fiche de paie est disponible",
     'title'  => "Portail Fiche de Paie",
    );
    
    $fields = array (
        'to'            => "c6Sey0VeRR2P9o7kDXgw0Z:APA91bH3y2yUou661cYdDQ8HW4sK0hTEcLfLSrezYNjGDS8BetQolVo45ujAJKh
        0FGKlLAUzd292FBFtQJwSG8EmJsWgHbEQlvTf29dCIYsmI1da0Ka2X5V3RZveNpByj-L2VAI_9pUn",
        'notification'  => $msg,
    );

    $headers = array (
        'Authorization: key=' . API_ACCESS_KEY,
        'Content-Type: application/json'
    );

    $sender = curl_init();
    curl_setopt( $sender,CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send' );
    curl_setopt( $sender,CURLOPT_POST, true );
    curl_setopt( $sender,CURLOPT_HTTPHEADER, $headers );
    curl_setopt( $sender,CURLOPT_RETURNTRANSFER, true );
    curl_setopt( $sender,CURLOPT_SSL_VERIFYPEER, false );
    curl_setopt( $sender,CURLOPT_POSTFIELDS, json_encode( $fields ) );
    $result = curl_exec($sender);
    if (!$result) {
        die('FCM Send Error: ' . curl_error($sender));
    }
    curl_close( $sender );
    echo $result;

 }
 
$agent_fiche_name = $Selected_File["name"];
$agent_matricule = "11493920";

// connexion a la base
$link = databaselink(SERVEUR,NOM,PWD,BASE);  

// Requete d'insertion du fichier dans la base de donnée 
$inserTools = " INSERT INTO AgentDocuments (`agent_matricule`, `agent_fiche_name`)
    VALUES  ('$agent_matricule', '$agent_fiche_name');" ;   

// on lance la requete et on recupère le resultat (ici une confimation de succes)
 $resultat = mysqli_query ($link, $inserTools) ; 

// Quand la connection avec la base de donnée est établie et que la requete d'insersion est lancée,
// on deplace le fichier de la sauvegarde temporaire vers un dossier spécifique du serveur !
// Puis on notifie en enregistrant juste le nom du fichier;
if ($resultat){
    move_uploaded_file($Selected_File["tmp_name"], "FileStore".DIRECTORY_SEPARATOR.$Selected_File["name"] );
    sendNotification();
}
?>
  