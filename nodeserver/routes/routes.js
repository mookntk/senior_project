const express = require("express");
const router = express.Router();
const user = require("./user");
const pharmacy = require("./pharmacy");
const pharmacist = require("./pharmacist");
const medicine = require("./medicine");

const patient = require("./patient");
const disease = require("./disease");
const diseasepatient = require("./disease_patient");

const order = require("./order");
const log = require("./orderlog");

router.use("/user", user);
router.use("/medicine", medicine);

router.use("/patient", patient);
router.use("/disease", disease);
router.use("/disease-patient", diseasepatient);
router.use("/pharmacy", pharmacy);
router.use("/pharmacist", pharmacist);
router.use("/order", order);
router.use("/log", log);

module.exports = router;
