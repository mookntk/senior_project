<template>
  <v-app-bar app class=" font teal lighten-3">
    <v-toolbar-title>
      <span>การจัดการเจ้าหน้าที่และยา</span>
    </v-toolbar-title>
    <div class="flex-grow-1"></div>

    <v-toolbar-items>
      <v-btn depressed @click="viewallhosstaff" value="home" :color="btncolor">หน้าหลัก</v-btn>
      <v-btn
        depressed
        @click="viewallhosstaff"
        value="hosstaff"
        :color="btncolor"
      >เภสัชกรของโรงพยาบาล</v-btn>
      <v-btn depressed @click="viewallphamacy" value="phamacy" :color="btncolor1">ร้านขายยา</v-btn>
      <v-btn
        depressed
        @click="viewallphamacist"
        value="phamacist"
        :color="btncolor2"
      >เภสัชกรร้านขายยา</v-btn>
      <v-btn depressed @click="viewallmedicine" value="medicine" :color="btncolor3">ยา</v-btn>

      <v-menu offset-y>
        <template v-slot:activator="{ on }">
          <v-btn color="primary" dark v-on="on" text>User</v-btn>
          <!-- ต้องเปลี่ยนคำว่า User ให้ขึ้นเป็น username ของUserปัจจุบันที่ใช้งานอยู่ ณ ตอนนั้น -->
        </template>
        <v-list>
          <v-list-item v-for="(item, index) in items" :key="index">
            <v-list-item :value="index" @click="logout($event)">{{ item }}</v-list-item>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-toolbar-items>
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return {
      logged: localStorage.getItem("login"),
      items: ["ชื่อ-สกุล", "Logout"],
      btncolor: "teal lighten-3",
      btncolor1: "teal lighten-3",
      btncolor2: "teal lighten-3",
      btncolor3: "teal lighten-3"
    };
  },
  methods: {
    logout: function() {
      localStorage.setItem("login", "false");
      console.log(localStorage.getItem("login"));
      this.$router.push("/");
    },

    viewallhosstaff: function(e) {
      console.log(e.currentTarget.value);
      if (e.currentTarget.value == "hosstaff") {
        this.btncolor = "teal lighten-1";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        this.$router.push("/hospitalstaff");
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "phamacy") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-1";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "phamacist") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-1";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "medicine") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-1";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "home") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-1";
        this.$router.push("/admin");
        console.log(this.btncolor);
      }
    },

    viewallphamacy: function(e) {
      console.log(e.currentTarget.value);
      if (e.currentTarget.value == "phamacy") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-1";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "้hosstaff") {
        this.btncolor = "teal lighten-1";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "้phamacist") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-1";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "medicine") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-1";
        console.log(this.btncolor);
      }
      this.$router.push("/phamacy");
    },

    viewallphamacist: function(e) {
      console.log(e.currentTarget.value);
      if (e.currentTarget.value == "phamacist") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-1";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "hosstaff") {
        this.btncolor = "teal lighten-1";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "phamacy") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-1";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "medicine") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-1";
        console.log(this.btncolor);
      }
      this.$router.push("/phamacist");
    },
    viewallmedicine: function(e) {
      console.log(e.currentTarget.value);
      if (e.currentTarget.value == "phamacist") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-1";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "hosstaff") {
        this.btncolor = "teal lighten-1";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "phamacy") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-1";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-3";
        console.log(this.btncolor);
      } else if (e.currentTarget.value == "medicine") {
        this.btncolor = "teal lighten-3";
        this.btncolor1 = "teal lighten-3";
        this.btncolor2 = "teal lighten-3";
        this.btncolor3 = "teal lighten-1";
        console.log(this.btncolor);
      }
      this.$router.push("/medicine");
    }
  }
};
</script>
<style >
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.font {
  font-family: "Sarabun", sans-serif;
}
thead {
  background-color: #ffd54f;
}
</style>