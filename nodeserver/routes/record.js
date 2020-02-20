const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const record = "record";

router.post(
  "/newrecord",

  async (req, res) => {
    try {
      const newrecord = await NewRecord(req.body);
      res.json(newrecord);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var NewRecord = function(item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${record} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ insertId: result.insertId });
    });
  });
};

module.exports = router;
