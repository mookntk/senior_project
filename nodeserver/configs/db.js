const mysql = require("mysql");
const connect = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "root",
  database: "test",
  charset: "utf8"
});

// checl database
// connect.getConnection((err, connect) => console.log(err));
module.exports = connect;
