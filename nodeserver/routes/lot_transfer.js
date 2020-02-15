const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const lot = "lot_transfer";

router.post("/newlot", async (req, res) => {
  try {
    const newitem = await NewLot(req.body);
    res.json(newitem);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var NewLot = function(item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${lot} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ insertId: result.insertId });
    });
  });
};

router.post("/deletelot", async (req, res) => {
  try {
    const item = await DeleteLot(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var DeleteLot = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `DELETE FROM ${lot} WHERE transport_id = ?`,
      [item.trans_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/getlot", async (req, res) => {
  try {
    const patients = await getLotByTransport(req.body);
    res.json(patients);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var getLotByTransport = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT * FROM ${lot} WHERE transport_id = ?`,
      [item.trans_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

module.exports = router;
