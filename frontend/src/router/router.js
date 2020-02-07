import Vue from "vue";
import VueRouter from "vue-router";
import store from "../store/";
import Login from "../views/Login";
import Patient from "../views/hospitalsection/hp_Patient";
import hosstaff from "../views/adminsection/Hospitalstaff";
import pharmacy from "../views/adminsection/Pharmacy";
import pharmacist from "../views/adminsection/Pharmacist";
import CreateOrder from "../views/hospitalsection/hp_CreateOrder";
import HpOrder from "../views/hospitalsection/hp_Order";
import WaitingMedicine from "../views/hospitalsection/hp_WaitingMedicine";
import WaitingTransport from "../views/hospitalsection/hp_WaitingTransport";
import TransportStatus from "../views/hospitalsection/hp_TransportStatus";
import Recall from "../views/hospitalsection/hp_Recall";
import OrderHistory from "../views/hospitalsection/hp_OrderHistory";
import TransportHistory from "../views/hospitalsection/hp_TransportHistory";
import ReadySell from "../views/pharmacistsection/ph_ReadySell";
import ReceiveOrder from "../views/pharmacistsection/ph_ReceiveOrder";
import ConfirmOrder from "../views/pharmacistsection/ph_ConfirmOrder";
import Prepare from "../views/pharmacistsection/ph_Prepare";
import SendbackOrder from "../views/pharmacistsection/ph_SendbackOrder";
import SendbackStatus from "../views/pharmacistsection/ph_SendbackStatus";
import OrderStatus from "../views/pharmacistsection/ph_OrderStatus";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "login",
    component: Login
  },

  {
    path: "/hospitalstaff",
    name: "hosstaff",
    component: hosstaff,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/pharmacy",
    name: "pharmacy",
    component: pharmacy,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/pharmacist",
    name: "pharmacist",
    component: pharmacist,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/patient",
    name: "patient",
    component: Patient,
    meta: {
      requiresAuth: true
    }
  },

  {
    path: "/create_order",
    name: "create_order",
    component: CreateOrder,
    meta: {
      requiresAuth: true
    }
  },

  {
    path: "/order",
    name: "HpOrder",
    component: HpOrder,
    meta: {
      requiresAuth: true
    }
  },

  {
    path: "/waiting_medicine",
    name: "WaitingMedicine",
    component: WaitingMedicine,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/waiting_transport",
    name: "WaitingTransport",
    component: WaitingTransport,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/transport_status",
    name: "TransportStatus",
    component: TransportStatus,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/recall",
    name: "Recall",
    component: Recall,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/order_history",
    name: "OrderHistory",
    component: OrderHistory,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/transport_history",
    name: "TransportHistory",
    component: TransportHistory,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/ready_sell",
    name: "ReadySell",
    component: ReadySell,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/receive_order",
    name: "ReceiveOrder",
    component: ReceiveOrder,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/confirm_order",
    name: "ConfirmOrder",
    component: ConfirmOrder,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/prepare",
    name: "Prepare",
    component: Prepare,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/sendback_order",
    name: "SendbackOrder",
    component: SendbackOrder,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/sendback_status",
    name: "SendbackStatus",
    component: SendbackStatus,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: "/order_status",
    name: "OrderStatus",
    component: OrderStatus,
    meta: {
      requiresAuth: true
    }
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    console.log(store.getters.isLoggedIn);
    if (store.getters.isLoggedIn) {
      next();
    } else {
      next("/");
    }
  } else {
    next();
  }
});

export default router;
