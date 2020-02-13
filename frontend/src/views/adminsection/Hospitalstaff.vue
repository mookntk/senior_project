<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menuadmin />
    </div>
    <v-data-table
      :search="search"
      :headers="headers"
      :items="hosstaff"
      :items-per-page="10"
      sort-by="name"
      class="font elevation-1"
    >
      <template v-slot:top>
        <v-toolbar flat color="white">
          <v-toolbar-title class="font">เภสัชกรโรงพยาบาล</v-toolbar-title>
          <v-spacer></v-spacer>

          <!-- ช่อง search -->
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="ค้นหา"
            single-line
            hide-details
          ></v-text-field>

          <v-divider class="mx-4" inset vertical></v-divider>
          <div class="flex-grow-1"></div>

          <v-dialog v-model="dialog" max-width="500px" persistent>
            <template v-slot:activator="{ on }">
              <v-btn class="font mb-2" color="primary" dark v-on="on"
                >+ เพิ่มเภสัชกรของโรงพยาบาล</v-btn
              >
            </template>
            <v-card class="font">
              <v-card-title>
                <span>{{ formTitle }}</span>
              </v-card-title>

              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field
                        v-model="hosstaff_selected.name"
                        label="ชื่อ"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field
                        v-model="hosstaff_selected.surname"
                        label="นามสกุล"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field
                        v-model="hosstaff_selected.username"
                        label="ชื่อผู้ใช้"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field
                        v-model="hosstaff_selected.email"
                        label="อีเมล"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field
                        v-model="hosstaff_selected.telno"
                        label="เบอร์ติดต่อ"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-radio-group
                        v-model="hosstaff_selected.sex"
                        label="เพศ"
                      >
                        <v-radio label="ชาย"></v-radio>
                        <v-radio label="หญิง"></v-radio>
                      </v-radio-group>
                    </v-col>
                  </v-row>
                </v-container>
              </v-card-text>

              <v-card-actions>
                <div class="flex-grow-1"></div>
                <v-btn color="blue darken-1" text @click="close">ยกเลิก</v-btn>
                <v-btn color="blue darken-1" text @click="save"
                  >เสร็จสิ้น</v-btn
                >
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-toolbar>
      </template>

      <template v-slot:item.action="{ item }">
        <v-icon small class="mr-6" @click="editItem(item)">mdi-pencil</v-icon>
        <v-icon small class="mr-6" @click="deleteItem(item)">mdi-delete</v-icon>
        <v-icon small class="mr-6" @click="forgotpw(item)"
          >mdi-email-send</v-icon
        >
      </template>
    </v-data-table>
    <!-- Data Table of hosstaff page -->
  </v-app>
</template>

<script>
import Menuadmin from "../../components/Menuadmin";
import axios from "axios";
export default {
  data: () => ({
    search: "",
    dialog: false,
    headers: [
      { text: "ชื่อ", value: "name",width:"15%" },
      { text: "นามสกุล", value: "surname",width:"15%" },
      { text: "username", value: "username",width:"15%" },
      { text: "อีเมล", value: "email",width:"25%" },
      { text: "เบอร์ติดต่อ", value: "telno",width:"15%" },
      {
        text: "แก้ไข / ลบ / ส่งรหัสผ่านให้ผู้ใช้",
        value: "action",
        sortable: false
      }
    ],
    hosstaff: [],
    hosstaff_selected: [],
    editedIndex: -1,
    editedItem: {
      name: "",
      surname: "",
      username: "",
      email: "",
      telno: ""
    },
    defaultItem: {
      name: "",
      surname: "",
      username: "",
      email: "",
      telno: "",
      sex: ""
    }
  }),
  components: {
    Menuadmin
  },

  computed: {
    formTitle() {
      return this.editedIndex === -1
        ? "เพิ่มเภสัชกรของโรงพยาบาล"
        : "แก้ไขข้อมูลเภสัชกรของโรงพยาบาล";
    }
  },
  methods: {
    editItem(item) {
      console.log(this.hosstaff);
      this.editedIndex = this.hosstaff.indexOf(item);
      this.hosstaff_selected = Object.assign({}, item);
      if (item.sex === "Male") {
        this.hosstaff_selected.sex = 0;
      } else {
        this.hosstaff_selected.sex = 1;
      }

      this.dialog = true;
    },
    deleteItem(item) {
      const index = this.hosstaff.indexOf(item);
      console.log(this.hosstaff[index].staff_id);
      confirm(
        "คุณต้องการที่จะลบข้อมูลเภสัชกรใช่หรือไม่?\nคุณ" +
          item.name +
          " " +
          item.surname
      ) &&
        axios
          .post("http://localhost:3000/api/user/deleteuser", {
            staff_id: item.staff_id
          })
          .then(res => {
            this.hosstaff.splice(index, 1);
          })
          .catch(e => {
            console.log("delete error " + e);
          });
    },
    forgotpw(item) {
      const index = this.hosstaff.indexOf(item);
      console.log(this.hosstaff[index].staff_id);
      confirm(
        "คุณต้องการที่จะส่งข้อมูลรหัสเภสัชกรใช่หรือไม่?\nคุณ" +
          item.name +
          " " +
          item.surname +
          "ไปที่อีเมล " +
          item.email
      ) &&
        axios
          .post("http://localhost:3000/api/user/sendmail", {
            username: item.username,
            password: item.password,
            email: item.email
          })
          .then(res => {
            this.hosstaff.splice(index, 1);
          })
          .catch(e => {
            console.log("send email error " + e);
          });
    },
    save() {
      if (this.editedIndex > -1) {
        axios
          .post(
            "http://localhost:3000/api/user/edituser",
            this.hosstaff_selected
          )
          .then(res => {
            this.getallstaff();
          });
      } else {
        var check = 0;
        axios.get("http://localhost:3000/api/user/showallstaff").then(res => {
          for (var i = 0; i < res.data.length; i++) {
            if (this.hosstaff_selected.username === res.data[i].username) {
              check = 1;
              console.log("มีชื่อผู้ใช้นี้แล้ว");
              alert("มีชื่อผู้ใช้นี้แล้ว โปรดใช้ชื่ออื่น");
              break;
            }
          }
          if (check == 0) {
            axios
              .post("http://localhost:3000/api/user/newuser", {
                username: this.hosstaff_selected.username,
                name: this.hosstaff_selected.name,
                surname: this.hosstaff_selected.surname,
                email: this.hosstaff_selected.email,
                telno: this.hosstaff_selected.telno,
                sex: this.hosstaff_selected.sex,
                password: this.randomstring
              })
              .then(res => {
                this.getallstaff();
              });
          }
        });
      }
      this.close();
    },
    getallstaff() {
      axios.get("http://localhost:3000/api/user/showhospital").then(res => {
        this.hosstaff = res.data;
      });
    },
    // genarate() {
    //   var chars =
    //     "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    //   var string_length = 8;
    //   var randomstring = "";
    //   for (var i = 0; i < string_length; i++) {
    //     var rnum = Math.floor(Math.random() * chars.length);
    //     randomstring += chars.substring(rnum, rnum + 1);
    //   }
    // },
    close() {
      console.log(this.editedIndex);
      this.dialog = false;
      setTimeout(() => {
        this.hosstaff_selected = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    }
  },
  mounted() {
    axios.get("http://localhost:3000/api/user/showhospital").then(res => {
      this.hosstaff = res.data;
    });
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
</style>
