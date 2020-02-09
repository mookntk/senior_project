const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const order = "orders";
const detail = "order_detail";
router.post(
  "/neworder",
  [
    check("patient_HN_order")
      .not()
      .isEmpty(),
    check("due_date")
      .not()
      .isEmpty(),
    check("status")
      .not()
      .isEmpty(),
    check("staff_id_order")
      .not()
      .isEmpty()
  ],
  async (req, res) => {
    try {
      const neworder = await new_order(req.body);
      res.json(neworder);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var new_order = function(item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${order} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ insertId: result.insertId });
    });
  });
};

router.post(
  "/neworder_detail",
  [
    check("order_id")
      .not()
      .isEmpty(),
    check("medicine_id")
      .not()
      .isEmpty(),
    check("qty")
      .not()
      .isEmpty(),
    check("administration")
      .not()
      .isEmpty()
  ],
  async (req, res) => {
    try {
      const newdetail = await new_order_detail(req.body);
      res.json(newdetail);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var new_order_detail = function(item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${detail} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ message: "success" });
    });
  });
};

router.post("/del_detail_orderid", async (req, res) => {
  try {
    const item = await DeleteDetailOrderid(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var DeleteDetailOrderid = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `DELETE FROM ${detail} WHERE order_id = ?`,
      [item.order_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/del_order", async (req, res) => {
  try {
    const item = await DeleteOrder(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var DeleteOrder = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `DELETE FROM ${order} WHERE order_id = ?`,
      [item.order_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/getorder_status", async (req, res) => {
  try {
    const patients = await GetOrderByStatus(req.body);
    res.json(patients);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var GetOrderByStatus = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT * FROM ${order} WHERE status = ?`,
      [item.status],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};
module.exports = router;
