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

var NewLot = function (item) {
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

var DeleteLot = function (item) {
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
      message: error.message,
    });
  }
});

var getLotByTransport = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT lot_no ,lot_no_id,qty,medicine_id,transport_id, DATE_FORMAT(lot_transfer.exp_date,'%Y-%m-%d') as exp_date FROM ${lot} WHERE transport_id = ?`,
      [item.trans_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/getlotonemed", async (req, res) => {
  try {
    const patients = await getLotOneMed(req.body);
    res.json(patients);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var getLotOneMed = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT lot_no_id,lot_no,qty,medicine_id,transport_id,qty_less, DATE_FORMAT(lot_transfer.exp_date,'%Y-%m-%d') as exp_date FROM ${lot} WHERE transport_id = ? and medicine_id = ? `,
      [item.transport_id, item.medicine_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/editlot", async (req, res) => {
  try {
    const item = await EditOrderStatus(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var EditOrderStatus = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE ${lot} SET qty_less = ? WHERE lot_no_id =? `,
      [item.qty_less, item.lot_no_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/editlotreturn", async (req, res) => {
  try {
    const item = await EditLotReturn(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var EditLotReturn = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE ${lot} SET qty_less = qty_less+? WHERE lot_no_id =? `,
      [parseInt(item.qty_less), item.lot_no_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};
router.post("/getonelot", async (req, res) => {
  try {
    const patients = await getoneLot(req.body);
    res.json(patients);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var getoneLot = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT lot_no ,lot_no_id,qty,medicine_id,transport_id, DATE_FORMAT(lot_transfer.exp_date,'%Y-%m-%d') as exp_date FROM ${lot} WHERE lot_no_id = ?`,
      [item.lot_no_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

module.exports = router;
