<template>
  <v-app-bar class="admin teal lighten-3">
    <v-toolbar-title>
      <span>เภสัชกรร้านขายยา</span>
      <!-- <span class="font-weight-light">MATERIAL DESIGN</span> -->
    </v-toolbar-title>
    <v-spacer></v-spacer>

    <v-toolbar-items>
      <v-btn depressed @click="click" value="้home" :color="btncolor">ออร์เดอร์พร้อมจำหน่าย</v-btn>

      <!-- ยืนยันออร์เดอร์ -->
      <v-menu offset-y open-on-hover>
        <template v-slot:activator="{ on }">
          <v-btn v-on="on" text>
            <span style="margin-right:7px">ยืนยันออร์เดอร์</span>
            <v-icon left>mdi-chevron-down</v-icon>
          </v-btn>
        </template>

        <v-list>
          <v-list-item v-for="item in confirm" :key="item.value" router :to="item.route">
            <v-list-item-title>{{ item.value }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <!-- ยืนยันออร์เดอร์ -->

      <v-btn depressed @click="click" value="prepareorder" :color="btncolor4">จัดยาตามออร์เดอร์</v-btn>

      <!-- <v-btn depressed @click="click" value="returnmedicine" :color="btncolor">การคืนยา</v-btn> -->
      <v-menu offset-y open-on-hover>
        <template v-slot:activator="{ on }">
          <v-btn v-on="on" text>
            <span style="margin-right:7px">ออร์เดอร์ที่ส่งคืนโรงพยาบาล</span>
            <v-icon left>mdi-chevron-down</v-icon>
          </v-btn>
        </template>

        <v-list>
          <v-list-item v-for="item in links" :key="item.value" router :to="item.route">
            <v-list-item-title>{{ item.value }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>

      <v-btn depressed @click="click" value="orderstatus" :color="btncolor2">สถานะออร์เดอร์</v-btn>
      <v-btn depressed @click="click" value="notification" :color="btncolor3">
        <v-icon>mdi-bell</v-icon>
      </v-btn>
    </v-toolbar-items>

    <v-menu offset-y open-on-hover>
      <template v-slot:activator="{ on }">
        <v-btn color="primary" dark v-on="on" text>ชื่อผู้ใช้</v-btn>
      </template>
      <v-list>
        <v-list-item v-for="(item, index) in items" :key="index">
          <v-list-item-title :value="index" @click="logout">{{ item }}</v-list-item-title>
          <!-- {{ item }} -->
        </v-list-item>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return {
      links: [
        {
          value: "รายการที่ต้องส่งคืน",
          route: "/sendback_order"
        },
        { value: "สถานะการจัดส่ง", route: "/sendback" }
      ],
      confirm: [
        {
          value: "ยืนยันรับออร์เดอร์จากโรงพยาบาล",
          route: "/receive_order"
        },
        { value: "ตรวจสอบและยืนยันจำนวนยา", route: "/check_confirm" }
      ],
      logged: localStorage.getItem("login"),
      items: ["ชื่อ-นามสกุล", "เลขใบอนุญาต", "Logout"],
      active: [false, false],
      btncolor: "teal lighten-3",
      btncolor1: "teal lighten-3",
      btncolor2: "teal lighten-3",
      btncolor3: "teal lighten-3",
      btncolor4: "teal lighten-3"
    };
  },
  methods: {
    logout: function(e) {
      console.log(e.currentTarget);
      // console.log(localStorage.getItem('login'))
      this.$router.push("/");
    },
    click: function(e) {
      console.log(e.currentTarget.value);
      if (e.currentTarget.value == "returnmedicine") {
        this.$router.push("/traceability");
        this.btncolor = "teal lighten-1";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "transferfromhp") {
        this.$router.push("/status_history");
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-1";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "order") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-1";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
        this.$router.push("/Orderdetail");
      } else if (e.currentTarget.value == "notification") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-1";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "้home") {
        this.$router.push("/about");
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-1";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "orderstatus") {
        this.$router.push("/Orderdetail");
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-1";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "prepareorder") {
        this.$router.push("/prepare_order");
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-1";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      }
    }
  }
};
</script>
<style scoped>
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.admin {
  font-family: "Sarabun", sans-serif;
}
thead {
  background-color: antiquewhite;
}
</style>