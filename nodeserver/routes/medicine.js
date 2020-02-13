const express = require("express");
const router = express.Router();
const {
  check
} = require("express-validator");
const db = require("../configs/db");

//edit medicine
router.post(
  "/editmedicine",
  [
    check("medicine_tmt")
    .not()
    .isEmpty(),
    check("medicine_generic")
    .not()
    .isEmpty(),
    check("medicine_trade")
    .not()
    .isEmpty(),
    check("strenght")
    .not()
    .isEmpty(),
    check("price")
    .not()
    .isEmpty(),
    check("unit")
    .not()
    .isEmpty(),
    check("disease_name")
    .not()
    .isEmpty()
  ],
  async (req, res) => {
    try {
      const editmedicine = await edit_medicine(req.body);
      res.json(editmedicine);
    } catch (error) {
      res.status(400).json({
        message: error.message
      });
    }
  }
);

var edit_medicine = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT * FROM diseases WHERE disease_name='" + item.disease_name + "'",
      (error, result) => {
        db.query(
          "UPDATE medicine SET medicine_tmt='" +
          item.medicine_tmt +
          "',medicine_generic='" +
          item.medicine_generic +
          "',medicine_trade='" +
          item.medicine_trade +
          "',strenght='" +
          item.strenght +
          "',price='" +
          item.price +
          "',unit='" +
          item.unit +
          "',disease_id_medicine='" +
          result[0].disease_id +
          "' WHERE medicine_id='" +
          item.medicine_id +
          "'",
          (error, result) => {
            if (error) return reject(error);

            resolve({
              message: "success"
            });
          }
        );
      }
    );
  });
};

//show all medicine
router.get("/showmedicine", async (req, res) => {
  try {
    const medicine = await show_medicine();
    res.json(medicine);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var show_medicine = function () {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT * FROM medicine AS d1 INNER JOIN diseases AS d2 ON (d2.disease_id=d1.disease_id_medicine)",
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

//show all disease
router.get("/showdisease", async (req, res) => {
  try {
    const disease = await select_disease();
    res.json(disease);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var select_disease = function () {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM diseases", (error, result) => {
      if (error) return reject(error);
      resolve(result);
    });
  });
};

//new disease
router.post(
  "/newmedicine",
  [
    check("medicine_tmt")
    .not()
    .isEmpty(),
    check("medicine_generic")
    .not()
    .isEmpty(),
    check("medicine_trade")
    .not()
    .isEmpty(),
    check("strenght")
    .not()
    .isEmpty(),
    check("price")
    .not()
    .isEmpty(),
    check("unit")
    .not()
    .isEmpty(),
    check("disease_name")
    .not()
    .isEmpty()
  ],
  async (req, res) => {
    try {
      const newmedicine = await new_medicine(req.body);
      res.json(newmedicine);
    } catch (error) {
      res.status(400).json({
        message: error.message
      });
    }
  }
);

var new_medicine = function (item) {
  return new Promise((resolve, reject) => {
    var disease_id = "";
    db.query(
      "SELECT * FROM diseases WHERE disease_name='" + item.disease_name + "'",
      (error, result) => {
        disease_id = result[0].disease_id;
        if (disease_id == "") {
          db.query(
            "INSERT INTO diseases (disease_name) VALUES ('" +
            item.disease_name +
            "')",
            (error, result) => {
              if (error) return reject(error);
              db.query(
                "INSERT INTO medicine (medicine_tmt, medicine_generic, medicine_trade, strenght, price, unit, disease_id_medicine) VALUES ('" +
                item.medicine_tmt +
                "','" +
                item.medicine_generic +
                "','" +
                item.medicine_trade +
                "','" +
                item.strenght +
                "','" +
                item.price +
                "','" +
                item.unit +
                "','" +
                result.insertId +
                "')",
                (error, result) => {
                  if (error) return reject(error);
                  resolve({
                    message: "success"
                  });
                }
              );
            }
          );
        } else {
          db.query(
            "INSERT INTO medicine (medicine_tmt, medicine_generic, medicine_trade, strenght, price, unit, disease_id_medicine) VALUES ('" +
            item.medicine_tmt +
            "','" +
            item.medicine_generic +
            "','" +
            item.medicine_trade +
            "','" +
            item.strenght +
            "','" +
            item.price +
            "','" +
            item.unit +
            "','" +
            disease_id +
            "')",
            (error, result) => {
              if (error) return reject(error);
              resolve({
                message: "success"
              });
            }
          );
        }
      }
    );
  });
};

//deletemedicine
router.post("/deletemedicine", async (req, res) => {
  try {
    const deletemedicine = await delete_medicine(req.body);
    res.json(deletemedicine);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var delete_medicine = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "DELETE FROM medicine WHERE medicine_id='" + item.medicine_id + "'",
      (error, result) => {
        if (error) return reject(error);
        resolve({
          message: "success"
        });
      }
    );
  });
};

//newdisease
router.post(
  "/newdisease",
  [
    check("dis_name")
    .not()
    .isEmpty(),
    check("dis_icd")
    .not()
    .isEmpty()
  ],
  async (req, res) => {
    try {
      const newdisease = await new_disease(req.body);
      res.json(newdisease);
    } catch (error) {
      res.status(400).json({
        message: error.message
      });
    }
  }
);

var new_disease = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "INSERT INTO diseases (disease_name,icd10) VALUES ('" + item.dis_name + "','" + item.dis_icd + "')",
      (error, result) => {
        if (error) return reject(error);
        resolve({
          message: "success"
        });
      }
    );
  });
};

//deletedisease
router.post("/deletedisease", async (req, res) => {
  try {
    const deletedisease = await delete_disease(req.body);
    res.json(deletedisease);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var delete_disease = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "DELETE FROM diseases WHERE disease_name='" + item.delete_name + "'",
      (error, result) => {
        if (error) return reject(error);
        resolve({
          message: "success"
        });
      }
    );
  });
};

//show medicine sort by disease
router.post("/showmedicine_disease", async (req, res) => {
  try {
    const medicine = await show_medicinebydisease(req.body);
    res.json(medicine);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

var show_medicinebydisease = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT * FROM medicine WHERE disease_id_medicine = ?",
      [item.disease_id],
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};
module.exports = router;