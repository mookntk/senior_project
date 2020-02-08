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

router.post(
  "/editd_p",
  [
    check("patient_HN_diseases_patient")
      .not()
      .isEmpty()
  ],
  async (req, res) => {
    try {
      const edit = await editdisease_patient(req.body);
      res.json(edit);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

router.post("/deleted_p", async (req, res) => {
  try {
    const deleted = await deletedisease_patient(req.body);
    res.json(deleted);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.get("/getalldisease_patient", async (req, res) => {
  try {
    const disease = await getalldisease_patient();
    res.json(disease);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.post("/getdiseasebyhn", async (req, res) => {
  try {
    const disease = await getdisease_hn(req.body);
    res.json(disease);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var adddisease_patient = function(item) {
  console.log(item);
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${table} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ message: "success" });
    });
  });
};

var editdisease_patient = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE ${table} SET disease_id = ? WHERE patient_HN = ? AND disease_id = ?`,
      [item.disease_id, item.patient_HN, item.disease_id_old],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

var deletedisease_patient = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `DELETE FROM ${table} WHERE patient_HN = ?`,
      [item.patient_HN],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

var getalldisease_patient = function() {
  return new Promise((resolve, reject) => {
    db.query(`SELECT * FROM ${table}`, (error, result) => {
      if (error) return reject(error);
      return resolve(result);
    });
  });
};

var getdisease_hn = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT * FROM ${table} WHERE patient_HN = ?`,
      [item.patient_HN],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};
module.exports = router;
