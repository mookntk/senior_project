const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const order_status = "order_status";

//show order fliter by it status
router.post(
  "/order_with_status",
  [check("pharmacy_id").not().isEmpty()],
  async (req, res) => {
    try {
      const s_order = await orderstatus(req.body);
      res.json(s_order);
    } catch (error) {
      res.status(400).json({
        message: error.message,
      });
    }
  }
);

var orderstatus = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT o.order_id,o.patient_HN_order,p.name,p.surname,o.status,o.remark,DATE_FORMAT(o.due_date,'%Y %m %d') AS due_date,o.return_id " +
        "from orders as o " +
        "left join patients as p ON o.patient_HN_order = p.patient_HN " +
        "WHERE o.pharmacy_id ='" +
        item.pharmacy_id +
        "'" +
        "AND (o.status = 'success'OR o.status = 'cancel'  OR o.status = 'missing') " +
        "group by o.order_id",
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

//oneorder gor each patient
router.post(
  "/one_order",
  [check("order_id").not().isEmpty()],
  [check("patient_HN_order").not().isEmpty()],
  async (req, res) => {
    try {
      const oneorder = await one_order(req.body);
      res.json(oneorder);
    } catch (error) {
      res.status(400).json({
        message: error.message,
      });
    }
  }
);

var one_order = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT o.order_id,p.name,p.surname,p.gender,p.DOB,o.status,o.patient_HN_order,m.medicine_id,m.medicine_generic,m.strength,od.qty,m.unit,od.received " +
        "from orders AS o " +
        "left join patients as p ON o.patient_HN_order = p.patient_HN " +
        "left join order_detail as od on od.order_id = o.order_id " +
        "inner join medicine as m ON m.medicine_id = od.medicine_id " +
        "WHERE od.received in ('false','0') and o.patient_HN_order ='" +
        item.patient_HN_order +
        "'" +
        "AND o.order_id ='" +
        item.order_id +
        "'",
      // "group by o.order_id",
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

module.exports = router;
