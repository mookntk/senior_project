const express = require("express");
const router = express.Router();
const user = require("./user");
const patient = require("./patient");
const pharmacy = require("./pharmacy");
const pharmacist = require("./pharmacist");
router.use("/user", user);
router.use("/patient", patient);
router.use("/pharmacy", pharmacy);
router.use("/pharmacist", pharmacist);
module.exports = router;
