dateFormat = require("dateformat");
const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const order = "orders";
const detail = "order_detail";

router.post(
  "/neworder",
  [
    check("patient_HN_order").not().isEmpty(),
    check("due_date").not().isEmpty(),
    check("status").not().isEmpty(),
    check("staff_id_order").not().isEmpty(),
  ],
  async (req, res) => {
    try {
      const neworder = await NewOrder(req.body);
      res.json(neworder);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var NewOrder = function (item) {
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
    check("order_id").not().isEmpty(),
    check("medicine_id").not().isEmpty(),
    check("qty").not().isEmpty(),
    check("administration").not().isEmpty(),
  ],
  async (req, res) => {
    try {
      const newdetail = await NewOrderDetail(req.body);
      res.json(newdetail);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var NewOrderDetail = function (item) {
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

var DeleteDetailOrderid = function (item) {
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

var DeleteOrder = function (item) {
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

router.post("/edit_orderstatus", async (req, res) => {
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
      `UPDATE ${order} SET status = ? , transport_id =? WHERE order_id = ?`,
      [item.status, item.transport_id, item.order_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/edit_missingorder", async (req, res) => {
  try {
    const item = await EditMissingOrder(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var EditMissingOrder = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE ${order} SET status = ? ,remark='ยาขาด', transport_id =? WHERE order_id = ?`,
      [item.status, item.transport_id, item.order_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/getorder_status", async (req, res) => {
  try {
    const item = await GetOrderByStatus(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var GetOrderByStatus = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT od.*,CASE WHEN od.qty_missing > 0 THEN od.qty_missing ELSE od.qty END AS qty, o.* , ol.name , ol.surname , m.*,ph.pharmacy_name, ph.province,tr.status as 'transport_status' from orders as o left join patients as ol ON o.patient_HN_order = ol.patient_HN inner join order_detail as od ON o.order_id = od.order_id inner join medicine as m ON m.medicine_id = od.medicine_id inner join pharmacy as ph on ph.pharmacy_id = o.pharmacy_id left join orders_transport as tr on tr.transport_id = o.transport_id where (o.status = ? and o.remark='ยาขาด' and od.qty_missing>0) or (o.status = ? and o.remark is null )  order by o.order_id ASC;`,
      [item.status, item.status],
      (error, result) => {
        if (error) return reject(error);
        var dataformat = [];
        var count = 0;
        result.forEach((element, index) => {
          // element.create_date = dateFormat(element.create_date, "dd/mm/yyyy");
          var medicineObj = {
            medicine_id: element.medicine_id,
            medicine_tmt: element.medicine_tmt,
            medicine_generic: element.medicine_generic,
            medicine_trade: element.medicine_trade,
            strength: element.strength,
            unit: element.unit,
            qty: element.qty,
            price: element.price,
            lotno: element.lotno,
            qty_missing: element.qty_missing,
          };
          delete element.medicine_id;
          delete element.medicine_tmt;
          delete element.medicine_generic;
          delete element.medicine_trade;
          delete element.strength;
          delete element.unit;
          delete element.qty;
          delete element.price;
          delete element.lotno;
          delete element.qty_missing;
          if (index == 0) {
            dataformat.push(element);
            dataformat[index]["medicineItem"] = [medicineObj];
          }
          if (index > 0) {
            if (result[index - 1].order_id != result[index].order_id) {
              count++;
              dataformat.push(element);
              dataformat[count]["medicineItem"] = [medicineObj];
            } else {
              dataformat[count]["medicineItem"].push(medicineObj);
            }
          }
        });
        return resolve(dataformat);
      }
    );
  });
};

router.post("/edit_nummed", async (req, res) => {
  try {
    const item = await EditNumMedicine(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var EditNumMedicine = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE ${detail} SET qty = ? WHERE order_id = ? AND medicine_id = ?`,
      [item.qty, item.order_id, item.medicine_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/edit_qtymissing", async (req, res) => {
  try {
    const item = await EditqtyMissing(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var EditqtyMissing = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE ${detail} SET qty_missing = ? WHERE order_id = ? AND medicine_id = ?`,
      [item.qty_missing, item.order_id, item.medicine_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/getorder_phid", async (req, res) => {
  try {
    const item = await GetOrderByPhId(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var GetOrderByPhId = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT o.* , ol.name , ol.surname ,od.*, m.*,ph.pharmacy_name, ph.province,tr.status as 'transport_status' from orders as o left join patients as ol ON o.patient_HN_order = ol.patient_HN inner join order_detail as od ON o.order_id = od.order_id inner join medicine as m ON m.medicine_id = od.medicine_id inner join pharmacy as ph on ph.pharmacy_id = o.pharmacy_id left join orders_transport as tr on tr.transport_id = o.transport_id WHERE o.status= ? and o.pharmacy_id = ? order by o.order_id ASC;`,
      ["received", item.pharmacy_id],
      (error, result) => {
        if (error) return reject(error);
        var dataformat = [];
        var count = 0;
        result.forEach((element, index) => {
          element.create_date = dateFormat(element.create_date, "dd/mm/yyyy");
          var medicineObj = {
            medicine_id: element.medicine_id,
            medicine_tmt: element.medicine_tmt,
            medicine_generic: element.medicine_generic,
            medicine_trade: element.medicine_trade,
            strength: element.strength,
            unit: element.unit,
            qty: element.qty,
            price: element.price,
            lotno: element.lotno,
          };
          delete element.medicine_id;
          delete element.medicine_tmt;
          delete element.medicine_generic;
          delete element.medicine_trade;
          delete element.strength;
          delete element.unit;
          delete element.qty;
          delete element.price;
          delete element.lotno;
          if (index == 0) {
            dataformat.push(element);
            dataformat[index]["medicineItem"] = [medicineObj];
          }
          if (index > 0) {
            if (result[index - 1].order_id != result[index].order_id) {
              count++;
              dataformat.push(element);
              dataformat[count]["medicineItem"] = [medicineObj];
            } else {
              dataformat[count]["medicineItem"].push(medicineObj);
            }
          }
        });
        return resolve(dataformat);
      }
    );
  });
};

router.get("/getorder_history", async (req, res) => {
  try {
    const item = await GetOrderHistory();
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var GetOrderHistory = function () {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT o.* , p.name , p.surname , ph.pharmacy_name from orders as o left join patients as p ON o.patient_HN_order = p.patient_HN inner join pharmacy as ph on o.pharmacy_id = ph.pharmacy_id WHERE o.status in ('prepare','ready','cancel','success') order by o.order_id DESC;`,
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/getorder_detail", async (req, res) => {
  try {
    const item = await GetOrderDetail(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var GetOrderDetail = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT od.*,m.* from order_detail as od inner join medicine as m on od.medicine_id = m.medicine_id WHERE od.order_id =?`,
      [item.order_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/getnext_duedate", async (req, res) => {
  try {
    const item = await getNextDueDate(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getNextDueDate = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT p.name,p.surname,o.next_due_date,p.patient_HN from orders as o inner join patients as p on o.patient_HN_order = p.patient_HN WHERE o.next_due_date between ? and ?`,
      [item.start, item.end],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/getorderpatient", async (req, res) => {
  try {
    const item = await getOrderPatient(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getOrderPatient = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select o.* from orders as o where o.patient_HN_order = ? and o.due_date between ? and ?`,
      [item.patient_HN, item.due_date_start, item.due_date_end],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/getpatientinfo", async (req, res) => {
  try {
    const item = await getPatientInfo(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getPatientInfo = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select o.*,od.administration,od.medicine_id,od.numpertime,m.*,d.* from orders as o inner join patients as p on o.patient_HN_order = p.patient_HN inner join order_detail as od on od.order_id = o.order_id inner join medicine as m on m.medicine_id = od.medicine_id inner join diseases as d on d.disease_id = m.disease_id_medicine where p.patient_HN = ? order by o.order_id  DESC,m.disease_id_medicine`,
      [item.patient_HN],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};
module.exports = router;
