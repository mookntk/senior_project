const express = require("express");
const router = express.Router();
const {
    check
} = require("express-validator");
const db = require("../configs/db");

//For Pharmacy.vue
//showpharmacy all pharmacy
router.get("/showpharmacy", async (req, res) => {
    try {
        const pharmacy = await show_pharmacy();
        res.json(pharmacy);
    } catch (error) {
        res.status(400).json({
            message: error.message
        });
    }
});

//For Pharmacy.vue
//newpharmacy
router.post(
    "/newpharmacy",
    [
        check("pharmacy_name")
        .not()
        .isEmpty(),
        check("address")
        .not()
        .isEmpty(),
        check("subdistrict")
        .not()
        .isEmpty(),
        check("district")
        .not()
        .isEmpty(),
        check("province")
        .not()
        .isEmpty(),
        check("Telno")
        .not()
        .isEmpty(),
        check("zipcode")
        .not()
        .isEmpty()
    ],
    async (req, res) => {
        try {
            const newpharmacy = await new_pharmacy(req.body);
            res.json(newpharmacy);
        } catch (error) {
            res.status(400).json({
                message: error.message
            });
        }
    }
);

//For Pharmacy.vue
//editpharmacy
router.post(
    "/editpharmacy",
    [
        check("pharmacy_name")
        .not()
        .isEmpty(),
        check("address")
        .not()
        .isEmpty(),
        check("subdistrict")
        .not()
        .isEmpty(),
        check("district")
        .not()
        .isEmpty(),
        check("province")
        .not()
        .isEmpty(),
        check("Telno")
        .not()
        .isEmpty(),
        check("zipcode")
        .not()
        .isEmpty()
    ],
    async (req, res) => {
        try {
            const editpharmacy = await edit_pharmacy(req.body);
            res.json(editpharmacy);
        } catch (error) {
            res.status(400).json({
                message: error.message
            });
        }
    }
);

//For Pharmacy.vue
//deletepharmacy
router.post(
    "/deletepharmacy",
    async (req, res) => {
        try {
            const deletepharmacy = await delete_pharmacy(req.body);
            res.json(deletepharmacy);
        } catch (error) {
            res.status(400).json({
                message: error.message
            });
        }
    }
);

var show_pharmacy = function () {
    return new Promise((resolve, reject) => {
        db.query("SELECT * FROM pharmacy", (error, result) => {
            if (error) return reject(error);
            resolve(result);
        });
    });
};

var new_pharmacy = function (item) {
    return new Promise((resolve, reject) => {
        db.query("INSERT INTO pharmacy (pharmacy_name,address,subdistrict,district,province,Telno,zipcode) VALUES ('" + item.pharmacy_name + "','" + item.address + "','" + item.subdistrict + "','" + item.district + "','" + item.province + "','" + item.Telno + "','" + item.zipcode + "')", (error, result) => {
            if (error) return reject(error);
            resolve({
                message: "success"
            });
        });
    });
};

var edit_pharmacy = function (item) {
    return new Promise((resolve, reject) => {
        db.query("UPDATE pharmacy SET pharmacy_name='" + item.pharmacy_name + "',address='" + item.address + "',subdistrict='" + item.subdistrict + "',district='" + item.district + "',province='" + item.province + "',Telno='" + item.Telno + "',zipcode='" + item.zipcode + "' WHERE pharmacy_id='" + item.pharmacy_id + "'", (error, result) => {
            if (error) return reject(error);
            resolve({
                message: "success"
            });
        });
    });
};

var delete_pharmacy = function (item) {
    return new Promise((resolve, reject) => {
        db.query("DELETE FROM pharmacy WHERE pharmacy_id='" + item.pharmacy_id + "'", (error, result) => {
            if (error) return reject(error);
            resolve({
                message: "success"
            });
        });
    });
};
module.exports = router;