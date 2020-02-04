const express = require("express");
const router = express.Router();
const {
  check
} = require("express-validator");
const db = require("../configs/db");
const nodemailer = require('nodemailer');

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
    res.status(400).json({ message: error.message });
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
    db.query(
      "INSERT INTO users (username,password,user_type,name,surname,telno,email,sex) VALUES ('" +
        item.username +
        "','1234','hos_staff','" +
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
        resolve({ message: "success" });
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
      subject: 'Senior Hospital : This is your Password', // หัวข้ออีเมล
      text: 'Your username is ' + item.username + '\n' + 'Your password is ' + randomstring, // plain text body
    });
  });
};

var edit_user = function (item) {
  return new Promise((resolve, reject) => {
    if (item.sex === 0) {
      item.sex = "Male";
    } else {
      item.sex = "Female";
    }
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
        "' WHERE username='" +
        item.username +
        "'",
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
      }
    );
  });
};

var delete_user = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      `DELETE FROM users WHERE staff_id = ?`,
      [item.staff_id],
      (error, result) => {
        if (error) return reject(error);
        resolve({ message: "success" });
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
      subject: 'Senior Hospital : This is your Password', // หัวข้ออีเมล
      text: 'Your username is ' + item.username + '\n' + 'Your password is ' + item.password, // plain text body
    });
  });
};

var show_pharmacist = function() {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM users INNER JOIN phamacist ON users.staff_id=phamacist.staff_id_phamacist  WHERE users.user_type='pharmacist' ", (error, result) => {
      if (error) return reject(error);
      resolve(result);
    });
  });
};
module.exports = router;
