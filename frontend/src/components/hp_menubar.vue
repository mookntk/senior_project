<template>
  <v-app-bar class="font teal lighten-3">
    <v-toolbar-title>
      <span>เภสัชกรโรงพยาบาล</span>
      <!-- <span class="font-weight-light">MATERIAL DESIGN</span> -->
    </v-toolbar-title>
    <v-spacer></v-spacer>
    <v-toolbar-items>
      <v-menu offset-y open-on-hover>
        <template v-slot:activator="{ on }">
          <v-btn v-on="on" text>
            <span style="margin-right:7px">ออร์เดอร์</span>
            <v-icon left>mdi-chevron-down</v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item v-for="item in links_order" :key="item.value" router :to="item.route">
            <v-list-item-title>{{ item.value }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-btn depressed class="teal lighten-3" to="/recall">การคืนยา</v-btn>
      <v-btn depressed class="teal lighten-3" to="/patient">ข้อมูลผู้ป่วย</v-btn>
      <v-btn depressed class="teal lighten-3" to="/lot_order">รหัสสินค้า</v-btn>
      <v-menu offset-y open-on-hover>
        <template v-slot:activator="{ on }">
          <v-btn v-on="on" text>
            <span style="margin-right:7px">ประวัติ</span>
            <v-icon left>mdi-chevron-down</v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item v-for="item in links" :key="item.value" router :to="item.route">
            <v-list-item-title>{{ item.value }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <!-- <v-btn depressed @click="click" value="notification" :color="btncolor1">
        <v-icon>mdi-bell</v-icon>
      </v-btn>-->
      <v-menu offset-y open-on-hover>
        <template v-slot:activator="{ on }">
          <v-btn text v-on="on">
            <v-badge v-model="show" color="cyan" right>
              <template v-slot:badge>
                <span>{{order.length}}</span>
              </template>
              <v-icon color="grey darken-1">mdi-bell</v-icon>
            </v-badge>
          </v-btn>
        </template>
        <v-list>
          <v-list-item three-line v-for="item in order" :key="item.patient_HN">
            <v-list-item-content class="font">
              <v-list-item-title style="font-size:15px">{{item.name}} {{item.surname}}</v-list-item-title>
              <v-list-item-subtitle
                style="font-size:12px;margin:5px"
              >วันนัดครั้งถัดไป {{setDate(item.next_due_date)}}</v-list-item-subtitle>
              <v-list-item-subtitle>
                <v-divider></v-divider>
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-menu>

      <v-menu offset-y open-on-hover>
        <template v-slot:activator="{ on }">
          <v-btn color="primary" dark v-on="on" text>{{username}}</v-btn>
        </template>
        <v-list>
          <v-list-item v-for="item in items" :key="item" @click="menuAccount(item)">
            <v-list-item-title>{{ item }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-toolbar-items>
  </v-app-bar>
</template>

<script>
import axios from "axios";
import dateFormat from "dateformat";
export default {
  data() {
    return {
      username: localStorage.getItem("username"),
      name: localStorage.getItem("name"),
      items: [localStorage.getItem("name"), "เปลี่ยนรหัสผ่าน", "ออกจากระบบ"],
      links: [
        { value: "ประวัติออร์เดอร์", route: "/order_history" },
        {
          value: "ประวัติการจัดส่งยา",
          route: "/transport_history"
        }
      ],
      links_order: [
        { value: "สร้างออร์เดอร์", route: "/create_order" },
        {
          value: "ออร์เดอร์",
          route: "/order"
        },
        {
          value: "จัดยา",
          route: "/waiting_medicine"
        },
        {
          value: "จัดส่ง",
          route: "/waiting_transport"
        },
        {
          value: "สถานะการจัดส่ง",
          route: "/transport_status"
        }
      ],
      btncolor: "teal lighten-3",
      btncolor1: "teal lighten-3",
      btncolor2: "teal lighten-3",
      order: []
    };
  },
  mounted() {
    this.order = [];
    var today = new Date();
    var nextmonth = (new Date().getMonth() + 1) % 12;
    var end = dateFormat(
      new Date(today.getFullYear(), nextmonth, today.getDate()),
      "yyyy-mm-dd HH:MM:ss"
    );
    axios
      .post("http://localhost:3000/api/order/getnext_duedate", {
        start: dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss"),
        end: end
      })
      .then(res => {
        res.data.forEach(element => {
          var date = new Date(element.next_due_date);
          var start2 = dateFormat(
            new Date(
              date.getFullYear(),
              date.getMonth(),
              date.getDate(),
              0,
              0,
              0
            ),
            "yyyy-mm-dd HH:MM:ss"
          );
          var end2 = dateFormat(
            new Date(
              date.getFullYear(),
              date.getMonth(),
              date.getDate(),
              23,
              59,
              59
            ),
            "yyyy-mm-dd HH:MM:ss"
          );
          axios
            .post("http://localhost:3000/api/order/getorderpatient", {
              patient_HN: element.patient_HN,
              due_date_start: start2,
              due_date_end: end2
            })
            .then(res2 => {
              if (res2.data.length == 0) {
                this.order.push(element);
              }
            });
        });
      });
  },
  methods: {
    logout: function(e) {
      this.$store.commit("set_user", null);
      this.$store.commit("set_staff_id", null);
      this.$store.commit("set_name", null);
      this.$store.commit("set_user_type", null);
      localStorage.setItem("username", null);
      localStorage.setItem("name", null);
      localStorage.setItem("staff_id", null);
      localStorage.setItem("user_type", null);
      this.$router.push("/");
    },
    menuAccount(item) {
      if (item === "เปลี่ยนรหัสผ่าน") {
        this.$router.push("/changepassword");
      } else if (item === "ออกจากระบบ") this.logout();
    },
    setDate(date) {
      var month = [
        "มกราคม",
        "กุมภาพันธ์",
        "มีนาคม",
        "เมษายน",
        "พฤษภาคม",
        "มิถุนายน",
        "กรกฎาคม",
        "สิงหาคม",
        "กันยายน",
        "ตุลาคม",
        "พฤศจิกายน",
        "ธันวาคม"
      ];
      if (date == null) return null;
      var d = dateFormat(date, "d/m/yyyy");
      var [date, m, y] = d.split("/");
      return date + " " + month[m - 1] + " " + (parseInt(y) + 543);
    },
    click(e) {
      var selected = e.currentTarget.value;
      if (selected == "patient") {
        this.$router.push("/patient");
      } else if (selected == "return") {
        this.$router.push("/recall");
      } else if (selected == "home") {
        this.$router.push("/hospital");
      }
    }
  }
};
</script>
