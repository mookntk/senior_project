const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const transport = "orders_transport";

router.post("/gettransport", async (req, res) => {
  try {
    const patients = await getTransportStatus(req.body);
    res.json(patients);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var getTransportStatus = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT DISTINCT o.transport_id , o.pharmacy_id_transport FROM ${transport} as o WHERE status = ?`,
      [item.status],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/newtransport", async (req, res) => {
  try {
    //   console.log(req.body);
    const newitem = await newTransportOrder(req.body);
    res.json(newitem);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var newTransportOrder = function(item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${transport} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ insertId: result.insertId });
    });
  });
};

module.exports = router;
