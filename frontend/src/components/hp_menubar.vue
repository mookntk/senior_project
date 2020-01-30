<template>
  <v-app-bar class="teal lighten-3">
    <v-toolbar-title class="font">
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
      <v-btn depressed @click="click" value="return" :color="btncolor">การคืนยา</v-btn>
      <v-btn depressed @click="click" value="patient" :color="btncolor">ข้อมูลผู้ป่วย</v-btn>
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
      <v-btn text>
        <v-badge v-model="show" color="cyan" right>
          <template v-slot:badge>
            <span>6</span>
          </template>
          <v-icon color="grey darken-1">mdi-bell</v-icon>
        </v-badge>
      </v-btn>
    </v-toolbar-items>
    <v-menu offset-y open-on-hover>
      <template v-slot:activator="{ on }">
        <v-btn color="primary" dark v-on="on" text>ชื่อผู้ใช้</v-btn>
      </template>
      <v-list>
        <v-list-item v-for="item in items" :key="item" @click="logout">
          <v-list-item-title>{{ item }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return {
      logged: localStorage.getItem("login"),
      items: ["ชื่อ-สกุล", "Logout"],
      links: [
        { value: "ประวัติออร์เดอร์", route: "/order_history" },
        {
          value: "ประวัติการจัดส่งยา",
          route: "/transfer_history"
        }
      ],
      links_order: [
        { value: "สร้างออร์เดอร์", route: "/create_order" },
        {
          value: "ออร์เดอร์",
          route: "/waiting_medicine"
        },
        {
          value: "จัดยา",
          route: "/prepare"
        },
        {
          value: "จัดส่ง",
          route: "/waiting_transport"
        },
        {
          value: "สถานะการจัดส่ง",
          route: "/transfer_status"
        }
      ],
      btncolor: "teal lighten-3",
      btncolor1: "teal lighten-3",
      btncolor2: "teal lighten-3"
    };
  },
  methods: {
    logout: function(e) {
      console.log(e.currentTarget.key);
      localStorage.setItem("login", "false");
      console.log(localStorage.getItem("login"));
      // this.$router.push("/");
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

<style scoped>
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.font {
  font-family: "Sarabun", sans-serif;
}
</style>