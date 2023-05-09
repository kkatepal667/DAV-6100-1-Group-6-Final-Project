CREATE DATABASE  IF NOT EXISTS `gun_culture_db`;
USE `gun_culture_db`;

--
-- Table structure for table `dim_date`
--
/* CREATE TABLE `dim_time` (
   `date_key` int(10) NOT NULL AUTO_INCREMENT,
  `date_year` int(10) DEFAULT NULL,
  `date_month` int(10) DEFAULT NULL,
  PRIMARY KEY (`date_key`)
); */
--
-- Table structure for table `dim_location`
--
DROP TABLE IF EXISTS `dim_location`;
CREATE TABLE `dim_location` (
  `location_key` int(10) NOT NULL AUTO_INCREMENT,
  `address` varchar(250) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`location_key`)
);

DROP TABLE IF EXISTS `dim_nics_firearms`;
CREATE TABLE `dim_nics_firearms` (
  `nics_firearms_key` int(10) NOT NULL AUTO_INCREMENT,
  `permit` int(50) DEFAULT NULL,
  `hand_gun` int(50) DEFAULT NULL,
  `long_gun` int(50) DEFAULT NULL,
  `multiple` int(50) DEFAULT NULL,
  `prepawn_hand_gun` int(50) DEFAULT NULL,
  `prepawn_long_gun` int(50) DEFAULT NULL,
  `redemption_hand_gun` int(50) DEFAULT NULL,
  `redemption_long_gun` int(50) DEFAULT NULL,
  `privatesale_hand_gun` int(50) DEFAULT NULL,
  `privatesale_long_gun` int(50) DEFAULT NULL,
  `totals` int(50) DEFAULT NULL,
  PRIMARY KEY (`nics_firearms_key`)
);

--
-- Table structure for table `dim_gun_violence`
--
DROP TABLE IF EXISTS `dim_gun_violence`;
CREATE TABLE `dim_gun_violence` (
  `gun_violence_key` int(10) NOT NULL AUTO_INCREMENT,
  `n_killed` int(50) DEFAULT NULL,
  `n_injured` int(50) DEFAULT NULL,
  PRIMARY KEY (`gun_violence_key`)
);

--
-- Table structure for table `dim_killings_and_injuries`
--
DROP TABLE IF EXISTS `dim_killings_and_injuries`;

CREATE TABLE `dim_killings_and_injuries` (
  `killings_and_injuries_key` int(10) NOT NULL AUTO_INCREMENT,
  `incident_id` int(50) DEFAULT NULL,
  `incident_date` varchar(50) DEFAULT NULL,
  `n_injured` int(50) DEFAULT NULL,
  PRIMARY KEY (`killings_and_injuries_key`)
);

--
-- Table structure for table `fact_gun_violence_incidents`
--

DROP TABLE IF EXISTS `gun_culture_db`.`fact_gun_violence_incidents`;

CREATE TABLE `fact_gun_violence_incidents` (
  `location_key` int(10) NOT NULL,
 `nics_firearms_key` int(10) NOT NULL,
 `gun_violence_key` int(10) NOT NULL,
 `killings_and_injuries_key` int(10) NOT NULL,
 `Average_Killed` int(10) NOT NULL,
 `Average_Injured` int(10) NOT NULL,
  CONSTRAINT `fact_gun_violence_ibfk_2` FOREIGN KEY (`location_key`) REFERENCES `dim_location` (`location_key`),
  CONSTRAINT `fact_gun_violence_ibfk_3` FOREIGN KEY (`nics_firearms_key`) REFERENCES `dim_nics_firearms` (`nics_firearms_key`),
 CONSTRAINT `fact_gun_violence_ibfk_4` FOREIGN KEY (`gun_violence_key`) REFERENCES `dim_gun_violence` (`gun_violence_key`),
  CONSTRAINT `fact_gun_violence_ibfk_5` FOREIGN KEY (`killings_and_injuries_key`) REFERENCES `dim_killings_and_injuries` (`killings_and_injuries_key`)
);
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Dumping data for table `dim_gun_violence`
--
INSERT INTO `gun_culture_db`.`dim_gun_violence`
(
`n_killed`,
`n_injured`)
(SELECT `n_killed`, `n_injured` FROM `final_project_database`.`gun_violence`);

SELECT * FROM `gun_culture_db`.`dim_gun_violence`;

--
-- Dumping data for table `dim_killings_and_injuries`
--
INSERT INTO `gun_culture_db`.`dim_killings_and_injuries`
(
`incident_id`,
`incident_date`,
`n_injured`)
(SELECT `Incident_ID`, `Incident_Date`, `n_Injured` 
FROM `final_project_database`.`killing_and_injuries`);

SELECT * FROM `gun_culture_db`.`dim_killings_and_injuries`;

--
-- Dumping data for table `dim_location`
--
INSERT INTO `gun_culture_db`.`dim_location`
(
`address`,
`city`, 
`state`)
(SELECT `Address`, `City_Or_County`, `State` 
FROM `final_project_database`.`killing_and_injuries`);

SELECT * FROM `gun_culture_db`.`dim_location`;

--
-- Dumping data for table `dim_nics_firearms`
--
INSERT INTO `gun_culture_db`.`dim_nics_firearms`
(
`permit`,
`hand_gun`, 
`long_gun`,
`multiple`,
`prepawn_hand_gun`, 
`prepawn_long_gun`,
`redemption_hand_gun`, 
`redemption_long_gun`,
`privatesale_hand_gun`, 
`privatesale_long_gun`, 
`totals`)
(SELECT `permit`, `handgun`, `long_gun`, `multiple`,
`prepawn_handgun`, `prepawn_long_gun`,`redemption_handgun`, 
`redemption_long_gun`,`private_sale_handgun`, `private_sale_long_gun`, `totals` 
FROM `final_project_database`.`nics_firearm`);

SELECT * FROM `gun_culture_db`.`dim_nics_firearms`;

SET FOREIGN_KEY_CHECKS=0;
INSERT INTO `gun_culture_db`.`fact_gun_violence_incidents`
(`location_key`,
`nics_firearms_key`,
`gun_violence_key`,
`killings_and_injuries_key`,
`Average_Killed`,
`Average_Injured`
)
(SELECT d1.location_key, d2.nics_firearms_key, d3.gun_violence_key, 
d4.killings_and_injuries_key,
Avg(d3.n_killed )as K, Avg(d3.n_injured) as I  
FROM `gun_culture_db`.`dim_location` as d1,
`gun_culture_db`.`dim_nics_firearms` as d2,
`gun_culture_db`.`dim_gun_violence` as d3,
`gun_culture_db`.`dim_killings_and_injuries` as d4 
) ;

select * from `gun_culture_db`.`fact_gun_violence_incidents`;
 
