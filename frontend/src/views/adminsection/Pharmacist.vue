<template>
  <v-app class="font cyan lighten-5">
    <Menuadmin />
    <v-data-table
      :search="search"
      :headers="headers"
      :items="pharmacist"
      sort-by="name"
      class="font elevation-1"
    >
      <template v-slot:top>
        <v-toolbar flat color="white">
          <v-toolbar-title>เภสัชกรร้านขายยา</v-toolbar-title>
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
          <v-dialog v-model="dialog" max-width="1000px" persistent>
            <template v-slot:activator="{ on }">
              <v-btn color="primary" dark class="mb-2" v-on="on"
                >+ เพิ่มเภสัชกรร้านขายยา</v-btn
              >
            </template>
            <v-form ref="form">
              <v-card-actions>
                <v-card class="font">
                  <v-card-title>
                    <span>{{ formTitle }}</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-row>
                        <v-col cols="12" sm="6" md="4">
                          <v-text-field
                            ref="input"
                            v-model="pharmacist_selected.name"
                            label="ชื่อ"
                            :rules="[rules.required]"
                            :error-messages="errorMessages"
                            required
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6" md="4">
                          <v-text-field
                            ref="input"
                            v-model="pharmacist_selected.surname"
                            label="นามสกุล"
                            :rules="[rules.required]"
                            :error-messages="errorMessages"
                            required
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6" md="4">
                          <v-text-field
                            ref="input"
                            v-model="pharmacist_selected.username"
                            label="ชื่อผู้ใช้"
                            :rules="[rules.required]"
                            :error-messages="errorMessages"
                            required
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6" md="4">
                          <v-text-field
                            ref="input"
                            v-model="pharmacist_selected.email"
                            label="อีเมล"
                            :rules="[rules.required, rules.email]"
                            :error-messages="errorMessages"
                            required
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6" md="4">
                          <v-autocomplete
                            :items="pharmacy"
                            item-text="pharmacy_name"
                            v-model="pharmacist_selected.pharmacy_name"
                            label="ร้านขายยาที่ประจำ"
                          ></v-autocomplete>
                        </v-col>
                        <v-col cols="12" sm="6" md="4">
                          <v-text-field
                            ref="input"
                            v-model="pharmacist_selected.expdate"
                            label="เลขใบอนุญาตฯเภสัช"
                            :rules="[rules.required]"
                            :error-messages="errorMessages"
                            required
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6" md="4">
                          <v-text-field
                            ref="input"
                            v-model="pharmacist_selected.telno"
                            :maxlength="10"
                            label="เบอร์ติดต่อ"
                            :rules="[rules.required]"
                            :error-messages="errorMessages"
                            required
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6" md="4">
                          <v-radio-group
                            v-model="pharmacist_selected.sex"
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
                    <v-btn color="blue darken-1" text @click="close"
                      >ยกเลิก</v-btn
                    >
                    <v-btn color="blue darken-1" text @click="save"
                      >เสร็จสิ้น</v-btn
                    >
                  </v-card-actions>
                </v-card>
              </v-card-actions>
            </v-form>
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
  </v-app>
</template>

