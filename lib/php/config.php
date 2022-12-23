<?php

  /**ETABLIR UNE CONNEXION AVEC LA BDD */

   define('SERVEUR', "localhost");
   define('NOM', "id17120160_id17120160_evrajodygildas");
   define('PWD', "eternelles_Life2");
   define('BASE', "id17120160_meetings"); // Revoir ici la base de donnée pour adapter le code

   /* *Cette fonction permet de récuperer les constantes de la base de donnée et de se connecté 
   * Il suffit juste d'appeler le fonction et de lui passer les parametres */

    function databaselink (string $host, string $username, string $pwd, string $database) : object {
      $connexion = mysqli_connect($host, $username, $pwd, $database); // connexion a la base 
      /**verification la connexion  */
      if ($connexion) {
          echo "Connexion avec la base etablie avec succès ! <br>";
         } else {
         echo "Désolé , connexion à " . SERVEUR . " impossible car " . mysqli_connect_error($connexion) ;
         exit ;
      }
      return $connexion;
   } 
   
    
   /** Cette fonction permet de lancer une requete SQL et de récuperer les résultats si 
   * les résultats sont nuls elle renvoie false */

      function querylancher(object $connexion, string $query ) : object {
      $resultat = mysqli_query ($connexion, $query) ; // effectue la requete : on lui passe le lien et la requete en question
       if ($resultat) {
         echo "Requete effectuée <br> ";
      } else {
         echo "<b> Erreur dans l’ exécution de la requête . </b><br / > " ;
         echo "<b> Message de MySQL : </ b> " . mysqli_error($connexion) ;
         exit;
      }
      return $resultat;  // c'est un groupe de valeurs qui depend de la requete effectuée;
   }
