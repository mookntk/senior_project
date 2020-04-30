const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const returnorder = "orders_return";
const detail = "orders_return_detail";

// router.post("/gettransport", async (req, res) => {
//   try {
//     const patients = await getTransportStatus(req.body);
//     res.json(patients);
//   } catch (error) {
//     res.status(400).json({
//       message: error.message
//     });
//   }
// });

// var getTransportStatus = function(item) {
//   return new Promise((resolve, reject) => {
//     db.query(
//       `SELECT DISTINCT o.transport_id , o.pharmacy_id_transport FROM ${transport} as o WHERE status = ?`,
//       [item.status],
//       (error, result) => {
//         if (error) return reject(error);
//         return resolve(result);
//       }
//     );
//   });
// };

router.post("/editorderreturnid", async (req, res) => {
  try {
    //   console.log(req.body);
    const newitem = await editOrderReturnId(req.body);
    res.json(newitem);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var editOrderReturnId = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE orders SET return_id = ? , remark = ? WHERE order_id = ?`,
      [item.return_id, item.remark, item.order_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/editstatus", async (req, res) => {
  try {
    //   console.log(req.body);
    const newitem = await editStatus(req.body);
    res.json(newitem);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var editStatus = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `UPDATE orders_return SET status = ? , send_date = ?, receive_date = ? ,pharmacist_id_return=? WHERE return_id = ?`,
      [
        item.status,
        item.send_date,
        item.receive_date,
        item.pharmacist_id,
        item.return_id,
      ],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

router.post("/newreturn", async (req, res) => {
  try {
    //   console.log(req.body);
    const newitem = await newReturnOrder(req.body);
    res.json(newitem);
  } catch (error) {
    res.status(400).json({
      message: error.message,
    });
  }
});

var newReturnOrder = function (item) {
  return new Promise((resolve, reject) => {
    db.query(`INSERT INTO ${returnorder} SET ?`, item, (error, result) => {
      if (error) return reject(error);
      resolve({ insertId: result.insertId });
    });
  });
};

router.post("/getwaitingreturn", async (req, res) => {
  try {
    const item = await getWaitingReturn(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getWaitingReturn = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select orders_return.return_id FROM ${returnorder} WHERE status = 'waiting-return' and pharmacy_id_return = ?`,
      [item.pharmacy_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/getorderbyid", async (req, res) => {
  try {
    const item = await getOrderById(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getOrderById = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select o.order_id,o.remark,od.qty, m.*, l.*,p.name,p.surname from orders as o inner join order_detail as od on od.order_id = o.order_id  inner join medicine as m on m.medicine_id = od.medicine_id inner join lot_order as l on l.medicine_id= m.medicine_id and l.order_id = o.order_id inner join patients as p on p.patient_HN = o.patient_HN_order where o.return_id = ? and od.received='false' or od.received='0';`,
      [item.return_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/getreturnstatus", async (req, res) => {
  try {
    const item = await getReturnStatus(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getReturnStatus = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select r.return_id,r.status,u.name,u.surname,count(order_id) as num_order ,DATE_FORMAT(r.send_date,'%Y %m %d') AS send_date,DATE_FORMAT(r.receive_date,'%Y %m %d') AS receive_date FROM orders as o inner join ${returnorder} as r on r.return_id = o.return_id left join users as u on u.staff_id = r.pharmacist_id_return WHERE pharmacy_id_return = ? group by r.return_id order by r.status DESC`,
      [item.pharmacy_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
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

router.get("/getreturnorder", async (req, res) => {
  try {
    const item = await getReturnOrder(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getReturnOrder = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select r.*,u.name as ph_name ,u.surname as ph_surname,u1.name as hp_name ,u1.surname as hp_surname ,count(order_id) as num_order ,ph.pharmacy_name FROM orders as o inner join ${returnorder} as r on r.return_id = o.return_id left join users as u on u.staff_id = r.pharmacist_id_return inner join pharmacy as ph on ph.pharmacy_id = r.pharmacy_id_return left join users as u1 on u1.staff_id = r.staff_id_return group by r.return_id order by r.status DESC`,
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};

router.post("/getonereturnorder", async (req, res) => {
  try {
    const item = await getOneReturnOrder(req.body);
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

var getOneReturnOrder = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      `select o.order_id , o.status , o.remark ,o.receive_date,m.medicine_id,m.medicine_generic,m.strength,od.qty,m.unit,l.*,p.name,p.surname from orders as o inner join order_detail as od on o.order_id = od.order_id inner join medicine as m on m.medicine_id = od.medicine_id inner join lot_order as l on l.medicine_id = od.medicine_id and l.order_id = o.order_id inner join patients as p on p.patient_HN = o.patient_HN_order where o.return_id = ? and od.received in ('false','0')`,
      [item.return_id],
      (error, result) => {
        if (error) return reject(error);
        return resolve(result);
      }
    );
  });
};
module.exports = router;
