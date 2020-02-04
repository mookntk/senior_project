const express = require("express");
const router = express.Router();
const user = require("./user");
const patient = require("./patient");
const disease = require("./disease");
const diseasepatient = require("./disease_patient");

router.use("/user", user);
router.use("/patient", patient);
router.use("/disease", disease);
router.use("/disease-patient", diseasepatient);

module.exports = router;
