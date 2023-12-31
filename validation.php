<?php
session_start();

include("connect.php");
error_reporting();

$name=$_POST['user'];
$pass=$_POST['password'];

$query="select * from signin where name ='$name' && password='$pass'";
$result=mysqli_query($conn,$query);
$num=mysqli_num_rows($result);

if ($num) {
	$_SESSION['username']=$name;
	header('location:tables.php');
}
else
{
	header('location:login.php');
}
?>