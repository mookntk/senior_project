const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");

//show transfer order
router.post("/show_transfer_order", async (req, res) => {
  try {
    const transfer_order = await show_transfer_order(req.body);
    res.json(transfer_order);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var show_transfer_order = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT count(*) AS qty_orders,t.transport_id,t.status, DATE_FORMAT(t.transport_date,'%d %m %Y') AS transport_date, DATE_FORMAT(t.receive_date,'%d %m %Y') AS receive_date,u.name,u.surname FROM orders as o ,orders_transport as t left join users as u on u.staff_id = t.pharmacist_id_transport WHERE t.transport_id = o.transport_id and t.pharmacy_id_transport = '" +
        item.pharmacy_id +
        "' and t.status in('transport' ,'received' )  group by t.transport_id,t.transport_date,t.receive_date order by t.status DESC;",

      (error, result) => {
        if (error) return reject(error);

        console.log(item.pharmacy_id);
        resolve(result);
      }
    );
  });
};

router.post("/show_confirm_order", async (req, res) => {
  try {
    const transfer_order = await show_confirm_order(req.body);
    res.json(transfer_order);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var show_confirm_order = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT count(*) AS qty_orders,t.transport_id,t.status, DATE_FORMAT(t.transport_date,'%d %m %Y') AS transport_date, DATE_FORMAT(t.receive_date,'%d %m %Y') AS receive_date FROM orders_transport as t, orders as o WHERE t.transport_id = o.transport_id and t.pharmacy_id_transport = '" +
        item.pharmacy_id +
        "' and t.status = 'received'  group by t.transport_id,t.transport_date,t.receive_date",

      (error, result) => {
        if (error) return reject(error);

        console.log(item.pharmacy_id);
        resolve(result);
      }
    );
  });
};

//show order in dialog
router.post(
  "/show_order",
  [check("transport_id").not().isEmpty()],
  async (req, res) => {
    try {
      const each_order = await show_order(req.body);
      res.json(each_order);
    } catch (error) {
      res.status(400).json({
        message: error.message,
      });
    }
  }
);

var show_order = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT o.order_id,o.remark,p.name,p.surname, DATE_FORMAT(o.create_date,'%d %m %Y') AS create_date," +
        "DATE_FORMAT(o.due_date,'%d %m %Y') AS due_date," +
        "group_concat(m.medicine_generic) as medicine_generic, " +
        "group_concat(m.strength) as strength, " +
        "group_concat(COALESCE(od.qty_missing, 'NULL')) as qty_missing, " +
        "group_concat(od.qty) as qty, " +
        "group_concat(m.unit) as unit " +
        "from orders as o " +
        "left join patients as p ON o.patient_HN_order = p.patient_HN " +
        "left join order_detail as od on od.order_id = o.order_id " +
        "inner join medicine as m ON m.medicine_id = od.medicine_id " +
        "WHERE o.transport_id ='" +
        item.transport_id +
        "'" +
        "AND o.pharmacy_id ='" +
        item.pharmacy_id +
        "'" +
        "group by o.order_id ",
      // "SELECT o.order_id,o.create_date,o.due_date , p.name , p.surname , group_concat(m.medicine_generic), " +
      // "group_concat(od.qty), group_concat(m.unit) " +
      // "from orders as o " +
      // "left join patients as p ON o.patient_HN_order = p.patient_HN "+
      // "inner join order_detail as od ON o.order_id = od.order_id "+
      // "inner join medicine as m ON m.medicine_id = od.medicine_id "+
      // "left join orders_transport as tr on tr.transport_id = o.transport_id"+
      // "WHERE o.transport_id ='3'",
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

router.post(
  "/edit_receivedate",
  [check("transport_id").not().isEmpty()],
  async (req, res) => {
    try {
      const editedItem = await editReceivedate(req.body);
      res.json(editedItem);
    } catch (error) {
      res.status(400).json({
        message: error.message,
      });
    }
  }
);

var editReceivedate = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE orders_transport SET receive_date = NOW() ,status = ? WHERE transport_id = ?`,
      ["received", item.transport_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({
          message: "success",
        });
      }
    );
  });
};
module.exports = router;
