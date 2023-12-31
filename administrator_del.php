<?php
include("connect.php");
error_reporting(0);
$_GET['rn'];
$_GET['n'];
?>



<!DOCTYPE html>
<html>
<head>
	<title>Society Management System</title>
<link rel="stylesheet" type="text/css" href="tablecss.css">
	<!-- CSS only -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" >
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<!-- JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" ></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" ></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
<div class="top-nav-bar">
	<div class="search-box">
		<img src="images/logo.png" class="logo">
		<input type="text" class="form-control">
		<span class="input-group-text"><i class="fa fa-search"></i></span>
	</div>
<div class="menu-bar">
	<ul>
		<li><a href="frontpage.html"><i class="fa fa-home"></i>Home</a></li>
		<li><a href="frontpage.html"><i class="fa fa-sign-out"></i>Log-out</a></li>
		<li><a href="tables.php"><i class="fa fa-address-book"></i>Database</a></li>
	</ul>
</div>
</div>

<div class="container">
<h2>Delete Administrator</h2>
<form action="" method="GET">
	Administratir ID<input type="text" name="id" value=""><br></br>
	<input type="submit" name="submit" value="submit">

</form>

<?php 

if($_GET['submit']){
	$rn1=$_GET['id'];


	$query="DELETE FROM signin where id='$rn1'";
	$data=mysqli_query($conn,$query);
	if($data){
		echo "<font color='green'>Record deleted successfully <a href='administrator.php'>Check updated list here</a>";}
		else{
			echo "<font color='red'>Record NOT deleted!!";
		}

		
	}
	else{
		echo "<font color='blue'>Click on update button to save changes";
	}


?>
</div>
</body>
</html>