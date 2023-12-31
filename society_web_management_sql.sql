-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: May 16, 2023 at 09:51 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `miniproject`
--
CREATE DATABASE IF NOT EXISTS `miniproject` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `miniproject`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `check_hall`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_hall` (IN `rid` INT, IN `hid` INT, IN `rdate` DATE, IN `flat1` INT(50), IN `type1` VARCHAR(50))   BEGIN
declare end_loop INT default 0;
declare rid1 int;
declare hid1 int;
declare rdate1 date;
declare c1 CURSOR FOR select Date_Booked from hall_bookings where Request_ID=hid;
declare continue handler for not found set end_loop=1;
open c1;

fill_table: LOOP
fetch from c1 into rdate1;
IF (end_loop=1) THEN
INSERT INTO hall_bookings VALUES (rid, hid, rdate);
UPDATE hall_occupancy SET status="Booked" where Request_ID=rid;
IF (type1="Owner") THEN
IF (hid=1) THEN
UPDATE charges SET Hall_Booking=Hall_Booking+5000 where Flat_number=flat1;
ELSEIF (hid=2) THEN
UPDATE charges SET Hall_Booking=Hall_Booking+5000 where Flat_number=flat1;
ELSEIF (hid=3) THEN
UPDATE charges SET Hall_Booking=Hall_Booking+9999 where Flat_number=flat1;
ELSEIF (hid=4) THEN
UPDATE charges SET Hall_Booking=Hall_Booking+6000 where Flat_number=flat1;
ELSE
UPDATE charges SET Hall_Booking=Hall_Booking+7000 where Flat_number=flat1;
END IF;
END IF;

IF (type1="Tenant") THEN
IF (hid=1) THEN
UPDATE charges SET Hall_Booking=Hall_Booking+6000 where Flat_number=flat1;
ELSEIF (hid=2) THEN
UPDATE charges SET Hall_Booking=Hall_Booking+6000 where Flat_number=flat1;
ELSEIF (hid=3) THEN
UPDATE charges SET Hall_Booking=Hall_Booking+10999 where Flat_number=flat1;
ELSEIF (hid=4) THEN
UPDATE charges SET Hall_Booking=Hall_Booking+7000 where Flat_number=flat1;
ELSE
UPDATE charges SET Hall_Booking=Hall_Booking+8000 where Flat_number=flat1;
END IF;
END IF;



leave fill_table;
END IF;

IF (rdate1=rdate) THEN
UPDATE hall_occupancy SET status="Not available" where Request_ID=rid;
leave fill_table;
END IF;
END LOOP fill_table;
close c1;
END$$

DROP PROCEDURE IF EXISTS `check_parking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_parking` (IN `ID1` INT, IN `flat1` VARCHAR(10), IN `re_date` DATE)   BEGIN
declare end_loop INT default 0;
declare ipark int;
declare park1 varchar(10);
declare c1 CURSOR FOR select parking_no from visitor_parking order by parking_no;
declare continue handler for not found set end_loop=1;
open c1;
SET ipark=1;
fill_table: LOOP
fetch from c1 into park1;

IF (end_loop=1) THEN
IF (ipark<21) THEN
update parking_request set status="accepted", parking_alloted=concat('V',ipark) where ID=ID1;
INSERT INTO visitor_parking(flat_no,parking_no,date_occ) VALUES(flat1, concat("V",ipark),re_date);
leave fill_table;

ELSE
update parking_request set status="Not avaialble" where ID=ID1;
leave fill_table;
END IF;
END IF;

IF (park1 in (select parking_no from visitor_parking) ) THEN
SET ipark=ipark+1;
ELSE 
update parking_request set status="accepted", parking_alloted=concat('V',ipark) where ID=ID1;
INSERT INTO visitor_parking(flat_no,parking_no,date_occ) VALUES(flat1, concat("V",ipark),re_date);
leave fill_table;
END IF;
END LOOP fill_table;
close c1;
END$$

DROP PROCEDURE IF EXISTS `date_remove`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `date_remove` ()   BEGIN
declare end_loop INT default 0;
declare date1 date;
declare c1 CURSOR FOR select date_occ from visitor_parking;
declare continue handler for not found set end_loop=1;
open c1;

fill_table: LOOP
fetch from c1 into date1;

IF (end_loop=1) THEN
leave fill_table;
END IF;

IF (date1<CURDATE()) THEN
delete from visitor_parking where date_occ=date1;
END IF;
END LOOP fill_table;
close c1;
END$$

DROP PROCEDURE IF EXISTS `mark_bonus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_bonus` ()   BEGIN

INSERT INTO employee_expense
SET amount=(SELECT sum(emp_salary)*0.15 from employee);

END$$

DROP PROCEDURE IF EXISTS `mark_maintenance_all`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_maintenance_all` ()   BEGIN

