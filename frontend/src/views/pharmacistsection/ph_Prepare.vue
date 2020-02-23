<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>

    <v-content class="font main">
      <v-dialog v-model="dialog_row" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font">
          <v-form ref="form" >
            <!-- tool-bar -->
            <v-toolbar dark color="primary">
              <v-btn icon dark @click="dialog_row = false">
                <v-icon>mdi-close</v-icon>
              </v-btn>
              <v-toolbar-title>ออร์เดอร์ที่ {{ oneorder[0].order_id }}</v-toolbar-title>
            </v-toolbar>
            <!-- tool-bar -->

            <v-card-title>
              <span class="font headline"></span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="6">
                    <v-text-field
                      :value="oneorder[0].name + ' ' + oneorder[0].surname"
                      label="ชื่อ-นามสกุลผู้ป่วย"
                      filled
                      readonly
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6">
                    <v-text-field :value="oneorder[0].gender" label="เพศ" filled readonly></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="4">
                    <v-text-field :value="setDate2(oneorder[0].DOB)" label="อายุ" filled readonly></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="8">
                    <v-text-field
                      :value="setDate3(oneorder[0].DOB)"
                      label="วัน/เดือน/ปีเกิด"
                      filled
                      readonly
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="4" md="6">
                    <v-text-field
                      :value="setStatus(oneorder[0].status)"
                      label="สถานะ"
                      filled
                      readonly
                    ></v-text-field>
                  </v-col>
                </v-row>

                <v-form ref="form2" v-model="valid">
                  <v-row>
                    <v-col cols="12">ยาที่ต้องได้รับ</v-col>
                    <v-row>
                      <v-col cols="12" sm="6" md="6">
                        <v-checkbox
                          v-for="item in oneorder"
                          :key="item.name"
                          v-model="checkbox"
                          :rules="[v => !!v || 'คุณต้องเลือกยาที่จัดแล้วก่อน']"
                          required
                          color="success"
                          :label="
                          setMed(
                            item.medicine_generic +
                              ';' +
                              item.strenght +
                              ';' +
                              item.qty +
                              ';' +
                              item.unit
                          )
                        "
                        ></v-checkbox>
                      </v-col>
                    </v-row>
                  </v-row>
                </v-form>
              </v-container>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn
                rounded
                color="success"
                :disabled="!checkbox"
                dark
                @click="successItem"
              >จัดยาเรียบร้อย</v-btn>
              <v-btn rounded color="grey" dark @click="close">ปิด</v-btn>
            </v-card-actions>
            <!-- table in pop-up page for see each of order detial -->
          </v-form>
        </v-card>
      </v-dialog>

      <!-- data table -->
      <v-row style="font-size:25px;margin:10px">{{ date }}</v-row>
      <v-data-table
        v-model="selected"
        :items="p_order"
        :items-per-page="10"
        :headers="headers"
        class="elevation-1"
      >
        <template v-slot:body="{ items }">
          <tbody>
            <tr
              v-for="item in items"
              :key="item.patient_HN_order"
              @click="selectItem(item)"
              :class="{ selectedRow: item === selectedItem }"
            >
              <td style="text-align:center">{{ item.patient_HN_order }}</td>
              <td style="text-align:left">{{ item.name }} {{ item.surname }}</td>
              <td style="text-align:center">{{ setDate(item.due_date) }}</td>
              <td style="text-align:center">
                <v-chip :color="getColor(item.status)" dark>
                  {{
                  setStatus(item.status)
                  }}
                </v-chip>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>
      <!-- <v-btn @click="logout">logout</v-btn> -->
    </v-content>
  </v-app>
</template>

