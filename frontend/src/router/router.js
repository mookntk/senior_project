import Vue from "vue";
import VueRouter from "vue-router";
import Login from "../views/Login";
import Patient from "../views/hospitalsection/hp_patient";
import hosstaff from "../views/adminsection/Hospitalstaff";
import pharmacy from "../views/adminsection/Pharmacy";
import pharmacist from "../views/adminsection/Pharmacist";
Vue.use(VueRouter);

const routes = [{
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
 
  // ,
  // {
  //   path: "/create_order",
  //   name: "create_order",
  //   component: CreateOrder
  // },

  // {
  //   path: "/order",
  //   name: "HpOrder",
  //   component: HpOrder
  // },

  // {
  //   path: "/waiting_medicine",
  //   name: "WaitingMedicine",
  //   component: WaitingMedicine
  // },
  // {
  //   path: "/waiting_transport",
  //   name: "WaitingTransport",
  //   component: WaitingTransport
  // },
  // {
  //   path: "/transport_status",
  //   name: "TransportStatus",
  //   component: TransportStatus
  // },
  // {
  //   path: "/recall",
  //   name: "Recall",
  //   component: Recall
  // },
  // {
  //   path: "/order_history",
  //   name: "OrderHistory",
  //   component: OrderHistory
  // },
  // {
  //   path: "/transport_history",
  //   name: "TransportHistory",
  //   component: TransportHistory
  // },
  // {
  //   path: "/ready_sell",
  //   name: "ReadySell",
  //   component: ReadySell
  // },
  // {
  //   path: "/receive_order",
  //   name: "ReceiveOrder",
  //   component: ReceiveOrder
  // },
  // {
  //   path: "/confirm_order",
  //   name: "ConfirmOrder",
  //   component: ConfirmOrder
  // },
  // {
  //   path: "/prepare",
  //   name: "Prepare",
  //   component: Prepare
  // },
  // {
  //   path: "/sendback_order",
  //   name: "SendbackOrder",
  //   component: SendbackOrder
  // },
  // {
  //   path: "/sendback_status",
  //   name: "SendbackStatus",
  //   component: SendbackStatus
  // },
  // {
  //   path: "/order_status",
  //   name: "OrderStatus",
  //   component: OrderStatus
  // }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

export default router;