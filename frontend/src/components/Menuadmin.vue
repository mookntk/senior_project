<template>
  <v-app-bar app class="font teal lighten-3">
    <v-toolbar-title>
      <span>การจัดการเจ้าหน้าที่และยา</span>
    </v-toolbar-title>
    <div class="flex-grow-1"></div>

    <!-- <v-toolbar-items> -->
      <!-- <v-btn depressed @click="viewallhosstaff" value="home" :color="btncolor">หน้าหลัก</v-btn> -->
      <v-btn-toggle v-model="toggle_exclusive"  color="deep-grey accent-3" group>
        <v-btn depressed @click="viewallhosstaff" value="hosstaff"
          >เภสัชกรของโรงพยาบาล</v-btn
        >

        <v-btn depressed @click="viewallphamacy" value="pharmacy"
          >ร้านขายยา</v-btn
        >
        <v-btn depressed @click="viewallphamacist" value="pharmacist"
          >เภสัชกรร้านขายยา</v-btn
        >
        <v-btn depressed @click="viewallmedicine" value="medicine">ยา</v-btn>
      </v-btn-toggle>

      <v-menu offset-y>
        <template v-slot:activator="{ on }">
          <v-btn color="primary" dark v-on="on" text>User</v-btn>
          <!-- ต้องเปลี่ยนคำว่า User ให้ขึ้นเป็น username ของUserปัจจุบันที่ใช้งานอยู่ ณ ตอนนั้น -->
        </template>
        <v-list>
          <v-list-item v-for="(item, index) in items" :key="index">
            <v-list-item :value="index" @click="logout($event)">{{
              item
            }}</v-list-item>
          </v-list-item>
        </v-list>
      </v-menu>
    <!-- </v-toolbar-items> -->
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return {
      logged: localStorage.getItem("login"),
      items: ["ชื่อ-สกุล", "Logout"],
      text: 'center',
      toggle_exclusive: undefined,
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
      this.$router.push("/hospitalstaff");
    },

    viewallphamacy: function(e) {
      console.log(e.currentTarget.value);
      
      this.$router.push("/pharmacy");
    },

    viewallphamacist: function(e) {
      console.log(e.currentTarget.value);
      
      this.$router.push("/pharmacist");
    },
    viewallmedicine: function(e) {
      console.log(e.currentTarget.value);
      this.$router.push("/medicine");
    }
  }
};
</script>

<style lang="stylus" scoped>
</style>
