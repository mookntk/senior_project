<template>
  <v-app-bar app class="font teal lighten-3">
    <v-toolbar-title>
      <span>การจัดการเจ้าหน้าที่และยา</span>
    </v-toolbar-title>
    <div class="flex-grow-1"></div>

    <v-btn depressed class="teal lighten-3" to="/hospitalstaff" value="hosstaff"
      >เภสัชกรของโรงพยาบาล</v-btn
    >
    <v-btn depressed class="teal lighten-3" to="/pharmacy" value="pharmacy"
      >ร้านขายยา</v-btn
    >
    <v-btn depressed class="teal lighten-3" to="/pharmacist" value="pharmacist"
      >เภสัชกรร้านขายยา</v-btn
    >
    <v-btn depressed class="teal lighten-3" to="/medicine" value="medicine"
      >ยา</v-btn
    >

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
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return {
      logged: localStorage.getItem("login"),
      items: ["ชื่อ-สกุล", "Logout"],
      text: "center"
    };
  },
  methods: {
    logout: function() {
      localStorage.setItem("login", "false");
      console.log(localStorage.getItem("login"));
      this.$router.push("/");
    }
  }
};
</script>

<style lang="stylus" scoped></style>
