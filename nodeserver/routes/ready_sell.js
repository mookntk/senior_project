const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const ready_sell = "ready_sell";

//show patient order
router.post(
  "/ready_order",
  [check("pharmacy_id").not().isEmpty()],
  async (req, res) => {
    try {
      const r_order = await ready_order(req.body);
      res.json(r_order);
    } catch (error) {
      res.status(400).json({
        message: error.message,
      });
    }
  }
);

var ready_order = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT o.order_id,o.patient_HN_order,p.name,p.surname,p.telno,p.email,o.status,DATE_FORMAT(o.due_date,'%Y %m %d') AS due_date " +
        "from orders as o " +
        "left join patients as p ON o.patient_HN_order = p.patient_HN " +
        "WHERE o.status ='ready' " +
        "AND o.pharmacy_id ='" +
        item.pharmacy_id +
        "'" +
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
  // [
  //     check("pharmacy_id")
  //     .not()
  //     .isEmpty()
  // ],
  [check("order_id").not().isEmpty()],
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
      "SELECT o.order_id,p.name,p.surname,p.gender,p.telno,p.email,p.DOB,o.status,o.patient_HN_order,m.medicine_generic,m.strength,od.qty,m.unit,m.medicine_id " +
        // "group_concat(m.medicine_generic) as medicine_generic, " +
        // "group_concat(m.strenght) as strenght, " +
        // "group_concat(od.qty) as qty, " +
        // "group_concat(m.unit) as unit " +
        "from orders AS o " +
        "left join patients as p ON o.patient_HN_order = p.patient_HN " +
        "left join order_detail as od on od.order_id = o.order_id " +
        "inner join medicine as m ON m.medicine_id = od.medicine_id " +
        "WHERE o.status ='ready' " +
        // "AND o.pharmacy_id ='" +
        // item.pharmacy_id +
        // "'" +
        "AND o.order_id ='" +
        item.order_id +
        "'",
      // +
      // "group by o.order_id",
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

router.post("/getlot", async (req, res) => {
  try {
    const patients = await getLot(req.body);
    res.json(patients);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var getLot = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select l.* ,o.status ,o.order_id from lot_transfer as l inner join orders as o on o.transport_id = l.transport_id where o.pharmacy_id = ? and l.medicine_id = ? and o.status in ('ready','prepare' ) and l.qty_less > 0`,
      [item.pharmacy_id, item.medicine_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/getmedicine", async (req, res) => {
  try {
    const patients = await getMedicine(req.body);
    res.json(patients);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var getMedicine = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select * from orders as o inner join order_detail as od on od.order_id = o.order_id where o.order_id = ?`,
      [item.order_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post(
  "/success",
  [check("order_id").not().isEmpty()],
  async (req, res) => {
    try {
      const oneorder = await successOrder(req.body);
      res.json(oneorder);
    } catch (error) {
      res.status(400).json({
        message: error.message,
      });
    }
  }
);

var successOrder = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE orders SET status='success' ,remark=?, receive_date = NOW() WHERE order_id=? `,
      [item.remark, item.order_id],
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

router.post("/editreceived", async (req, res) => {
  try {
    const patients = await editReceived(req.body);
    res.json(patients);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var editReceived = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE order_detail SET received=? WHERE order_id=? AND medicine_id=?`,
      [item.received, item.order_id, item.medicine_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

module.exports = router;
