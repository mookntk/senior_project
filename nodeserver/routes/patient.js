const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");

router.get("/showpatients", async (req, res) => {
  try {
    const patients = await all_patients();
    res.json(patients);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.post(
  "/newpatient",
  [
    check("patient_HN")
      .not()
      .isEmpty(),
    check("name")
      .not()
      .isEmpty(),
    check("surname")
      .not()
      .isEmpty(),
    check("DOB")
      .not()
      .isEmpty(),
    check("gender")
      .not()
      .isEmpty(),
    check("address")
      .not()
      .isEmpty(),
    check("subdistrinct")
      .not()
      .isEmpty(),
    check("distrinct")
      .not()
      .isEmpty(),
    check("province")
      .not()
      .isEmpty()
  ],
  async (req, res) => {
    try {
      //   console.log(req.body);
      const newpatient = await new_patient(req.body);
      res.json(newpatient);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var all_patients = function() {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT * FROM patients LEFT JOIN pharmacy ON patients.pharmacy_id_patient = pharmacy.pharmacy_id",
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

var new_patient = function(item) {
  return new Promise((resolve, reject) => {
    db.query("INSERT INTO patients SET ?", item, (error, result) => {
      if (error) return reject(error);
      resolve({ message: "success" });
    });
  });
};
module.exports = router;
