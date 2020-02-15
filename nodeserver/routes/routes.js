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
const transport = require("./transport_order");
const lot_transfer = require("./lot_transfer");

router.use("/user", user);
router.use("/medicine", medicine);
router.use("/patient", patient);
router.use("/disease", disease);
router.use("/disease-patient", diseasepatient);
router.use("/pharmacy", pharmacy);
router.use("/pharmacist", pharmacist);
router.use("/order", order);
router.use("/log", log);
router.use("/transport", transport);
router.use("/lot_transfer", lot_transfer);

module.exports = router;
