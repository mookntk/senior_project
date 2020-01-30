import Vue from "vue";
import VueRouter from "vue-router";
import Patient from "../views/hospitalsection/hp_patient";
import hosstaff from "../views/adminsection/Hospitalstaff";
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
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

export default router;
