
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Uploading file</title>

     <form action="./upload.php" method="post" enctype="multipart/form-data">
        <label for="Selected_File" >Selectionnez un ficher </label>
        <input type="file" name="Selected_File"  required> <br>
         <input type="submit" value="Send" name="submit">
     </form>

</head>
<body>
</body>
</html>