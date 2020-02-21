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
const receive_order = require("./receive_order");
const ph_prepare = require("./ph_prepare");
const ready_sell = require("./ready_sell");
const order_status = require("./order_status");
const record = require("./record");

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
router.use("/receive_order", receive_order);
router.use("/ph_prepare", ph_prepare);
router.use("/ready_sell", ready_sell);
router.use("/order_status", order_status);
router.use("/record", record);

module.exports = router;
