const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const diseases = "diseases";

router.get("/getdiseases", async (req, res) => {
  try {
    const diseases = await all_diseases();
    res.json(diseases);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var all_diseases = function() {
  return new Promise((resolve, reject) => {
    db.query(`SELECT * FROM ${diseases}`, (error, result) => {
      if (error) return reject(error);
      return resolve(result);
    });
  });
};

module.exports = router;
