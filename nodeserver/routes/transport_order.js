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
      message: error.message,
    });
  }
});

var getTransportStatus = function (item) {
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
      message: error.message,
    });
  }
});

var newTransportOrder = function (item) {
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
      message: error.message,
    });
  }
});

var newTransportDetail = function (item) {
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

var DeleteTransportDetail = function (item) {
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

var EditTransportStatus = function (item) {
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

router.post("/sorttransportid", async (req, res) => {
  try {
    const item = await sortTransportId(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var sortTransportId = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT o.* , ol.name , ol.surname ,od.*, m.*,ph.pharmacy_name, ph.province,tr.status as 'transport_status' from orders as o left join patients as ol ON o.patient_HN_order = ol.patient_HN inner join order_detail as od ON o.order_id = od.order_id inner join medicine as m ON m.medicine_id = od.medicine_id inner join pharmacy as ph on ph.pharmacy_id = o.pharmacy_id left join orders_transport as tr on tr.transport_id = o.transport_id WHERE o.status= ? order by o.order_id ASC;`,
      [item.status],
      (error, result) => {
        if (error) return reject(error);
        var order = [];
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
            administration: element.administration,
            expdate: element.expdate,
            received: element.received,
            disease_id_medicine: element.disease_id_medicine,
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
          delete element.administration;
          delete element.expdate;
          delete element.received;
          delete element.disease_id_medicine;
          if (index == 0) {
            order.push(element);
            order[index]["medicineItem"] = [medicineObj];
          }
          if (index > 0) {
            if (result[index - 1].order_id != result[index].order_id) {
              count++;
              order.push(element);
              order[count]["medicineItem"] = [medicineObj];
            } else {
              order[count]["medicineItem"].push(medicineObj);
            }
          }
        });
        var transport_id = [];
        for (let i = 0; i < order.length; i++) {
          transport_id.push(order[i].transport_id);
        }
        transport_id = transport_id.filter(
          (item, index) => transport_id.indexOf(item) === index
        );
        var sorttransport = [];
        transport_id.forEach((element, index) => {
          sorttransport[index] = order.filter((item, i) => {
            return order[i].transport_id == transport_id[index];
          });
        });

        return resolve(sorttransport);
      }
    );
  });
};

router.post("/edit_transportdate", async (req, res) => {
  try {
    const item = await EditTransportDate(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var EditTransportDate = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE ${transport} SET status = ? , transport_date = NOW() WHERE transport_id = ?`,
      [item.status, item.transport_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/sorttransportid", async (req, res) => {
  try {
    const item = await sortTransportId(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var sortTransportId = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT o.* , ol.name , ol.surname ,od.*, m.*,ph.pharmacy_name, ph.province,tr.status as 'transport_status' from orders as o left join patients as ol ON o.patient_HN_order = ol.patient_HN inner join order_detail as od ON o.order_id = od.order_id inner join medicine as m ON m.medicine_id = od.medicine_id inner join pharmacy as ph on ph.pharmacy_id = o.pharmacy_id left join orders_transport as tr on tr.transport_id = o.transport_id WHERE o.status= ? order by o.order_id ASC;`,
      [item.status],
      (error, result) => {
        if (error) return reject(error);
        var sorttransport = sortDataFormat(result);
        return resolve(sorttransport);
      }
    );
  });
};

router.get("/transportstatus", async (req, res) => {
  try {
    const item = await TransportStatus();
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var TransportStatus = function () {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT o.* , ol.name , ol.surname ,od.*, m.*,ph.pharmacy_name, ph.province,tr.status as 'transport_status' ,tr.transport_date,tr.receive_date from orders as o left join patients as ol ON o.patient_HN_order = ol.patient_HN inner join order_detail as od ON o.order_id = od.order_id inner join medicine as m ON m.medicine_id = od.medicine_id inner join pharmacy as ph on ph.pharmacy_id = o.pharmacy_id left join orders_transport as tr on tr.transport_id = o.transport_id WHERE tr.status IN ('received','transport') order by o.order_id ASC;`,
      (error, result) => {
        if (error) return reject(error);
        var sorttransport = sortDataFormat(result);
        return resolve(sorttransport);
      }
    );
  });
};

router.get("/transporthistory", async (req, res) => {
  try {
    const item = await TransportHistory();
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var TransportHistory = function () {
  return new Promise((resolve, reject) => {
    db.query(
      `select t.* ,count(order_id) as num_order , p.pharmacy_name from orders as o inner join orders_transport as t on o.transport_id = t.transport_id inner join pharmacy as p on t.pharmacy_id_transport = p.pharmacy_id group by t.transport_id`,
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/transport_order", async (req, res) => {
  try {
    const item = await getTransportOrder(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getTransportOrder = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT o.due_date,o.create_date,o.status,od.*,m.*,p.name,p.surname FROM orders as o inner join order_detail as od on o.order_id = od.order_id inner join medicine as m on m.medicine_id = od.medicine_id inner join patients as p on p.patient_HN=o.patient_HN_order where o.transport_id = ? order by od.order_id;`,
      [item.transport_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/transportreceived", async (req, res) => {
  try {
    const item = await TransportReceived(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var TransportReceived = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `SELECT o.* , ol.name , ol.surname ,od.*, m.*,ph.pharmacy_name, ph.province,tr.status as 'transport_status' ,tr.transport_date,tr.receive_date from orders as o left join patients as ol ON o.patient_HN_order = ol.patient_HN inner join order_detail as od ON o.order_id = od.order_id inner join medicine as m ON m.medicine_id = od.medicine_id inner join pharmacy as ph on ph.pharmacy_id = o.pharmacy_id left join orders_transport as tr on tr.transport_id = o.transport_id WHERE o.status = 'received' AND o.pharmacy_id=? order by o.order_id ASC;`,
      [item.pharmacy_id],
      (error, result) => {
        if (error) return reject(error);
        var sorttransport = sortDataFormat(result);
        return resolve(sorttransport);
      }
    );
  });
};

var sortDataFormat = function (result) {
  var order = [];
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
      administration: element.administration,
      expdate: element.expdate,
      received: element.received,
      disease_id_medicine: element.disease_id_medicine,
      qty_received: element.qty_received,
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
    delete element.administration;
    delete element.expdate;
    delete element.received;
    delete element.disease_id_medicine;
    delete element.qty_received;
    if (index == 0) {
      order.push(element);
      order[index]["medicineItem"] = [medicineObj];
    }
    if (index > 0) {
      if (result[index - 1].order_id != result[index].order_id) {
        count++;
        order.push(element);
        order[count]["medicineItem"] = [medicineObj];
      } else {
        order[count]["medicineItem"].push(medicineObj);
      }
    }
  });
  var transport_id = [];
  for (let i = 0; i < order.length; i++) {
    transport_id.push(order[i].transport_id);
  }
  transport_id = transport_id.filter(
    (item, index) => transport_id.indexOf(item) === index
  );
  var sorttransport = [];
  transport_id.forEach((element, index) => {
    sorttransport[index] = order.filter((item, i) => {
      return order[i].transport_id == transport_id[index];
    });
  });
  return sorttransport;
};
module.exports = router;
