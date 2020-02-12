const express = require("express");
const app = express();
const express_session = require("express-session");
const bodyParser = require("body-parser");
const { check, validationResult } = require("express-validator");
const PORT = 3000;

app.use(
  express_session({
    secret: "keyboard cat",
    resave: false,
    saveUninitialized: true,
    cookie: {}
  })
);

app.use(bodyParser.urlencoded({ extended: false }));
// parse application/json
app.use(bodyParser.json());
app.use("/api", require("./routes/routes"));
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
// app.post("/", (req, res) => res.json(req.body));
app.get("*", (req, res) => {
  res.end(`<h1>Backend server is startd. session is ${req.session.item}</h1>`);
});

app.listen(PORT, () => console.log(`Server is started, Port ${PORT}.`));
