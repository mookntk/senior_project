const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const db = require("../configs/db");

//login
router.post(
  "/login",
  [
    check("username")
      .not()
      .isEmpty(),
    check("password")
      .not()
      .isEmpty()
  ],
  async (req, res) => {
    try {
      const userLogin = await Login(req.body);
      res.json(userLogin);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

var Login = function(item) {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT * FROM users WHERE username=?",
      [item.username],
      (error, result) => {
        if (error) return reject(error);
        if (result.length > 0) {
          const userLogin = result[0];
          if (userLogin.password === item.password) {
            delete userLogin.password;
            return resolve(userLogin);
          }
        }
        reject(new Error("Invalid username or password"));
      }
    );
  });
};

module.exports = router;
