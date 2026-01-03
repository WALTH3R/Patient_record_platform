-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 01, 2025 at 11:19 AM
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
-- Database: `PatientRecordsDB`
--

-- --------------------------------------------------------

--
-- Table structure for table `Doctor`
--

CREATE TABLE `Doctor` (
  `Staff_Number` int(11) NOT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone_Number` varchar(20) DEFAULT NULL,
  `Profession_Domain` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Nurse`
--

CREATE TABLE `Nurse` (
  `Staff_Number` int(11) NOT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone_Number` varchar(20) DEFAULT NULL,
  `Profession_Domain` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Patient`
--

CREATE TABLE `Patient` (
  `Patient_Number` int(11) NOT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone_Number` varchar(20) DEFAULT NULL,
  `Age` int(11) DEFAULT NULL,
  `Sex` varchar(10) DEFAULT NULL,
  `Blood_Type` varchar(5) DEFAULT NULL,
  `Height` float DEFAULT NULL,
  `Weight` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Patient`
--

INSERT INTO `Patient` (`Patient_Number`, `First_Name`, `Last_Name`, `Email`, `Phone_Number`, `Age`, `Sex`, `Blood_Type`, `Height`, `Weight`) VALUES
(1, 'Hamid Sharif', 'Sabrina', 'sabrina2005@gmail.com', '68013029', 20, 'Female', NULL, NULL, NULL),
(2, 'Hamid Sharif', 'Sabrina', 'sabrina2005@gmail.com', '68013029', 20, 'Female', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Patient_Payment`
--

CREATE TABLE `Patient_Payment` (
  `Payment_ID` int(11) NOT NULL,
  `Staff_Number` int(11) DEFAULT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Pricing` int(11) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Patient_Record`
--

CREATE TABLE `Patient_Record` (
  `Record_ID` int(11) NOT NULL,
  `Patient_Number` int(11) DEFAULT NULL,
  `Staff_Number` int(11) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Diagnostic` varchar(255) DEFAULT NULL,
  `Medication` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Doctor`
--
ALTER TABLE `Doctor`
  ADD PRIMARY KEY (`Staff_Number`);

--
-- Indexes for table `Nurse`
--
ALTER TABLE `Nurse`
  ADD PRIMARY KEY (`Staff_Number`);

--
-- Indexes for table `Patient`
--
ALTER TABLE `Patient`
  ADD PRIMARY KEY (`Patient_Number`);

--
-- Indexes for table `Patient_Payment`
--
ALTER TABLE `Patient_Payment`
  ADD PRIMARY KEY (`Payment_ID`),
  ADD KEY `Staff_Number` (`Staff_Number`);

--
-- Indexes for table `Patient_Record`
--
ALTER TABLE `Patient_Record`
  ADD PRIMARY KEY (`Record_ID`),
  ADD KEY `Staff_Number` (`Staff_Number`),
  ADD KEY `patient_record_ibfk_1` (`Patient_Number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Patient`
--
ALTER TABLE `Patient`
  MODIFY `Patient_Number` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Patient_Payment`
--
ALTER TABLE `Patient_Payment`
  MODIFY `Payment_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Patient_Record`
--
ALTER TABLE `Patient_Record`
  MODIFY `Record_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Patient_Payment`
--
ALTER TABLE `Patient_Payment`
  ADD CONSTRAINT `patient_payment_ibfk_1` FOREIGN KEY (`Staff_Number`) REFERENCES `Doctor` (`Staff_Number`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Patient_Record`
--
ALTER TABLE `Patient_Record`
  ADD CONSTRAINT `patient_record_ibfk_1` FOREIGN KEY (`Patient_Number`) REFERENCES `Patient` (`Patient_Number`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patient_record_ibfk_2` FOREIGN KEY (`Staff_Number`) REFERENCES `Doctor` (`Staff_Number`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