<script>
import Menuadmin from "../../components/Menuadmin";
import axios from "axios";
export default {
  data: () => ({
    search: "",
    dialog: false,
    input: null,
    errorMessages: "",
    formHasErrors: false,
    rules: {
      required: input => !!input || "โปรดใส่ข้อมูล",
      // counter: value => value.length <= 20 || "Max 20 characters",
      email: input => {
        const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return pattern.test(input) || "รูปแบบอีเมลไม่ถูกต้อง";
      }
    },
    headers: [
      { text: "ชื่อ", value: "name", width: "13%" },
      { text: "นามสกุล", value: "surname", width: "13%" },
      { text: "username", value: "username", width: "10%", sortable: false },
      { text: "อีเมล", value: "email", width: "18%", sortable: false },
      {
        text: "ร้านขายยาที่ประจำ",
        value: "pharmacy_name",
        width: "10%",
        sortable: false
      },
      {
        text: "เลขใบอนุญาตฯเภสัช",
        value: "expdate",
        align: "center",
        width: "13%",
        sortable: false
      },
      {
        text: "เบอร์ติดต่อ",
        value: "telno",
        width: "10%",
        sortable: false
      },
      {
        text: "แก้ไข / ลบ / ส่งรหัสผ่านให้ผู้ใช้",
        value: "action",
        sortable: false
      }
    ],
    pharmacy: [],
    pharmacist: [],
    pharmacist_selected: [],
    editedIndex: -1,
    editedItem: {
      name: "",
      surname: "",
      username: "",
      email: "",
      pharmacy_name: "",
      expdate: "",
      telno: "",
      sex: ""
    },
    defaultItem: {
      name: "",
      surname: "",
      username: "",
      email: "",
      pharmacy_name: "",
      expdate: "",
      telno: "",
      sex: ""
    }
  }),
  components: {
    Menuadmin
  },

  computed: {
    form() {
      return {
        input: this.input
      };
    },
    formTitle() {
      return this.editedIndex === -1
        ? "เพิ่มเภสัชกรร้านขายยา"
        : "แก้ไขข้อมูลเภสัขกรร้านขายยา";
    }
  },

  watch: {
    input() {
      this.errorMessages = "";
    }
  },

  methods: {
    reset() {
      this.$refs.form.reset();
    },

    editItem(item) {
      this.editedIndex = this.pharmacist.indexOf(item);
      this.pharmacist_selected = Object.assign({}, item);
      console.log(this.pharmacist_selected);
      if (item.sex === "Male") {
        this.pharmacist_selected.sex = 0;
      } else {
        this.pharmacist_selected.sex = 1;
      }

      this.dialog = true;
    },
    deleteItem(item) {
      const index = this.pharmacist.indexOf(item);
      console.log(this.pharmacist[index].staff_id);
      confirm(
        "คุณต้องการที่จะลบข้อมูลเภสัชกรร้านขายยาใช่หรือไม่?\nคุณ" +
          item.name +
          " " +
          item.surname
      ) &&
        axios
          .post("http://localhost:3000/api/pharmacist/deleteuser", {
            staff_id: item.staff_id
          })
          .then(res => {
            this.pharmacist.splice(index, 1);
          })
          .catch(e => {
            console.log("delete error " + e);
          });
    },
    forgotpw(item) {
      const index = this.pharmacist.indexOf(item);
      console.log(this.pharmacist[index].staff_id);
      confirm(
        "คุณต้องการที่จะส่งข้อมูลรหัสเภสัชกรใช่หรือไม่?\nคุณ" +
          item.name +
          " " +
          item.surname +
          "ไปที่อีเมล " +
          item.email
      ) &&
        axios
          .post("http://localhost:3000/api/pharmacist/sendmail", {
            name : item.name,
            surname : item.surname,
            username: item.username,
            password: item.password,
            email: item.email,
            pharmacy_name : item.pharmacy_name
          })
          .then(res => {
            this.pharmacist.splice(index, 1);
          })
          .catch(e => {
            console.log("send email error " + e);
          });
    },
    save() {
      if (this.$refs.form.validate()) {
        if (this.editedIndex > -1) {
          axios
            .post(
              "http://localhost:3000/api/pharmacist/edituser",
              this.pharmacist_selected
            )
            .then(res => {
              // Object.assign(
              //   this.pharmacist[this.editedIndex],
              //   this.pharmacist_selected
              // );
              this.getallstaff();
              this.close();
            });
        } else {
          axios
            .get("http://localhost:3000/api/pharmacist/showpharmacist")
            .then(res => {
              for (var i = 0; i < res.data.length; i++) {
                if (
                  this.pharmacist_selected.username === res.data[i].username
                ) {
                  console.log("มีชื่อผู้ใช้นี้แล้ว");
                  alert("ชื่อผู้ใช้ซ้ำ โปรดใช่ชื่ออื่น");
                  break;
                }
                if (i === res.data.length - 1) {
                  axios
                    .post("http://localhost:3000/api/pharmacist/newuser", {
                      username: this.pharmacist_selected.username,
                      name: this.pharmacist_selected.name,
                      surname: this.pharmacist_selected.surname,
                      email: this.pharmacist_selected.email,
                      telno: this.pharmacist_selected.telno,
                      sex: this.pharmacist_selected.sex,
                      pharmacy_name: this.pharmacist_selected.pharmacy_name,
                      expdate: this.pharmacist_selected.expdate
                    })
                    .then(res => {
                      this.getallstaff();
                      this.close();
                    });
                }
              }
            });
        }
        
      }
    },
    getallstaff() {
      axios
        .get("http://localhost:3000/api/pharmacist/showpharmacist")
        .then(res => {
          this.pharmacist = res.data;
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
        this.reset();
        // this.pharmacist_selected = Object.assign({}, this.defaultItem);
        // this.editedIndex = -1;
      }, 300);
    }
  },
  mounted() {
    axios
      .get("http://localhost:3000/api/pharmacist/showpharmacist")
      .then(res => {
        this.pharmacist = res.data;
      });
    axios.get("http://localhost:3000/api/pharmacy/showpharmacy").then(res => {
      this.pharmacy = res.data;
    });
  }
};
</script>
