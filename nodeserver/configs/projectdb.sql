-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: senior_project
-- ------------------------------------------------------
-- Server version	5.7.27-log

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
-- Table structure for table `diseases`
--

DROP TABLE IF EXISTS `diseases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diseases` (
  `disease_id` int(11) NOT NULL AUTO_INCREMENT,
  `disease_name` varchar(45) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`disease_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diseases`
--

LOCK TABLES `diseases` WRITE;
/*!40000 ALTER TABLE `diseases` DISABLE KEYS */;
INSERT INTO `diseases` VALUES (1,'เบาหวาน'),(2,'หอบหืด'),(3,'ความดันโลหิตสูง'),(4,'จิตเวช');
/*!40000 ALTER TABLE `diseases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diseases_patient`
--

DROP TABLE IF EXISTS `diseases_patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diseases_patient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `medicine_id` int(11) DEFAULT NULL,
  `disease_id` int(11) NOT NULL,
  `patient_HN` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `medicine_id_diseases_patient_idx` (`medicine_id`),
  KEY `disease_id_diseases_patient_idx` (`disease_id`),
  KEY `patient_HN_idx` (`patient_HN`),
  CONSTRAINT `disease_id_diseases_patient` FOREIGN KEY (`disease_id`) REFERENCES `diseases` (`disease_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `medicine_id_diseases_patient` FOREIGN KEY (`medicine_id`) REFERENCES `medicine` (`medicine_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `patient_HN` FOREIGN KEY (`patient_HN`) REFERENCES `patients` (`patient_HN`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diseases_patient`
--

LOCK TABLES `diseases_patient` WRITE;
/*!40000 ALTER TABLE `diseases_patient` DISABLE KEYS */;
INSERT INTO `diseases_patient` VALUES (2,NULL,2,25144),(5,NULL,1,3662),(8,NULL,4,148),(9,NULL,3,148),(10,NULL,2,3662),(11,NULL,2,25144),(29,NULL,3,3662),(30,NULL,2,3662),(32,NULL,1,25144),(33,NULL,1,231),(34,NULL,2,231),(35,NULL,3,231),(36,NULL,1,665),(37,NULL,2,665),(38,NULL,1,2554),(39,NULL,3,2554),(40,NULL,2,2554),(41,NULL,1,322),(42,NULL,2,322),(43,NULL,3,332),(46,NULL,3,432),(47,NULL,2,432),(48,NULL,1,441),(49,NULL,2,456),(50,NULL,2,443),(51,NULL,3,443),(52,NULL,2,854),(53,NULL,1,854),(54,NULL,3,854),(55,NULL,1,887),(56,NULL,2,887),(57,NULL,2,888),(58,NULL,1,888),(59,NULL,3,975),(60,NULL,1,981),(61,NULL,3,981),(62,NULL,1,990),(65,NULL,2,999),(66,NULL,1,999),(67,NULL,1,1230),(68,NULL,3,1230),(69,NULL,4,1230),(70,NULL,1,1267),(71,NULL,1,2011),(72,NULL,2,2020),(73,NULL,1,2061),(74,NULL,2,2061),(75,NULL,2,2214),(76,NULL,3,2214),(77,NULL,1,2538),(78,NULL,2,2538),(79,NULL,2,2597),(80,NULL,3,2597),(82,NULL,1,3214),(83,NULL,2,4062),(84,NULL,3,4062),(85,NULL,4,4582),(86,NULL,2,5124),(87,NULL,1,5124),(89,NULL,3,6653),(90,NULL,4,6653),(91,NULL,3,6789),(92,NULL,4,6789),(93,NULL,2,7602),(94,NULL,3,7602),(95,NULL,1,7654),(96,NULL,2,7654),(97,NULL,2,7676),(98,NULL,3,7676),(99,NULL,4,7676),(100,NULL,1,8432),(101,NULL,3,8432),(102,NULL,2,8432),(103,NULL,2,8686),(104,NULL,1,8686),(105,NULL,3,8686),(106,NULL,2,8753),(107,NULL,3,8753),(108,NULL,2,8765),(109,NULL,1,8765),(110,NULL,1,8783),(111,NULL,3,8783),(112,NULL,2,8783),(113,NULL,2,8987),(114,NULL,3,8987),(115,NULL,4,8987),(116,NULL,2,9854),(117,NULL,3,9854),(118,NULL,1,9912),(119,NULL,2,15030),(120,NULL,3,15030),(122,NULL,1,309803),(123,NULL,2,309803),(124,NULL,2,309804),(125,NULL,3,309804),(127,NULL,2,309801),(128,NULL,2,9876),(129,NULL,3,9876),(130,NULL,3,6464),(131,NULL,3,3456),(132,NULL,2,3456),(133,NULL,2,559),(134,NULL,3,559),(135,NULL,4,559);
/*!40000 ALTER TABLE `diseases_patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lot`
--

DROP TABLE IF EXISTS `lot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lot` (
  `lot_no_id` int(20) NOT NULL AUTO_INCREMENT,
  `lot_no` varchar(45) NOT NULL,
  `qty` int(11) NOT NULL,
  PRIMARY KEY (`lot_no_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lot`
--

LOCK TABLES `lot` WRITE;
/*!40000 ALTER TABLE `lot` DISABLE KEYS */;
/*!40000 ALTER TABLE `lot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine`
--

DROP TABLE IF EXISTS `medicine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicine` (
  `medicine_id` int(11) NOT NULL,
  `medicine_tmt` int(11) NOT NULL,
  `medicine_generic` varchar(45) CHARACTER SET latin1 NOT NULL,
  `medicine_trade` varchar(45) CHARACTER SET latin1 NOT NULL,
  `strength` varchar(45) CHARACTER SET latin1 NOT NULL,
  `price` varchar(45) CHARACTER SET latin1 NOT NULL,
  `unit` varchar(45) CHARACTER SET latin1 NOT NULL,
  `disease_id_medicine` int(11) DEFAULT NULL,
  PRIMARY KEY (`medicine_id`),
  KEY `disease_id_medicine_idx` (`disease_id_medicine`),
  CONSTRAINT `disease_id_medicine` FOREIGN KEY (`disease_id_medicine`) REFERENCES `medicine` (`medicine_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicine`
--

LOCK TABLES `medicine` WRITE;
/*!40000 ALTER TABLE `medicine` DISABLE KEYS */;
INSERT INTO `medicine` VALUES (1,0,'aaa','aaa','12','250','tablet',1),(2,0,'bbb','bbb','10','120','tablet',1),(3,0,'ccc','ccc','12','210','tablet',2),(4,0,'ddd','ddd','15','150','tablet',2),(5,0,'eee','eee','20','130','tablet',3),(6,0,'fff','fff','15','240','tablet',4);
/*!40000 ALTER TABLE `medicine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `medicine_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `lot_no` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `expdate` datetime DEFAULT NULL,
  `administration` varchar(200) CHARACTER SET utf8 NOT NULL,
  `recieved` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id_detail_idx` (`order_id`),
  CONSTRAINT `order_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (21,46,1,50,NULL,NULL,'ก่อนอาหาร-เช้า,ก่อนอาหาร-กลางวัน,ก่อนอาหาร-เย็น',NULL),(22,46,4,60,NULL,NULL,'หลังอาหาร-เช้า,หลังอาหาร-เย็น',NULL),(23,46,5,40,NULL,NULL,'หลังอาหาร-ก่อนนอน',NULL),(26,48,6,20,NULL,NULL,'หลังอาหาร-เช้า,หลังอาหาร-เย็น',NULL),(27,48,5,30,NULL,NULL,'ก่อนอาหาร-ก่อนนอน',NULL),(28,49,3,60,NULL,NULL,'หลังอาหาร-เช้า,หลังอาหาร-กลางวัน,หลังอาหาร-เย็น',NULL),(33,53,1,70,NULL,NULL,'ก่อนอาหาร-เช้า,ก่อนอาหาร-กลางวัน,ก่อนอาหาร-เย็น',NULL),(34,54,5,50,NULL,NULL,'หลังอาหาร-เช้า,หลังอาหาร-กลางวัน,หลังอาหาร-เย็น',NULL),(35,55,5,20,NULL,NULL,'ก่อนอาหาร-ก่อนนอน',NULL),(36,55,4,60,NULL,NULL,'หลังอาหาร-เช้า,หลังอาหาร-กลางวัน',NULL);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderlog`
--

DROP TABLE IF EXISTS `orderlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(45) NOT NULL,
  `start_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `staff_id_log` int(11) NOT NULL,
  `order_id_log` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id_log_idx` (`staff_id_log`),
  KEY `order_id_log_idx` (`order_id_log`),
  CONSTRAINT `order_id_log` FOREIGN KEY (`order_id_log`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_id_log` FOREIGN KEY (`staff_id_log`) REFERENCES `users` (`staff_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderlog`
--

LOCK TABLES `orderlog` WRITE;
/*!40000 ALTER TABLE `orderlog` DISABLE KEYS */;
INSERT INTO `orderlog` VALUES (4,'create-order','2020-02-09 00:00:00',1248,41),(9,'create-order','2020-02-09 00:00:00',1248,46),(11,'create-order','2020-02-10 00:00:00',1248,48),(12,'create-order','2020-02-10 00:00:00',1248,49),(16,'create-order','2020-02-11 00:00:00',1248,53),(17,'create-order','2020-02-11 00:00:00',1248,54),(18,'create-order','2020-02-11 00:00:00',1248,55);
/*!40000 ALTER TABLE `orderlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `due_date` datetime NOT NULL,
  `status` varchar(45) CHARACTER SET latin1 NOT NULL,
  `receive_date` datetime DEFAULT NULL,
  `remark` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `patient_HN_order` int(11) NOT NULL,
  `staff_id_order` int(11) NOT NULL,
  `pharmacist_id_order` int(11) DEFAULT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pharmacy_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `pharmacist_id_order_idx` (`pharmacist_id_order`),
  KEY `staff_id_order_idx` (`staff_id_order`),
  KEY `patient_HN_order_idx` (`patient_HN_order`),
  KEY `pharmacy_id_order_idx` (`pharmacy_id`),
  CONSTRAINT `patient_HN_order` FOREIGN KEY (`patient_HN_order`) REFERENCES `patients` (`patient_HN`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pharmacist_id_order` FOREIGN KEY (`pharmacist_id_order`) REFERENCES `phamacist` (`phamacist_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pharmacy_id_order` FOREIGN KEY (`pharmacy_id`) REFERENCES `pharmacy` (`pharmacy_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_id_order` FOREIGN KEY (`staff_id_order`) REFERENCES `users` (`staff_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (41,'2020-02-14 00:00:00','waiting-medicine',NULL,NULL,148,1248,NULL,'2020-02-10 15:19:36',1),(46,'2020-02-22 00:00:00','create-order',NULL,NULL,2554,1248,NULL,'2020-02-10 15:19:36',5),(48,'2020-02-14 00:00:00','create-order',NULL,NULL,148,1248,NULL,'2020-02-10 15:34:33',3),(49,'2020-02-19 00:00:00','create-order',NULL,NULL,2554,1248,NULL,'2020-02-10 15:34:55',2),(53,'2020-02-20 00:00:00','create-order',NULL,NULL,665,1248,NULL,'2020-02-11 13:56:51',5),(54,'2020-02-14 00:00:00','create-order',NULL,NULL,332,1248,NULL,'2020-02-11 13:57:42',3),(55,'2020-02-15 00:00:00','create-order',NULL,NULL,432,1248,NULL,'2020-02-11 13:58:06',3);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_return`
--

DROP TABLE IF EXISTS `orders_return`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_return` (
  `id` int(11) NOT NULL,
  `return_id` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  `send_date` varchar(45) NOT NULL,
  `receive_date` varchar(45) DEFAULT NULL,
  `order_id_return` int(11) DEFAULT NULL,
  `staff_id_return` int(11) DEFAULT NULL,
  `pharmacist_id_return` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id_idx` (`receive_date`),
  KEY `order_id_idx` (`return_id`),
  KEY `pharmacist_id_idx` (`pharmacist_id_return`),
  KEY `order_id_return_idx` (`order_id_return`),
  KEY `staff_id_return_idx` (`staff_id_return`),
  CONSTRAINT `order_id_return` FOREIGN KEY (`order_id_return`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pharmacist_id_return` FOREIGN KEY (`pharmacist_id_return`) REFERENCES `phamacist` (`phamacist_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `staff_id_return` FOREIGN KEY (`staff_id_return`) REFERENCES `users` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_return`
--

LOCK TABLES `orders_return` WRITE;
/*!40000 ALTER TABLE `orders_return` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders_return` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_return_detail`
--

DROP TABLE IF EXISTS `orders_return_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_return_detail` (
  `id` int(11) NOT NULL,
  `medicine_id` varchar(45) DEFAULT NULL,
  `qty` varchar(45) DEFAULT NULL,
  `lot_no_id_return` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lot_no_id_idx` (`lot_no_id_return`),
  CONSTRAINT `lot_no_id_return` FOREIGN KEY (`lot_no_id_return`) REFERENCES `lot` (`lot_no_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_return_detail`
--

LOCK TABLES `orders_return_detail` WRITE;
/*!40000 ALTER TABLE `orders_return_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders_return_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_transport`
--

DROP TABLE IF EXISTS `orders_transport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_transport` (
  `id` int(11) NOT NULL,
  `transport_id` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  `receive_date` datetime DEFAULT NULL,
  `order_id_transport` int(11) DEFAULT NULL,
  `staff_id_transport` int(11) DEFAULT NULL,
  `pharmacist_id_transport` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pharmacist_id_transport_idx` (`pharmacist_id_transport`),
  KEY `order_id_transport_idx` (`order_id_transport`),
  KEY `staff_id_orders_transport_idx` (`staff_id_transport`),
  CONSTRAINT `order_id_transport` FOREIGN KEY (`order_id_transport`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pharmacist_id_transport` FOREIGN KEY (`pharmacist_id_transport`) REFERENCES `phamacist` (`phamacist_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `staff_id_orders_transport` FOREIGN KEY (`staff_id_transport`) REFERENCES `users` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_transport`
--

LOCK TABLES `orders_transport` WRITE;
/*!40000 ALTER TABLE `orders_transport` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders_transport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_transport_detail`
--

DROP TABLE IF EXISTS `orders_transport_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_transport_detail` (
  `id` int(11) NOT NULL,
  `medicine_id` varchar(45) DEFAULT NULL,
  `qty` varchar(45) DEFAULT NULL,
  `lot_no_id_transport` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lot_no_id_transport_idx` (`lot_no_id_transport`),
  CONSTRAINT `lot_no_id_transport` FOREIGN KEY (`lot_no_id_transport`) REFERENCES `lot` (`lot_no_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_transport_detail`
--

LOCK TABLES `orders_transport_detail` WRITE;
/*!40000 ALTER TABLE `orders_transport_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders_transport_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `patient_HN` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `surname` varchar(45) CHARACTER SET tis620 NOT NULL,
  `gender` varchar(45) COLLATE utf8_bin NOT NULL,
  `DOB` varchar(45) COLLATE utf8_bin NOT NULL,
  `Telno` varchar(45) COLLATE utf8_bin NOT NULL,
  `address` varchar(45) COLLATE utf8_bin NOT NULL,
  `subdistrict` varchar(45) COLLATE utf8_bin NOT NULL,
  `district` varchar(45) COLLATE utf8_bin NOT NULL,
  `province` varchar(45) COLLATE utf8_bin NOT NULL,
  `pharmacy_id_patient` int(11) NOT NULL,
  `email` varchar(100) COLLATE utf8_bin NOT NULL DEFAULT 'default@gmail.com',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastupdate_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `zipcode` int(10) DEFAULT NULL,
  PRIMARY KEY (`patient_HN`),
  KEY `pharmacy_id_patient_idx` (`pharmacy_id_patient`)
) ENGINE=InnoDB AUTO_INCREMENT=309805 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (148,'ประเสริฐ','มั่งคั่ง','ชาย','03/01/2499','0810000003','142/3 หมู่บ้านธนาสุข','คลองเตย','คลองเตย','กรุงเทพมหานคร',5,'default@gmail.com','2020-02-04 14:53:55','2020-02-04 14:53:55',10110),(231,'เฉลิม','อยู่ดี','ชาย','31/05/2498','0810000006','112/9 หมู่บ้านนิรัน','คลองต้นไทร','คลองสาน','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-08 17:32:36',10600),(322,'กลอยใจ','วังพิง','หญิง','30/05/2491','0810000007','13/3 หมู่บ้านบุหงัน','คลองต้นไทร','คลองสาน','กรุงเทพมหานคร',2,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:27:39',10600),(332,'วัน','อยู่ดี','ชาย','26/12/2518','0810000008','99/2','จอมพล','จตุจักร','กรุงเทพมหานคร',3,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:27:50',10900),(432,'สุทิน','กว้างไกล','ชาย','27/10/2510','0810000009','99/1','คลองตัน','คลองเตย','กรุงเทพมหานคร',3,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:28:14',10110),(441,'จริทนร์','นาคเอกบวรชัย','หญิง','09/03/2514','0810000010','98/1','บางระมาด','ตลิ่งชัน','กรุงเทพมหานคร',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:28:30',10170),(443,'เอื้อนจันทร์','น้ำใจ','หญิง','25/12/2513','0810000011','112/7','ทรายกองดินใต้','คลองสามวา','กรุงเทพมหานคร',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:29:01',10510),(456,'เอกภพ','ภูเวียงชัย','ชาย','05/05/2487','0810000012','83/4','คลองสาน','คลองสาน','กรุงเทพมหานคร',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:28:47',10600),(559,'เอกชัย','เกียรติบุตร','ชาย','14/02/2510','0810000013','11/1','บางบำหรุ','บางพลัด','กรุงเทพมหานคร',3,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:40:01',10700),(665,'จันทรา','นาน่วม','หญิง','11/11/2520','0810000014','102/3','สมเด็จเจ้าพระยา','คลองสาน','กรุงเทพมหานคร',5,'default@gmail.com','2020-02-04 14:53:55','2020-02-08 17:33:41',10600),(854,'จันทร์จิภา','รอดภาษี','หญิง','26/03/2502','0810000015','103/1','จันทรเกษม','จตุจักร','กรุงเทพมหานคร',6,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:29:18',10900),(887,'จรินทร์','มณฑา','ชาย','31/08/2503','0810000016','115/1','บางพรม','ตลิ่งชัน','กรุงเทพมหานคร',2,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:29:29',10170),(888,'เอกนพ','บัวคล้อย','ชาย','30/05/2501','0810000017','100/1','ตลิ่งชัน','เหนือคลอง','กระบี่',3,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:29:43',81130),(975,'ประยุทธ์','จันทรชา','ชาย','03/03/2509','0810000018','110/1','คันนายาว','คันนายาว','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:29:52',10230),(981,'รัศมี','ชัยนา','หญิง','19/05/2520','0810000019','98/1','พระโขนง','คลองเตย','กรุงเทพมหานคร',2,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:30:06',10110),(990,'สันติ','เวศามนัส','ชาย','10/11/2510','0810000020','987/42','บางลำภูล่าง','คลองสาน','กรุงเทพมหานคร',2,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:30:14',10600),(999,'วิหค','เทวศินทร์','ชาย','08/08/2529','0810000021','142/32','แสนสุข','เมืองชลบุรี','ชลบุรี',2,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:30:33',20130),(1230,'วริศรา','ใจดี','หญิง','14/04/1997','0985211432','5/2','แสนตอ','ท่ามะกา','กาญจนบุรี',3,'waris@gmail.com','2020-02-08 11:13:05','2020-02-11 13:30:48',71130),(1267,'ทอง','ทองมั่งมี','ชาย','15/08/2519','0810000022','142/31','ดาวคะนอง','ธนบุรี','กรุงเทพมหานคร',3,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:31:01',10600),(2011,'พิมลจันทร์','ระวังภัย','หญิง','26/05/2513','0810000023','142/30','ศาลายา','พุทธมณฑล','นครปฐม',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:31:11',73170),(2020,'เอกชัย','จงระวัง','ชาย','13/11/2513','0810000024','142/29','วัดกัลยาณ์','ธนบุรี','กรุงเทพมหานคร',5,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:31:25',10600),(2061,'มาลี','ใจพร้อม','หญิง','09/12/2517','0810000025','142/28','แสนแสบ','มีนบุรี','กรุงเทพมหานคร',2,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:31:36',10510),(2214,'ทวี','ไกรบุษย์','ชาย','28/05/2504','0810000026','142/27','บางมด','จอมทอง','กรุงเทพมหานคร',3,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:31:47',10150),(2538,'ก้องเกียรติ','มีเจริญ','ชาย','11/06/2489','0810000027','142/26','ศาลายา','พุทธมณฑล','นครปฐม',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:32:00',73170),(2554,'สันติ','มั่นคั่ง','ชาย','17/08/1988','0856541222','3/2','แสนแสบ','มีนบุรี','กรุงเทพมหานคร',5,'santi2554@gmail.com','2020-02-08 13:20:25','2020-02-08 22:43:38',10510),(2597,'หวานใจ','เกียรติบวรชัย','หญิง','12/12/2512','0810000028','142/25','ศาลายา','พุทธมณฑล','นครปฐม',6,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:32:14',73170),(3214,'วิภพ','ชัยศืรื','ชาย','01/07/2511','0810000029','142/24','ศาลาด่าน','เกาะลันตา','กระบี่',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:32:36',81150),(3456,'รัศมี','รอดแก้ว','หญิง','09/01/2514','0810000030','98/5','บางขุนศรี','บางกอกน้อย','กรุงเทพมหานคร',3,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:39:38',10700),(3662,'สารี','ตั้งมั่น','หญิง','09/05/2527','0845523325','3/2','หนองบอน','ประเวศ','กรุงเทพมหานคร',6,'waree@gmail.com','2020-02-08 16:49:24','2020-02-08 16:49:24',10250),(4062,'มาลี','มั่นเมือง','หญิง','08/10/2516','0810000031','142/23','ท่าแร้ง','บางเขน','กรุงเทพมหานคร',2,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:32:51',10220),(4582,'จักรภพ','แม้นเมือง','ชาย','17/01/2499','0810000032','142/22','ตลาดพลู','ธนบุรี','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:33:05',10600),(5124,'สันติ','ใจกว้าง','ชาย','08/05/2002','0845154522','2/2','แสนสุข','เมืองชลบุรี','ชลบุรี',6,'santi@gmail.com','2020-02-08 13:18:56','2020-02-11 13:33:11',20130),(6464,'ทวี','กลิ้มใจ','ชาย','21/03/2511','0810000033','142/21','บ้านช่างหล่อ','บางกอกน้อย','กรุงเทพมหานคร',3,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:39:05',10700),(6653,'ทวีทรัพย์','โชคดี','ชาย','25/01/2499','0810000034','142/20','ศาลายา','พุทธมณฑล','นครปฐม',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:33:30',73170),(6789,'บัวบุษยา','มณฑาเกียรติ','หญิง','08/12/2511','0810000035','142/19','คลองต้นไทร','คลองสาน','กรุงเทพมหานคร',2,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:33:39',10600),(7602,'นพชัย','จงรัก','ชาย','24/11/2515','0810000036','142/18','คลองตำหรุ','เมืองชลบุรี','ชลบุรี',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:33:53',20000),(7654,'พิมลวรรณ','มณฑารักษ์','หญิง','17/11/2510','0810000037','142/17','คลองสาน','คลองสาน','กรุงเทพมหานคร',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:34:00',10600),(7676,'นันทนา','บัวสาย','หญิง','03/05/2499','0810000038','142/16','คลองต้นไทร','คลองสาน','กรุงเทพมหานคร',4,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:34:13',10600),(8432,'ศิริประภา','ชัยน้อย','หญิง','02/07/2500','0810000039','142/15','คลองต้นไทร','คลองสาน','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:34:24',10600),(8686,'ปวีนา','ใจพร้อม','หญิง','03/05/2531','0810000040','142/14','บางขุนนนท์','บางกอกน้อย','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:34:39',10700),(8753,'ธรรมรัฐ','ธรรมบุษโยกุล','ชาย','18/09/2516','0810000041','142/13','บางลำภูล่าง','คลองสาน','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:34:58',10600),(8765,'สมดี','ไกรรักษ์','ชาย','15/04/2519','0810000042','142/12','คลองสาน','คลองสาน','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:35:15',10600),(8783,'สายสมร','สมใจ','หญิง','13/08/2518','0810000043','142/11','สมเด็จเจ้าพระยา','คลองสาน','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:35:29',10600),(8987,'สายหยุด','โพธิ์ทองมา','หญิง','09/10/2503','0810000044','142/10','บ้านช่างหล่อ','บางกอกน้อย','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:35:38',10700),(9854,'เอกภพ','ศิริโสภา','ชาย','02/02/2499','0810000045','142/9','คลองสาน','คลองสาน','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:35:54',10600),(9876,'พรพิมล','มณฑาเกียรติ','หญิง','09/10/2517','0810000046','142/8','ศาลาธรรมสพน์','ทวีวัฒนา','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:38:42',10170),(9912,'สมฤดี','บัวหวัง','หญิง','12/09/2506','0810000047','142/7','บางขุนศรี','บางกอกน้อย','กรุงเทพมหานคร',1,'default@gmail.com','2020-02-04 14:53:55','2020-02-11 13:36:02',10700),(15030,'อทิมา','มั่นคง','หญิง','08/05/1996','0928451355','2/2','บ้านเก่า','พานทอง','ชลบุรี',5,'atima@gmail.com','2020-02-08 11:20:21','2020-02-11 13:36:08',20160),(25144,'มนตรา','สายชล','หญิง','03/05/2531','0845554844','3/3','แสนแสบ','มีนบุรี','กรุงเทพมหานคร',5,'montra@gmail.com','2020-02-08 17:01:33','2020-02-08 17:03:38',10510),(309801,'เขมิกา','จันมี','หญิง','09-03-1989','0989390556','115/2','นาป่า','เมืองชลบุรี','ชลบุรี',3,'janmee@gmail.com','2020-02-04 14:53:55','2020-02-11 13:37:57',20000),(309803,'เขมิกา','จันมี','หญิง','09-03-1989','0989390556','115/2','ดอนหัวฬ่อ','เมืองชลบุรี','ชลบุรี',5,'janmee@gmail.com','2020-02-04 14:53:55','2020-02-11 13:36:34',20000),(309804,'วริศรา','ใจดี','หญิง','12/5/2514','0985455123','5/3','บางยี่เรือ','ธนบุรี','กรุงเทพมหานคร',3,'waris@gmail.com','2020-02-04 21:56:59','2020-02-11 13:36:44',10600);
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phamacist`
--

DROP TABLE IF EXISTS `phamacist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phamacist` (
  `phamacist_id` int(11) NOT NULL,
  `expdate` varchar(45) CHARACTER SET latin1 NOT NULL,
  `staff_id_pharmacist` int(11) NOT NULL,
  `pharmacy_id_pharmacist` int(11) NOT NULL,
  PRIMARY KEY (`phamacist_id`),
  KEY `pharmacy_id_pharmacist_idx` (`pharmacy_id_pharmacist`),
  CONSTRAINT `pharmacy_id_pharmacist` FOREIGN KEY (`pharmacy_id_pharmacist`) REFERENCES `pharmacy` (`pharmacy_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phamacist`
--

LOCK TABLES `phamacist` WRITE;
/*!40000 ALTER TABLE `phamacist` DISABLE KEYS */;
INSERT INTO `phamacist` VALUES (1000,'0',4,1),(1001,'0',5,2),(1003,'0',6,1),(1005,'0',7,17),(1006,'0',8,2),(3000,'0',9,10);
/*!40000 ALTER TABLE `phamacist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pharmacy`
--

DROP TABLE IF EXISTS `pharmacy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy` (
  `pharmacy_id` int(11) NOT NULL,
  `pharmacy_name` varchar(45) COLLATE utf8_bin NOT NULL,
  `address` varchar(100) COLLATE utf8_bin NOT NULL,
  `subdistrict` varchar(45) COLLATE utf8_bin NOT NULL,
  `district` varchar(45) COLLATE utf8_bin NOT NULL,
  `province` varchar(45) COLLATE utf8_bin NOT NULL,
  `Telno` varchar(45) CHARACTER SET latin1 NOT NULL,
  `latitude` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `longtitude` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `zipcode` varchar(45) COLLATE utf8_bin NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastupdate_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`pharmacy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pharmacy`
--

LOCK TABLES `pharmacy` WRITE;
/*!40000 ALTER TABLE `pharmacy` DISABLE KEYS */;
INSERT INTO `pharmacy` VALUES (1,'ดรัก คอนเนอร์','70/1 หมู่ ซอย โชคชัยร่วมมิตร ถนน วิภาวดีรังสิต','จอมพล','จตุจักร','กรุงเทพมหานคร','02-00000001',NULL,NULL,'10900','2020-02-04 14:58:08','2020-02-04 14:58:08'),(2,'พิพัฒน์เภสัช','958/8 หมู่ ซอย สุขุมวิท 101 ถนน สุขุมวิท','บางจาก','พระโขนง','กรุงเทพมหานคร','02-00000002',NULL,NULL,'10260','2020-02-04 14:58:08','2020-02-04 14:58:08'),(3,'ใกล้เภสัชกร','33/312 หมู่ 10 ซอย โชคชัย 4 ถนน ลาดพร้าว','ลาดพร้าว','ลาดพร้าว','กรุงเทพมหานคร','02-00000003',NULL,NULL,'10230','2020-02-04 14:58:08','2020-02-04 14:58:08'),(4,'เกรียงแสงเภสัช','163/11 หมู่ ซอย กล้วยน้ำไท ถนน สุขุมวิท','พระโขนง','คลองเตย','กรุงเทพมหานคร','02-00000004',NULL,NULL,'10110','2020-02-04 14:58:08','2020-02-04 14:58:08'),(5,'จิตนาคลังยา','26/30 หมู่ 3 ซอย เพชรเกษม 58 ถนน เพชรเกษม','บางด้วน','ภาษีเจริญ ','กรุงเทพมหานคร','02-00000005',NULL,NULL,'10160','2020-02-04 14:58:08','2020-02-04 14:58:08'),(6,'กู๊ดฟาร์มาซี','9/17 หมู่ ซอย สุขาภิบาล 5 ซอย41 ถนน สุขาภิบาล 5','ออเงิน','สายไหม ','กรุงเทพมหานคร','02-00000006',NULL,NULL,'10220','2020-02-04 14:58:08','2020-02-04 14:58:08'),(7,'เขียวมะกอกเภสัช','593/7 หมู่ ซอย ถนน ลาดพร้าว','ลาดยาว','จตุจักร','กรุงเทพมหานคร','02-00000007',NULL,NULL,'10900','2020-02-04 14:58:08','2020-02-04 14:58:08'),(8,'คลังยา','2143/2,2143/3 หมู่ - ซอย - ถนน ลาดพร้าว','วังทองหลาง','วังทองหลาง','กรุงเทพมหานคร','02-00000008',NULL,NULL,'10310','2020-02-04 14:58:08','2020-02-04 14:58:08'),(9,'แจ๊ส เภสัช','1478 หมู่ ซอย ชานเมือง ถนน รัชดาภิเษก','ดินแดง','ดินแดง','กรุงเทพมหานคร','02-00000009',NULL,NULL,'10400','2020-02-04 14:58:08','2020-02-04 14:58:08'),(10,'จงเสถียรเภสัช','3189 หมู่ ซอย ถนน ลาดพร้าว','คลองจั่น','บางกะปิ','กรุงเทพมหานคร','02-00000010',NULL,NULL,'10240','2020-02-04 14:58:08','2020-02-04 14:58:08'),(11,'ดวงแก้ว บ้านยา','113/339 หมู่ 11 ซอย ถนน รามอินทรา','บางชัน','คลองสามวา','กรุงเทพมหานคร','02-00000011',NULL,NULL,'10510','2020-02-04 14:58:08','2020-02-04 14:58:08'),(12,'นำจรูญเภสัช','537/27 หมู่ ซอย ถนน สาธุประดิษฐ์','ช่องนนทรี','ยานนาวา','กรุงเทพมหานคร','02-00000012',NULL,NULL,'10120','2020-02-04 14:58:08','2020-02-04 14:58:08'),(13,'บ้านยา','77/558 ห้อง 6 หมู่ 5 ซอย บางกระดี่ 1 ถนน บางกระดี่','แสมดำ','บางขุนเทียน','กรุงเทพมหานคร','02-00000013',NULL,NULL,'10150','2020-02-04 14:58:08','2020-02-04 14:58:08'),(14,'ไปรยาเภสัช','1209 หมู่ ซอย ถนน ลาดกระบัง','ลาดกระบัง','ลาดกระบัง','กรุงเทพมหานคร','02-00000014',NULL,NULL,'10520','2020-02-04 14:58:08','2020-02-04 14:58:08'),(15,'ปิยะกรเภสัช','121 หมู่ ซอย ศาลธนบุรี ถนน ศาลธนบุรี','บางหว้า','ภาษีเจริญ','กรุงเทพมหานคร','02-00000015',NULL,NULL,'10160','2020-02-04 14:58:08','2020-02-04 14:58:08'),(16,'เจริญเภสัช','26/28 หมู่ ซอย ถนน จรัญสนิทวงศ์','วัดท่าพระ','บางกอกใหญ่','กรุงเทพมหานคร','02-00000016',NULL,NULL,'10600','2020-02-04 14:58:08','2020-02-04 14:58:08'),(17,'เพชรรุ่งเรือง','30/121 หมู่ 6 ซอย ชินเขต2 ถนน งามวงศ์วาน','ทุ่งสองห้อง','หลักสี่','กรุงเทพมหานคร','02-00000017',NULL,NULL,'10210','2020-02-04 14:58:08','2020-02-04 14:58:08'),(18,'เม็ดยา ร่มเกล้า','1261/1 หมู่ ซอย ถนน เคหะร่มเกล้า','คลองสองต้นนุ่น','ลาดกระบัง','กรุงเทพมหานคร','02-00000018',NULL,NULL,'10520','2020-02-04 14:58:08','2020-02-04 14:58:08'),(19,'ไมโคร','58 หมู่ ซอย ถนน ดินสอ','บวรนิเวศ','พระนคร','กรุงเทพมหานคร','02-00000019',NULL,NULL,'10200','2020-02-04 14:58:08','2020-02-04 14:58:08'),(20,'ยาเภสัชกรชุมชน','1 หมู่ - ซอย นวมินทร์ 74 แยก 3-8-8 ถนน นวมินทร์','คันนายาว','คันนายาว','กรุงเทพมหานคร','02-00000020',NULL,NULL,'10230','2020-02-04 14:58:08','2020-02-04 14:58:08'),(21,'ขุมทรัพย์เภสัช','12/5 หมู่ ซอย สุขุมวิท 23 (ประสานมิตร) ถนน สุขุมวิท','คลองเตยเหนือ','วัฒนา','กรุงเทพมหานคร','02-00000021',NULL,NULL,'10110','2020-02-04 14:58:08','2020-02-04 14:58:08'),(22,'กระปุกยา','583/20 หมู่ 6 ซอย แอนเน็กซ์ ถนน พหลโยธิน','สายไหม','สายไหม','กรุงเทพมหานคร','02-00000022',NULL,NULL,'10220','2020-02-04 14:58:08','2020-02-04 14:58:08'),(23,'ร้านยา อุ่นใจ','233/24 หมู่ 3 ซอย สรณคมณ์ ถนน สรณคมณ์','สีกัน','ดอนเมือง','กรุงเทพมหานคร','02-00000023',NULL,NULL,'10210','2020-02-04 14:58:08','2020-02-04 14:58:08'),(24,'รุ่งเรืองฟาร์มาซี','60/16 นิรันดร์เรซิเดนท์ 2 หมู่ 8 ซอย ถนน รามคำแหง2','ดอกไม้','ประเวศ','กรุงเทพมหานคร','02-00000024',NULL,NULL,'10250','2020-02-04 14:58:08','2020-02-04 14:58:08'),(25,'ราชวิถีเภสัช','419/7 หมู่ ซอย ถนน ราชวิถี','ทุ่งพญาไท','ราชเทวี','กรุงเทพมหานคร','02-00000025',NULL,NULL,'10400','2020-02-04 14:58:08','2020-02-04 14:58:08'),(26,'วุฒิเวช','95/5 หมู่ ซอย ถนน วุฒากาส','ตลาดพลู','ธนบุรี','กรุงเทพมหานคร','02-00000026',NULL,NULL,'10600','2020-02-04 14:58:08','2020-02-04 14:58:08'),(27,'วิทยาพรเภสัช','128 หมู่ ซอย กรุงธนบุรี4 ถนน กรุงธนบุรี','บางลำภูล่าง','คลองสาน','กรุงเทพมหานคร','02-00000027',NULL,NULL,'10600','2020-02-04 14:58:08','2020-02-04 14:58:08'),(28,'วดีเภสัช','844/70 หมู่ ซอย วัดจันทร์ใน ถนน ประดู่ 1','บางโคล่','บางคอแหลม','กรุงเทพมหานคร','02-00000028',NULL,NULL,'10120','2020-02-04 14:58:08','2020-02-04 14:58:08'),(29,'แสงสิริเภสัช','2/48 หมู่ 14 ซอย - ถนน เสรีไทย','มีนบุรี','มีนบุรี','กรุงเทพมหานคร','02-00000029',NULL,NULL,'10510','2020-02-04 14:58:08','2020-02-04 14:58:08'),(30,'สยามเจริญโอสถ','193 หมู่ ซอย จรัญสนิทวงศ์ 57 ถนน จรัญสนิทวงศ์','บางบำหรุ','บางพลัด','กรุงเทพมหานคร','02-00000030',NULL,NULL,'10700','2020-02-04 14:58:08','2020-02-04 14:58:08'),(31,'ห้องยาตากสิน','330 หมู่ ซอย ถนน สมเด็จพระเจ้าตากสิน','บุคคโล','ธนบุรี','กรุงเทพมหานคร','02-00000031',NULL,NULL,'10600','2020-02-04 14:58:08','2020-02-04 14:58:08'),(32,'เตือนใจเภสัช','251 หมู่ 7 ซอย เพชรเกษม 79 ถนน เพชรเกษม','หนองค้างพลู','หนองแขม','กรุงเทพมหานคร','02-00000032',NULL,NULL,'10160','2020-02-04 14:58:08','2020-02-04 14:58:08'),(33,'ทับยาวเภสัช','398/6 หมู่ 4 ซอย - ถนน ประชาพัฒนา','ทับยาว','ลาดกระบัง','กรุงเทพมหานคร','02-00000033',NULL,NULL,'10520','2020-02-04 14:58:08','2020-02-04 14:58:08'),(34,'ธัญพรขายยา','77 หมู่ - ซอย - ถนน ประชาอุทิศ','ดอนเมือง','ดอนเมือง','กรุงเทพมหานคร','02-00000034',NULL,NULL,'10210','2020-02-04 14:58:08','2020-02-04 14:58:08');
/*!40000 ALTER TABLE `pharmacy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `record`
--

DROP TABLE IF EXISTS `record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `weight` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `pressure_sys` int(11) DEFAULT NULL,
  `pressue_di` int(11) DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `patient_HN_record` int(11) NOT NULL,
  `pharmacy_id_record` int(11) NOT NULL,
  `order_id_record` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id_record_idx` (`order_id_record`),
  KEY `pharmacy_id_record_idx` (`pharmacy_id_record`),
  KEY `patient_HN_idx` (`patient_HN_record`),
  CONSTRAINT `order_id_record` FOREIGN KEY (`order_id_record`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `patient_HN_record` FOREIGN KEY (`patient_HN_record`) REFERENCES `patients` (`patient_HN`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pharmacy_id_record` FOREIGN KEY (`pharmacy_id_record`) REFERENCES `pharmacy` (`pharmacy_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `record`
--

LOCK TABLES `record` WRITE;
/*!40000 ALTER TABLE `record` DISABLE KEYS */;
/*!40000 ALTER TABLE `record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `staff_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) COLLATE utf8_bin NOT NULL,
  `password` varchar(100) CHARACTER SET latin1 NOT NULL,
  `user_type` varchar(45) CHARACTER SET latin1 NOT NULL,
  `name` varchar(45) COLLATE utf8_bin NOT NULL,
  `surname` varchar(45) COLLATE utf8_bin NOT NULL,
  `telno` varchar(45) CHARACTER SET latin1 NOT NULL,
  `email` varchar(45) CHARACTER SET latin1 NOT NULL,
  `sex` varchar(7) COLLATE utf8_bin NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastupdate_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1249 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1248,'mook','1234','hos_staff','Nattakan','O.','0989390556','mook.nattakan309@gmail.com','Female','2020-02-04 14:48:25','2020-02-04 14:49:20');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-02-11 15:44:18
