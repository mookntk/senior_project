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
      res.status(400).json({ message: error.message });
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
      res.status(400).json({ message: error.message });
    }
  }
);

router.post("/deleteuser", async (req, res) => {
  try {
    const deleteuser = await delete_user(req.body);
    res.json(deleteuser);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.get("/showpharmacy", async (req, res) => {
  try {
    const pharmacy = await show_pharmacy();
    res.json(pharmacy);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.get("/showpharmacists", async (req, res) => {
  try {
    const pharmacists = await show_pharmacists();
    res.json(pharmacists);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.get("/showhospital", async (req, res) => {
  try {
    const hos_staff = await show_hospital();
    res.json(hos_staff);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.get("/showallstaff", async (req, res) => {
  try {
    const staff = await show_allstaff();
    res.json(staff);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

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

var new_user = function(item) {
  return new Promise((resolve, reject) => {
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
  });
};

var edit_user = function(item) {
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

var show_pharmacy = function() {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM pharmacy", (error, result) => {
      if (error) return reject(error);
      resolve(result);
    });
  });
};

var show_pharmacists = function() {
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

var show_hospital = function() {
  return new Promise((resolve, reject) => {
    db.query(
      "SELECT * FROM users WHERE user_type=?",
      ["hos_staff"],
      (error, result) => {
        if (error) return reject(error);
        resolve(result);
      }
    );
  });
};

var show_allstaff = function() {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM users ", (error, result) => {
      if (error) return reject(error);
      resolve(result);
    });
  });
};
module.exports = router;
