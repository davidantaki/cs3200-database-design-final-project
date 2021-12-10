CREATE DATABASE  IF NOT EXISTS `energy_app` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `energy_app`;
-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: energy_app
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appliance`
--

DROP TABLE IF EXISTS `appliance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appliance` (
  `applianceName` varchar(256) NOT NULL,
  `avgDailyUsageHr` float NOT NULL,
  `energyRatingKW` float NOT NULL,
  `address` varchar(256) NOT NULL,
  `city` varchar(128) NOT NULL,
  `state` varchar(2) NOT NULL,
  `zipcode` varchar(16) NOT NULL,
  PRIMARY KEY (`applianceName`,`address`,`city`,`state`,`zipcode`),
  KEY `address` (`address`,`city`,`state`,`zipcode`),
  CONSTRAINT `appliance_ibfk_1` FOREIGN KEY (`address`, `city`, `state`, `zipcode`) REFERENCES `properties` (`address`, `city`, `state`, `zipcode`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appliance`
--

LOCK TABLES `appliance` WRITE;
/*!40000 ALTER TABLE `appliance` DISABLE KEYS */;
INSERT INTO `appliance` VALUES ('Dryer',0.14,5.5,'38 Calumet St','Boston','MA','02120'),('Fridge',24,0.4,'38 Calumet St','Boston','MA','02120'),('Stove',1,3.5,'38 Calumet St','Boston','MA','02120');
/*!40000 ALTER TABLE `appliance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `properties`
--

DROP TABLE IF EXISTS `properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `properties` (
  `address` varchar(256) NOT NULL,
  `city` varchar(128) NOT NULL,
  `state` varchar(2) NOT NULL,
  `zipcode` varchar(16) NOT NULL,
  `username` varchar(256) NOT NULL,
  PRIMARY KEY (`address`,`city`,`state`,`zipcode`),
  KEY `username` (`username`),
  KEY `state` (`state`),
  CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `properties_ibfk_2` FOREIGN KEY (`state`) REFERENCES `state` (`twoLetterName`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `properties`
--

LOCK TABLES `properties` WRITE;
/*!40000 ALTER TABLE `properties` DISABLE KEYS */;
INSERT INTO `properties` VALUES ('1 Rocket Rd','Starbase','TX','78521','dantaki'),('356 Ridge Rd','Aspen','CO','816111','dantaki'),('38 Calumet St','Boston','MA','02120','dantaki'),('4305 Ruben M Torres Blvd','Brownsville','TX','78526','dantaki'),('6','7','MA','10','ssaraf'),('6','7','MA','8','ssaraf'),('6','7','MA','9','ssaraf');
/*!40000 ALTER TABLE `properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `state` (
  `twoLetterName` varchar(2) NOT NULL,
  `fullName` varchar(256) NOT NULL,
  PRIMARY KEY (`twoLetterName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state`
--

LOCK TABLES `state` WRITE;
/*!40000 ALTER TABLE `state` DISABLE KEYS */;
INSERT INTO `state` VALUES ('AK','ALASKA'),('AL','ALABAMA'),('AR','ARKANSAS'),('AS','AMERICAN SAMOA'),('AZ','ARIZONA'),('CA','CALIFORNIA'),('CO','COLORADO'),('CT','CONNECTICUT'),('DC','DISTRICT OF COLUMBIA'),('DE','DELAWARE'),('FL','FLORIDA'),('GA','GEORGIA'),('GU','GUAM'),('HI','HAWAII'),('IA','IOWA'),('ID','IDAHO'),('IL','ILLINOIS'),('IN','INDIANA'),('KS','KANSAS'),('KY','KENTUCKY'),('LA','LOUISIANA'),('MA','MASSACHUSETTS'),('MD','MARYLAND'),('ME','MAINE'),('MI','MICHIGAN'),('MN','MINNESOTA'),('MO','MISSOURI'),('MP','NORTHERN MARIANA IS'),('MS','MISSISSIPPI'),('MT','MONTANA'),('NC','NORTH CAROLINA'),('ND','NORTH DAKOTA'),('NE','NEBRASKA'),('NH','NEW HAMPSHIRE'),('NJ','NEW JERSEY'),('NM','NEW MEXICO'),('NV','NEVADA'),('NY','NEW YORK'),('OH','OHIO'),('OK','OKLAHOMA'),('OR','OREGON'),('PA','PENNSYLVANIA'),('PR','PUERTO RICO'),('RI','RHODE ISLAND'),('SC','SOUTH CAROLINA'),('SD','SOUTH DAKOTA'),('TN','TENNESSEE'),('TX','TEXAS'),('UT','UTAH'),('VA','VIRGINIA'),('VI','VIRGIN ISLANDS'),('VT','VERMONT'),('WA','WASHINGTON'),('WI','WISCONSIN'),('WV','WEST VIRGINIA'),('WY','WYOMING');
/*!40000 ALTER TABLE `state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stateavgenergydata`
--

DROP TABLE IF EXISTS `stateavgenergydata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stateavgenergydata` (
  `twoLetterState` varchar(2) NOT NULL,
  `numCustomers` int NOT NULL,
  `avgMonthlyConsumptionKWh` decimal(13,2) NOT NULL,
  `avgPriceCentsPerKWh` decimal(13,2) NOT NULL,
  `avgMonthlyBillDollars` decimal(13,2) NOT NULL,
  PRIMARY KEY (`twoLetterState`),
  CONSTRAINT `stateavgenergydata_ibfk_1` FOREIGN KEY (`twoLetterState`) REFERENCES `state` (`twoLetterName`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stateavgenergydata`
--

LOCK TABLES `stateavgenergydata` WRITE;
/*!40000 ALTER TABLE `stateavgenergydata` DISABLE KEYS */;
INSERT INTO `stateavgenergydata` VALUES ('AK',315208,552.29,22.57,124.66),('AL',2280741,1144.77,12.57,143.95),('AS',2896339,1113.69,12.27,136.70),('AZ',1413490,1060.04,10.41,110.33),('CA',13834719,571.84,20.45,116.94),('CO',2400357,711.09,12.36,87.88),('CT',1521112,711.20,22.71,161.55),('DC',290466,703.64,12.63,88.89),('DE',446276,932.00,12.56,117.09),('FL',9731237,1141.50,11.27,128.64),('GA',4487431,1081.17,12.02,129.92),('HI',442002,537.16,30.28,162.66),('IA',1403386,865.02,12.46,107.78),('ID',782559,955.28,9.95,95.04),('IL',5339610,720.57,13.04,93.98),('IN',2920266,938.22,12.83,120.34),('KS',1282532,883.18,12.85,113.52),('KY',2013910,1073.17,10.87,116.62),('LA',2112928,1200.58,9.67,116.07),('MA',2817549,601.74,21.97,132.18),('MD',2376983,957.32,13.01,124.50),('ME',717559,569.67,16.81,95.77),('MI',4423595,675.60,16.26,109.86),('MN',2464753,775.46,13.17,102.11),('MO',2833918,1027.74,11.22,115.35),('MS',1308149,1146.33,11.17,128.08),('MT',522382,858.24,11.24,96.49),('NC',4695096,1040.83,11.38,118.44),('ND',387506,1085.26,10.44,113.26),('NE',864842,1013.19,10.80,109.39),('NH',633234,630.41,19.04,120.01),('NJ',3618587,683.44,16.03,109.54),('NM',905885,669.89,12.94,86.66),('NV',1226566,973.02,11.34,110.36),('NY',7239162,601.56,18.36,110.47),('OH',5014959,873.27,12.29,107.30),('OK',1795629,1078.20,10.12,109.07),('OR',1785131,916.27,11.17,102.32),('PA',5448109,845.97,13.58,114.90),('RI',441573,594.09,22.01,130.75),('SC',2377020,1080.70,12.78,138.16),('SD',407532,1036.73,11.75,121.77),('TN',2930482,1168.32,10.76,125.70),('TX',11515333,1131.93,11.71,132.59),('UT',1143136,768.85,10.44,80.24),('VA',3506844,1095.21,12.03,131.72),('VT',316948,567.13,19.54,110.79),('WA',3168238,969.49,9.87,95.72),('WI',2742424,694.24,14.32,99.42),('WV',862279,1051.24,11.80,124.09),('WY',276029,869.33,11.11,96.59);
/*!40000 ALTER TABLE `stateavgenergydata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `username` varchar(256) NOT NULL,
  `passwordHash` binary(32) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('dantaki',_binary '81dc9bdb52d04dc20036dbd8313ed055'),('ssaraf',_binary '674f3c2c1a8a6f90461e8a66fb5550ba');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilitybill`
--

DROP TABLE IF EXISTS `utilitybill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilitybill` (
  `month` int NOT NULL,
  `year` int NOT NULL,
  `address` varchar(256) NOT NULL,
  `city` varchar(128) NOT NULL,
  `state` varchar(2) NOT NULL,
  `zipcode` varchar(16) NOT NULL,
  `energyConsumptionKWh` int NOT NULL,
  `energyCost` decimal(5,2) NOT NULL,
  `providerName` varchar(256) NOT NULL,
  PRIMARY KEY (`month`,`year`,`address`,`city`,`state`,`zipcode`,`providerName`),
  KEY `address` (`address`,`city`,`state`,`zipcode`),
  KEY `providerName` (`providerName`),
  CONSTRAINT `utilitybill_ibfk_1` FOREIGN KEY (`address`, `city`, `state`, `zipcode`) REFERENCES `properties` (`address`, `city`, `state`, `zipcode`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `utilitybill_ibfk_2` FOREIGN KEY (`providerName`) REFERENCES `utilityprovider` (`providerName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilitybill`
--

LOCK TABLES `utilitybill` WRITE;
/*!40000 ALTER TABLE `utilitybill` DISABLE KEYS */;
INSERT INTO `utilitybill` VALUES (1,2021,'356 Ridge Rd','Aspen','CO','816111',123,40.10,'Solar'),(1,2021,'38 Calumet St','Boston','MA','02120',756,124.25,'Eversource'),(2,2021,'356 Ridge Rd','Aspen','CO','816111',313,89.34,'Solar'),(2,2021,'38 Calumet St','Boston','MA','02120',819,169.20,'Eversource'),(3,2021,'6','7','MA','8',650,65.00,'Unitil'),(4,2021,'6','7','MA','8',750,75.00,'Unitil'),(4,2021,'6','7','MA','9',500,50.00,'Solar'),(4,2021,'6','7','MA','9',300,30.00,'Town of Suffolk');
/*!40000 ALTER TABLE `utilitybill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilityprovider`
--

DROP TABLE IF EXISTS `utilityprovider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilityprovider` (
  `providerName` varchar(256) NOT NULL,
  PRIMARY KEY (`providerName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilityprovider`
--

LOCK TABLES `utilityprovider` WRITE;
/*!40000 ALTER TABLE `utilityprovider` DISABLE KEYS */;
INSERT INTO `utilityprovider` VALUES ('Alpha Electric'),('Eversource'),('National Electric'),('Solar'),('Town of Suffolk'),('Unitil');
/*!40000 ALTER TABLE `utilityprovider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'energy_app'
--

--
-- Dumping routines for database 'energy_app'
--
/*!50003 DROP FUNCTION IF EXISTS `checkUserPass` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `checkUserPass`(_username varchar(256), _pass varchar(256)) RETURNS int
    DETERMINISTIC
begin
		declare stored_password_hash binary(32);
        declare inputted_password_hash binary(32);
		set inputted_password_hash = md5(_pass);
		
        select passwordHash into stored_password_hash from users where username = _username;
        
        if stored_password_hash = inputted_password_hash then
			return 0;
		else
			return -1;
		end if;
    end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addAppliance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addAppliance`(in _applianceName varchar(256), in _avgDailyUsageHr float, in _energyRatingKW float,
	in _address varchar(256), in _city varchar(128), in _state varchar(2), in _zipcode varchar(16))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare property_does_not_exist tinyint default false;
	declare data_too_long tinyint default false;
	declare continue handler for 1406 set data_too_long = true;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
    declare continue handler for 1452 set property_does_not_exist = true;
    
	INSERT INTO appliance (applianceName, avgDailyUsageHr, energyRatingKW, address, city, state, zipcode)
    VALUES(_applianceName, _avgDailyUsageHr, _energyRatingKW, _address, _city, _state, _zipcode);
    
    if duplicate_entry_for_key = true then
		select 'That appliance already exists.' as response_msg,
			1 as response_code;
	elseif property_does_not_exist = true then
		select 'That property does not exist.' as response_msg,
			1 as response_code;
	elseif data_too_long = true then
		select 'Data entered is too long.' as response_msg,
			1 as response_code;
	else
		select 'Appliance added to your property.' as response_msg,
			0 as response_code;	-- on success
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addBill` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addBill`(in _month int, in _year int, in _address varchar(256), in _city varchar(128), in _state varchar(2),
	in _zipcode varchar(16), in _energyConsumptionKWh int, in _energyCost decimal(5,2), in _providerName varchar(256))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare user_does_not_exist tinyint default false;
	declare data_too_long tinyint default false;
	declare continue handler for 1406 set data_too_long = true;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    
	INSERT INTO utilityBill (month, year, address, city, state, zipcode, energyConsumptionKWh, energyCost, providerName)
    VALUES(_month, _year, _address, _city, _state, _zipcode, _energyConsumptionKWh, _energyCost, _providerName);
    
    if duplicate_entry_for_key = true then
		select 'That bill already exists.' as response_msg,
			1 as response_code;
	elseif data_too_long = true then
		select 'Data entered is too long.' as response_msg,
			1 as response_code;
	else
		select 'Bill added to your portfolio.' as response_msg,
			0 as response_code;	-- on success
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addProperty` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addProperty`(in _username varchar(256), in _address varchar(256), in _city varchar(128), in _state varchar(2), in _zipcode varchar(16))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare state_does_not_exist tinyint default false;
	declare data_too_long tinyint default false;
	declare continue handler for 1406 set data_too_long = true;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
    declare continue handler for 1452 set state_does_not_exist = true;
    
    
	INSERT INTO properties (address, city, state, zipcode, username) VALUES(_address, _city, _state, _zipcode, _username);
    
    if state_does_not_exist = true then
		select 'The state entered does not exist in the database. Must be the 2 letter state abbreviation.' as response_msg,
			1 as response_code;
    elseif duplicate_entry_for_key = true then
		select 'That property already exists.' as response_msg,
			1 as response_code;
	elseif data_too_long = true then
		select 'Data entered is too long.' as response_msg,
			1 as response_code;
	else
		select 'Property added to your portfolio.' as response_msg,
			0 as response_code;	-- on success
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addProvider` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addProvider`(_name varchar (256))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare user_does_not_exist tinyint default false;
	declare data_too_long tinyint default false;
	declare continue handler for 1406 set data_too_long = true;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
        
	INSERT INTO utilityProvider (providerName) VALUES(_name);

    if duplicate_entry_for_key = true then
		select 'That provider already exists.' as response_msg,
			1 as response_code;
	elseif data_too_long = true then
		select 'Data entered is too long.' as response_msg,
			1 as response_code;
	else
		select 'Utility Provider added.' as response_msg,
			0 as response_code;	-- on success
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUser`(in _username varchar(256), in _pass varchar(256))
BEGIN
	declare duplicate_entry_for_key tinyint default false;
    declare data_too_long tinyint default false;
	declare continue handler for 1406 set data_too_long = true;
    declare continue handler for 1062 set duplicate_entry_for_key = true;
	INSERT INTO users (username, passwordHash) VALUES(_username, md5(_pass));
    
    if duplicate_entry_for_key = true then
		select 'That user already exists.' as response_msg,
			1 as response_code;
	elseif data_too_long = true then
		select 'Data entered is too long.' as response_msg,
			1 as response_code;
	else
		select 'User added.' as response_msg,
			0 as response_code;	-- on success
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllAppliances` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllAppliances`(in _address varchar(256), in _city varchar(128), in _state varchar(2), _zipcode varchar(16))
BEGIN
	select applianceName, avgDailyUsageHr, energyRatingKW from appliance where address = _address and city = _city and state = _state and zipcode = _zipcode;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllBills` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllBills`(in _address varchar(256), in _city varchar(128), in _state varchar(2), _zipcode varchar(16))
BEGIN
	select month, year, energyConsumptionKWh, energyCost, providerName from utilityBill where address = _address and city = _city and state = _state and zipcode = _zipcode;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllProperties` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllProperties`(in _username varchar(256))
BEGIN
	select address, city, state, zipcode from properties where username = _username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllProviders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllProviders`()
BEGIN
	select providerName from utilityProvider;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAvgData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAvgData`(in _state varchar(2))
BEGIN
	select twoLetterState, avgMonthlyConsumptionKWh, avgPriceCentsPerKWh, avgMonthlyBillDollars from stateavgenergydata
	where _state=twoLetterState;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getPropertyProviders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPropertyProviders`(in _address varchar(256), in _city varchar(128), in _state varchar(2), _zipcode varchar(16))
BEGIN
	select distinct providerName from utilityBill where address=_address and city=_city and state=_state and zipcode=_zipcode;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `removeAppliance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `removeAppliance`(in _applianceName varchar(256),
	in _address varchar(256), in _city varchar(128), in _state varchar(2), in _zipcode varchar(16))
BEGIN 
    declare data_too_long tinyint default false;
	declare continue handler for 1406 set data_too_long = true;
    
    if exists (select 1 from appliance where applianceName=_applianceName and address=_address
		and city=_city and state=_state and zipcode=_zipcode) then
		delete from appliance where applianceName=_applianceName and address=_address
		and city=_city and state=_state and zipcode=_zipcode;
		select 'Appliance removed from your property.' as response_msg,
			0 as response_code;	-- on success
	elseif data_too_long = true then
		select 'Data entered is too long.' as response_msg,
			1 as response_code;
	else
		select 'That appliance does not exist.' as response_msg,
			1 as response_code;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `removeBill` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `removeBill`(in _month int, in _year int, in _address varchar(256), in _city varchar(128),
in _state varchar(2), in _zipcode varchar(16), in _providerName varchar(256))
BEGIN
    declare user_does_not_exist tinyint default false;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    if exists (select 1 from utilitybill where month=_month and year=_year and address=_address
		and city=_city and state=_state and zipcode=_zipcode and providerName = _providerName) then
		delete from utilitybill where month=_month and year=_year and address=_address
			and city=_city and state=_state and zipcode=_zipcode and providerName = _providerName;
		select 'Bill removed from your portfolio.' as response_msg,
			0 as response_code;	-- on success
	else
		select 'That bill does not exist.' as response_msg,
			1 as response_code;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `removeProperty` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `removeProperty`(in _username varchar(256), in _address varchar(256), in _city varchar(128), in _state varchar(2), in _zipcode varchar(16))
BEGIN
    declare user_does_not_exist tinyint default false;
	declare data_too_long tinyint default false;
	declare continue handler for 1406 set data_too_long = true;
    declare continue handler for 1452 set user_does_not_exist = true;
    
    delete from properties where username=_username and _address=address and _city=city and _state=state and _zipcode=zipcode;
    
    if user_does_not_exist = true then
		select 'The current user does not exist in the database.' as response_msg,
			1 as response_code;
	elseif data_too_long = true then
		select 'Data entered is too long.' as response_msg,
			1 as response_code;
	else
		select 'Property removed from your portfolio.' as response_msg,
			0 as response_code;	-- on success
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateAppliance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAppliance`(in _oldApplianceName varchar(256), in _newApplianceName varchar(256), in _avgDailyUsageHr float, in _energyRatingKW float,
	in _address varchar(256), in _city varchar(128), in _state varchar(2), in _zipcode varchar(16))
BEGIN
	update appliance set applianceName = _newApplianceName, avgDailyUsageHr=_avgDailyUsageHr,energyRatingKW=_energyRatingKW
    where applianceName = _oldApplianceName and address = _address and city = _city and state = _state and zipcode = _zipcode;
    
	select 'Appliance updated.' as response_msg,
		1 as response_code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateProperty` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateProperty`(in _username varchar(256), in _oldAddress varchar(256),
	in _oldCity varchar(128),  in _oldState varchar(2), in _oldZipcode varchar(16),
    in _newAddress varchar(256), in _newCity varchar(128),  in _newState varchar(2),  in _newZipcode varchar(16))
BEGIN
	update properties set address = _newAddress, city=_newCity, state=_newState, zipcode=_newZipcode
    where address = _oldAddress and city = _oldCity and state = _oldState and zipcode = _oldZipcode;
    
	select 'Property updated.' as response_msg,
		1 as response_code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-12-09 20:29:06
