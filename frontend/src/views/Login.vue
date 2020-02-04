<template>
  <v-app id="inspire" class="font grey lighten-4">
    <div style="position:absolute;width:100%">
      <v-alert border="left" v-if="alert" type="error">Incorrect username or password</v-alert>
    </div>
    <v-content>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12" sm="8" md="4">
            <v-card class="elevation-12 font" width="400px" height="330px">
              <v-toolbar class="teal lighten-2" dark flat>
                <v-toolbar-title>Hospital</v-toolbar-title>
                <div class="flex-grow-1"></div>
              </v-toolbar>
              <v-card-text>
                <v-form>
                  <v-text-field
                    label="ชื่อผู้ใช้"
                    name="username"
                    prepend-icon="mdi-account"
                    type="text"
                    v-model="username"
                    required
                  ></v-text-field>
                  <v-text-field
                    id="password"
                    label="รหัสผ่าน"
                    name="password"
                    prepend-icon="mdi-lock"
                    :type="showpass?'text':'password'"
                    :append-icon="showpass ? 'mdi-eye' : 'mdi-eye-off'"
                    v-model="password"
                    required
                    @click:append="showpass = !showpass"
                    @keyup.enter="login"
                  ></v-text-field>
                  <v-layout justify-space-between>
                    <v-spacer></v-spacer>
                    <v-btn
                      x-small
                      text
                      color="primary"
                      style="font-size:12px"
                      @click="sendemail"
                    >ลืมรหัสผ่าน</v-btn>
                  </v-layout>
                </v-form>
              </v-card-text>
              <v-card-actions>
                <div class="flex-grow-1"></div>
                <v-btn color="teal lighten-2 white--text" large block @click="login">เข้าสู่ระบบ</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
// import ConnectDatabase from '../server/server'
import axios from "axios";
export default {
  data() {
    return {
      username: "hos_staff",
      password: "",
      type: "",
      data: "",
      alert: false,
      showpass: false
    };
  },
  mounted() {
    if (localStorage.getItem("login") == true) {
      this.$router.push("/about");
    }
  },
  methods: {
    sendemail() {
      confirm("ต้องการให้ส่งรหัสผ่านไปยังอีเมลของคุณใช่หรือไม่?");
    },

    hidepass: function() {
      this.hidepassword =
        this.hidepassword === "password" ? "text" : "password";
    },
    login: function() {
      axios
        .post("http://localhost:3000/api/user/login", {
          username: this.username,
          password: this.password
        })
        .then(res => {
          this.data = res.data;
          localStorage.setItem("username", this.data.username);
          localStorage.setItem(
            "name",
            this.data.name + " " + this.data.surname
          );
          localStorage.setItem("staff_id", this.data.staff_id);
          this.$router.push("/patient");
        })
        .catch(e => {
          console.log(e);
        });
    },
    entertologin(e) {}
  }
};
</script>
<style >
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.font {
  font-family: "Sarabun", sans-serif;
}
</style>