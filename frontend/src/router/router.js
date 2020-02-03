import Vue from "vue";
import VueRouter from "vue-router";
import Login from "../views/Login";
import Patient from "../views/hospitalsection/hp_Patient";
import Hosstaff from "../views/adminsection/Hospitalstaff";
import CreateOrder from "../views/hospitalsection/hp_CreateOrder";
import HpOrder from "../views/hospitalsection/hp_Order";
import WaitingMedicine from "../views/hospitalsection/hp_WaitingMedicine";
import WaitingTransport from "../views/hospitalsection/hp_WaitingTransport";
import TransportStatus from "../views/hospitalsection/hp_TransportStatus";
import Recall from "../views/hospitalsection/hp_Recall";
import OrderHistory from "../views/hospitalsection/hp_OrderHistory";
import TransportHistory from "../views/hospitalsection/hp_TransportHistory";
Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "login",
    component: Login
  },
  {
    path: "/patient",
    name: "patient",
    component: Patient
  },
  {
    path: "/hospitalstaff",
    name: "hosstaff",
    component: Hosstaff
  },
  {
    path: "/create_order",
    name: "create_order",
    component: CreateOrder
  },

  {
    path: "/order",
    name: "HpOrder",
    component: HpOrder
  },

  {
    path: "/waiting_medicine",
    name: "WaitingMedicine",
    component: WaitingMedicine
  },
  {
    path: "/waiting_transport",
    name: "WaitingTransport",
    component: WaitingTransport
  },
  {
    path: "/transport_status",
    name: "TransportStatus",
    component: TransportStatus
  },
  {
    path: "/recall",
    name: "Recall",
    component: Recall
  },
  {
    path: "/order_history",
    name: "OrderHistory",
    component: OrderHistory
  },
  {
    path: "/transport_history",
    name: "TransportHistory",
    component: TransportHistory
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

export default router;