<script>
// import ConnectDatabase from '../server/server'
import axios from "axios";
import Menubar from "../../components/ph_menubar";
export default {
  components: {
    Menubar
  },
  data: () => ({
    valid: false,
    dialog_wait: false,
    date: "",
    search: "",
    headers: [
      {
        text: "HN",
        align: "center",
        value: "HN"
      },
      { text: "ชื่อ-นามสกุลผู้ป่วย", align: "left" },
      { text: "วันนัดรับยา", align: "center" },
      { text: "สถานะ", align: "center" }
      // { text: 'Actions', value: 'action', sortable: false },
    ],
    editedIndex: -1,
    editedItem: {
      HN: "",
      name: "",
      duedate: "",
      status: ""
    },
    defaultItem: {
      HN: "",
      name: "",
      duedate: "",
      status: ""
    },
    click: false,
    dialog: false,
    dialog_row: false,
    dialog_record: false,
    selected: [],
    index: 0,
    oneorder: [
      {
        order_id: "",
        name: "",
        surname: "",
        gender: "",
        DOB: "",
        status: "",
        patient_HN_order: "",
        medicine_generic: "",
        strenght: "",
        qty: "",
        unit: ""
      }
    ],
    p_order: [
      {
        order_id: "",
        patient_HN_order: "",
        name: "",
        surname: "",
        status: "",
        due_date: ""
      }
    ],
    medist: ""
  }),
  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "New Item" : "Edit Item";
    }
  },
  methods: {
    reset() {
      this.$refs.form.reset();
    },
    reset2() {
      this.$refs.form2.reset();
    },
    setMed: function(m) {
      console.log("เข้าsetMed");
      console.log("m= " + m);
      if (m != null) {
        var med_detail = m.split(";");
        var med_name = med_detail[0];
        var med_name2 = med_name.split(",");
        var med_strenght = med_detail[1];
        var med_strenght2 = med_strenght.split(",");
        var med_qty = med_detail[2];
        var med_qty2 = med_qty.split(",");
        var med_unit = med_detail[3];
        var med_unit2 = med_unit.split(",");

        var med_show = "";
        for (var i = 0; i < med_name2.length; i++) {
          if (i === med_name2.length - 1) {
            med_show +=
              med_name2[i] +
              " " +
              med_strenght2[i] +
              " " +
              med_qty2[i] +
              " " +
              med_unit2[i];
          } else {
            med_show +=
              med_name2[i] +
              " " +
              med_strenght2[i] +
              " " +
              med_qty2[i] +
              " " +
              med_unit2[i] +
              "/";
          }
          console.log("med_show = " + med_show);
        }
        return med_show;
      }
    },

    setDate: function(d) {
      console.log(d);
      var month = [
        "มกราคม",
        "กุมภาพันธ์",
        "มีนาคม",
        "เมษายน",
        "พฤษภาคม",
        "มิถุนายน",
        "กรกฎาคม",
        "สิงหาคม",
        "กันยายน",
        "ตุลาคม",
        "พฤศจิกายน",
        "ธันวาคม"
      ];
      if (d != null) {
        var due_date = d.split(" ");
        due_date[0] = parseInt(due_date[0]) + 543;
        due_date =
          due_date[2] + " " + month[due_date[1] - 1] + " " + due_date[0];
        console.log(due_date);
        return due_date;
      } else return "";
    },
    setDate2: function(m) {
      console.log(m);
      var month = [
        "มกราคม",
        "กุมภาพันธ์",
        "มีนาคม",
        "เมษายน",
        "พฤษภาคม",
        "มิถุนายน",
        "กรกฎาคม",
        "สิงหาคม",
        "กันยายน",
        "ตุลาคม",
        "พฤศจิกายน",
        "ธันวาคม"
      ];
      if (m != null) {
        var dob_date = m.split("/");
        var date = new Date();
        dob_date = date.getFullYear() + 543 - dob_date[2];
        console.log(dob_date);

        return dob_date;
      } else return "";
    },
    setDate3: function(d) {
      console.log(d);
      var month = [
        "มกราคม",
        "กุมภาพันธ์",
        "มีนาคม",
        "เมษายน",
        "พฤษภาคม",
        "มิถุนายน",
        "กรกฎาคม",
        "สิงหาคม",
        "กันยายน",
        "ตุลาคม",
        "พฤศจิกายน",
        "ธันวาคม"
      ];
      if (d != null) {
        var dob_date3 = d.split("/");
        dob_date3 =
          dob_date3[0] + " " + month[dob_date3[1] - 1] + " " + dob_date3[2];
        console.log(dob_date3);
        return dob_date3;
      } else return "";
    },
    setStatus: function(s) {
      if (s === "prepare") {
        s = "รอการจัดยา";
      }
      return s;
    },
    dialog: function(e) {
      alert(e.currentTarget);
    },
    logout: function() {
      localStorage.setItem("login", "false");
      console.log(localStorage.getItem("login"));
      this.$router.push("/");
    },
    selectItem(item) {
      this.index = this.p_order.indexOf(item);
      console.log("selected" + "this.index = " + this.index);
      this.oneorder = item;
      axios
        .post("http://localhost:3000/api/ph_prepare/one_order", {
          order_id: this.p_order[this.index].order_id
        })
        .then(res => {
          this.oneorder = res.data;
        });

      if (this.p_order.status == "prepare") {
        this.dialog_wait = true;
      } else {
        this.dialog_row = true;
      }
    },
    successItem() {
      var id = this.oneorder[0].order_id;
      console.log("order_id = " + this.index);
      if (this.$refs.form.validate()) {
        console.log("success order");
        axios
          .post("http://localhost:3000/api/ph_prepare/success_prepare", {
            order_id: id
          })
          .then(res => {
            console.log(this.p_order);
            console.log(this.index);
            this.p_order.splice(this.index, 1);
            console.log(this.p_order);
            this.close();
          });
        // this.oneorder.splice(this.index, 1);
        // this.dialog_row = false;
      }
    },
    getColor(status) {
      if (status == "cancel") return "red";
      else if (status == "พร้อมจ่ายยา") return "orange";
      else return "grey";
    },
    close() {
      this.reset2();
      this.dialog_row = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    save() {
      if (this.editedIndex > -1) {
        Object.assign(this.oneorder[this.editedIndex], this.editedItem);
      } else {
        this.oneorder.push(this.editedItem);
      }
      this.close();
    }
  },

  mounted() {
    axios
      .post("http://localhost:3000/api/user/getuserbyid", {
        staff_id: localStorage.getItem("staff_id")
      })
      .then(res => {
        this.pharmacy_id = res.data[0].pharmacy_id_pharmacist;
        axios
          .post("http://localhost:3000/api/ph_prepare/patient_order", {
            pharmacy_id: this.pharmacy_id
          })
          .then(res => {
            this.p_order = res.data;
          });
      })
      .catch(e => {
        console.log(e);
      });
    var day = [
      "วันอาทิตย์",
      "วันจันทร์",
      "วันอังคาร",
      "วันพุธ",
      "วันพฤหัสบดี",
      "วันศุกร์",
      "วันเสาร์"
    ];
    var month = [
      "มกราคม",
      "กุมภาพันธ์",
      "มีนาคม",
      "เมษายน",
      "พฤษภาคม",
      "มิถุนายน",
      "กรกฎาคม",
      "สิงหาคม",
      "กันยายน",
      "ตุลาคม",
      "พฤศจิกายน",
      "ธันวาคม"
    ];
    var date = new Date();
    var date_format =
      day[date.getDay()] +
      " " +
      date.getDate() +
      " " +
      month[date.getMonth()] +
      " " +
      (date.getFullYear() + 543);

    this.date = date_format;
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
