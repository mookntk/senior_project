const express = require("express");
const router = express.Router();
const {
  check
} = require("express-validator");
const db = require("../configs/db");
const nodemailer = require('nodemailer');


//
router.post(
  "/newuser",
  [
    check("username")
    .not()
    .isEmpty(),
    check("name")
    .not()
    .isEmpty(),
    check("surname")
    .not()
    .isEmpty(),
    check("telno")
    .not()
    .isEmpty(),
    check("email")
    .not()
    .isEmpty(),
    check("sex")
    .not()
    .isEmpty(),
    check("expdate")
    .not()
    .isEmpty()
  ],
  async (req, res) => {
    try {
      const newuser = await new_user(req.body);
      res.json(newuser);
    } catch (error) {
      res.status(400).json({
        message: error.message
      });
    }
  }
);

router.post(
  "/edituser",
  [
    check("username")
    .not()
    .isEmpty(),
    check("name")
    .not()
    .isEmpty(),
    check("surname")
    .not()
    .isEmpty(),
    check("telno")
    .not()
    .isEmpty(),
    check("email")
    .not()
    .isEmpty(),
    check("sex")
    .not()
    .isEmpty()
  ],
  async (req, res) => {
    try {
      const edituser = await edit_user(req.body);
      res.json(edituser);
    } catch (error) {
      res.status(400).json({
        message: error.message
      });
    }
  }
);

router.post(
  "/deleteuser",
  async (req, res) => {
    try {
      const deleteuser = await delete_user(req.body);
      res.json(deleteuser);
    } catch (error) {
      res.status(400).json({
        message: error.message
      });
    }
  }
);

