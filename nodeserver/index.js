const express = require("express");
const server = express();
const express_session = require("express-session");
const bodyParser = require("body-parser");
const { check, validationResult } = require("express-validator");
// const config = require("./configs");
const PORT = 3000;

server.use(
  express_session({
    secret: "keyboard cat",
    resave: false,
    saveUninitialized: true,
    cookie: {}
  })
);

server.use(bodyParser.urlencoded({ extended: false }));
// parse application/json
server.use(bodyParser.json());

// server.post(
//   "/",
//   [
//     check("ff")
//       .not()
//       .isEmpty()
//   ],
//   (req, res) => {
//     try {
//       validationResult(req).throw();
//       res.json(req.body);
//     } catch (e) {
//       res.status(400).json({ message: e.message });
//     }
//   }
// );
// server.get("/s", (req, res) => {
//   req.session.item = "hello world";
//   res.end("set session");
// });
// server.post("/", (req, res) => res.json(req.body));
// server.get("*", (req, res) => {
//   //   if (config.isProduction) return res.sendFile(`${__dirname}/www/index.html`);

//   res.end(`<h1>Backend server is startd. session is ${req.session.item}</h1>`);
// });

server.listen(PORT, () => console.log(`Server is started, Port ${PORT}.`));
