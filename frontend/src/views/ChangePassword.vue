<template>
  <v-app class="font cyan lighten-5">
    <div v-if="user_type=='hos_staff'" class="menu-header">
      <Hp_Menu />
    </div>
    <div v-else-if="user_type=='pharmacist'" class="menu-header">
      <Ph_Menu />
    </div>
    <div v-else class="menu-header">
      <Admin_Menu />
    </div>
    <v-content class="font main">
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12" sm="8" md="4">
            <v-card class="font" width="400px" height="300px">
              <v-toolbar color="#bdc3c7" flat>
                <v-toolbar-title>เปลี่ยนรหัสผ่าน</v-toolbar-title>
                <div class="flex-grow-1"></div>
              </v-toolbar>
              <v-card-text>
                <v-form ref="form">
                  <v-tooltip left>
                    <template v-slot:activator="{ on }">
                      <v-text-field
                        label="รหัสผ่านใหม่"
                        v-model="password"
                        type="password"
                        :rules="[
                    v=>v.length>=8||'กรุณากรอกอย่างน้อย 8 ตัวอักษร']"
                        counter
                        required
                        v-on="on"
                      ></v-text-field>
                    </template>
                    <span class="font">อย่างน้อย 8 ตัวอักษร</span>
                  </v-tooltip>
                  <v-text-field
                    id="password"
                    label="กรอกรหัสผ่านใหม่อีกครั้ง"
                    type="password"
                    name="password2"
                    :rules="[
                    v=>!!v||'กรุณากรอกข้อมูล',v=>v==password||'รหัสผ่านไม่ตรงกัน']"
                    counter
                    required
                  ></v-text-field>
                </v-form>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="#76C3AF" large @click="ChangePassword">ยืนยัน</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
import Hp_Menu from "../components/hp_menubar";
import Ph_Menu from "../components/ph_menubar";
import Admin_Menu from "../components/Menuadmin";
import axios from "axios";
import dateFormat from "dateformat";
export default {
  data() {
    return {
      user_type: localStorage.getItem("user_type"),
      password: null
    };
  },
  components: {
    Hp_Menu,
    Ph_Menu,
    Admin_Menu
  },
  methods: {
    ChangePassword() {
      axios
        .post("http://localhost:3000/api/user/changepassword", {
          password: this.password,
          staff_id: localStorage.getItem("staff_id")
        })
        .then(() => {
          this.$refs.form.reset();
        });
    }
  }
};
</script>
<style>
.menu-header {
  position: fixed;
  width: 100%;
  top: 0px;
  right: 0px;
  z-index: 1;
}
.main {
  margin: 20px;
  margin-top: 120px;
}
.alert {
  position: fixed;
  z-index: 2;
  width: 100%;
}
</style>
