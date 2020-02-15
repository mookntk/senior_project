const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const transport = "orders_transport";
const detail = "orders_transport_detail";

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

router.post("/newtransportdetail", async (req, res) => {
  try {
    //   console.log(req.body);
    const newitem = await newTransportDetail(req.body);
    res.json(newitem);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var newTransportDetail = function(item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${detail} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ insertId: result.insertId });
    });
  });
};

router.post("/del_detail_transid", async (req, res) => {
  try {
    const item = await DeleteTransportDetail(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var DeleteTransportDetail = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `DELETE FROM ${detail} WHERE transport_id = ?`,
      [item.trans_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/edit_transportstatus", async (req, res) => {
  try {
    const item = await EditTransportStatus(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var EditTransportStatus = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE ${transport} SET status = ? WHERE transport_id = ?`,
      [item.status, item.transport_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};
module.exports = router;
