CREATE DATABASE  IF NOT EXISTS `Emoda` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `Emoda`;
-- MySQL dump 10.13  Distrib 8.0.17, for macos10.14 (x86_64)
--
-- Host: localhost    Database: Emoda
-- ------------------------------------------------------
-- Server version	8.0.17

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
-- Table structure for table `Diary`
--

DROP TABLE IF EXISTS `Diary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Diary` (
  `diary_Seq` int(11) NOT NULL AUTO_INCREMENT,
  `userInfo_Email` varchar(45) DEFAULT NULL,
  `diary_Emotion` int(11) DEFAULT NULL,
  `diary_Title` varchar(45) DEFAULT NULL,
  `diary_Contents` varchar(45) DEFAULT NULL,
  `diary_Date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`diary_Seq`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Diary`
--

LOCK TABLES `Diary` WRITE;
/*!40000 ALTER TABLE `Diary` DISABLE KEYS */;
INSERT INTO `Diary` VALUES (1,'james@naver.com',2,'about James','I\'m James','2020-03-18'),(2,'jane@naver.com',3,'about Jane','I\'m Jane','2020-03-19'),(3,'jeal@naver.com',1,'about Jeal','I\'m Jeal','2020-03-20'),(4,'jean@naver.com',4,'about Jean','I\'m Jean','2020-03-22'),(5,'jeje@naver.com',2,'about Jeje','I\'m Jeje','2020-03-21'),(6,'jenny@naver.com',5,'about Jenny','I\'m Jenny','2020-03-01'),(7,'jeus@naver.com',4,'about Jeus','I\'m Jeus','2020-03-02'),(8,'jhon@naver.com',3,'about Jhon','I\'m Jhon','2020-03-03'),(9,'juan@naver.com',2,'about Juan','I\'m Juan','2020-03-04'),(10,'july@naver.com',1,'about July','I\'m July','2020-03-05'),(11,'june@naver.com',5,'about June','I\'m June','2020-03-06'),(12,'jeong@naver.com',3,'about Jeong','I\'m Jeong','2020-03-07'),(13,'ezra@naver.com',3,'about Ezra','I\'m Ezra','2020-03-08'),(46,'helen@naver.com',3,'about Helen','I’m Helen','2020-03-11');
/*!40000 ALTER TABLE `Diary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserInfo`
--

DROP TABLE IF EXISTS `UserInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserInfo` (
  `userInfo_Email` varchar(45) NOT NULL,
  `userInfo_Nickname` varchar(45) NOT NULL,
  `userInfo_Latitude` double DEFAULT NULL,
  `userInfo_Longtitude` double DEFAULT NULL,
  PRIMARY KEY (`userInfo_Email`),
  UNIQUE KEY `userInfo_Nicname_UNIQUE` (`userInfo_Nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserInfo`
--

LOCK TABLES `UserInfo` WRITE;
/*!40000 ALTER TABLE `UserInfo` DISABLE KEYS */;
INSERT INTO `UserInfo` VALUES ('ezra@naver.com','Ezra',37.518,127.042),('helen@naver.com','Helen',37.505,127.047),('james@naver.com','James',37.516,127.04),('jane@naver.com','Jane',37.505,127.046),('jeal@naver.com','Jeal',37.506,127.03),('jean@naver.com','Jean',37.507,127.031),('jeje@naver.com','Jeje',37.515,127.039),('jenny@naver.com','Jenny',37.508,127.032),('jeong@naver.com','Jeong',37.52,127.044),('jeus@naver.com','Jeus',37.514,127.038),('jhon@naver.com','Jhon',37.521,127.045),('juan@naver.com','Juan',37.509,127.033),('july@naver.com','July',37.513,127.037),('june@naver.com','June',37.517,127.041),('shara@naver.com','Shara',37.511,127.035),('shawn@naver.com','Shawn',37.519,127.043),('sia@naver.com','Sia',37.512,127.036);
/*!40000 ALTER TABLE `UserInfo` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-03-25 11:07:12
