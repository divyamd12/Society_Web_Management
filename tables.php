<?php 

session_start();
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
		<i class="fa fa-bars" id="menu-btn" onclick="openmenu()"></i>
		<i class="fa fa-times" id="close-btn" onclick="closemenu()"></i>
		<img src="images/logo.png" class="logo">
		<input type="text" class="form-control">
		<span class="input-group-text"><i class="fa fa-search"></i></span>

	</div>
<div class="menu-bar">
	<ul>
		<li><a href="#">Hi <?php echo $_SESSION['username'];?></a></li>
		<li><a href="index.html"><i class="fa fa-home"></i>Home</a></li>
		<li><a href="index.html"><i class="fa fa-sign-out"></i>Log-out</a></li>
		<li><a href="#"><i class="fa fa-address-book"></i>Contact-Us</a></li>
	</ul>
</div>
</div>

<section class="header">
<div class="card">
  <img src="images/resident1.png" style="max-width:10%;" class="card-img-top" alt="...">

  <div class="card-body">
    <h5 class="card-title">Residents Details</h5>
    <p class="card-text">Some quick example text to build on the card title and
		 make up the bulk of the card's content.</p>
    <a href="resident.php" class="btn btn-primary">Go somewhere</a>
  </div>
</div>
<div class="card">
  <img src="images/employee1.png" style="max-width:10%;" class="card-img-top" alt="...">

  <div class="card-body">
    <h5 class="card-title">Employee Details</h5>
    <p class="card-text">Some quick example text to build on the card title and
		 make up the bulk of the card's content.</p>
    <a href="employee.php" class="btn btn-primary">Go somewhere</a>
  </div>
</div>
<div class="card">
  <img src="images/admin.webp" style="max-width:10%;" class="card-img-top" alt="...">

  <div class="card-body">
    <h5 class="card-title">Administrator Details</h5>
    <p class="card-text">Some quick example text to build on the card title and
		 make up the bulk of the card's content.</p>
    <a href="administrator.php" class="btn btn-primary">Go somewhere</a>
  </div>
</div>

<div class="card">
  <img src="images/car.png" style="max-width:10%;" class="card-img-top" alt="...">

  <div class="card-body">
    <h5 class="card-title">Parking Details</h5>
    <p class="card-text">Some quick example text to build on the card title and
		 make up the bulk of the card's content.</p>
    <a href="resident_procedure.php" class="btn btn-primary">Go somewhere</a>
  </div>
</div>

<div class="card">
  <img src="images/hall.png" style="max-width:10%;" class="card-img-top" alt="...">

  <div class="card-body">
    <h5 class="card-title">Hall Details</h5>
    <p class="card-text">Some quick example text to build on the card title and
		 make up the bulk of the card's content.</p>
    <a href="hall_occupancy.php" class="btn btn-primary">Go somewhere</a>
  </div>
</div>


<div class="card">
  <img src="images/visitor1.png" style="max-width:10%;" class="card-img-top" alt="...">

  <div class="card-body">
    <h5 class="card-title">Visitor Details</h5>
    <p class="card-text">Some quick example text to build on the card title and
		 make up the bulk of the card's content.</p>
    <a href="visitor.php" class="btn btn-primary">Go somewhere</a>
  </div>
</div>



	<!-- <div class="side-menu" id="side-menu">
		<ul>
			<li><a href="society.php">Society <i class="fa fa-angle-right"></i></a><ul>
				<li>Information</li>
				<li>Society ID</li>
				<li>Address</li>
				<li>Pincode</li>
				<li>City</li>
			</ul></li>


			<li><a href="resident.php">Resident <i class="fa fa-angle-right"></i></a><ul>
				<li>Information</li>
				<li>Resident ID</li>
				<li>Owner Name</li>
				<li>Parking No</li>
			</ul></li>
			

			<li><a href="Employee.php">Employee <i class="fa fa-angle-right"></i></a><ul>
				<li>Information</li>
				<li>Employee ID</li>
				<li>Employee Name</li>
				<li>Entry Time</li>
			</ul></li>
			

			<li><a href="visitor.php">Visitor <i class="fa fa-angle-right"></i></a><ul>
				<li>Information</li>
				<li>Visitor ID</li>
				<li>Visior Name</li>
				<li>Visitor Type</li>
				<li>Entry Time</li>
			</ul></li>
			

			<li><a href="administrator.php">Administrator <i class="fa fa-angle-right"></i></a><ul>
				<li>Information</li>
				<li>Username</li>
				<li>Password</li>
			</ul></li>
			
			

		</ul>		
	</div> -->
</section>
<script type="text/javascript">
function openmenu()
{
	document.getElementById("side-menu").style.display="block";
	document.getElementById("menu-btn").style.display="block";
	document.getElementById("close-btn").style.display="block";
}	

function closemenu()
{
	document.getElementById("side-menu").style.display=none;
	document.getElementById("menu-btn").style.display=none;
	document.getElementById("close-btn").style.display=none;
}	

</script>

</body>
</html>