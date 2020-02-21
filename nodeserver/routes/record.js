const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const record = "record";

router.post(
  "/newrecord",

  async (req, res) => {
    try {
      const newrecord = await newRecord(req.body);
      res.json(newrecord);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var newRecord = function(item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${record} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ insertId: result.insertId });
    });
  });
};

router.post(
  "/getrecord",

  async (req, res) => {
    try {
      const newrecord = await getRecord(req.body);
      res.json(newrecord);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var getRecord = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT record.*, users.name,users.surname FROM ${record} left join users on record.staff_id_record = users.staff_id WHERE patient_HN_record = ? order by date desc`,
      [item.patient_HN],
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

module.exports = router;
