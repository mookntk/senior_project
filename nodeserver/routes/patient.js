const express = require("express");
const router = express.Router();
const {
  check
} = require("express-validator");
const db = require("../configs/db");
const patient = "patients";
router.get("/showpatients", async (req, res) => {
  try {
    const patients = await all_patients();
    res.json(patients);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
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
      res.status(400).json({
        message: error.message
      });
    }
  }
);

router.post("/deletepatient", async (req, res) => {
  try {
    const patient = await delete_patient(req.body);
    res.json(patient);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

router.post("/editpatient", async (req, res) => {
  try {
    const edited = await edit_patient(req.body);
    res.json(edited);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var all_patients = function () {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT patients.* , pharmacy.pharmacy_id , pharmacy.pharmacy_name FROM ${patient} LEFT JOIN pharmacy ON patients.pharmacy_id_patient = pharmacy.pharmacy_id`,
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

var new_patient = function (item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${patient} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({
        message: "success"
      });
    });
  });
};

var delete_patient = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      'DELETE FROM ${patient} WHERE patient_HN = ?',
      [item.patient_HN],
      (error, result) => {
        if (error) return reject(error);
        resolve({
          message: "success"
        });
      }
    );
  });
};

var edit_patient = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      'UPDATE ${patient} SET name = ?, surname = ?, gender = ?, DOB = ?, Telno = ?, address = ?, subdistrict = ?, district = ?, province = ?, zipcode = ?,pharmacy_id_patient = ?, email = ?, lastupdate_date = NOW() WHERE patient_HN = ?',
      [
        item.name,
        item.surname,
        item.gender,
        item.DOB,
        item.Telno,
        item.address,
        item.subdistrict,
        item.district,
        item.province,
        item.zipcode,
        item.pharmacy_id_patient,
        item.email,
        item.patient_HN
      ],
      (error, result) => {
        if (error) return reject(error);
        resolve({
          message: "success"
        });
      }
    );
  });
};

module.exports = router;