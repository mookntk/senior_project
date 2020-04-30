const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const lot = "lot_order";

router.post("/newlot", async (req, res) => {
  try {
    const newitem = await NewLot(req.body);
    res.json(newitem);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var NewLot = function (item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${lot} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ insertId: result.insertId });
    });
  });
};

router.post("/dellot", async (req, res) => {
  try {
    const item = await DeleteLot(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var DeleteLot = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `DELETE FROM ${lot} WHERE lot_no_id = ?`,
      [item.lot_no_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/getlot_byid", async (req, res) => {
  try {
    const item = await getLotByID(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getLotByID = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select l.*,od.*,o.status,o.remark,o.receive_date ,p.name,p.surname,p.telno,p.email from lot_order as l inner join order_detail as od on od.order_id = l.order_id and l.medicine_id = od.medicine_id inner join orders as o on  o.order_id = od.order_id inner join patients as p on p.patient_HN = o.patient_HN_order where l.lot_transfer_id =? order by o.order_id ASC`,
      [item.lot_no_id],
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};
module.exports = router;
