const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const table = "diseases_patient";

router.post(
  "/addd_p",
  [
    check("patient_HN_diseases_patient")
      .not()
      .isEmpty()
  ],
  async (req, res) => {
    try {
      const newrow = await adddisease_patient(req.body);
      res.json(newrow);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var adddisease_patient = function(item) {
  console.log(item);
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${table} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ message: "success" });
    });
  });
};

module.exports = router;
