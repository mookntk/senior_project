const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const log = "orderlog";

router.post(
  "/newlog",
  [
    check("status")
      .not()
      .isEmpty(),
    check("start_date")
      .not()
      .isEmpty(),
    check("staff_id_log")
      .not()
      .isEmpty(),
    check("order_id_log")
      .not()
      .isEmpty()
  ],
  async (req, res) => {
    try {
      const neworder = await new_log(req.body);
      res.json(neworder);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var new_log = function(item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${log} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ message: "success" });
    });
  });
};

router.post("/del_log_orderid", async (req, res) => {
  try {
    const item = await DeleteLogOrderid(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var DeleteLogOrderid = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `DELETE FROM ${log} WHERE order_id_log = ?`,
      [item.order_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};
module.exports = router;