router.get("/show_allpharmacist", async (req, res) => {
  try {
    const pharmacist = await show_allpharmacist();
    res.json(pharmacist);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});

router.post(
  "/sendmail",
  [
    check("username")
    .not()
    .isEmpty(),
    check("email")
    .not()
    .isEmpty(),
    check("password")
    .not()
    .isEmpty()
  ],
  async (req, res) => {
    try {
      const sendmail = await send_mail(req.body);
      res.json(sendmail);
    } catch (error) {
      res.status(400).json({
        message: error.message
      });
    }
  }
);

router.get("/showpharmacist", async (req, res) => {
  try {
    const pharmacist = await show_pharmacist();
    res.json(pharmacist);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
});


var new_user = function (item) {
  return new Promise((resolve, reject) => {
    var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    var string_length = 8;
    var randomstring = '';
    for (var i = 0; i < string_length; i++) {
      var rnum = Math.floor(Math.random() * chars.length);
      randomstring += chars.substring(rnum, rnum + 1);
    }
    if (item.sex === 0) {
      item.sex = "Male";
    } else {
      item.sex = "Female";
    }
    var pharmacy_id = '';
    db.query(
      "SELECT * FROM pharmacy WHERE pharmacy_name='" + item.pharmacy_name + "'",
      (error, result) => {
        pharmacy_id = result[0].pharmacy_id;

        db.query(
          "INSERT INTO users (username,password,user_type,name,surname,telno,email,sex) VALUES ('" +
          item.username +
          "','" +
          randomstring +
          "','pharmacist','" +
          item.name +
          "','" +
          item.surname +
          "','" +
          item.telno +
          "','" +
          item.email +
          "','" +
          item.sex +
          "')",
          (error, result) => {
            if (error) return reject(error);

            db.query(
              "INSERT INTO phamacist (expdate, staff_id_pharmacist, pharmacy_id_pharmacist) VALUES ('" +
              item.expdate +
              "','" +
              result.insertId +
              "','" +
              pharmacy_id +
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

        var transporter = nodemailer.createTransport({
          host: 'smtp.gmail.com',
          port: 587,
          secure: false, // true for 465, false for other ports
          auth: { // ข้อมูลการเข้าสู่ระบบ
            user: 'seniorhospital111@gmail.com', // email user ของเรา
            pass: 'hospital111' // email password
          }
        });
        // เริ่มทำการส่งอีเมล
        var info = transporter.sendMail({
          from: '"Senior Hospital" <seniorhospital111@gmail.com>', // อีเมลผู้ส่ง
          to: item.email, // อีเมลผู้รับ สามารถกำหนดได้มากกว่า 1 อีเมล โดยขั้นด้วย ,(Comma)
          subject: 'Senior Hospital : ยินดีต้อนรับผู้ใช้ใหม่ (ระบบส่งรหัสผ่านอัตโนมัติ)', // หัวข้ออีเมล
          text: "ยินดีต้อนรับคุณ" + item.name + " " + item.surname + " เข้าสู่ระบบการจัดการยาของโรงพยาบาล Senior Hospital \n" +
            "คุณคือเภสัชกรร้านยา '" + item.pharmacy_name + "'" + "\n" +
            "ชื่อผู้ใช้ของคุณคือ " + item.username + "\n" +
            "รหัสผ่านคือ " + randomstring + "\n" + // plain text body
            "โปรดป้อนรหัสผ่านที่ได้ในการลงชื่อเข้าใช้"
        });
      }
    );
  });
};

var edit_user = function (item) {
  return new Promise((resolve, reject) => {
    if (item.sex === 0) {
      item.sex = "Male";
    } else {
      item.sex = "Female";
    }
    var pharmacy_id = '';
    db.query(
      "SELECT * FROM pharmacy WHERE pharmacy_name='" + item.pharmacy_name + "'",
      (error, result) => {
        pharmacy_id = result[0].pharmacy_id;
        db.query(
          "UPDATE users SET name='" +
          item.name +
          "',surname='" +
          item.surname +
          "',email='" +
          item.email +
          "',telno='" +
          item.telno +
          "',sex='" +
          item.sex +
          "' WHERE staff_id='" +
          item.staff_id +
          "'",
          (error, result) => {
            if (error) return reject(error);
            db.query(
              "UPDATE phamacist SET expdate='" +
              item.expdate +
              "',pharmacy_id_pharmacist='" +
              pharmacy_id +
              "' WHERE staff_id_pharmacist='" +
              item.staff_id +
              "'",
              (error, result) => {
                if (error) return reject(error);
                resolve({
                  message: "success"
                });
              });
          });
      });
  });
};
//DELETE users, phamacist FROM users inner join phamacist on phamacist.staff_id_pharmacist=users.staff_id WHERE staff_id = ?
var delete_user = function (item) {
  return new Promise((resolve, reject) => {
    // db.query(
    //   "DELETE users, phamacist FROM users inner join phamacist on phamacist.staff_id_pharmacist=users.staff_id WHERE staff_id = ?",
    //   [item.staff_id],
    //   (error, result) => {
    //     if (error) return reject(error);
    //     resolve({ message: "success" });
    //   }
    // );
    db.query(
      "DELETE FROM users WHERE staff_id = ?",
      [item.staff_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({
          message: "success"
        });
      }
    );
  });
};

var show_allpharmacist = function () {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT * FROM users WHERE user_type=?",
      ["pharmacist"],
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

var send_mail = function (item) {
  return new Promise((resolve, reject) => {

    db.query("SELECT * FROM users AS d1 INNER JOIN phamacist AS d2 ON (d2.staff_id_pharmacist=d1.staff_id) " +
      "INNER JOIN pharmacy AS d3 ON (d2.pharmacy_id_pharmacist=d3.pharmacy_id) where d1.username='" + item.username + "'",
      (error, result) => {
        name = result[0].name;
        surname = result[0].surname;

        var transporter = nodemailer.createTransport({
          host: 'smtp.gmail.com',
          port: 587,
          secure: false, // true for 465, false for other ports
          auth: { // ข้อมูลการเข้าสู่ระบบ
            user: 'seniorhospital111@gmail.com', // email user ของเรา
            pass: 'hospital111' // email password
          }
        });
        // เริ่มทำการส่งอีเมล
        var info = transporter.sendMail({
          from: '"Senior Hospital" <seniorhospital111@gmail.com>', // อีเมลผู้ส่ง
          to: item.email, // อีเมลผู้รับ สามารถกำหนดได้มากกว่า 1 อีเมล โดยขั้นด้วย ,(Comma)
          subject: 'Senior Hospital : ยินดีต้อนรับผู้ใช้ใหม่ (ระบบส่งรหัสผ่านอัตโนมัติ)', // หัวข้ออีเมล
          text: "ยินดีต้อนรับคุณ" + name + " " + surname + " เข้าสู่ระบบการจัดการยาของโรงพยาบาล Senior Hospital \n" +
            "คุณคือเภสัชกรร้านยา '" + item.pharmacy_name + "'" + "\n" +
            "ชื่อผู้ใช้ของคุณคือ " + item.username + "\n" +
            "รหัสผ่านคือ " + item.password + "\n" + // plain text body
            "โปรดป้อนรหัสผ่านที่ได้ในการลงชื่อเข้าใช้"
        });
      });

    // var transporter = nodemailer.createTransport({
    //   host: 'smtp.gmail.com',
    //   port: 587,
    //   secure: false, // true for 465, false for other ports
    //   auth: { // ข้อมูลการเข้าสู่ระบบ
    //     user: 'seniorhospital111@gmail.com', // email user ของเรา
    //     pass: 'hospital111' // email password
    //   }
    // });
    // // เริ่มทำการส่งอีเมล
    // var info = transporter.sendMail({
    //   from: '"Senior Hospital" <seniorhospital111@gmail.com>', // อีเมลผู้ส่ง
    //   to: item.email, // อีเมลผู้รับ สามารถกำหนดได้มากกว่า 1 อีเมล โดยขั้นด้วย ,(Comma)
    //   subject: 'Senior Hospital : ยินดีต้อนรับผู้ใช้ใหม่ (ระบบส่งรหัสผ่านอัตโนมัติ)', // หัวข้ออีเมล
    //   text:
    //     "ยินดีต้อนรับคุณ"+ item.name + " " + item.surname + " เข้าสู่ระบบการจัดการยาของโรงพยาบาล Senior Hospital \n" +
    //     "คุณคือเภสัชกรร้านยา '" + item.pharmacy_name + "'" + "\n" +
    //     "ชื่อผู้ใช้ของคุณคือ " + item.username +"\n" +
    //     "รหัสผ่านคือ " + item.password +"\n"+ // plain text body
    //     "โปรดป้อนรหัสผ่านที่ได้ในการลงชื่อเข้าใช้"
    // });
  });
};

//SELECT * FROM users INNER JOIN phamacist ON users.staff_id=phamacist.staff_id_phamacist  WHERE users.user_type='pharmacist' 
var show_pharmacist = function () {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM users AS d1 INNER JOIN phamacist AS d2 ON (d2.staff_id_pharmacist=d1.staff_id) INNER JOIN pharmacy AS d3 ON (d2.pharmacy_id_pharmacist=d3.pharmacy_id) where d1.user_type='pharmacist'", (error, result) => {
      if (error) return reject(error);
      resolve(result);
    });
  });
};
module.exports = router;