
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>LoveBot</title>
<link rel="stylesheet" href="styles.css">

</head>
<body>

<?php
// define variables and set to empty values
$name = $email = $gender = $comment = $website = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
   $name = test_input($_POST["name"]);
   $email = test_input($_POST["email"]);
   $message = test_input($_POST["message"]);
   $gender = test_input($_POST["gender"]);
}

function test_input($data) {
   $data = trim($data);
   $data = stripslashes($data);
   $data = htmlspecialchars($data);
   return $data;
}
?>

<h2>Send a Love Message</h2>
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>"> 
   Name: <input type="text" name="name">
   <br><br>
   E-mail: <input type="text" name="email">
   <br><br>
   Gender:
   <input type="radio" name="gender" value="female">Female
   <input type="radio" name="gender" value="male">Male
   <br><br>
   <input type="radio" name="message" value="intelligent">You are so intelligent.
   <br><br>
   <input type="radio" name="message" value="love">I am so in love with you its unbelievable.
   <br><br>
   <input type="radio" name="message" value="ineffable">You are ineffable.
   <br><br>
   <input type="submit" name="submit" value="Submit"> 
</form>


<?php
echo "<h2>Your Input:</h2>";
echo $name;
echo "<br>";
echo $email;
echo "<br>";
echo $message;
echo "<br>";
echo $gender;
?>





<h2>
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">  
Name: <input type="text" name="name">
   <br><br>
Message: <input type-"text" name="LoveMessage">
  <br><br>
<input type="submit" name="Send" value="post"> 
<h2/>


</body>
</html>
