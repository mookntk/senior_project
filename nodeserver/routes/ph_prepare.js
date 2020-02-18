const express = require("express");
const router = express.Router();
const {
    check
} = require("express-validator");
const db = require("../configs/db");
const ph_prepare = "ph_prepare";


//show patient order
router.post(
    "/patient_order",
    [
        check("pharmacy_id")
        .not()
        .isEmpty()
    ],
    async (req, res) => {
        try {
            const p_order = await patient_order(req.body);
            res.json(p_order);
        } catch (error) {
            res.status(400).json({
                message: error.message
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
            "group by o.order_id",
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
    [
        check("patient_HN_order")
        .not()
        .isEmpty()
    ],
    async (req, res) => {
        try {
            const oneorder = await one_order(req.body);
            res.json(oneorder);
        } catch (error) {
            res.status(400).json({
                message: error.message
            });
        }
    }
);



var one_order = function (item) {
    return new Promise((resolve, reject) => {
        db.query(
            "SELECT o.order_id,p.name,p.surname,p.gender,p.DOB,o.status,o.patient_HN_order, " +
            "group_concat(m.medicine_generic) as medicine_generic, " +
            "group_concat(m.strenght) as strenght, " +
            "group_concat(od.qty) as qty, " +
            "group_concat(m.unit) as unit " +
            "from orders AS o "+
            "left join patients as p ON o.patient_HN_order = p.patient_HN "+
            "left join order_detail as od on od.order_id = o.order_id "+
            "inner join medicine as m ON m.medicine_id = od.medicine_id " +
            "WHERE o.status ='prepare' " +
            // "AND o.pharmacy_id ='" +
            // item.pharmacy_id +
            // "'" +
            "AND o.patient_HN_order ='" +
            item.patient_HN_order +
            "'" ,
            // +
            // "group by o.order_id",
            (error, result) => {
                if (error) return reject(error);
                resolve(result);
            }
        );
    });
};



module.exports = router;