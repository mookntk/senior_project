<template>
  <v-app-bar class="font teal lighten-3">
    <v-toolbar-title>
      <span>เภสัชกรร้านขายยา</span>
      <!-- <span class="font-weight-light">MATERIAL DESIGN</span> -->
    </v-toolbar-title>
    <v-spacer></v-spacer>

    <v-toolbar-items>
      <v-btn depressed class="teal lighten-3" to="/ready_sell">ออร์เดอร์พร้อมจำหน่าย</v-btn>

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

      <v-btn depressed class="teal lighten-3" to="/prepare" >จัดยาตามออร์เดอร์</v-btn>

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

      <v-btn depressed class="teal lighten-3" to="/order_status" >สถานะออร์เดอร์</v-btn>
      <v-btn depressed class="teal lighten-3" @click="click" value="/notification" >
        <v-icon>mdi-bell</v-icon>
      </v-btn>
    </v-toolbar-items>

    <v-menu offset-y open-on-hover>
      <template v-slot:activator="{ on }">
        <v-btn color="primary" dark v-on="on" text>{{username}}</v-btn>
      </template>
      <v-list>
        <v-list-item v-for="(item, index) in items" :key="index">
          <v-list-item-title :value="index" @click="logout">
            {{
            item
            }}
          </v-list-item-title>
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
      username: localStorage.getItem("username"),
      name: localStorage.getItem("name"),
      links: [
        {
          value: "รายการที่ต้องส่งคืน",
          route: "/sendback_order"
        },
        { value: "สถานะการจัดส่ง", route: "/sendback_status" }
      ],
      confirm: [
        {
          value: "ยืนยันรับออร์เดอร์จากโรงพยาบาล",
          route: "/receive_order"
        },
        { value: "ตรวจสอบและยืนยันจำนวนยา", route: "/confirm_order" }
      ],
      logged: localStorage.getItem("login"),
      items: [localStorage.getItem("name"), "เลขใบอนุญาต", "Logout"],
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
      this.$store.commit("set_user", null);
      this.$store.commit("set_staff_id", null);
      this.$store.commit("set_name", null);
      this.$store.commit("set_user_type", null);
      this.$router.push("/");
      localStorage.setItem("username", null);
      localStorage.setItem("name", null);
      localStorage.setItem("staff_id", null);
      localStorage.setItem("user_type", null);
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
        this.$router.push("/order_status");
      } else if (e.currentTarget.value == "notification") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-1";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "้home") {
        this.$router.push("/ready_sell");
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-1";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "orderstatus") {
        this.$router.push("/order_status");
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-1";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "prepareorder") {
        this.$router.push("/prepare");
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