declare end_loop INT default 0;
declare maintenance1 int;
declare id1 int;
declare c1 CURSOR FOR select Resident_ID, maintenance from charges;
declare continue handler for not found set end_loop=1;
open c1;
fill_table: LOOP
fetch from c1 into id1, maintenance1;

IF (end_loop=1) THEN
leave fill_table;
END IF;
update charges set maintenance=maintenance+5000 where Resident_ID=id1;
END LOOP fill_table;
close c1;
END$$

DROP PROCEDURE IF EXISTS `mark_salary`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_salary` ()   BEGIN

INSERT INTO employee_expense
SET amount=(SELECT sum(emp_salary) from employee);

END$$

DROP PROCEDURE IF EXISTS `newparking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `newparking` (IN `flatno` VARCHAR(10))   begin
    declare x int;
    declare y varchar(30);
    select count(parking_id) from parking into x;
    
	
	if x <= 80 then
		update parking set parking_no = concat(flatno,'-1') where parking.parking_no=flatno;
		insert into parking(soc_id,res_flatno,parking_no) values (1,flatno,concat(flatno,"-2"));
        
        UPDATE charges SET extra_parking=extra_parking+5000 where Flat_number=flatno;


	end if;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `administrator`
--

DROP TABLE IF EXISTS `administrator`;
CREATE TABLE `administrator` (
  `admin_id` int(11) NOT NULL,
  `admin_name` varchar(30) NOT NULL,
  `admin_password` varchar(30) DEFAULT 'admin',
  `admin_phone` int(10) DEFAULT NULL,
  `soc_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `charges`
--

DROP TABLE IF EXISTS `charges`;
CREATE TABLE `charges` (
  `Flat_number` varchar(255) NOT NULL,
  `Resident_ID` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `Maintenance` int(11) NOT NULL DEFAULT 0,
  `Visitor_Parking` int(11) NOT NULL DEFAULT 0,
  `Hall_Booking` int(11) NOT NULL DEFAULT 0,
  `Extra_Parking` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `charges`
--

INSERT INTO `charges` (`Flat_number`, `Resident_ID`, `type`, `Maintenance`, `Visitor_Parking`, `Hall_Booking`, `Extra_Parking`) VALUES
('A 101', 10, 'Owner', 15000, 4000, 11000, 0),
('A 102', 11, 'Owner', 15000, 2000, 11000, 5000),
('A 103', 12, 'Owner', 15000, 2000, 11000, 0),
('A 104', 13, 'Tenant', 17000, 0, 11000, 0),
('A 105', 14, 'Owner', 15000, 0, 11000, 0),
('A 106', 15, 'Tenant', 17000, 0, 11000, 0),
('A 107', 16, 'Owner', 15000, 0, 11000, 0),
('A 108', 17, 'Tenant', 17000, 0, 11000, 0),
('A 109', 18, 'Owner', 15000, 0, 11000, 5000),
('A 110', 19, 'Owner', 15000, 0, 11000, 0),
('A 111', 20, 'Tenant', 17000, 0, 11000, 0),
('A 112', 21, 'Tenant', 17000, 0, 11000, 0),
('B 113', 22, 'Owner', 15000, 0, 11000, 0),
('B 114', 23, 'Owner', 15000, 0, 11000, 0),
('B 115', 24, 'Tenant', 17000, 0, 11000, 0),
('B 116', 25, 'Tenant', 17000, 0, 11000, 0),
('B 117', 26, 'Owner', 15000, 0, 11000, 0),
('B 118', 27, 'Owner', 15000, 2000, 11000, 0),
('B 119', 28, 'Tenant', 17000, 0, 11000, 0),
('B 120', 29, 'Tenant', 17000, 0, 11000, 0),
('B 121', 30, 'Owner', 15000, 0, 11000, 0),
('B 122', 31, 'Owner', 15000, 0, 11000, 0),
('B 123', 32, 'Tenant', 17000, 0, 11000, 0),
('B 124', 33, 'Owner', 15000, 2000, 11000, 0),
('C 125', 34, 'Owner', 15000, 0, 11000, 0),
('C 126', 35, 'Owner', 15000, 0, 11000, 0),
('C 127', 36, 'Owner', 15000, 0, 11000, 0),
('C 128', 37, 'Tenant', 17000, 0, 11000, 0),
('C 129', 38, 'Tenant', 17000, 0, 11000, 0),
('C 130', 39, 'Tenant', 17000, 0, 11000, 0),
('C 131', 40, 'Tenant', 17000, 0, 11000, 0),
('C 132', 41, 'Owner', 15000, 0, 11000, 0),
('C 133', 42, 'Owner', 15000, 0, 11000, 0),
('C 134', 43, 'Owner', 15000, 0, 11000, 0),
('C 135', 44, 'Tenant', 17000, 0, 11000, 0),
('C 136', 45, 'Tenant', 17000, 0, 11000, 0),
('D 137', 46, 'Owner', 15000, 0, 11000, 0),
('D 138', 47, 'Owner', 15000, 0, 11000, 0),
('D 139', 48, 'Owner', 15000, 0, 11000, 0),
('D 140', 49, 'Owner', 15000, 0, 11000, 0),
('D 141', 50, 'Tenant', 17000, 0, 11000, 0),
('D 142', 51, 'Owner', 15000, 0, 11000, 0),
('D 143', 52, 'Tenant', 17000, 0, 11000, 0),
('D 144', 53, 'Tenant', 17000, 0, 11000, 0),
('D 145', 54, 'Tenant', 17000, 0, 11000, 0),
('D 146', 55, 'Tenant', 17000, 0, 11000, 0),
('D 147', 56, 'Tenant', 17000, 0, 11000, 0),
('D 148', 57, 'Tenant', 17000, 0, 11000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `emp_id` int(11) NOT NULL,
  `emp_name` varchar(30) NOT NULL,
  `emp_type` varchar(30) NOT NULL,
  `emp_salary` decimal(7,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`emp_id`, `emp_name`, `emp_type`, `emp_salary`) VALUES
(3, 'Ram', 'House Keeper', 6000.00);

--
-- Triggers `employee`
--
DROP TRIGGER IF EXISTS `eentrytime`;
DELIMITER $$
CREATE TRIGGER `eentrytime` AFTER INSERT ON `employee` FOR EACH ROW begin
	declare etime datetime default now();
    declare emp int ;
    #etime=select now();
    select emp_id from employee where employee.emp_id = new.emp_id into emp;
    insert into employee_timings(entry_time,emp_id) values (etime,emp);
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_expense`
--

DROP TABLE IF EXISTS `employee_expense`;
CREATE TABLE `employee_expense` (
  `ID` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_expense`
--

INSERT INTO `employee_expense` (`ID`, `amount`, `date`) VALUES
(1, 6000, '2023-05-16'),
(2, 900, '2023-05-16'),
(3, 6000, '2023-05-17');

-- --------------------------------------------------------

--
-- Table structure for table `employee_timings`
--

DROP TABLE IF EXISTS `employee_timings`;
CREATE TABLE `employee_timings` (
  `time_id` int(11) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `entry_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_timings`
--

INSERT INTO `employee_timings` (`time_id`, `emp_id`, `entry_time`) VALUES
(3, 3, '2023-05-16 23:15:27');

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
CREATE TABLE `expenses` (
  `ID` int(11) NOT NULL,
  `Time` date NOT NULL DEFAULT current_timestamp(),
  `Electricity` int(11) NOT NULL,
  `Water` int(11) NOT NULL,
  `Legal` int(11) NOT NULL,
  `Miscellaneous` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`ID`, `Time`, `Electricity`, `Water`, `Legal`, `Miscellaneous`) VALUES
(1, '2023-05-15', 1000, 2000, 3000, 12000),
(2, '2023-05-16', 10000, 15000, 20000, 7500);

-- --------------------------------------------------------

--
-- Table structure for table `hall`
--

DROP TABLE IF EXISTS `hall`;
CREATE TABLE `hall` (
  `hall_id` int(11) NOT NULL,
  `hall_name` varchar(30) DEFAULT NULL,
  `hall_charges` float(6,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hall`
--

INSERT INTO `hall` (`hall_id`, `hall_name`, `hall_charges`) VALUES
(1, 'Yoga', 5000.00),
(2, 'Zumba', 5000.00),
(3, 'Party', 9999.00),
(4, 'Entertainment', 6000.00),
(5, 'Amphitheatre', 7000.00);

-- --------------------------------------------------------

--
-- Table structure for table `hall_bookings`
--

DROP TABLE IF EXISTS `hall_bookings`;
CREATE TABLE `hall_bookings` (
  `ID` int(11) NOT NULL,
  `Request_ID` int(11) NOT NULL,
  `Date_Booked` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hall_bookings`
--

INSERT INTO `hall_bookings` (`ID`, `Request_ID`, `Date_Booked`) VALUES
(4, 4, '2023-05-11'),
(5, 2, '2023-05-11'),
(6, 1, '2023-05-11'),
(7, 2, '2023-05-11'),
(9, 1, '2023-05-17'),
(10, 1, '2023-05-16'),
(11, 4, '2023-05-17'),
(13, 3, '2023-05-19'),
(14, 2, '2023-05-17'),
(17, 4, '2023-05-20');

-- --------------------------------------------------------

--
-- Table structure for table `hall_occupancy`
--

DROP TABLE IF EXISTS `hall_occupancy`;
CREATE TABLE `hall_occupancy` (
  `Request_ID` int(11) NOT NULL,
  `f_hall_id` int(11) DEFAULT NULL,
  `date_from` date DEFAULT NULL,
  `Status` varchar(50) NOT NULL DEFAULT 'TBT',
  `Flat_Number` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hall_occupancy`
--

INSERT INTO `hall_occupancy` (`Request_ID`, `f_hall_id`, `date_from`, `Status`, `Flat_Number`) VALUES
(14, 2, '2023-05-17', 'Booked', 'A 101'),
(15, 1, '2023-05-17', 'Not available', 'A 102'),
(16, 2, '2023-05-17', 'Not available', 'A 102'),
(17, 4, '2023-05-20', 'Booked', 'A 102');

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
CREATE TABLE `location` (
  `loc_pin` int(6) NOT NULL,
  `loc_city` varchar(30) NOT NULL,
  `loc_state` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`loc_pin`, `loc_city`, `loc_state`) VALUES
(400012, 'Mumbai', 'Maharashtra'),
(411001, 'Pune', 'Maharashtra'),
(411057, 'Pune', 'Maharashtra'),
(411078, 'Pune', 'Maharashtra');

-- --------------------------------------------------------

--
-- Table structure for table `parking`
--

DROP TABLE IF EXISTS `parking`;
CREATE TABLE `parking` (
  `parking_id` int(11) NOT NULL,
  `soc_id` int(11) NOT NULL,
  `res_flatno` varchar(10) NOT NULL,
  `parking_no` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parking`
--

INSERT INTO `parking` (`parking_id`, `soc_id`, `res_flatno`, `parking_no`) VALUES
(42, 1, 'A 101', 'A 101'),
(43, 1, 'A 103', 'A 103'),
(44, 1, 'A 102', 'A 102-1'),
(45, 1, 'A 104', 'A 104'),
(46, 1, 'A 105', 'A 105'),
(47, 1, 'A 106', 'A 106'),
(48, 1, 'A 107', 'A 107'),
(49, 1, 'A 108', 'A 108'),
(50, 1, 'A 109', 'A 109-1'),
(51, 1, 'A 110', 'A 110'),
(52, 1, 'A 111', 'A 111'),
(53, 1, 'A 112', 'A 112'),
(54, 1, 'B 113', 'B 113'),
(55, 1, 'B 114', 'B 114'),
(56, 1, 'B 115', 'B 115'),
(57, 1, 'B 116', 'B 116'),
(58, 1, 'B 117', 'B 117'),
(59, 1, 'B 118', 'B 118'),
(60, 1, 'B 119', 'B 119'),
(61, 1, 'B 120', 'B 120'),
(62, 1, 'B 121', 'B 121'),
(63, 1, 'B 122', 'B 122'),
(64, 1, 'B 123', 'B 123'),
(65, 1, 'B 124', 'B 124'),
(66, 1, 'C 125', 'C 125'),
(67, 1, 'C 126', 'C 126'),
(68, 1, 'C 127', 'C 127'),
(69, 1, 'C 128', 'C 128'),
(70, 1, 'C 129', 'C 129'),
(71, 1, 'C 130', 'C 130'),
(72, 1, 'C 131', 'C 131'),
(73, 1, 'C 132', 'C 132'),
(74, 1, 'C 133', 'C 133'),
(75, 1, 'C 134', 'C 134'),
(76, 1, 'C 135', 'C 135'),
(77, 1, 'C 136', 'C 136'),
(78, 1, 'D 137', 'D 137'),
(79, 1, 'D 138', 'D 138'),
(80, 1, 'D 139', 'D 139'),
(81, 1, 'D 140', 'D 140'),
(82, 1, 'D 141', 'D 141'),
(83, 1, 'D 142', 'D 142'),
(84, 1, 'D 143', 'D 143'),
(85, 1, 'D 144', 'D 144'),
(86, 1, 'D 145', 'D 145'),
(87, 1, 'D 146', 'D 146'),
(88, 1, 'D 147', 'D 147'),
(89, 1, 'D 148', 'D 148'),
(90, 1, 'A 102', 'A 102-2'),
(91, 1, 'A 109', 'A 109-2');

-- --------------------------------------------------------

--
-- Table structure for table `parking_request`
--

DROP TABLE IF EXISTS `parking_request`;
CREATE TABLE `parking_request` (
  `ID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `faltno` varchar(20) DEFAULT NULL,
  `date_request` date DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `parking_alloted` varchar(50) DEFAULT 'TBT'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parking_request`
--

INSERT INTO `parking_request` (`ID`, `name`, `type`, `faltno`, `date_request`, `status`, `parking_alloted`) VALUES
(77, 'kamal Dholwani', '1', 'A 101', '2023-05-17', 'accepted', 'V1'),
(78, 'Sonali More', '1', 'A 102', '2023-05-17', 'accepted', 'V2'),
(79, 'Gaurav Dave', '1', 'A 103', '2023-05-18', 'accepted', 'V3'),
(80, 'Varsha Zope', '1', 'B 118', '2023-05-18', 'accepted', 'V4'),
(81, 'Aditya', '1', 'A 101', '2023-05-16', 'accepted', 'V5'),
(82, 'Lishika Zope', '1', 'B 124', '2023-05-20', 'accepted', 'V5');

-- --------------------------------------------------------

--
-- Table structure for table `resident`
--

DROP TABLE IF EXISTS `resident`;
CREATE TABLE `resident` (
  `res_id` int(11) NOT NULL,
  `res_name` varchar(30) NOT NULL,
  `res_type` varchar(30) DEFAULT NULL,
  `res_flatno` varchar(30) NOT NULL,
  `soc_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `resident`
--

INSERT INTO `resident` (`res_id`, `res_name`, `res_type`, `res_flatno`, `soc_id`) VALUES
(10, 'Divyam', 'Owner', 'A 101', 1),
(11, 'Shashwat', 'Owner', 'A 102', 1),
(12, 'Soham', 'Owner', 'A 103', 1),
(13, 'Raj', 'Tenant', 'A 104', 1),
(14, 'Ram', 'Owner', 'A 105', 1),
(15, 'Ravi', 'Tenant', 'A 106', 1),
(16, 'Aditya', 'Owner', 'A 107', 1),
(17, 'Omkar', 'Tenant', 'A 108', 1),
(18, 'Gaurav', 'Owner', 'A 109', 1),
(19, 'Sahil', 'Owner', 'A 110', 1),
(20, 'Chinmay', 'Tenant', 'A 111', 1),
(21, 'Parth', 'Tenant', 'A 112', 1),
(22, 'Ajay', 'Owner', 'B 113', 1),
(23, 'Atul', 'Owner', 'B 114', 1),
(24, 'Viraj', 'Tenant', 'B 115', 1),
(25, 'Swapnil', 'Tenant', 'B 116', 1),
(26, 'Vivek', 'Owner', 'B 117', 1),
(27, 'Vivan', 'Owner', 'B 118', 1),
(28, 'Viren', 'Tenant', 'B 119', 1),
(29, 'Saniya', 'Tenant', 'B 120', 1),
(30, 'Soniya', 'Owner', 'B 121', 1),
(31, 'Shreya', 'Owner', 'B 122', 1),
(32, 'Vijay', 'Tenant', 'B 123', 1),
(33, 'Sanjay', 'Owner', 'B 124', 1),
(34, 'Amir', 'Owner', 'C 125', 1),
(35, 'Ayan', 'Owner', 'C 126', 1),
(36, 'Ryan', 'Owner', 'C 127', 1),
(37, 'Aryan', 'Tenant', 'C 128', 1),
(38, 'Rehan', 'Tenant', 'C 129', 1),
(39, 'Divyansh', 'Tenant', 'C 130', 1),
(40, 'Kshitij', 'Tenant', 'C 131', 1),
(41, 'Aarya', 'Owner', 'C 132', 1),
(42, 'Arnav', 'Owner', 'C 133', 1),
(43, 'Yogesh', 'Owner', 'C 134', 1),
(44, 'Sachin', 'Tenant', 'C 135', 1),
(45, 'Dravid', 'Tenant', 'C 136', 1),
(46, 'Varsha', 'Owner', 'D 137', 1),
(47, 'Sarika', 'Owner', 'D 138', 1),
(48, 'Shamla', 'Owner', 'D 139', 1),
(49, 'Nikhil', 'Owner', 'D 140', 1),
(50, 'Anupama', 'Tenant', 'D 141', 1),
(51, 'Bhushan', 'Owner', 'D 142', 1),
(52, 'Alex', 'Tenant', 'D 143', 1),
(53, 'Jack', 'Tenant', 'D 144', 1),
(54, 'Jill', 'Tenant', 'D 145', 1),
(55, 'Rohit', 'Tenant', 'D 146', 1),
(56, 'Krish', 'Tenant', 'D 147', 1),
(57, 'Manisha', 'Tenant', 'D 148', 1);

--
-- Triggers `resident`
--
DROP TRIGGER IF EXISTS `add_charge_entry`;
DELIMITER $$
CREATE TRIGGER `add_charge_entry` AFTER INSERT ON `resident` FOR EACH ROW BEGIN



END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `alotpark`;
DELIMITER $$
CREATE TRIGGER `alotpark` AFTER INSERT ON `resident` FOR EACH ROW begin
declare socid varchar(10);
SET socid=1;


insert into parking (parking_no,soc_id,res_flatno) values (new.res_flatno,socid,new.res_flatno);


if (new.res_type="Owner") THEN

INSERT INTO charges
SET Resident_ID=new.res_id,
Flat_number=new.res_flatno,
type=new.res_type,
maintenance=10000;

ELSE
INSERT INTO charges
SET Resident_ID=new.res_id,
Flat_number=new.res_flatno,
type=new.res_type,
maintenance=12000;
END IF;  
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `signin`
--

DROP TABLE IF EXISTS `signin`;
CREATE TABLE `signin` (
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `signin`
--

INSERT INTO `signin` (`name`, `password`) VALUES
('divyam', '123'),
('shashwat', 'sh123'),
('Soham ', 'soham123');

-- --------------------------------------------------------

--
-- Table structure for table `society`
--

DROP TABLE IF EXISTS `society`;
CREATE TABLE `society` (
  `soc_id` int(11) NOT NULL,
  `soc_name` varchar(30) NOT NULL,
  `soc_pin` int(6) NOT NULL,
  `avail_parking` int(11) DEFAULT 50
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `society`
--

INSERT INTO `society` (`soc_id`, `soc_name`, `soc_pin`, `avail_parking`) VALUES
(1, 'ABC', 411001, 65),
(3, 'Titanium', 411057, 45),
(4, 'Sapphire', 411057, 41),
(5, 'Diamond', 400012, 20);

-- --------------------------------------------------------

--
-- Table structure for table `visitor`
--

DROP TABLE IF EXISTS `visitor`;
CREATE TABLE `visitor` (
  `vis_id` int(11) NOT NULL,
  `vis_name` varchar(30) NOT NULL,
  `vis_phone` int(10) NOT NULL,
  `soc_id` int(11) NOT NULL DEFAULT 1,
  `flatno` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `visitor`
--

INSERT INTO `visitor` (`vis_id`, `vis_name`, `vis_phone`, `soc_id`, `flatno`) VALUES
(82, 'kamal Dholwani', 2147483647, 1, 'A 101'),
(83, 'Sonali More', 2147483647, 1, 'A 102'),
(84, 'Gaurav Dave', 2147483647, 1, 'A 103'),
(85, 'Varsha Zope', 45678954, 1, 'B 118'),
(86, 'Aditya', 12356879, 1, 'A 101'),
(87, 'Shirish Zope', 895214759, 1, 'B 122'),
(88, 'Lishika Zope', 2147483647, 1, 'B 124');

--
-- Triggers `visitor`
--
DROP TRIGGER IF EXISTS `ventrytime`;
DELIMITER $$
CREATE TRIGGER `ventrytime` AFTER INSERT ON `visitor` FOR EACH ROW begin
	declare etime datetime default now() ;
    declare vis int ;
    #etime=select now();
    select vis_id from visitor  where visitor.vis_id = new.vis_id into vis;
    insert into visitor_timings(entry_time,vis_id) values (etime ,vis);
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `visitor_parking`
--

DROP TABLE IF EXISTS `visitor_parking`;
CREATE TABLE `visitor_parking` (
  `ID` int(11) NOT NULL,
  `flat_no` varchar(10) NOT NULL,
  `parking_no` varchar(20) NOT NULL,
  `date_occ` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `visitor_parking`
--

INSERT INTO `visitor_parking` (`ID`, `flat_no`, `parking_no`, `date_occ`) VALUES
(64, 'A 101', 'V1', '2023-05-17'),
(65, 'A 102', 'V2', '2023-05-17'),
(66, 'A 103', 'V3', '2023-05-18'),
(67, 'B 118', 'V4', '2023-05-18'),
(69, 'B 124', 'V5', '2023-05-20');

--
-- Triggers `visitor_parking`
--
DROP TRIGGER IF EXISTS `visitor_charge`;
DELIMITER $$
CREATE TRIGGER `visitor_charge` AFTER INSERT ON `visitor_parking` FOR EACH ROW BEGIN
UPDATE charges
SET visitor_parking=visitor_parking+2000 
where Flat_number=new.flat_no;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `visitor_timings`
--

DROP TABLE IF EXISTS `visitor_timings`;
CREATE TABLE `visitor_timings` (
  `time_id` int(11) NOT NULL,
  `vis_id` int(11) DEFAULT NULL,
  `entry_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `visitor_timings`
--

INSERT INTO `visitor_timings` (`time_id`, `vis_id`, `entry_time`) VALUES
(82, 82, '2023-05-16 22:46:15'),
(83, 83, '2023-05-16 22:46:49'),
(84, 84, '2023-05-16 22:47:19'),
(85, 85, '2023-05-17 01:13:16'),
(86, 86, '2023-05-17 01:13:49'),
(87, 87, '2023-05-17 01:14:26'),
(88, 88, '2023-05-17 01:14:57');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `administrator`
--
ALTER TABLE `administrator`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `charges`
--
ALTER TABLE `charges`
  ADD PRIMARY KEY (`Resident_ID`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`emp_id`);

--
-- Indexes for table `employee_expense`
--
ALTER TABLE `employee_expense`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `employee_timings`
--
ALTER TABLE `employee_timings`
  ADD PRIMARY KEY (`time_id`),
  ADD KEY `emp_id` (`emp_id`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `hall`
--
ALTER TABLE `hall`
  ADD PRIMARY KEY (`hall_id`);

--
-- Indexes for table `hall_occupancy`
--
ALTER TABLE `hall_occupancy`
  ADD PRIMARY KEY (`Request_ID`),
  ADD KEY `f_hall_id` (`f_hall_id`);

--
-- Indexes for table `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`loc_pin`);

--
-- Indexes for table `parking`
--
ALTER TABLE `parking`
  ADD PRIMARY KEY (`parking_id`);

--
-- Indexes for table `parking_request`
--
ALTER TABLE `parking_request`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `resident`
--
ALTER TABLE `resident`
  ADD PRIMARY KEY (`res_flatno`);

--
-- Indexes for table `signin`
--
ALTER TABLE `signin`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `society`
--
ALTER TABLE `society`
  ADD PRIMARY KEY (`soc_id`);

--
-- Indexes for table `visitor`
--
ALTER TABLE `visitor`
  ADD PRIMARY KEY (`vis_id`);

--
-- Indexes for table `visitor_parking`
--
ALTER TABLE `visitor_parking`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `visitor_timings`
--
ALTER TABLE `visitor_timings`
  ADD PRIMARY KEY (`time_id`),
  ADD KEY `vis_id` (`vis_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `administrator`
--
ALTER TABLE `administrator`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `emp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `employee_expense`
--
ALTER TABLE `employee_expense`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `employee_timings`
--
ALTER TABLE `employee_timings`
  MODIFY `time_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hall_occupancy`
--
ALTER TABLE `hall_occupancy`
  MODIFY `Request_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `parking`
--
ALTER TABLE `parking`
  MODIFY `parking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `parking_request`
--
ALTER TABLE `parking_request`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `society`
--
ALTER TABLE `society`
  MODIFY `soc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `visitor`
--
ALTER TABLE `visitor`
  MODIFY `vis_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `visitor_parking`
--
ALTER TABLE `visitor_parking`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `visitor_timings`
--
ALTER TABLE `visitor_timings`
  MODIFY `time_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `administrator`
--
ALTER TABLE `administrator`
  ADD CONSTRAINT `administrator_ibfk_1` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`);

--
-- Constraints for table `employee_timings`
--
ALTER TABLE `employee_timings`
  ADD CONSTRAINT `employee_timings_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`);

--
-- Constraints for table `hall_occupancy`
--
ALTER TABLE `hall_occupancy`
  ADD CONSTRAINT `hall_occupancy_ibfk_1` FOREIGN KEY (`f_hall_id`) REFERENCES `hall` (`hall_id`);

--
-- Constraints for table `parking`
--
ALTER TABLE `parking`
  ADD CONSTRAINT `parking_ibfk_1` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`);

--
-- Constraints for table `society`
--
ALTER TABLE `society`
  ADD CONSTRAINT `society_ibfk_1` FOREIGN KEY (`soc_pin`) REFERENCES `location` (`loc_pin`);

--
-- Constraints for table `visitor`
--
ALTER TABLE `visitor`
  ADD CONSTRAINT `visitor_ibfk_1` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`);

--
-- Constraints for table `visitor_timings`
--
ALTER TABLE `visitor_timings`
  ADD CONSTRAINT `visitor_timings_ibfk_1` FOREIGN KEY (`vis_id`) REFERENCES `visitor` (`vis_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
