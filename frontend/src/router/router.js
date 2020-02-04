import Vue from "vue";
import VueRouter from "vue-router";
import Patient from "../views/hospitalsection/hp_patient";
import hosstaff from "../views/adminsection/Hospitalstaff";
import pharmacy from "../views/adminsection/Pharmacy";
import pharmacist from "../views/adminsection/Pharmacist";
Vue.use(VueRouter);

const routes = [
  {
    path: "/patient",
    name: "patient",
    component: Patient
  },
  {
    path: "/hospitalstaff",
    name: "hosstaff",
    component: hosstaff
  },
  {
    path: "/pharmacy",
    name: "pharmacy",
    component: pharmacy
  },
  {
    path: "/pharmacist",
    name: "pharmacist",
    component: pharmacist
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

export default router;
