const express = require("express");
const router = express.Router();
const user = require("./user");
const patient = require("./patient");
router.use("/user", user);
router.use("/patient", patient);
module.exports = router;
