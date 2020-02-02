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
      class="elevation-1"
    >
      <!-- <v-content class="main"> -->
      <template v-slot:top>
        <v-toolbar flat color="white">
          <v-toolbar-title>เภสัชกรโรงพยาบาล</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="ค้นหา"
            single-line
            hide-details
          ></v-text-field>
          <v-divider class="mx-4" inset vertical></v-divider>
          <div class="flex-grow-1"></div>

          <v-dialog v-model="dialog" max-width="500px">
            <template v-slot:activator="{ on }">
              <v-btn color="primary" dark class="mb-2" v-on="on">+ เพิ่มเภสัชกรของโรงพยาบาล</v-btn>
            </template>
            <v-card class="font">
              <v-card-title>
                <span>{{ formTitle }}</span>
              </v-card-title>

              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field v-model="hosstaff_selected.name" label="ชื่อ"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field v-model="hosstaff_selected.surname" label="นามสกุล"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field
                        v-model="hosstaff_selected.username"
                        label="ชื่อผู้ใช้"
                        
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field v-model="hosstaff_selected.email" label="อีเมล"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field v-model="hosstaff_selected.telno" label="เบอร์ติดต่อ"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="6">
                      <v-radio-group v-model="hosstaff_selected.sex" label="เพศ">
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
                <v-btn color="blue darken-1" text @click="save">เสร็จสิ้น</v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-toolbar>
      </template>

      <!-- Data Table of hosstaff page -->
      <!-- <v-data-table
      :search="search"
      :headers="headers"
      :items="hosstaff"
      :items-per-page="10"
      sort-by="name"
      class="elevation-1"
      >-->
      <template v-slot:item.action="{ item }">
        <!-- <tbody>
          <tr v-for="item in items" :key="item.name">
            <td>{{ item.name }}</td>
            <td>{{ item.surname }}</td>
            <td style="text-align:center">{{ item.username }}</td>
            <td style="text-align:center">{{ item.email }}</td>
            <td style="text-align:center">{{ item.Telno}}</td>
        <td style="text-align:center">-->
        <v-icon small class="mr-6" @click="editItem(item)">mdi-pencil</v-icon>
        <v-icon small class="mr-6" @click="deleteItem(item)">mdi-delete</v-icon>
        <v-icon small class="mr-6" @click="save(item)">mdi-email-send</v-icon>
        <!-- </td>
          </tr>
        </tbody>-->
      </template>
    </v-data-table>
    <!-- Data Table of hosstaff page -->
  </v-app>
</template>

<script>
import Menuadmin from "../../components/Menuadmin";
import axios from "axios";
import UpdateUserVue from "../../../../../WebPro_Assignment1/assignment1/src/components/UpdateUser.vue";
export default {
  data: () => ({
    search: "",
    dialog: false,
    headers: [
      { text: "ชื่อ", value: "name" },
      { text: "นามสกุล", value: "surname" },
      { text: "username", value: "username" },
      { text: "อีเมล", value: "email" },
      { text: "เบอร์ติดต่อ", value: "telno" },
      // { text: "password", value: "password", sortable: false },
      {
        text: "แก้ไข / ลบ / ส่งรหัสผ่านใหม่ให้ผู้ใช้",
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
      telno: ""
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

  // watch: {
  //   dialog(val) {
  //     val || this.close();
  //   }
  // },

  // created() {
  //   this.initialize();
  // },
  methods: {
    // showItem(item) {
    //   this.hosstaff_selected = item.name + " " + item.surname;
    //   this.index = this.hosstaff.indexOf(item);
    //   this.dialog_record = true;
    // },
    editItem(item) {
      // this.index = this.hosstaff.indexOf(item);
      this.editedIndex = this.hosstaff.indexOf(item);
      // this.hosstaff_selected = item.name + " " + item.surname;
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
      confirm(
        "คุณต้องการที่จะลบข้อมูลเภสัชกรใช่หรือไม่?\nคุณ" +
          item.name +
          " " +
          item.surname
      ) && this.hosstaff.splice(index, 1);
    },
    save() {
      console.log(this.hosstaff_selected);
      if (this.editedIndex > -1) {
        Object.assign(this.hosstaff[this.editedIndex], this.hosstaff_selected);
        this.hosstaff.push(this.hosstaff_selected);
        axios
          .post("http://localhost:3000/api/user/edituser", {
            username: this.hosstaff_selected.username,
            name: this.hosstaff_selected.name,
            surname: this.hosstaff_selected.surname,
            email: this.hosstaff_selected.email,
            telno: this.hosstaff_selected.telno,
            sex: this.hosstaff_selected.sex
          })
          .then(res => {
            this.hosstaff = res.data;
          });
      } else {
        // console.log(this.hosstaff_selected);
        this.hosstaff.push(this.hosstaff_selected);
        axios
          .post("http://localhost:3000/api/user/newuser", {
            username: this.hosstaff_selected.username,
            name: this.hosstaff_selected.name,
            surname: this.hosstaff_selected.surname,
            email: this.hosstaff_selected.email,
            telno: this.hosstaff_selected.telno,
            sex: this.hosstaff_selected.sex
          })
          .then(res => {
            this.hosstaff = res.data;
          });
      }
      this.close();
    },
    close() {
      console.log(this.editedIndex);
      this.dialog = false;
      // function click(element) {
      //   location.reload();
      // }
      setTimeout(() => {
        this.hosstaff_selected = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    updateStuff: function () {
                    this.$http.get('/api/user').then((response) => {
                        console.log(response.data.data);
                        this.user = response.data.data;
                    }, (response) => {
                        console.log('ERROR');
                        console.log(response);
                    });
                    setTimeout(this.updateStuff, 50);
                }
            },
            ready() {
                this.updateStuff();
            }
  ,

  mounted() {
    axios.get("http://localhost:3000/api/user/showhospital").then(res => {
      this.hosstaff = res.data;
    });
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

