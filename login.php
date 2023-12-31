<?php
include("connect.php");
error_reporting();

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
		<li><a href="index.html"><i class="fa fa-home"></i>Home</a></li>
		<li><a href="index.html"><i class="fa fa-sign-out"></i>Log-out</a></li>
	</ul>
</div>
</div>

<div class="container">
	<div class="row">
		<div class="col-lg-6">
			<h2>Login Form</h2>
			<form action="validation.php" method="post">
				<div class="form-group">
					<label>Username</label>
					<input type="text" name="user" class="form-control1">


				</div>


				<div class="form-group">
					<label>Password</label>
					<input type="password" name="password" class="form-control1">


				</div>
				<button type="submit"class="btn btn-primary">Login</button>
			</form>
		</div>
			<div class="col-lg-6">
			<h2>Sign Up Form</h2>
			<form action="registration.php" method="post">
				<div class="form-group">
					<label>Username</label>
					<input type="text" name="user" class="form-control1">


				</div>


				<div class="form-group">
					<label>Password</label>
					<input type="password" name="password" class="form-control1">


				</div>
				<button type="submit" class="btn btn-primary">Signin</button>
			</form>



		</div>
	</div>
</div>
</body>
</html>