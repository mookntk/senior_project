const express = require("express");
const router = express.Router();
const user = require("./user");
const patient = require("./patient");
const disease = require("./disease");
const diseasepatient = require("./disease_patient");

const pharmacy = require("./pharmacy");
const pharmacist = require("./pharmacist");
router.use("/user", user);
router.use("/patient", patient);
router.use("/disease", disease);
router.use("/disease-patient", diseasepatient);

router.use("/pharmacy", pharmacy);
router.use("/pharmacist", pharmacist);
module.exports = router;
