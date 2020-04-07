const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");
const nodemailer = require("nodemailer");
const ph_prepare = "ph_prepare";

//show patient order
router.post(
  "/patient_order",
  [check("pharmacy_id").not().isEmpty()],
  async (req, res) => {
    try {
      const p_order = await patient_order(req.body);
      res.json(p_order);
    } catch (error) {
      res.status(400).json({
        message: error.message,
      });
    }
  }
);

var patient_order = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT o.order_id,o.patient_HN_order,p.name,p.surname,o.status,DATE_FORMAT(o.due_date,'%Y %m %d') AS due_date " +
        "from orders as o " +
        "left join patients as p ON o.patient_HN_order = p.patient_HN " +
        "WHERE o.status ='prepare' " +
        "AND o.pharmacy_id ='" +
        item.pharmacy_id +
        "'" +
        "group by o.order_id" +
        " order by o.due_date ASC",
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
      "SELECT o.order_id,p.name,p.surname,p.gender,p.DOB,o.status,p.email,p.telno,o.patient_HN_order,m.medicine_generic,m.strength,od.qty,m.unit " +
        // "group_concat(m.medicine_generic) as medicine_generic, " +
        // "group_concat(m.strenght) as strenght, " +
        // "group_concat(od.qty) as qty, " +
        // "group_concat(m.unit) as unit " +
        "from orders AS o " +
        "left join patients as p ON o.patient_HN_order = p.patient_HN " +
        "left join order_detail as od on od.order_id = o.order_id " +
        "inner join medicine as m ON m.medicine_id = od.medicine_id " +
        "WHERE o.status ='prepare' " +
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

//oneorder success in prepare medication
router.post(
  "/success_prepare",
  [check("order_id").not().isEmpty()],
  async (req, res) => {
    try {
      const oneorder = await success_prepare(req.body);
      res.json(oneorder);
    } catch (error) {
      res.status(400).json({
        message: error.message,
      });
    }
  }
);

var success_prepare = function (item) {
  return new Promise((resolve, reject) => {
    db.query(
      "UPDATE orders SET status='ready'" +
        "WHERE order_id='" +
        item.order_id +
        "'",
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );

    db.query(
      "SELECT p.name,p.surname,p.email,m.medicine_generic,m.strength,od.qty,m.unit,ph.pharmacy_name,DATE_FORMAT(o.due_date,'%Y %m %d') AS due_date " +
        "from orders as o " +
        "left join patients as p ON o.patient_HN_order = p.patient_HN " +
        "inner join order_detail as od ON o.order_id = od.order_id " +
        "inner join medicine as m ON m.medicine_id = od.medicine_id " +
        "inner join pharmacy as ph on o.pharmacy_id = ph.pharmacy_id " +
        "WHERE o.order_id ='" +
        item.order_id +
        "'",
      (error, result) => {
        var text_medicine = " ";
        for (var i = 0; i < result.length; i++) {
          if (i == 0) {
            text_medicine =
              result[i].medicine_generic +
              " " +
              result[i].strength +
              " " +
              result[i].qty +
              " " +
              result[i].unit +
              "\n";
          } else {
            text_medicine +=
              result[i].medicine_generic +
              " " +
              result[i].strength +
              " " +
              result[i].qty +
              " " +
              result[i].unit +
              "\n";
          }
        }

        var month = [
          "มกราคม",
          "กุมภาพันธ์",
          "มีนาคม",
          "เมษายน",
          "พฤษภาคม",
          "มิถุนายน",
          "กรกฎาคม",
          "สิงหาคม",
          "กันยายน",
          "ตุลาคม",
          "พฤศจิกายน",
          "ธันวาคม",
        ];

        if (result[0].due_date != null) {
          var due_date = result[0].due_date.split(" ");
          due_date[0] = parseInt(due_date[0]) + 543;
          due_date =
            due_date[2] + " " + month[due_date[1] - 1] + " " + due_date[0];
          console.log(due_date);

          var transporter = nodemailer.createTransport({
            host: "smtp.gmail.com",
            port: 587,
            secure: false, // true for 465, false for other ports
            auth: {
              // ข้อมูลการเข้าสู่ระบบ
              user: "seniorhospital111@gmail.com", // email user ของเรา
              pass: "hospital111", // email password
            },
          });
          // เริ่มทำการส่งอีเมล
          var info = transporter.sendMail({
            from: '"Senior Hospital" <seniorhospital111@gmail.com>', // อีเมลผู้ส่ง
            to: result[0].email, // อีเมลผู้รับ สามารถกำหนดได้มากกว่า 1 อีเมล โดยขั้นด้วย ,(Comma)
            subject: "Senior Hospital : ออเดอร์ของคุณพร้อมจำหน่าย", // หัวข้ออีเมล
            text:
              "เรียนคุณ " +
              result[0].name +
              " " +
              result[0].surname +
              "\n" +
              "ออเดอร์ยาของคุณได้ทำการจัดเตรียมเรียบร้อยแล้ว สามารถมารับได้ที่ร้านขายยา " +
              result[0].pharmacy_name +
              "\n" +
              "ภายในวันที่ " +
              due_date +
              "\n" +
              "รายละเอียดยาที่ต้องได้รับ" +
              "\n" +
              text_medicine,
          });
        }
      }
    );
  });
};

module.exports = router;
