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

router.post(
  "/getrecordorder",

  async (req, res) => {
    try {
      const newrecord = await getRecordOrder(req.body);
      res.json(newrecord);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var getRecordOrder = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT * FROM ${record} WHERE order_id_record = ? `,
      [item.order_id],
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

//cancel order in prepare medication
router.post(
  "/cancel_order",
  [
    check("order_id")
      .not()
      .isEmpty()
  ],
  async (req, res) => {
    try {
      const cancel = await cancel_order(req.body);
      res.json(cancel);
    } catch (error) {
      res.status(400).json({
        message: error.message
      });
    }
  }
);

var cancel_order = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      "UPDATE orders SET status='cancel'" +
        "WHERE order_id='" +
        item.order_id +
        "'",
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};
module.exports = router;
