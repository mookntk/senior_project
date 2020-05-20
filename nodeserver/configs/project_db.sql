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
CREATE TABLE `diseases`
(
  `disease_id` int
(11) NOT NULL AUTO_INCREMENT,
  `disease_name` varchar
(45) CHARACTER
SET utf8
COLLATE utf8_bin NOT NULL,
  PRIMARY KEY
(`disease_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diseases`
--

LOCK TABLES `diseases` WRITE;
/*!40000 ALTER TABLE `diseases` DISABLE KEYS */;
INSERT INTO `
diseases`
VALUES
  (1, 'เบาหวาน'),
  (2, 'หอบหืด'),
  (3, 'ความดันโลหิตสูง'),
  (4, 'จิตเวช');
/*!40000 ALTER TABLE `diseases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diseases_patient`
--

DROP TABLE IF EXISTS `diseases_patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diseases_patient`
(
  `id` int
(11) NOT NULL AUTO_INCREMENT,
  `medicine_id` int
(11) DEFAULT NULL,
  `disease_id` int
(11) NOT NULL,
  `patient_HN` int
(11) NOT NULL,
  PRIMARY KEY
(`id`),
  KEY `medicine_id_diseases_patient_idx`
(`medicine_id`),
  KEY `disease_id_diseases_patient_idx`
(`disease_id`),
  KEY `patient_HN_idx`
(`patient_HN`),
  CONSTRAINT `disease_id_diseases_patient` FOREIGN KEY
(`disease_id`) REFERENCES `diseases`
(`disease_id`) ON
DELETE NO ACTION ON
UPDATE NO ACTION,
  CONSTRAINT `medicine_id_diseases_patient` FOREIGN KEY
(`medicine_id`) REFERENCES `medicine`
(`medicine_id`) ON
DELETE NO ACTION ON
UPDATE NO ACTION,
  CONSTRAINT `patient_HN` FOREIGN KEY
(`patient_HN`) REFERENCES `patients`
(`patient_HN`) ON
DELETE NO ACTION ON
UPDATE NO ACTION
) ENGINE=InnoDB
AUTO_INCREMENT=138 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diseases_patient`
--

LOCK TABLES `diseases_patient` WRITE;
/*!40000 ALTER TABLE `diseases_patient` DISABLE KEYS */;
INSERT INTO `
diseases_patient`
VALUES
  (5, NULL, 1, 3662),
  (8, NULL, 4, 148),
  (9, NULL, 3, 148),
  (10, NULL, 2, 3662),
  (11, NULL, 2, 25144),
  (29, NULL, 3, 3662),
  (30, NULL, 2, 3662),
  (32, NULL, 1, 25144),
  (33, NULL, 1, 231),
  (34, NULL, 2, 231),
  (35, NULL, 3, 231),
  (36, NULL, 1, 665),
  (37, NULL, 2, 665),
  (38, NULL, 1, 2554),
  (39, NULL, 3, 2554),
  (40, NULL, 2, 2554),
  (41, NULL, 1, 322),
  (42, NULL, 2, 322),
  (43, NULL, 3, 332),
  (46, NULL, 3, 432),
  (47, NULL, 2, 432),
  (48, NULL, 1, 441),
  (49, NULL, 2, 456),
  (50, NULL, 2, 443),
  (51, NULL, 3, 443),
  (52, NULL, 2, 854),
  (53, NULL, 1, 854),
  (54, NULL, 3, 854),
  (55, NULL, 1, 887),
  (56, NULL, 2, 887),
  (57, NULL, 2, 888),
  (58, NULL, 1, 888),
  (59, NULL, 3, 975),
  (60, NULL, 1, 981),
  (61, NULL, 3, 981),
  (62, NULL, 1, 990),
  (65, NULL, 2, 999),
  (66, NULL, 1, 999),
  (67, NULL, 1, 1230),
  (68, NULL, 3, 1230),
  (69, NULL, 4, 1230),
  (70, NULL, 1, 1267),
  (71, NULL, 1, 2011),
  (72, NULL, 2, 2020),
  (73, NULL, 1, 2061),
  (74, NULL, 2, 2061),
  (75, NULL, 2, 2214),
  (76, NULL, 3, 2214),
  (77, NULL, 1, 2538),
  (78, NULL, 2, 2538),
  (79, NULL, 2, 2597),
  (80, NULL, 3, 2597),
  (82, NULL, 1, 3214),
  (83, NULL, 2, 4062),
  (84, NULL, 3, 4062),
  (85, NULL, 4, 4582),
  (86, NULL, 2, 5124),
  (87, NULL, 1, 5124),
  (89, NULL, 3, 6653),
  (90, NULL, 4, 6653),
  (91, NULL, 3, 6789),
  (92, NULL, 4, 6789),
  (93, NULL, 2, 7602),
  (94, NULL, 3, 7602),
  (95, NULL, 1, 7654),
  (96, NULL, 2, 7654),
  (97, NULL, 2, 7676),
  (98, NULL, 3, 7676),
  (99, NULL, 4, 7676),
  (100, NULL, 1, 8432),
  (101, NULL, 3, 8432),
  (102, NULL, 2, 8432),
  (103, NULL, 2, 8686),
  (104, NULL, 1, 8686),
  (105, NULL, 3, 8686),
  (106, NULL, 2, 8753),
  (107, NULL, 3, 8753),
  (108, NULL, 2, 8765),
  (109, NULL, 1, 8765),
  (110, NULL, 1, 8783),
  (111, NULL, 3, 8783),
  (112, NULL, 2, 8783),
  (113, NULL, 2, 8987),
  (114, NULL, 3, 8987),
  (115, NULL, 4, 8987),
  (116, NULL, 2, 9854),
  (117, NULL, 3, 9854),
  (118, NULL, 1, 9912),
  (119, NULL, 2, 15030),
  (120, NULL, 3, 15030),
  (122, NULL, 1, 309803),
  (123, NULL, 2, 309803),
  (124, NULL, 2, 309804),
  (125, NULL, 3, 309804),
  (127, NULL, 2, 309801),
  (128, NULL, 2, 9876),
  (129, NULL, 3, 9876),
  (130, NULL, 3, 6464),
  (131, NULL, 3, 3456),
  (132, NULL, 2, 3456),
  (133, NULL, 2, 559),
  (134, NULL, 3, 559),
  (135, NULL, 4, 559),
  (136, NULL, 3, 322211),
  (137, NULL, 2, 322211);
/*!40000 ALTER TABLE `diseases_patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lot_order`
--

DROP TABLE IF EXISTS `lot_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lot_order`
(
  `lot_no_id` int
(20) NOT NULL AUTO_INCREMENT,
  `lot_no` varchar
(45) NOT NULL,
  `lot_qty` int
(11) NOT NULL,
  `order_id` int
(11) NOT NULL,
  `medicine_id` int
(11) NOT NULL,
  `lot_transfer_id` int
(15) NOT NULL,
  PRIMARY KEY
(`lot_no_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lot_order`
--

LOCK TABLES `lot_order` WRITE;
/*!40000 ALTER TABLE `lot_order` DISABLE KEYS */;
INSERT INTO `
lot_order`
VALUES
  (11, '23131', 20, 81, 1, 112),
  (12, 'redrt454', 30, 64, 6, 114),
  (13, '4334', 50, 59, 5, 115),
  (14, '23131', 20, 59, 1, 112),
  (15, 'rrrr43', 15, 59, 1, 324),
  (16, 'rt4353', 15, 59, 1, 323),
  (44, 'hy7754', 10, 71, 5, 333),
  (45, 'gtd4453', 10, 71, 6, 322),
  (46, 't4544', 10, 71, 6, 334),
  (48, 'oo999', 20, 74, 2, 335),
  (49, 'rt4353', 15, 74, 1, 323),
  (50, 'rrrr43', 5, 74, 1, 324),
  (55, 'oo999', 10, 81, 2, 335),
  (56, 'oo999', 10, 59, 2, 335),
  (57, '435362', 50, 59, 2, 325),
  (66, '555214', 20, 75, 1, 311),
  (67, 't4544', 10, 93, 6, 334),
  (68, '23131', 84, 106, 1, 112),
  (69, 'i889090', 30, 106, 2, 316),
  (70, 'r5444y', 44, 106, 2, 352),
  (71, 'oo999', 10, 106, 2, 335),
  (72, 'redrt454', 30, 108, 6, 114),
  (73, 'iu775', 20, 108, 6, 276),
  (74, 'dfdf44ju', 10, 108, 6, 329),
  (75, '23131', 20, 79, 1, 112),
  (76, '345345', 10, 79, 2, 113),
  (77, 'tfggb666', 15, 99, 6, 362),
  (78, 'e4443', 62, 115, 3, 361),
  (79, 'gggg67', 30, 83, 1, 327),
  (80, 'r465434', 10, 83, 2, 310),
  (81, '1254441', 10, 83, 2, 309),
  (82, 'pp0988', 10, 83, 2, 321),
  (83, 'TRF54343', 100, 138, 2, 373),
  (84, 'ry6665', 22, 138, 2, 353),
  (85, 'TTU4554', 183, 138, 3, 375),
  (86, 'hh67rdd', 15, 98, 4, 332),
  (87, '484tr', 20, 95, 3, 273),
  (88, '4334', 15, 98, 5, 115);
/*!40000 ALTER TABLE `lot_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lot_transfer`
--

DROP TABLE IF EXISTS `lot_transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lot_transfer`
(
  `lot_no_id` int
(15) NOT NULL AUTO_INCREMENT,
  `qty` int
(11) DEFAULT NULL,
  `transport_id` int
(15) DEFAULT NULL,
  `medicine_id` int
(11) DEFAULT NULL,
  `exp_date` datetime DEFAULT NULL,
  `lot_no` varchar
(45) COLLATE utf8_bin DEFAULT NULL,
  `qty_less` int
(11) DEFAULT NULL,
  PRIMARY KEY
(`lot_no_id`)
) ENGINE=InnoDB AUTO_INCREMENT=376 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lot_transfer`
--

LOCK TABLES `lot_transfer` WRITE;
/*!40000 ALTER TABLE `lot_transfer` DISABLE KEYS */;
INSERT INTO `
lot_transfer`
VALUES
  (109, 30, 84, 1, '2021-02-10 00:00:00', '3453', 4),
  (110, 40, 84, 1, '2020-12-12 00:00:00', '324243252', 0),
  (111, 30, 84, 5, '2021-10-10 00:00:00', '32432423', 30),
  (112, 170, 86, 1, '2020-12-20 00:00:00', '23131', 26),
  (113, 60, 86, 2, '2020-10-10 00:00:00', '345345', 50),
  (114, 30, 86, 6, '2024-02-10 00:00:00', 'redrt454', 0),
  (115, 50, 86, 5, '2020-12-10 00:00:00', '4334', 35),
  (116, 4, 86, 4, '2021-05-05 00:00:00', '3243', 0),
  (118, 10, 91, 1, '2024-10-10 00:00:00', 're23423', 10),
  (119, 10, 91, 1, '2023-04-10 00:00:00', 'ju1254', 10),
  (120, 10, 91, 2, '2025-02-10 00:00:00', 'lt7788', 10),
  (273, 20, 93, 3, '2023-02-12 00:00:00', '484tr', 0),
  (274, 10, 93, 4, '2024-02-12 00:00:00', 'huyu78767', 0),
  (275, 10, 93, 5, '2023-02-12 00:00:00', 'u876', 10),
  (276, 20, 93, 6, '2024-01-12 00:00:00', 'iu775', 0),
  (277, 50, 92, 1, '2024-12-10 00:00:00', '4525', 0),
  (278, 5, 92, 6, '2021-12-10 00:00:00', 'rr44', 5),
  (279, 5, 92, 6, '2020-12-10 00:00:00', '3423', 5),
  (309, 10, 94, 2, '2024-08-21 00:00:00', '1254441', 0),
  (310, 10, 94, 2, '2024-05-15 00:00:00', 'r465434', 0),
  (311, 20, 94, 1, '2025-02-12 00:00:00', '555214', 0),
  (315, 20, 95, 1, '2031-08-20 00:00:00', 'y465343', 20),
  (316, 30, 95, 2, '2025-05-06 00:00:00', 'i889090', 0),
  (317, 50, 96, 1, '2020-06-19 00:00:00', 'g54ee3', 20),
  (318, 20, 96, 2, '2020-11-19 00:00:00', 'y5467', 20),
  (319, 20, 96, 2, '2022-02-24 00:00:00', 'ui998865', 20),
  (320, 20, 97, 1, '2020-06-25 00:00:00', 'r43r243', 20),
  (321, 10, 97, 2, '2021-08-26 00:00:00', 'pp0988', 0),
  (322, 10, 98, 6, '2021-08-26 00:00:00', 'gtd4453', 0),
  (323, 15, 98, 1, '2021-08-26 00:00:00', 'rt4353', 0),
  (324, 25, 98, 1, '2021-08-26 00:00:00', 'rrrr43', 20),
  (325, 50, 98, 2, '2021-08-26 00:00:00', '435362', 0),
  (326, 40, 98, 3, '2021-08-26 00:00:00', '88765', 40),
  (327, 50, 99, 1, '2021-08-26 00:00:00', 'gggg67', 0),
  (328, 30, 99, 5, '2021-08-26 00:00:00', 'hht556', 30),
  (329, 10, 99, 6, '2021-08-26 00:00:00', 'dfdf44ju', 0),
  (330, 5, 99, 6, '2021-08-26 00:00:00', 'uu76y', 5),
  (331, 20, 99, 4, '2021-08-26 00:00:00', 'nbhg56', 15),
  (332, 15, 99, 4, '2021-08-26 00:00:00', 'hh67rdd', 0),
  (333, 30, 98, 5, '2021-08-26 00:00:00', 'hy7754', 20),
  (334, 20, 98, 6, '2021-08-26 00:00:00', 't4544', 0),
  (335, 50, 98, 2, '2021-08-26 00:00:00', 'oo999', 0),
  (336, NULL, 83, 1, '2021-08-26 00:00:00', 't7645', NULL),
  (337, NULL, 83, 4, NULL, '', NULL),
  (338, NULL, 83, 3, NULL, '', NULL),
  (345, 30, 101, 1, '2020-05-30 00:00:00', 'fe333', NULL),
  (346, 30, 101, 1, '2020-07-15 00:00:00', 'p098ii', NULL),
  (347, 50, 101, 3, '2020-06-25 00:00:00', 'o08uuuu', NULL),
  (348, 61, 101, 5, '2020-07-22 00:00:00', 'Lpt34', NULL),
  (349, 274, 101, 2, '2020-06-17 00:00:00', 'o45333', NULL),
  (350, 40, 101, 3, '2020-06-26 00:00:00', '99oikk', NULL),
  (351, 116, 100, 1, '2020-07-25 00:00:00', 'Tr4323', 116),
  (352, 44, 100, 2, '2020-06-27 00:00:00', 'r5444y', 0),
  (353, 40, 100, 2, '2020-06-27 00:00:00', 'ry6665', 18),
  (354, 96, 100, 3, '2020-06-25 00:00:00', 'o888oi', 50),
  (355, 60, 100, 6, '2020-06-24 00:00:00', 'IL9877', 40),
  (356, 20, 102, 3, '2020-07-25 00:00:00', 'gttttt43', 20),
  (357, 30, 102, 2, '2020-07-25 00:00:00', '45reew3', 30),
  (360, 30, 103, 3, '2020-06-18 00:00:00', 'ttedde3', 30),
  (361, 78, 103, 3, '2020-06-27 00:00:00', 'e4443', 16),
  (362, 124, 103, 6, '2020-07-30 00:00:00', 'tfggb666', 124),
  (367, 171, 104, 5, '2020-08-28 00:00:00', 'AD42355', 160),
  (368, 20, 104, 4, '2020-07-24 00:00:00', 'DF4645647', 20),
  (369, 27, 104, 4, '2020-07-23 00:00:00', 'GF45633', 27),
  (370, 122, 104, 1, '2020-07-17 00:00:00', 'DS5346', 122),
  (372, 91, 105, 6, '2020-10-24 00:00:00', 'DRD15442', 91),
  (373, 100, 105, 2, '2020-11-27 00:00:00', 'TRF54343', 0),
  (374, 22, 105, 2, '2020-12-26 00:00:00', 'THY43633', 22),
  (375, 183, 105, 3, '2021-03-12 00:00:00', 'TTU4554', 0);
/*!40000 ALTER TABLE `lot_transfer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine`
--

DROP TABLE IF EXISTS `medicine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicine`
(
  `medicine_id` int
(11) NOT NULL,
  `medicine_tmt` int
(11) NOT NULL,
  `medicine_generic` varchar
(45) COLLATE utf8_bin NOT NULL,
  `medicine_trade` varchar
(45) COLLATE utf8_bin NOT NULL,
  `strength` varchar
(45) COLLATE utf8_bin NOT NULL,
  `price` varchar
(45) CHARACTER
SET utf8
COLLATE utf8_czech_ci NOT NULL,
  `unit` varchar
(45) COLLATE utf8_bin NOT NULL,
  `disease_id_medicine` int
(11) DEFAULT NULL,
  PRIMARY KEY
(`medicine_id`),
  KEY `disease_id_medicine_idx`
(`disease_id_medicine`),
  CONSTRAINT `disease_id_medicine` FOREIGN KEY
(`disease_id_medicine`) REFERENCES `medicine`
(`medicine_id`) ON
DELETE NO ACTION ON
UPDATE NO ACTION
) ENGINE=InnoDB
DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicine`
--

LOCK TABLES `medicine` WRITE;
/*!40000 ALTER TABLE `medicine` DISABLE KEYS */;
INSERT INTO `
medicine`
VALUES
  (1, 22411, 'aaa', 'aaa', '12 mg', '250', 'เม็ด', 1),
  (2, 25417, 'bbb', 'bbb', '10 mg', '120', 'เม็ด', 1),
  (3, 25374, 'ccc', 'ccc', '12 mg', '210', 'เม็ด', 2),
  (4, 24110, 'ddd', 'ddd', '15 mg', '150', 'เม็ด', 2),
  (5, 25741, 'eee', 'eee', '20 mg', '130', 'เม็ด', 3),
  (6, 25786, 'fff', 'fff', '15 mg', '240', 'เม็ด', 4);
/*!40000 ALTER TABLE `medicine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail`
(
  `id` int
(18) NOT NULL AUTO_INCREMENT,
  `order_id` int
(11) NOT NULL,
  `medicine_id` int
(11) NOT NULL,
  `qty` int
(11) NOT NULL,
  `administration` varchar
(200) CHARACTER
SET utf8
NOT NULL,
  `received` varchar
(5) COLLATE utf8_bin DEFAULT NULL,
  `qty_received` int
(11) DEFAULT NULL,
  `qty_missing` int
(11) DEFAULT NULL,
  `numpertime` int
(5) NOT NULL,
  PRIMARY KEY
(`id`),
  KEY `order_id_detail_idx`
(`order_id`),
  CONSTRAINT `order_id_fk` FOREIGN KEY
(`order_id`) REFERENCES `orders`
(`order_id`) ON
DELETE CASCADE ON
UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET
=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `
order_detail`
VALUES
  (21, 46, 1, 50, 'ก่อนอาหาร-เช้า,ก่อนอาหาร-กลางวัน,ก่อนอาหาร-เย็น', 'true', NULL, NULL, 0),
  (22, 46, 4, 4, 'หลังอาหาร-เช้า,หลังอาหาร-เย็น', 'true', NULL, NULL, 0),
  (28, 49, 3, 60, 'หลังอาหาร-เช้า,หลังอาหาร-กลางวัน,หลังอาหาร-เย็น', NULL, NULL, NULL, 0),
  (33, 53, 1, 70, 'ก่อนอาหาร-เช้า,ก่อนอาหาร-กลางวัน,ก่อนอาหาร-เย็น', 'false', NULL, NULL, 0),
  (34, 54, 5, 50, 'หลังอาหาร-เช้า,หลังอาหาร-กลางวัน,หลังอาหาร-เย็น', NULL, NULL, NULL, 0),
  (35, 55, 5, 15, 'ก่อนอาหาร-ก่อนนอน', NULL, NULL, NULL, 0),
  (36, 55, 4, 60, 'หลังอาหาร-เช้า,หลังอาหาร-กลางวัน', NULL, NULL, NULL, 0),
  (37, 56, 1, 50, 'ก่อนอาหาร-เช้า', NULL, NULL, NULL, 0),
  (39, 59, 2, 60, 'หลังอาหาร-เช้า,หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (40, 59, 1, 50, 'ก่อนอาหาร-กลางวัน,ก่อนอาหาร-เย็น', 'true', NULL, NULL, 0),
  (41, 59, 5, 50, 'หลังอาหาร-เช้า,หลังอาหาร-กลางวัน', 'true', NULL, NULL, 0),
  (44, 61, 1, 10, 'ก่อนอาหาร-ก่อนนอน', NULL, NULL, NULL, 0),
  (45, 62, 1, 70, 'ก่อนอาหาร-เช้า,ก่อนอาหาร-กลางวัน', NULL, NULL, NULL, 0),
  (46, 62, 5, 30, 'หลังอาหาร-กลางวัน', NULL, NULL, NULL, 0),
  (47, 63, 5, 20, 'หลังอาหาร-กลางวัน,หลังอาหาร-เช้า', NULL, NULL, NULL, 0),
  (48, 64, 6, 30, 'หลังอาหาร-กลางวัน', 'true', NULL, NULL, 0),
  (49, 65, 1, 40, 'หลังอาหาร-เช้า', NULL, NULL, NULL, 0),
  (50, 65, 4, 20, 'ก่อนอาหาร-เช้า', NULL, NULL, NULL, 0),
  (51, 66, 3, 20, 'หลังอาหาร-เช้า', 'true', NULL, NULL, 0),
  (52, 66, 4, 10, 'หลังอาหาร-เช้า', 'true', NULL, NULL, 0),
  (53, 67, 3, 20, 'หลังอาหาร-เช้า,หลังอาหาร-เย็น', NULL, NULL, 10, 0),
  (54, 67, 1, 10, 'หลังอาหาร-เช้า,หลังอาหาร-เย็น', NULL, NULL, NULL, 0),
  (56, 69, 1, 10, 'ก่อนอาหาร-เช้า,ก่อนอาหาร-กลางวัน,ก่อนอาหาร-เย็น', NULL, NULL, NULL, 0),
  (57, 69, 2, 10, 'ก่อนอาหาร-เช้า,ก่อนอาหาร-กลางวัน,ก่อนอาหาร-เย็น', NULL, NULL, NULL, 0),
  (58, 70, 3, 40, 'หลังอาหาร-กลางวัน', NULL, NULL, NULL, 0),
  (59, 71, 5, 10, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (60, 71, 6, 20, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (61, 72, 5, 30, 'หลังอาหาร-เช้า', NULL, NULL, NULL, 0),
  (62, 72, 3, 20, 'หลังอาหาร-กลางวัน', NULL, NULL, NULL, 0),
  (63, 73, 6, 10, 'หลังอาหาร-กลางวัน', NULL, NULL, NULL, 0),
  (64, 74, 2, 20, 'หลังอาหาร-เช้า', 'false', NULL, NULL, 0),
  (65, 74, 1, 20, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (66, 75, 1, 20, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (67, 75, 2, 30, 'หลังอาหาร-เช้า', 'true', NULL, NULL, 0),
  (68, 79, 1, 20, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (69, 79, 2, 10, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (72, 81, 1, 20, 'หลังอาหาร-กลางวัน', 'true', NULL, NULL, 0),
  (73, 81, 2, 10, 'หลังอาหาร-เช้า', 'false', NULL, NULL, 0),
  (74, 83, 1, 30, 'ก่อนอาหาร-เช้า,ก่อนอาหาร-เย็น', 'false', NULL, NULL, 0),
  (75, 83, 2, 30, 'หลังอาหาร-เช้า', 'false', NULL, NULL, 0),
  (76, 84, 1, 30, 'หลังอาหาร-กลางวัน', NULL, NULL, NULL, 0),
  (77, 93, 6, 10, 'ก่อนอาหาร-เช้า', '1', NULL, NULL, 0),
  (78, 94, 1, 20, 'ก่อนอาหาร-เช้า', NULL, NULL, NULL, 0),
  (79, 94, 3, 20, 'หลังอาหาร-ก่อนนอน', NULL, NULL, 20, 0),
  (80, 94, 2, 30, 'ก่อนอาหาร-เช้า', NULL, NULL, 30, 0),
  (81, 95, 3, 20, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (82, 96, 1, 20, 'หลังอาหาร-เย็น', 'false', NULL, NULL, 0),
  (83, 96, 2, 20, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (84, 97, 1, 20, 'ก่อนอาหาร-กลางวัน', NULL, NULL, 20, 0),
  (85, 97, 4, 20, 'หลังอาหาร-เช้า', NULL, NULL, 5, 0),
  (86, 98, 4, 15, 'ก่อนอาหาร-เช้า', 'true', NULL, NULL, 0),
  (87, 98, 5, 15, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (88, 99, 6, 15, 'หลังอาหาร-เช้า', 'true', NULL, NULL, 0),
  (89, 99, 5, 15, 'หลังอาหาร-กลางวัน', 'false', NULL, NULL, 0),
  (92, 101, 5, 60, 'หลังอาหาร*เช้า*เย็น', NULL, NULL, NULL, 1),
  (93, 101, 3, 90, 'เมื่อมีอาการ*หอบหืด*8', NULL, NULL, NULL, 1),
  (94, 102, 1, 122, 'ก่อนอาหาร*เช้า*เย็น', NULL, NULL, NULL, 1),
  (95, 102, 2, 61, 'ก่อนอาหาร*เย็น', NULL, NULL, NULL, 1),
  (96, 103, 1, 60, 'ก่อนอาหาร*เย็น*เช้า', NULL, NULL, NULL, 1),
  (97, 103, 2, 30, 'ก่อนอาหาร*เย็น', NULL, NULL, NULL, 1),
  (98, 103, 3, 90, 'เมื่อมีอาการ*หอบ*8', NULL, NULL, NULL, 1),
  (99, 104, 5, 61, 'ก่อนอาหาร*เย็น', NULL, NULL, NULL, 1),
  (100, 104, 2, 244, 'หลังอาหาร*เช้า*เย็น', NULL, NULL, NULL, 2),
  (102, 106, 1, 84, 'หลังอาหาร*เย็น', 'true', NULL, NULL, 1),
  (103, 106, 2, 84, 'ก่อนอาหาร*เช้า', 'true', NULL, NULL, 1),
  (104, 107, 1, 32, 'ก่อนอาหาร*เย็น', NULL, NULL, NULL, 1),
  (105, 107, 3, 96, 'เมื่อมีอาการ*หอบ*8', NULL, NULL, 46, 1),
  (106, 108, 6, 60, 'หลังอาหาร*เช้า*เย็น', 'true', NULL, 20, 1),
  (107, 109, 6, 124, 'ก่อนอาหาร*กลางวัน', 'false', NULL, NULL, 2),
  (108, 110, 5, 62, 'หลังอาหาร*กลางวัน', NULL, NULL, NULL, 2),
  (109, 111, 3, 31, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 1),
  (110, 111, 4, 62, 'เมื่อมีอาการ*ปวด*12', NULL, NULL, NULL, 1),
  (111, 112, 1, 30, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 1),
  (112, 113, 5, 44, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 1),
  (113, 114, 2, 35, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 1),
  (114, 115, 3, 62, 'หลังอาหาร*เย็น', 'true', NULL, NULL, 1),
  (118, 119, 5, 24, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 1),
  (122, 122, 5, 110, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 1),
  (123, 123, 4, 47, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 1),
  (124, 124, 5, 61, 'หลังอาหาร*เย็น', NULL, NULL, 11, 1),
  (132, 131, 1, 122, 'หลังอาหาร*เช้า*เย็น', NULL, NULL, NULL, 1),
  (136, 134, 6, 31, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 1),
  (137, 135, 6, 60, 'หลังอาหาร*ก่อนนอน', NULL, NULL, NULL, 2),
  (142, 138, 2, 122, 'หลังอาหาร*เย็น', 'true', NULL, NULL, 2),
  (143, 138, 3, 183, 'เมื่อมีอาการ*ไอ*8', 'true', NULL, NULL, 1),
  (144, 139, 1, 168, 'หลังอาหาร*กลางวัน*เย็น', NULL, NULL, NULL, 1),
  (145, 139, 2, 168, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 2),
  (146, 142, 3, 31, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 1),
  (147, 142, 5, 124, 'หลังอาหาร*เย็น*กลางวัน', NULL, NULL, NULL, 2),
  (148, 143, 2, 52, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 2),
  (149, 143, 1, 52, 'หลังอาหาร*เย็น', NULL, NULL, NULL, 2);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderlog`
--

DROP TABLE IF EXISTS `orderlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderlog`
(
  `id` int
(11) NOT NULL AUTO_INCREMENT,
  `status` varchar
(45) NOT NULL,
  `start_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `staff_id_log` int
(11) NOT NULL,
  `order_id_log` int
(11) NOT NULL,
  PRIMARY KEY
(`id`),
  KEY `staff_id_log_idx`
(`staff_id_log`),
  KEY `order_id_log_idx`
(`order_id_log`),
  CONSTRAINT `order_id_log` FOREIGN KEY
(`order_id_log`) REFERENCES `orders`
(`order_id`) ON
DELETE CASCADE ON
UPDATE CASCADE,
  CONSTRAINT `staff_id_log` FOREIGN KEY
(`staff_id_log`) REFERENCES `users`
(`staff_id`) ON
DELETE NO ACTION ON
UPDATE NO ACTION
) ENGINE=InnoDB
AUTO_INCREMENT=181 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderlog`
--

LOCK TABLES `orderlog` WRITE;
/*!40000 ALTER TABLE `orderlog` DISABLE KEYS */;
INSERT INTO `
orderlog`
VALUES
  (9, 'create-order', '2020-02-09 00:00:00', 1248, 46),
  (12, 'create-order', '2020-02-10 00:00:00', 1248, 49),
  (16, 'create-order', '2020-02-11 00:00:00', 1248, 53),
  (17, 'create-order', '2020-02-11 00:00:00', 1248, 54),
  (18, 'create-order', '2020-02-11 00:00:00', 1248, 55),
  (19, 'create-order', '2020-02-11 00:00:00', 1248, 56),
  (22, 'create-order', '2020-02-12 00:00:00', 1248, 59),
  (24, 'create-order', '2020-02-12 00:00:00', 1248, 61),
  (25, 'create-order', '2020-02-13 00:00:00', 1248, 62),
  (26, 'create-order', '2020-02-13 00:00:00', 1248, 63),
  (27, 'create-order', '2020-02-13 00:00:00', 1248, 64),
  (28, 'create-order', '2020-02-16 00:00:00', 1248, 65),
  (29, 'create-order', '2020-02-16 00:00:00', 1248, 66),
  (30, 'create-order', '2020-02-16 00:00:00', 1248, 67),
  (32, 'create-order', '2020-02-16 00:00:00', 1248, 69),
  (33, 'create-order', '2020-02-16 00:00:00', 1248, 70),
  (34, 'create-order', '2020-02-17 00:00:00', 1248, 71),
  (35, 'create-order', '2020-02-17 00:00:00', 1248, 72),
  (36, 'create-order', '2020-02-17 00:00:00', 1248, 73),
  (37, 'received', '2020-02-17 00:00:00', 123, 62),
  (38, 'received', '2020-02-17 00:00:00', 123, 62),
  (39, 'received', '2020-02-17 00:00:00', 123, 62),
  (40, 'create-order', '2020-02-17 00:00:00', 1248, 79),
  (42, 'received', '2020-02-17 00:00:00', 25, 46),
  (43, 'received', '2020-02-17 00:00:00', 25, 59),
  (44, 'received', '2020-02-17 00:00:00', 25, 53),
  (45, 'received', '2020-02-17 00:00:00', 25, 64),
  (46, 'received', '2020-02-19 00:00:00', 25, 66),
  (47, 'received', '2020-02-19 00:00:00', 25, 71),
  (48, 'confirm', '2020-02-19 00:00:00', 25, 71),
  (49, 'confirm', '2020-02-19 00:00:00', 25, 66),
  (50, 'create-order', '2020-02-20 00:00:00', 1248, 81),
  (51, 'received', '2020-02-20 00:00:00', 25, 74),
  (52, 'confirm', '2020-02-20 00:00:00', 25, 46),
  (53, 'confirm', '2020-02-20 00:00:00', 25, 53),
  (54, 'confirm', '2020-02-20 00:00:00', 25, 59),
  (55, 'confirm', '2020-02-20 00:00:00', 25, 64),
  (56, 'confirm', '2020-02-20 00:00:00', 25, 74),
  (57, 'success', '2020-02-20 00:00:00', 25, 46),
  (58, 'success', '2020-02-20 00:00:00', 25, 46),
  (59, 'success', '2020-02-21 00:00:00', 25, 46),
  (61, 'success', '2020-04-01 00:00:00', 25, 66),
  (62, 'success', '2020-04-01 00:00:00', 25, 66),
  (63, 'success', '2020-04-01 00:00:00', 25, 66),
  (64, 'success', '2020-04-01 00:00:00', 25, 66),
  (65, 'create-order', '2020-04-03 00:00:00', 1248, 83),
  (66, 'received', '2020-04-03 00:00:00', 25, 79),
  (67, 'received', '2020-04-03 00:00:00', 25, 83),
  (68, 'confirm', '2020-04-03 00:00:00', 25, 79),
  (69, 'confirm', '2020-04-03 00:00:00', 25, 83),
  (70, 'create-order', '2020-04-07 00:00:00', 1248, 84),
  (71, 'received', '2020-04-07 00:00:00', 25, 75),
  (72, 'confirm', '2020-04-07 00:00:00', 25, 75),
  (73, 'received', '2020-04-13 00:00:00', 25, 81),
  (74, 'received', '2020-04-13 00:00:00', 25, 81),
  (75, 'received', '2020-04-13 00:00:00', 25, 81),
  (76, 'received', '2020-04-13 00:00:00', 25, 81),
  (77, 'received', '2020-04-13 00:00:00', 25, 81),
  (85, 'create-order', '2020-04-14 00:00:00', 1248, 93),
  (86, 'create-order', '2020-04-14 00:00:00', 1248, 94),
  (87, 'create-order', '2020-04-14 00:00:00', 1248, 96),
  (88, 'received', '2020-04-14 00:00:00', 25, 93),
  (89, 'received', '2020-04-14 00:00:00', 25, 96),
  (90, 'received', '2020-04-14 00:00:00', 25, 94),
  (91, 'received', '2020-04-14 00:00:00', 25, 95),
  (92, 'confirm', '2020-04-15 00:00:00', 25, 81),
  (93, 'create-order', '2020-04-19 00:00:00', 1248, 97),
  (94, 'create-order', '2020-04-19 00:00:00', 1248, 98),
  (95, 'create-order', '2020-04-19 00:00:00', 1248, 99),
  (96, 'received', '2020-04-19 00:00:00', 25, 84),
  (97, 'received', '2020-04-19 00:00:00', 25, 98),
  (98, 'received', '2020-04-19 00:00:00', 25, 97),
  (99, 'received', '2020-04-19 00:00:00', 25, 99),
  (101, 'create-order', '2020-04-23 00:00:00', 1248, 101),
  (102, 'create-order', '2020-04-23 00:00:00', 1248, 102),
  (103, 'create-order', '2020-04-23 00:00:00', 1248, 103),
  (104, 'create-order', '2020-04-23 00:00:00', 1248, 104),
  (105, 'confirm', '2020-04-23 00:00:00', 25, 97),
  (106, 'confirm', '2020-04-23 00:00:00', 25, 98),
  (107, 'confirm', '2020-04-23 00:00:00', 25, 99),
  (108, 'confirm', '2020-04-23 00:00:00', 25, 84),
  (110, 'create-order', '2020-04-24 00:00:00', 1248, 106),
  (111, 'create-order', '2020-04-24 00:00:00', 1248, 107),
  (112, 'create-order', '2020-04-24 00:00:00', 1248, 108),
  (113, 'received', '2020-04-24 00:00:00', 25, 106),
  (114, 'received', '2020-04-24 00:00:00', 25, 107),
  (115, 'received', '2020-04-24 00:00:00', 25, 108),
  (116, 'create-order', '2020-04-30 00:00:00', 1248, 109),
  (117, 'create-order', '2020-05-05 00:00:00', 1248, 110),
  (118, 'create-order', '2020-05-05 00:00:00', 1248, 111),
  (119, 'create-order', '2020-05-05 00:00:00', 1248, 112),
  (120, 'create-order', '2020-05-05 00:00:00', 1248, 113),
  (121, 'create-order', '2020-05-05 00:00:00', 1248, 114),
  (122, 'create-order', '2020-05-05 00:00:00', 1248, 115),
  (123, 'received', '2020-05-05 00:00:00', 25, 107),
  (124, 'received', '2020-05-05 00:00:00', 25, 109),
  (125, 'received', '2020-05-05 00:00:00', 25, 115),
  (129, 'create-order', '2020-05-06 00:00:00', 1248, 119),
  (132, 'create-order', '2020-05-06 00:00:00', 1248, 122),
  (133, 'create-order', '2020-05-06 00:00:00', 1248, 123),
  (134, 'create-order', '2020-05-07 00:00:00', 1248, 124),
  (141, 'create-order', '2020-05-07 00:00:00', 1248, 131),
  (142, 'received', '2020-05-07 00:00:00', 25, 122),
  (143, 'received', '2020-05-07 00:00:00', 25, 124),
  (144, 'received', '2020-05-07 00:00:00', 25, 123),
  (145, 'received', '2020-05-07 00:00:00', 25, 131),
  (147, 'received', '2020-05-08 00:00:00', 25, 122),
  (148, 'received', '2020-05-08 00:00:00', 25, 123),
  (149, 'received', '2020-05-08 00:00:00', 25, 124),
  (150, 'received', '2020-05-08 00:00:00', 25, 131),
  (151, 'received', '2020-05-09 00:00:00', 25, 122),
  (152, 'received', '2020-05-09 00:00:00', 25, 123),
  (153, 'received', '2020-05-09 00:00:00', 25, 124),
  (154, 'received', '2020-05-09 00:00:00', 25, 131),
  (156, 'create-order', '2020-05-09 00:00:00', 1248, 134),
  (157, 'create-order', '2020-05-09 00:00:00', 1248, 135),
  (160, 'create-order', '2020-05-09 00:00:00', 1248, 138),
  (161, 'received', '2020-05-09 00:00:00', 25, 134),
  (162, 'received', '2020-05-09 00:00:00', 25, 135),
  (163, 'received', '2020-05-09 00:00:00', 25, 138),
  (164, 'received', '2020-05-09 00:00:00', 25, 134),
  (165, 'received', '2020-05-09 00:00:00', 25, 135),
  (166, 'received', '2020-05-09 00:00:00', 25, 138),
  (167, 'received', '2020-05-09 00:00:00', 25, 134),
  (168, 'received', '2020-05-09 00:00:00', 25, 135),
  (169, 'received', '2020-05-09 00:00:00', 25, 138),
  (170, 'received', '2020-05-09 00:00:00', 25, 134),
  (171, 'received', '2020-05-09 00:00:00', 25, 135),
  (172, 'received', '2020-05-09 00:00:00', 25, 138),
  (173, 'received', '2020-05-09 00:00:00', 25, 134),
  (174, 'received', '2020-05-09 00:00:00', 25, 135),
  (175, 'received', '2020-05-09 00:00:00', 25, 138),
  (176, 'create-order', '2020-05-11 00:00:00', 1248, 139),
  (179, 'create-order', '2020-05-12 00:00:00', 1248, 142),
  (180, 'create-order', '2020-05-12 00:00:00', 1248, 143);
/*!40000 ALTER TABLE `orderlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders`
(
  `order_id` int
(11) NOT NULL AUTO_INCREMENT,
  `due_date` datetime NOT NULL,
  `status` varchar
(45) CHARACTER
SET utf8
COLLATE utf8_bin NOT NULL,
  `receive_date` datetime DEFAULT NULL,
  `remark` varchar
(45) CHARACTER
SET utf8
COLLATE utf8_bin DEFAULT NULL,
  `patient_HN_order` int
(11) NOT NULL,
  `staff_id_order` int
(11) NOT NULL,
  `pharmacist_id_order` int
(11) DEFAULT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pharmacy_id` int
(11) DEFAULT NULL,
  `transport_id` int
(15) DEFAULT NULL,
  `return_id` int
(15) DEFAULT NULL,
  `next_due_date` datetime NOT NULL,
  PRIMARY KEY
(`order_id`),
  KEY `pharmacist_id_order_idx`
(`pharmacist_id_order`),
  KEY `staff_id_order_idx`
(`staff_id_order`),
  KEY `patient_HN_order_idx`
(`patient_HN_order`),
  KEY `pharmacy_id_order_idx`
(`pharmacy_id`),
  CONSTRAINT `patient_HN_order` FOREIGN KEY
(`patient_HN_order`) REFERENCES `patients`
(`patient_HN`) ON
DELETE NO ACTION ON
UPDATE NO ACTION,
  CONSTRAINT `pharmacist_id_order` FOREIGN KEY
(`pharmacist_id_order`) REFERENCES `phamacist`
(`phamacist_id`) ON
DELETE NO ACTION ON
UPDATE NO ACTION,
  CONSTRAINT `pharmacy_id_order` FOREIGN KEY
(`pharmacy_id`) REFERENCES `pharmacy`
(`pharmacy_id`) ON
DELETE CASCADE ON
UPDATE CASCADE,
  CONSTRAINT `staff_id_order` FOREIGN KEY
(`staff_id_order`) REFERENCES `users`
(`staff_id`) ON
DELETE NO ACTION ON
UPDATE NO ACTION
) ENGINE=InnoDB
AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `
orders`
VALUES
  (46, '2020-02-22 00:00:00', 'success', '2020-02-15 15:19:36', 'รับยาครบ', 2554, 1248, NULL, '2020-02-10 15:19:36', 5, 86, NULL, '2020-06-16 00:00:00'),
  (49, '2020-05-19 00:00:00', 'waiting-medicine', NULL, NULL, 2554, 1248, NULL, '2020-02-10 15:34:55', 2, 83, NULL, '2020-06-16 00:00:00'),
  (53, '2020-02-20 00:00:00', 'cancel', NULL, 'ผู้ป่วยไม่มารับ', 665, 1248, NULL, '2020-02-11 13:56:51', 5, 86, 1, '2020-06-16 00:00:00'),
  (54, '2020-05-14 00:00:00', 'waiting-medicine', NULL, NULL, 332, 1248, NULL, '2020-02-11 13:57:42', 3, 82, NULL, '2020-06-16 00:00:00'),
  (55, '2020-05-15 00:00:00', 'create-order', NULL, NULL, 432, 1248, NULL, '2020-02-11 13:58:06', 3, NULL, NULL, '2020-06-16 00:00:00'),
  (56, '2020-05-15 00:00:00', 'transport', NULL, NULL, 231, 1248, NULL, '2020-02-11 16:16:23', 1, 92, NULL, '2020-06-16 00:00:00'),
  (59, '2020-05-15 00:00:00', 'success', '2020-04-23 18:44:03', 'รับยาบางส่วน', 2554, 1248, NULL, '2020-02-12 22:00:26', 5, 86, 9, '2020-06-16 00:00:00'),
  (61, '2020-05-21 00:00:00', 'transport', NULL, NULL, 441, 1248, NULL, '2020-02-12 22:04:00', 4, 91, NULL, '2020-06-16 00:00:00'),
  (62, '2020-05-21 00:00:00', 'received', NULL, NULL, 231, 1248, NULL, '2020-02-13 00:43:02', 1, 84, NULL, '2020-06-17 00:00:00'),
  (63, '2020-05-21 00:00:00', 'waiting-medicine', NULL, NULL, 332, 1248, NULL, '2020-02-13 00:45:18', 3, 82, NULL, '2020-06-16 00:00:00'),
  (64, '2020-06-14 00:00:00', 'success', '2020-04-15 11:04:59', 'รับยาครบ', 148, 1248, NULL, '2020-02-13 00:46:53', 5, 86, NULL, '2020-06-16 00:00:00'),
  (65, '2020-05-22 00:00:00', 'waiting-medicine', NULL, NULL, 322, 1248, NULL, '2020-02-16 16:26:32', 2, 83, NULL, '2020-06-16 00:00:00'),
  (66, '2020-02-28 00:00:00', 'success', '2020-04-01 01:09:24', 'รับยาครบ', 2020, 1248, NULL, '2020-02-16 21:54:22', 5, 93, NULL, '2020-06-16 00:00:00'),
  (67, '2020-05-28 00:00:00', 'missing', NULL, 'ยาขาด', 888, 1248, NULL, '2020-02-16 21:54:51', 3, NULL, NULL, '2020-06-16 00:00:00'),
  (69, '2020-05-24 00:00:00', 'transport', NULL, NULL, 3214, 1248, NULL, '2020-02-16 21:55:37', 4, 91, NULL, '2020-06-16 00:00:00'),
  (70, '2020-05-19 00:00:00', 'create-order', NULL, NULL, 456, 1248, NULL, '2020-02-16 21:56:01', 4, 0, NULL, '2020-06-16 00:00:00'),
  (71, '2020-02-20 00:00:00', 'cancel', NULL, 'ผู้ป่วยไม่มารับ', 148, 1248, NULL, '2020-02-17 16:58:01', 5, 93, 7, '2020-06-16 00:00:00'),
  (72, '2020-05-20 00:00:00', 'create-order', NULL, NULL, 432, 1248, NULL, '2020-02-17 16:59:30', 3, 0, NULL, '2020-06-16 00:00:00'),
  (73, '2020-05-20 00:00:00', 'transport', NULL, NULL, 4582, 1248, NULL, '2020-02-17 17:00:27', 1, 92, NULL, '2020-06-16 00:00:00'),
  (74, '2020-02-21 00:00:00', 'cancel', NULL, 'ผู้ป่วยไม่มารับ', 665, 1248, NULL, '2020-02-17 21:30:43', 5, 94, 8, '2020-06-16 00:00:00'),
  (75, '2020-02-19 00:00:00', 'success', '2020-04-15 02:46:27', 'รับยาบางส่วน', 665, 1248, NULL, '2020-02-17 21:31:14', 5, 95, 10, '2020-06-16 00:00:00'),
  (76, '2020-05-22 00:00:00', 'missing', NULL, 'ยาขาด', 443, 1248, NULL, '2020-02-17 21:32:05', 4, 0, NULL, '2020-06-16 00:00:00'),
  (77, '2020-05-22 00:00:00', 'create-order', NULL, NULL, 443, 1248, NULL, '2020-02-17 21:32:15', 4, 0, NULL, '2020-06-16 00:00:00'),
  (78, '2020-05-22 00:00:00', 'create-order', NULL, NULL, 443, 1248, NULL, '2020-02-17 21:32:57', 4, 0, NULL, '2020-06-16 00:00:00'),
  (79, '2020-02-20 00:00:00', 'cancel', NULL, 'ผู้ป่วยไม่มารับ', 665, 1248, NULL, '2020-02-17 21:33:24', 5, 96, 11, '2020-06-16 00:00:00'),
  (81, '2020-06-29 00:00:00', 'success', '2020-04-15 10:41:45', 'รับยาบางส่วน', 665, 1248, NULL, '2020-02-20 10:35:53', 5, 97, 8, '2020-06-16 00:00:00'),
  (83, '2020-05-28 00:00:00', 'cancel', NULL, 'ผู้ป่วยไม่มารับ', 309803, 1248, NULL, '2020-04-03 09:14:42', 5, 96, 11, '2020-06-16 00:00:00'),
  (84, '2020-05-30 00:00:00', 'ready', NULL, NULL, 665, 1248, NULL, '2020-04-07 17:39:37', 5, 99, NULL, '2020-06-16 00:00:00'),
  (93, '2020-05-18 00:00:00', 'success', '2020-05-07 23:05:56', 'รับยาครบ', 148, 1248, NULL, '2020-04-14 13:35:15', 5, 98, NULL, '2020-06-16 00:00:00'),
  (94, '2020-05-30 00:00:00', 'missing', NULL, 'ยาขาด', 665, 1248, NULL, '2020-04-14 13:37:34', 5, NULL, NULL, '2020-06-20 00:00:00'),
  (95, '2020-05-29 00:00:00', 'cancel', NULL, 'ผู้ป่วยไม่มารับ', 2020, 1248, NULL, '2020-04-14 13:38:07', 5, 98, 12, '2020-06-16 00:00:00'),
  (96, '2020-04-30 00:00:00', 'cancel', NULL, NULL, 309803, 1248, NULL, '2020-04-14 13:39:39', 5, 98, NULL, '2020-06-16 00:00:00'),
  (97, '2020-05-27 00:00:00', 'missing', NULL, 'ยาขาด', 309803, 1248, NULL, '2020-04-19 14:40:51', 5, NULL, NULL, '2020-06-16 00:00:00'),
  (98, '2020-05-30 00:00:00', 'success', '2020-05-09 23:53:55', 'รับยาบางส่วน', 15030, 1248, NULL, '2020-04-19 14:43:48', 5, 99, 12, '2020-06-16 00:00:00'),
  (99, '2020-05-29 00:00:00', 'success', '2020-05-08 00:58:21', 'รับยาบางส่วน', 148, 1248, NULL, '2020-04-19 14:44:16', 5, 99, NULL, '2020-06-16 00:00:00'),
  (101, '2020-05-30 00:00:00', 'create-order', NULL, NULL, 3456, 1248, NULL, '2020-04-23 01:38:49', 3, 0, NULL, '2020-05-30 00:00:00'),
  (102, '2020-05-30 00:00:00', 'create-order', NULL, NULL, 441, 1248, NULL, '2020-04-23 01:54:40', 4, 0, NULL, '2020-06-30 00:00:00'),
  (103, '2020-05-30 00:00:00', 'waiting-medicine', NULL, NULL, 8432, 1248, NULL, '2020-04-23 09:43:39', 1, 101, NULL, '2020-05-30 00:00:00'),
  (104, '2020-05-30 00:00:00', 'waiting-medicine', NULL, NULL, 8686, 1248, NULL, '2020-04-23 09:44:35', 1, 101, NULL, '2020-06-30 00:00:00'),
  (106, '2020-05-30 00:00:00', 'success', '2020-05-07 23:08:00', 'รับยาครบ', 25144, 1248, NULL, '2020-04-24 04:59:15', 5, 100, NULL, '2020-07-29 00:00:00'),
  (107, '2020-05-15 00:00:00', 'prepare', NULL, 'ยาขาด', 309803, 1248, NULL, '2020-04-24 05:01:50', 5, 103, NULL, '2020-05-31 00:00:00'),
  (108, '2020-05-30 00:00:00', 'success', '2020-05-07 23:08:51', 'รับยาครบ', 148, 1248, NULL, '2020-04-24 10:15:55', 5, 103, NULL, '2020-05-30 00:00:00'),
  (109, '2020-05-30 00:00:00', 'cancel', NULL, NULL, 148, 1248, NULL, '2020-04-30 15:12:19', 5, 103, NULL, '2020-07-31 00:00:00'),
  (110, '2020-05-30 00:00:00', 'create-order', NULL, NULL, 443, 1248, NULL, '2020-05-05 14:26:10', 4, 0, NULL, '2020-06-30 00:00:00'),
  (111, '2020-05-29 00:00:00', 'create-order', NULL, NULL, 443, 1248, NULL, '2020-05-05 15:00:31', 4, NULL, NULL, '2020-06-29 00:00:00'),
  (112, '2020-05-31 00:00:00', 'create-order', NULL, NULL, 322, 1248, NULL, '2020-05-05 15:01:53', 2, NULL, NULL, '2020-06-30 00:00:00'),
  (113, '2020-05-25 00:00:00', 'create-order', NULL, NULL, 975, 1248, NULL, '2020-05-05 15:02:45', 1, NULL, NULL, '2020-06-16 00:00:00'),
  (114, '2020-05-26 00:00:00', 'create-order', NULL, NULL, 322, 1248, NULL, '2020-05-05 15:04:48', 2, NULL, NULL, '2020-06-30 00:00:00'),
  (115, '2020-05-20 00:00:00', 'success', '2020-05-09 13:31:18', 'รับยาครบ', 2020, 1248, NULL, '2020-05-05 15:13:33', 5, 103, NULL, '2020-07-21 00:00:00'),
  (119, '2020-05-07 00:00:00', 'create-order', NULL, NULL, 332, 1248, NULL, '2020-05-06 12:36:14', 3, NULL, NULL, '2020-05-31 00:00:00'),
  (122, '2020-05-28 00:00:00', 'prepare', NULL, NULL, 322211, 1248, NULL, '2020-05-06 13:43:00', 5, 104, NULL, '2020-09-15 00:00:00'),
  (123, '2020-05-30 00:00:00', 'prepare', NULL, NULL, 2214, 1248, NULL, '2020-05-06 13:43:56', 5, 104, NULL, '2020-07-16 00:00:00'),
  (124, '2020-05-30 00:00:00', 'missing', NULL, 'ยาขาด', 432, 1248, NULL, '2020-05-07 19:02:42', 5, 104, NULL, '2020-07-30 00:00:00'),
  (131, '2020-05-30 00:00:00', 'prepare', NULL, NULL, 25144, 1248, NULL, '2020-05-07 22:57:47', 5, 104, NULL, '2020-07-30 00:00:00'),
  (134, '2020-05-26 00:00:00', 'prepare', NULL, NULL, 148, 1248, NULL, '2020-05-09 21:45:31', 5, 105, NULL, '2020-06-26 00:00:00'),
  (135, '2020-05-27 00:00:00', 'prepare', NULL, NULL, 4582, 1248, NULL, '2020-05-09 21:47:05', 5, 105, NULL, '2020-06-26 00:00:00'),
  (138, '2020-05-25 00:00:00', 'success', '2020-05-09 23:52:07', 'รับยาครบ', 2554, 1248, NULL, '2020-05-09 22:19:50', 5, 105, NULL, '2020-07-25 00:00:00'),
  (139, '2020-05-29 00:00:00', 'create-order', NULL, NULL, 990, 1248, NULL, '2020-05-11 21:53:33', 2, NULL, NULL, '2020-08-21 00:00:00'),
  (142, '2020-05-20 00:00:00', 'create-order', NULL, NULL, 559, 1248, NULL, '2020-05-12 14:58:53', 3, NULL, NULL, '2020-06-20 00:00:00'),
  (143, '2020-06-20 00:00:00', 'create-order', NULL, NULL, 665, 1248, NULL, '2020-05-12 18:10:39', 5, NULL, NULL, '2020-07-16 00:00:00');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_return`
--

DROP TABLE IF EXISTS `orders_return`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_return`
(
  `return_id` int
(11) NOT NULL AUTO_INCREMENT,
  `status` varchar
(45) NOT NULL,
  `send_date` datetime DEFAULT NULL,
  `receive_date` datetime DEFAULT NULL,
  `pharmacy_id_return` int
(11) DEFAULT NULL,
  `staff_id_return` int
(11) DEFAULT NULL,
  `pharmacist_id_return` int
(11) DEFAULT NULL,
  PRIMARY KEY
(`return_id`),
  KEY `staff_id_idx`
(`receive_date`),
  KEY `order_id_idx`
(`return_id`),
  KEY `staff_id_return_idx`
(`staff_id_return`),
  KEY `pharmacy_id_return_idx`
(`pharmacy_id_return`),
  KEY `pharmacist_id_return_idx`
(`pharmacist_id_return`),
  CONSTRAINT `pharmacist_id_return` FOREIGN KEY
(`pharmacist_id_return`) REFERENCES `users`
(`staff_id`) ON
DELETE NO ACTION ON
UPDATE NO ACTION,
  CONSTRAINT `pharmacy_id_return` FOREIGN KEY
(`pharmacy_id_return`) REFERENCES `pharmacy`
(`pharmacy_id`) ON
DELETE CASCADE ON
UPDATE CASCADE,
  CONSTRAINT `staff_id_return` FOREIGN KEY
(`staff_id_return`) REFERENCES `users`
(`staff_id`) ON
DELETE CASCADE ON
UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET
=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_return`
--

LOCK TABLES `orders_return` WRITE;
/*!40000 ALTER TABLE `orders_return` DISABLE KEYS */;
INSERT INTO `
orders_return`
VALUES
  (2, 'sending', NULL, NULL, 5, NULL, NULL),
  (7, 'received', '2020-04-30 10:04:58', '2020-04-30 10:04:17', 5, NULL, 1248),
  (8, 'received', '2020-04-30 15:59:15', '2020-05-06 12:54:28', 5, NULL, 1248),
  (9, 'received', '2020-05-06 12:54:46', '2020-05-06 14:10:05', 5, NULL, 1248),
  (10, 'sending', '2020-05-08 00:49:57', NULL, 5, NULL, 25),
  (11, 'sending', '2020-05-10 00:03:44', NULL, 5, NULL, 25),
  (12, 'received', '2020-05-10 00:05:32', '2020-05-10 00:06:16', 5, NULL, 1248);
/*!40000 ALTER TABLE `orders_return` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_return_detail`
--

DROP TABLE IF EXISTS `orders_return_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_return_detail`
(
  `id` int
(11) NOT NULL,
  `medicine_id` varchar
(45) DEFAULT NULL,
  `qty` varchar
(45) DEFAULT NULL,
  `lot_no_id_return` int
(11) DEFAULT NULL,
  PRIMARY KEY
(`id`),
  KEY `lot_no_id_idx`
(`lot_no_id_return`),
  CONSTRAINT `lot_no_id_return` FOREIGN KEY
(`lot_no_id_return`) REFERENCES `lot_order`
(`lot_no_id`) ON
DELETE CASCADE ON
UPDATE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET=latin1;
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
CREATE TABLE `orders_transport`
(
  `transport_id` int
(15) NOT NULL AUTO_INCREMENT,
  `status` varchar
(45) COLLATE utf8_bin NOT NULL,
  `receive_date` datetime DEFAULT NULL,
  `pharmacy_id_transport` int
(11) DEFAULT NULL,
  `staff_id_transport` int
(11) DEFAULT NULL,
  `pharmacist_id_transport` int
(11) DEFAULT NULL,
  `transport_date` datetime DEFAULT NULL,
  PRIMARY KEY
(`transport_id`),
  KEY `staff_id_orders_transport_idx`
(`staff_id_transport`),
  KEY `pharmacy_id_transport_idx`
(`pharmacy_id_transport`),
  KEY `pharmacist_id_transport_idx`
(`pharmacist_id_transport`),
  CONSTRAINT `pharmacist_id_transport` FOREIGN KEY
(`pharmacist_id_transport`) REFERENCES `users`
(`staff_id`) ON
DELETE NO ACTION ON
UPDATE NO ACTION,
  CONSTRAINT `pharmacy_id_transport` FOREIGN KEY
(`pharmacy_id_transport`) REFERENCES `pharmacy`
(`pharmacy_id`) ON
DELETE CASCADE ON
UPDATE CASCADE,
  CONSTRAINT `staff_id_orders_transport` FOREIGN KEY
(`staff_id_transport`) REFERENCES `users`
(`staff_id`) ON
DELETE CASCADE ON
UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET
=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_transport`
--

LOCK TABLES `orders_transport` WRITE;
/*!40000 ALTER TABLE `orders_transport` DISABLE KEYS */;
INSERT INTO `
orders_transport`
VALUES
  (82, 'waiting-medicine', NULL, 3, NULL, NULL, NULL),
  (83, 'waiting-medicine', NULL, 2, NULL, NULL, NULL),
  (84, 'received', '2020-02-17 20:43:55', 1, NULL, NULL, '2020-02-16 15:39:28'),
  (86, 'received', '2020-02-17 21:49:33', 5, NULL, 25, '2020-02-17 21:34:12'),
  (91, 'transport', NULL, 4, NULL, NULL, '2020-02-16 21:58:04'),
  (92, 'transport', NULL, 1, NULL, NULL, '2020-04-24 05:03:00'),
  (93, 'received', '2020-02-19 01:07:25', 5, NULL, 25, '2020-02-17 21:34:06'),
  (94, 'received', '2020-02-20 10:37:08', 5, NULL, 25, '2020-02-20 10:36:58'),
  (95, 'received', '2020-04-07 17:40:11', 5, NULL, 25, '2020-04-07 17:40:02'),
  (96, 'received', '2020-04-03 09:16:39', 5, NULL, 25, '2020-04-03 09:16:19'),
  (97, 'received', '2020-04-13 23:23:34', 5, NULL, 25, '2020-04-07 18:25:04'),
  (98, 'received', '2020-04-14 13:42:40', 5, NULL, 25, '2020-04-14 13:42:01'),
  (99, 'received', '2020-04-19 14:46:16', 5, NULL, 25, '2020-04-19 14:46:07'),
  (100, 'received', '2020-04-24 10:21:51', 5, NULL, 25, '2020-04-24 10:21:07'),
  (101, 'medicine-complete', NULL, 1, NULL, NULL, NULL),
  (102, 'waiting-transport', NULL, 5, NULL, NULL, NULL),
  (103, 'received', '2020-05-05 20:54:44', 5, NULL, 25, '2020-05-05 17:36:46'),
  (104, 'received', '2020-05-09 17:18:50', 5, NULL, 25, '2020-05-07 22:59:05'),
  (105, 'received', '2020-05-09 23:04:34', 5, NULL, 25, '2020-05-09 22:21:12');
/*!40000 ALTER TABLE `orders_transport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_transport_detail`
--

DROP TABLE IF EXISTS `orders_transport_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_transport_detail`
(
  `id` int
(11) NOT NULL AUTO_INCREMENT,
  `medicine_id` varchar
(45) NOT NULL,
  `qty` varchar
(45) NOT NULL,
  `transport_id` int
(11) NOT NULL,
  PRIMARY KEY
(`id`),
  KEY `transport_id_fk_idx`
(`transport_id`),
  CONSTRAINT `transport_id_fk` FOREIGN KEY
(`transport_id`) REFERENCES `orders_transport`
(`transport_id`) ON
DELETE CASCADE ON
UPDATE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET=latin1;
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
CREATE TABLE `patients`
(
  `patient_HN` int
(11) NOT NULL AUTO_INCREMENT,
  `name` varchar
(45) CHARACTER
SET utf8
COLLATE utf8_czech_ci NOT NULL,
  `surname` varchar
(45) CHARACTER
SET tis620
NOT NULL,
  `gender` varchar
(45) COLLATE utf8_bin NOT NULL,
  `DOB` varchar
(45) COLLATE utf8_bin NOT NULL,
  `telno` varchar
(45) COLLATE utf8_bin NOT NULL,
  `address` varchar
(45) COLLATE utf8_bin NOT NULL,
  `subdistrict` varchar
(45) COLLATE utf8_bin NOT NULL,
  `district` varchar
(45) COLLATE utf8_bin NOT NULL,
  `province` varchar
(45) COLLATE utf8_bin NOT NULL,
  `pharmacy_id_patient` int
(11) NOT NULL,
  `email` varchar
(100) COLLATE utf8_bin NOT NULL DEFAULT 'default@gmail.com',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastupdate_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `zipcode` int
(10) DEFAULT NULL,
  PRIMARY KEY
(`patient_HN`),
  KEY `pharmacy_id_patient_idx`
(`pharmacy_id_patient`)
) ENGINE=InnoDB AUTO_INCREMENT=322212 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `
patients`
VALUES
  (148, 'ประเสริฐ', 'มั่งคั่ง', 'ชาย', '03/01/2499', '0810000003', '142/3 หมู่บ้านธนาสุข', 'คลองเตย', 'คลองเตย', 'กรุงเทพมหานคร', 5, 'mook.nattakan309@gmail.com', '2020-02-04 14:53:55', '2020-02-04 14:53:55', 10110),
  (231, 'เฉลิม', 'อยู่ดี', 'ชาย', '31/05/2498', '0810000006', '112/9 หมู่บ้านนิรัน', 'คลองต้นไทร', 'คลองสาน', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-08 17:32:36', 10600),
  (322, 'กลอยใจ', 'วังพิง', 'หญิง', '30/05/2491', '0810000007', '13/3 หมู่บ้านบุหงัน', 'คลองต้นไทร', 'คลองสาน', 'กรุงเทพมหานคร', 2, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:27:39', 10600),
  (332, 'วัน', 'อยู่ดี', 'ชาย', '26/12/2518', '0810000008', '99/2', 'จอมพล', 'จตุจักร', 'กรุงเทพมหานคร', 3, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:27:50', 10900),
  (432, 'สุทิน', 'กว้างไกล', 'ชาย', '27/10/2510', '0810000009', '99/1', 'คลองตัน', 'คลองเตย', 'กรุงเทพมหานคร', 5, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:28:14', 10110),
  (441, 'จริทนร์', 'นาคเอกบวรชัย', 'หญิง', '09/03/2514', '0810000010', '98/1', 'บางระมาด', 'ตลิ่งชัน', 'กรุงเทพมหานคร', 4, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:28:30', 10170),
  (443, 'เอื้อนจันทร์', 'น้ำใจ', 'หญิง', '25/12/2513', '0810000011', '112/7', 'ทรายกองดินใต้', 'คลองสามวา', 'กรุงเทพมหานคร', 4, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:29:01', 10510),
  (456, 'เอกภพ', 'ภูเวียงชัย', 'ชาย', '05/05/2487', '0810000012', '83/4', 'คลองสาน', 'คลองสาน', 'กรุงเทพมหานคร', 4, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:28:47', 10600),
  (559, 'เอกชัย', 'เกียรติบุตร', 'ชาย', '14/02/2510', '0810000013', '11/1', 'บางบำหรุ', 'บางพลัด', 'กรุงเทพมหานคร', 3, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:40:01', 10700),
  (665, 'จันทรา', 'นาน่วม', 'หญิง', '11/11/2520', '0810000014', '102/3', 'สมเด็จเจ้าพระยา', 'คลองสาน', 'กรุงเทพมหานคร', 5, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-08 17:33:41', 10600),
  (854, 'จันทร์จิภา', 'รอดภาษี', 'หญิง', '26/03/2502', '0810000015', '103/1', 'จันทรเกษม', 'จตุจักร', 'กรุงเทพมหานคร', 6, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:29:18', 10900),
  (887, 'จรินทร์', 'มณฑา', 'ชาย', '31/08/2503', '0810000016', '115/1', 'บางพรม', 'ตลิ่งชัน', 'กรุงเทพมหานคร', 2, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:29:29', 10170),
  (888, 'เอกนพ', 'บัวคล้อย', 'ชาย', '30/05/2501', '0810000017', '100/1', 'ตลิ่งชัน', 'เหนือคลอง', 'กระบี่', 3, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:29:43', 81130),
  (975, 'ประยุทธ์', 'จันทรชา', 'ชาย', '03/03/2509', '0810000018', '110/1', 'คันนายาว', 'คันนายาว', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:29:52', 10230),
  (981, 'รัศมี', 'ชัยนา', 'หญิง', '19/05/2520', '0810000019', '98/1', 'พระโขนง', 'คลองเตย', 'กรุงเทพมหานคร', 2, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:30:06', 10110),
  (990, 'สันติ', 'เวศามนัส', 'ชาย', '10/11/2510', '0810000020', '987/42', 'บางลำภูล่าง', 'คลองสาน', 'กรุงเทพมหานคร', 2, 'mook.nattakan309@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:30:14', 10600),
  (999, 'วิหค', 'เทวศินทร์', 'ชาย', '08/08/2529', '0810000021', '142/32', 'แสนสุข', 'เมืองชลบุรี', 'ชลบุรี', 2, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:30:33', 20130),
  (1230, 'วริศรา', 'ใจดี', 'หญิง', '14/04/1997', '0985211432', '5/2', 'แสนตอ', 'ท่ามะกา', 'กาญจนบุรี', 3, 'waris@gmail.com', '2020-02-08 11:13:05', '2020-02-11 13:30:48', 71130),
  (1267, 'ทอง', 'ทองมั่งมี', 'ชาย', '15/08/2519', '0810000022', '142/31', 'ดาวคะนอง', 'ธนบุรี', 'กรุงเทพมหานคร', 3, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:31:01', 10600),
  (2011, 'พิมลจันทร์', 'ระวังภัย', 'หญิง', '26/05/2513', '0810000023', '142/30', 'ศาลายา', 'พุทธมณฑล', 'นครปฐม', 4, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:31:11', 73170),
  (2020, 'เอกชัย', 'จงระวัง', 'ชาย', '13/11/2513', '0810000024', '142/29', 'วัดกัลยาณ์', 'ธนบุรี', 'กรุงเทพมหานคร', 5, 'mook.nattakan309@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:31:25', 10600),
  (2061, 'มาลี', 'ใจพร้อม', 'หญิง', '09/12/2517', '0810000025', '142/28', 'แสนแสบ', 'มีนบุรี', 'กรุงเทพมหานคร', 2, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:31:36', 10510),
  (2214, 'ทวี', 'ไกรบุษย์', 'ชาย', '28/05/2504', '0810000026', '142/27', 'บางมด', 'จอมทอง', 'กรุงเทพมหานคร', 5, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:31:47', 10150),
  (2538, 'ก้องเกียรติ', 'มีเจริญ', 'ชาย', '11/06/2489', '0810000027', '142/26', 'ศาลายา', 'พุทธมณฑล', 'นครปฐม', 4, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:32:00', 73170),
  (2554, 'สันติ', 'มั่นคั่ง', 'ชาย', '17/08/2508', '0856541222', '3/2', 'แสนแสบ', 'มีนบุรี', 'กรุงเทพมหานคร', 5, 'mook.nattakan309@gmail.com', '2020-02-08 13:20:25', '2020-02-08 22:43:38', 10510),
  (2597, 'หวานใจ', 'เกียรติบวรชัย', 'หญิง', '12/12/2512', '0810000028', '142/25', 'ศาลายา', 'พุทธมณฑล', 'นครปฐม', 6, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:32:14', 73170),
  (3214, 'วิภพ', 'ชัยศืรื', 'ชาย', '01/07/2511', '0810000029', '142/24', 'ศาลาด่าน', 'เกาะลันตา', 'กระบี่', 4, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:32:36', 81150),
  (3456, 'รัศมี', 'รอดแก้ว', 'หญิง', '09/01/2514', '0810000030', '98/5', 'บางขุนศรี', 'บางกอกน้อย', 'กรุงเทพมหานคร', 3, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:39:38', 10700),
  (3662, 'สารี', 'ตั้งมั่น', 'หญิง', '09/05/2527', '0845523325', '3/2', 'หนองบอน', 'ประเวศ', 'กรุงเทพมหานคร', 6, 'waree@gmail.com', '2020-02-08 16:49:24', '2020-02-08 16:49:24', 10250),
  (4062, 'มาลี', 'มั่นเมือง', 'หญิง', '08/10/2516', '0810000031', '142/23', 'ท่าแร้ง', 'บางเขน', 'กรุงเทพมหานคร', 2, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:32:51', 10220),
  (4582, 'จักรภพ', 'แม้นเมือง', 'ชาย', '17/01/2499', '0810000032', '142/22', 'ตลาดพลู', 'ธนบุรี', 'กรุงเทพมหานคร', 5, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:33:05', 10600),
  (5124, 'สันติ', 'ใจกว้าง', 'ชาย', '08/05/2002', '0845154522', '2/2', 'แสนสุข', 'เมืองชลบุรี', 'ชลบุรี', 6, 'santi@gmail.com', '2020-02-08 13:18:56', '2020-02-11 13:33:11', 20130),
  (6464, 'ทวี', 'กลิ้มใจ', 'ชาย', '21/03/2511', '0810000033', '142/21', 'บ้านช่างหล่อ', 'บางกอกน้อย', 'กรุงเทพมหานคร', 3, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:39:05', 10700),
  (6653, 'ทวีทรัพย์', 'โชคดี', 'ชาย', '25/01/2499', '0810000034', '142/20', 'ศาลายา', 'พุทธมณฑล', 'นครปฐม', 4, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:33:30', 73170),
  (6789, 'บัวบุษยา', 'มณฑาเกียรติ', 'หญิง', '08/12/2511', '0810000035', '142/19', 'คลองต้นไทร', 'คลองสาน', 'กรุงเทพมหานคร', 2, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:33:39', 10600),
  (7602, 'นพชัย', 'จงรัก', 'ชาย', '24/11/2515', '0810000036', '142/18', 'คลองตำหรุ', 'เมืองชลบุรี', 'ชลบุรี', 4, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:33:53', 20000),
  (7654, 'พิมลวรรณ', 'มณฑารักษ์', 'หญิง', '17/11/2510', '0810000037', '142/17', 'คลองสาน', 'คลองสาน', 'กรุงเทพมหานคร', 4, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:34:00', 10600),
  (7676, 'นันทนา', 'บัวสาย', 'หญิง', '03/05/2499', '0810000038', '142/16', 'คลองต้นไทร', 'คลองสาน', 'กรุงเทพมหานคร', 5, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:34:13', 10600),
  (8432, 'ศิริประภา', 'ชัยน้อย', 'หญิง', '02/07/2500', '0810000039', '142/15', 'คลองต้นไทร', 'คลองสาน', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:34:24', 10600),
  (8686, 'ปวีนา', 'ใจพร้อม', 'หญิง', '03/05/2531', '0810000040', '142/14', 'บางขุนนนท์', 'บางกอกน้อย', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:34:39', 10700),
  (8753, 'ธรรมรัฐ', 'ธรรมบุษโยกุล', 'ชาย', '18/09/2516', '0810000041', '142/13', 'บางลำภูล่าง', 'คลองสาน', 'กรุงเทพมหานคร', 5, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:34:58', 10600),
  (8765, 'สมดี', 'ไกรรักษ์', 'ชาย', '15/04/2519', '0810000042', '142/12', 'คลองสาน', 'คลองสาน', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:35:15', 10600),
  (8783, 'สายสมร', 'สมใจ', 'หญิง', '13/08/2518', '0810000043', '142/11', 'สมเด็จเจ้าพระยา', 'คลองสาน', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:35:29', 10600),
  (8987, 'สายหยุด', 'โพธิ์ทองมา', 'หญิง', '09/10/2503', '0810000044', '142/10', 'บ้านช่างหล่อ', 'บางกอกน้อย', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:35:38', 10700),
  (9854, 'เอกภพ', 'ศิริโสภา', 'ชาย', '02/02/2499', '0810000045', '142/9', 'คลองสาน', 'คลองสาน', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:35:54', 10600),
  (9876, 'พรพิมล', 'มณฑาเกียรติ', 'หญิง', '09/10/2517', '0810000046', '142/8', 'ศาลาธรรมสพน์', 'ทวีวัฒนา', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:38:42', 10170),
  (9912, 'สมฤดี', 'บัวหวัง', 'หญิง', '12/09/2506', '0810000047', '142/7', 'บางขุนศรี', 'บางกอกน้อย', 'กรุงเทพมหานคร', 1, 'default@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:36:02', 10700),
  (15030, 'อทิมา', 'มั่นคง', 'หญิง', '08/05/2529', '0928451355', '2/2', 'บ้านเก่า', 'พานทอง', 'ชลบุรี', 5, 'atima@gmail.com', '2020-02-08 11:20:21', '2020-02-11 13:36:08', 20160),
  (25144, 'มนตรา', 'สายชล', 'หญิง', '03/05/2531', '0845554844', '3/3', 'แสนแสบ', 'มีนบุรี', 'กรุงเทพมหานคร', 5, 'montra@gmail.com', '2020-02-08 17:01:33', '2020-02-08 17:03:38', 10510),
  (309801, 'เขมิกา', 'จันมี', 'หญิง', '09/03/2535', '0989390556', '115/2', 'นาป่า', 'เมืองชลบุรี', 'ชลบุรี', 3, 'janmee@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:37:57', 20000),
  (309803, 'เขมิกา', 'จันมี', 'หญิง', '09/03/2532', '0989390556', '115/2', 'ดอนหัวฬ่อ', 'เมืองชลบุรี', 'ชลบุรี', 5, 'janmee@gmail.com', '2020-02-04 14:53:55', '2020-02-11 13:36:34', 20000),
  (309804, 'วริศรา', 'ใจดี', 'หญิง', '12/5/2514', '0985455123', '5/3', 'บางยี่เรือ', 'ธนบุรี', 'กรุงเทพมหานคร', 3, 'waris@gmail.com', '2020-02-04 21:56:59', '2020-02-11 13:36:44', 10600),
  (322211, 'มานะ', 'ใจดี', 'ชาย', '12/05/2514', '0989390556', '5/3', 'บางพลีใหญ่', 'บางพลี', 'สมุทรปราการ', 5, 'mook.nattakan309@gmail.com', '2020-04-20 23:19:42', '2020-04-20 23:19:42', 10540);
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phamacist`
--

DROP TABLE IF EXISTS `phamacist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phamacist`
(
  `phamacist_id` int
(11) NOT NULL,
  `expdate` varchar
(45) CHARACTER
SET latin1
NOT NULL,
  `staff_id_pharmacist` int
(11) NOT NULL,
  `pharmacy_id_pharmacist` int
(11) NOT NULL,
  PRIMARY KEY
(`phamacist_id`),
  KEY `pharmacy_id_pharmacist_idx`
(`pharmacy_id_pharmacist`),
  CONSTRAINT `pharmacy_id_pharmacist` FOREIGN KEY
(`pharmacy_id_pharmacist`) REFERENCES `pharmacy`
(`pharmacy_id`) ON
DELETE NO ACTION ON
UPDATE NO ACTION
) ENGINE=InnoDB
DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phamacist`
--

LOCK TABLES `phamacist` WRITE;
/*!40000 ALTER TABLE `phamacist` DISABLE KEYS */;
INSERT INTO `
phamacist`
VALUES
  (215, '02550', 27, 2),
  (254, '04521', 28, 3),
  (645, '05684', 30, 5),
  (1000, '20458', 4, 1),
  (1001, '03547', 5, 2),
  (1003, '01235', 6, 1),
  (1005, '10274', 7, 17),
  (1006, '20047', 8, 2),
  (1234, '03547', 26, 1),
  (1235, '02588', 25, 5),
  (2100, '12254', 123, 1),
  (2354, '23544', 29, 4),
  (3000, '25441', 9, 10),
  (5275, '20355', 31, 6);
/*!40000 ALTER TABLE `phamacist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pharmacy`
--

DROP TABLE IF EXISTS `pharmacy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy`
(
  `pharmacy_id` int
(11) NOT NULL,
  `pharmacy_name` varchar
(45) COLLATE utf8_bin NOT NULL,
  `address` varchar
(100) COLLATE utf8_bin NOT NULL,
  `subdistrict` varchar
(45) COLLATE utf8_bin NOT NULL,
  `district` varchar
(45) COLLATE utf8_bin NOT NULL,
  `province` varchar
(45) COLLATE utf8_bin NOT NULL,
  `Telno` varchar
(45) CHARACTER
SET latin1
NOT NULL,
  `latitude` varchar
(45) CHARACTER
SET latin1 DEFAULT
NULL,
  `longtitude` varchar
(45) CHARACTER
SET latin1 DEFAULT
NULL,
  `zipcode` varchar
(45) COLLATE utf8_bin NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastupdate_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY
(`pharmacy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pharmacy`
--

LOCK TABLES `pharmacy` WRITE;
/*!40000 ALTER TABLE `pharmacy` DISABLE KEYS */;
INSERT INTO `
pharmacy`
VALUES
  (1, 'ดรัก คอนเนอร์', '70/1 หมู่ ซอย โชคชัยร่วมมิตร ถนน วิภาวดีรังสิต', 'จอมพล', 'จตุจักร', 'กรุงเทพมหานคร', '02-00000001', NULL, NULL, '10900', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (2, 'พิพัฒน์เภสัช', '958/8 หมู่ ซอย สุขุมวิท 101 ถนน สุขุมวิท', 'บางจาก', 'พระโขนง', 'กรุงเทพมหานคร', '02-00000002', NULL, NULL, '10260', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (3, 'ใกล้เภสัชกร', '33/312 หมู่ 10 ซอย โชคชัย 4 ถนน ลาดพร้าว', 'ลาดพร้าว', 'ลาดพร้าว', 'กรุงเทพมหานคร', '02-00000003', NULL, NULL, '10230', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (4, 'เกรียงแสงเภสัช', '163/11 หมู่ ซอย กล้วยน้ำไท ถนน สุขุมวิท', 'พระโขนง', 'คลองเตย', 'กรุงเทพมหานคร', '02-00000004', NULL, NULL, '10110', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (5, 'จิตนาคลังยา', '26/30 หมู่ 3 ซอย เพชรเกษม 58 ถนน เพชรเกษม', 'บางด้วน', 'ภาษีเจริญ ', 'กรุงเทพมหานคร', '02-00000005', NULL, NULL, '10160', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (6, 'กู๊ดฟาร์มาซี', '9/17 หมู่ ซอย สุขาภิบาล 5 ซอย41 ถนน สุขาภิบาล 5', 'ออเงิน', 'สายไหม ', 'กรุงเทพมหานคร', '02-00000006', NULL, NULL, '10220', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (7, 'เขียวมะกอกเภสัช', '593/7 หมู่ ซอย ถนน ลาดพร้าว', 'ลาดยาว', 'จตุจักร', 'กรุงเทพมหานคร', '02-00000007', NULL, NULL, '10900', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (8, 'คลังยา', '2143/2,2143/3 หมู่ - ซอย - ถนน ลาดพร้าว', 'วังทองหลาง', 'วังทองหลาง', 'กรุงเทพมหานคร', '02-00000008', NULL, NULL, '10310', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (9, 'แจ๊ส เภสัช', '1478 หมู่ ซอย ชานเมือง ถนน รัชดาภิเษก', 'ดินแดง', 'ดินแดง', 'กรุงเทพมหานคร', '02-00000009', NULL, NULL, '10400', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (10, 'จงเสถียรเภสัช', '3189 หมู่ ซอย ถนน ลาดพร้าว', 'ลำผักชี', 'หนองจอก', 'กรุงเทพมหานคร', '02-0000001', NULL, NULL, '10530', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (11, 'ดวงแก้ว บ้านยา', '113/339 หมู่ 11 ซอย ถนน รามอินทรา', 'บางชัน', 'คลองสามวา', 'กรุงเทพมหานคร', '02-00000011', NULL, NULL, '10510', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (12, 'นำจรูญเภสัช', '537/27 หมู่ ซอย ถนน สาธุประดิษฐ์', 'ช่องนนทรี', 'ยานนาวา', 'กรุงเทพมหานคร', '02-00000012', NULL, NULL, '10120', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (13, 'บ้านยา', '77/558 ห้อง 6 หมู่ 5 ซอย บางกระดี่ 1 ถนน บางกระดี่', 'แสมดำ', 'บางขุนเทียน', 'กรุงเทพมหานคร', '02-00000013', NULL, NULL, '10150', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (14, 'ไปรยาเภสัช', '1209 หมู่ ซอย ถนน ลาดกระบัง', 'ลาดกระบัง', 'ลาดกระบัง', 'กรุงเทพมหานคร', '02-00000014', NULL, NULL, '10520', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (15, 'ปิยะกรเภสัช', '121 หมู่ ซอย ศาลธนบุรี ถนน ศาลธนบุรี', 'บางหว้า', 'ภาษีเจริญ', 'กรุงเทพมหานคร', '02-00000015', NULL, NULL, '10160', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (16, 'เจริญเภสัช', '26/28 หมู่ ซอย ถนน จรัญสนิทวงศ์', 'วัดท่าพระ', 'บางกอกใหญ่', 'กรุงเทพมหานคร', '02-00000016', NULL, NULL, '10600', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (17, 'เพชรรุ่งเรือง', '30/121 หมู่ 6 ซอย ชินเขต2 ถนน งามวงศ์วาน', 'ทุ่งสองห้อง', 'หลักสี่', 'กรุงเทพมหานคร', '02-00000017', NULL, NULL, '10210', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (18, 'เม็ดยา ร่มเกล้า', '1261/1 หมู่ ซอย ถนน เคหะร่มเกล้า', 'คลองสองต้นนุ่น', 'ลาดกระบัง', 'กรุงเทพมหานคร', '02-00000018', NULL, NULL, '10520', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (19, 'ไมโคร', '58 หมู่ ซอย ถนน ดินสอ', 'บวรนิเวศ', 'พระนคร', 'กรุงเทพมหานคร', '02-00000019', NULL, NULL, '10200', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (20, 'ยาเภสัชกรชุมชน', '1 หมู่ - ซอย นวมินทร์ 74 แยก 3-8-8 ถนน นวมินทร์', 'คันนายาว', 'คันนายาว', 'กรุงเทพมหานคร', '02-00000020', NULL, NULL, '10230', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (21, 'ขุมทรัพย์เภสัช', '12/5 หมู่ ซอย สุขุมวิท 23 (ประสานมิตร) ถนน สุขุมวิท', 'คลองเตยเหนือ', 'วัฒนา', 'กรุงเทพมหานคร', '02-00000021', NULL, NULL, '10110', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (22, 'กระปุกยา', '583/20 หมู่ 6 ซอย แอนเน็กซ์ ถนน พหลโยธิน', 'สายไหม', 'สายไหม', 'กรุงเทพมหานคร', '02-00000022', NULL, NULL, '10220', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (23, 'ร้านยา อุ่นใจ', '233/24 หมู่ 3 ซอย สรณคมณ์ ถนน สรณคมณ์', 'สีกัน', 'ดอนเมือง', 'กรุงเทพมหานคร', '02-00000023', NULL, NULL, '10210', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (24, 'รุ่งเรืองฟาร์มาซี', '60/16 นิรันดร์เรซิเดนท์ 2 หมู่ 8 ซอย ถนน รามคำแหง2', 'ดอกไม้', 'ประเวศ', 'กรุงเทพมหานคร', '02-00000024', NULL, NULL, '10250', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (25, 'ราชวิถีเภสัช', '419/7 หมู่ ซอย ถนน ราชวิถี', 'ทุ่งพญาไท', 'ราชเทวี', 'กรุงเทพมหานคร', '02-00000025', NULL, NULL, '10400', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (26, 'วุฒิเวช', '95/5 หมู่ ซอย ถนน วุฒากาส', 'ตลาดพลู', 'ธนบุรี', 'กรุงเทพมหานคร', '02-00000026', NULL, NULL, '10600', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (27, 'วิทยาพรเภสัช', '128 หมู่ ซอย กรุงธนบุรี4 ถนน กรุงธนบุรี', 'บางลำภูล่าง', 'คลองสาน', 'กรุงเทพมหานคร', '02-00000027', NULL, NULL, '10600', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (28, 'วดีเภสัช', '844/70 หมู่ ซอย วัดจันทร์ใน ถนน ประดู่ 1', 'บางโคล่', 'บางคอแหลม', 'กรุงเทพมหานคร', '02-00000028', NULL, NULL, '10120', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (29, 'แสงสิริเภสัช', '2/48 หมู่ 14 ซอย - ถนน เสรีไทย', 'มีนบุรี', 'มีนบุรี', 'กรุงเทพมหานคร', '02-00000029', NULL, NULL, '10510', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (30, 'สยามเจริญโอสถ', '193 หมู่ ซอย จรัญสนิทวงศ์ 57 ถนน จรัญสนิทวงศ์', 'บางบำหรุ', 'บางพลัด', 'กรุงเทพมหานคร', '02-00000030', NULL, NULL, '10700', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (31, 'ห้องยาตากสิน', '330 หมู่ ซอย ถนน สมเด็จพระเจ้าตากสิน', 'บุคคโล', 'ธนบุรี', 'กรุงเทพมหานคร', '02-00000031', NULL, NULL, '10600', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (32, 'เตือนใจเภสัช', '251 หมู่ 7 ซอย เพชรเกษม 79 ถนน เพชรเกษม', 'หนองค้างพลู', 'หนองแขม', 'กรุงเทพมหานคร', '02-00000032', NULL, NULL, '10160', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (33, 'ทับยาวเภสัช', '398/6 หมู่ 4 ซอย - ถนน ประชาพัฒนา', 'ทับยาว', 'ลาดกระบัง', 'กรุงเทพมหานคร', '02-00000033', NULL, NULL, '10520', '2020-02-04 14:58:08', '2020-02-04 14:58:08'),
  (34, 'ธัญพรขายยา', '77 หมู่ - ซอย - ถนน ประชาอุทิศ', 'ดอนเมือง', 'ดอนเมือง', 'กรุงเทพมหานคร', '02-00000034', NULL, NULL, '10210', '2020-02-04 14:58:08', '2020-02-04 14:58:08');
/*!40000 ALTER TABLE `pharmacy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `record`
--

DROP TABLE IF EXISTS `record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `record`
(
  `id` int
(11) NOT NULL AUTO_INCREMENT,
  `weight` double DEFAULT NULL,
  `height` double DEFAULT NULL,
  `pressure_sys` int
(11) DEFAULT NULL,
  `pressure_di` int
(11) DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `patient_HN_record` int
(11) NOT NULL,
  `pharmacy_id_record` int
(11) NOT NULL,
  `order_id_record` int
(11) NOT NULL,
  `staff_id_record` int
(11) NOT NULL,
  PRIMARY KEY
(`id`),
  KEY `order_id_record_idx`
(`order_id_record`),
  KEY `pharmacy_id_record_idx`
(`pharmacy_id_record`),
  KEY `patient_HN_idx`
(`patient_HN_record`),
  CONSTRAINT `order_id_record` FOREIGN KEY
(`order_id_record`) REFERENCES `orders`
(`order_id`) ON
DELETE CASCADE ON
UPDATE CASCADE,
  CONSTRAINT `patient_HN_record` FOREIGN KEY
(`patient_HN_record`) REFERENCES `patients`
(`patient_HN`) ON
DELETE CASCADE ON
UPDATE CASCADE,
  CONSTRAINT `pharmacy_id_record` FOREIGN KEY
(`pharmacy_id_record`) REFERENCES `pharmacy`
(`pharmacy_id`) ON
DELETE CASCADE ON
UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET
=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `record`
--

LOCK TABLES `record` WRITE;
/*!40000 ALTER TABLE `record` DISABLE KEYS */;
INSERT INTO `
record`
VALUES
  (3, 60.6, 150, 120, 80, '2020-02-21 00:00:00', 2554, 5, 46, 25),
  (4, 60, 158, 120, 75, '2020-04-01 00:00:00', 2020, 5, 66, 25),
  (5, 60, 160, 120, 75, '2020-04-15 00:00:00', 665, 5, 75, 25),
  (6, 60, 160, 120, 75, '2020-04-15 00:00:00', 665, 5, 81, 25),
  (7, 60, 160, 120, 80, '2020-04-15 00:00:00', 148, 5, 64, 25),
  (8, 60, 160, 120, 75, '2020-04-23 00:00:00', 2554, 5, 59, 25),
  (9, 60, 160, 120, 78, '2020-04-23 00:00:00', 2554, 5, 59, 25),
  (10, 75, 175, 120, 85, '2020-05-07 00:00:00', 148, 5, 93, 25),
  (11, 58, 157, 120, 75, '2020-05-07 00:00:00', 25144, 5, 106, 25),
  (12, 60, 160, 120, 75, '2020-05-07 00:00:00', 148, 5, 108, 25),
  (13, 60, 160, 120, 75, '2020-05-08 00:00:00', 148, 5, 99, 25),
  (14, 67, 178, 120, 75, '2020-05-09 00:00:00', 2020, 5, 115, 25),
  (15, 68, 169, 120, 80, '2020-05-09 00:00:00', 2554, 5, 138, 25),
  (16, 55, 160, 120, 75, '2020-05-09 00:00:00', 15030, 5, 98, 25);
/*!40000 ALTER TABLE `record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users`
(
  `staff_id` int
(11) NOT NULL AUTO_INCREMENT,
  `username` varchar
(45) COLLATE utf8_bin NOT NULL,
  `password` varchar
(100) COLLATE utf8_bin NOT NULL,
  `user_type` varchar
(45) COLLATE utf8_bin NOT NULL,
  `name` varchar
(45) COLLATE utf8_bin NOT NULL,
  `surname` varchar
(45) COLLATE utf8_bin NOT NULL,
  `telno` varchar
(45) COLLATE utf8_bin NOT NULL,
  `email` varchar
(45) COLLATE utf8_bin NOT NULL,
  `sex` varchar
(7) COLLATE utf8_bin NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastupdate_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY
(`staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1249 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `
users`
VALUES
  (5, 'ph5', '1234', 'pharmacist', 'มาริสา', 'รุ่งเรือง', '0989390556', 'mook.nattakan309@gmail.com', 'female', '2020-02-19 01:52:22', '2020-02-19 01:52:22'),
  (14, 'admin', '1234', 'admin', 'Nattakan', 'O.', '0989390556', 'mook.nattakan309@gmail.com', 'female', '2020-02-17 00:58:07', '2020-02-17 00:58:07'),
  (25, 'ph801', 'bananana', 'pharmacist', 'จิดาภา', 'รุ่งเรือง', '0989390556', 'mook.nattakan309@gmail.com', 'female', '2020-02-17 21:28:03', '2020-05-09 18:27:12'),
  (26, 'ph1', '1234', 'pharmacist', 'มาริสา', 'รุ่งเรือง', '0989390556', 'mook.nattakan309@gmail.com', 'female', '2020-02-20 12:25:20', '2020-02-20 12:25:20'),
  (27, 'ph2', '1234', 'pharmacist', 'วรภรณ์', 'สารี', '0989390556', 'mook.nattakan309@gmail.com', 'female', '2020-02-20 12:25:20', '2020-02-20 12:25:20'),
  (28, 'ph3', '1234', 'pharmacist', 'มานพ', 'พาเพลิน', '0989390556', 'mook.nattakan309@gmail.com', 'male', '2020-02-20 12:25:20', '2020-02-20 12:25:20'),
  (29, 'ph4', '1234', 'pharmacist', 'กิตติ', 'พายัพ', '0989390556', 'mook.nattakan309@gmail.com', 'male', '2020-02-20 12:25:20', '2020-02-20 12:25:20'),
  (30, 'ph5', '1234', 'pharmacist', 'วราวุฒิ', 'จันดี', '0989390556', 'mook.nattakan309@gmail.com', 'male', '2020-02-20 12:25:20', '2020-02-20 12:25:20'),
  (31, 'ph6', '1234', 'pharmacist', 'มนัส', 'หมั่นดี', '0989390556', 'mook.nattakan309@gmail.com', 'male', '2020-02-20 12:28:06', '2020-02-20 12:28:06'),
  (111, 'hos1', '1234', 'hos_staff', 'สมชาย', 'มั่นคง', '0815477233', 'mook.nattakan309@gmail.com', 'male', '2020-05-08 09:43:41', '2020-05-08 09:43:41'),
  (112, 'hos2', '1234', 'hos_staff', 'ณภัทร', 'ใจดี', '0851222455', 'mook.nattakan309@gmail.com', 'male', '2020-05-08 09:43:41', '2020-05-08 09:43:41'),
  (113, 'hos3', '1234', 'hos_staff', 'ประเสริฐ', 'จันมี', '0654777339', 'mook.nattakan309@gmail.com', 'male', '2020-05-08 09:43:41', '2020-05-08 09:43:41'),
  (114, 'hos4', '1234', 'hos_staff', 'มารี', 'จันมี', '0641222541', 'mook.nattakan309@gmail.com', 'female', '2020-05-08 09:43:41', '2020-05-08 09:43:41'),
  (115, 'hos5', '1234', 'hos_staff', 'นภา', 'วารี', '0852525141', 'mook.nattakan309@gmail.com', 'female', '2020-05-08 09:43:41', '2020-05-08 09:43:41'),
  (123, 'ph309', '1234', 'pharmacist', 'Nattakan', 'O.', '0989390556', 'mook.nattakan309@gmail.com', 'female', '2020-02-17 00:57:32', '2020-02-17 00:57:32'),
  (1248, 'hospital', '1234', 'hos_staff', 'Nattakan', 'O.', '0989390556', 'mook.nattakan309@gmail.com', 'female', '2020-02-04 14:48:25', '2020-02-04 14:49:20');
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

-- Dump completed on 2020-05-20 19:22:24
