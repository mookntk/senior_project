<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>
    <v-content class="font main">
      <v-dialog v-model="dialog_row" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font">
          <v-toolbar color="#77B3D5">
            <v-btn color="#C85D5C" fab small depressed @click="reset">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title style="margin-left:20px">ออร์เดอร์ที่ {{ oneorder[0].order_id }}</v-toolbar-title>
          </v-toolbar>

          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" md="10" sm="11">
                  <div
                    style="border-left: 10px solid #5B48A2;padding:12px;background-color:#D4D7C4"
                  >
                    <p style="font-size:18px;margin:auto">
                      <v-icon v-if="oneorder[0].gender=='ชาย'">mdi-face-profile</v-icon>
                      <v-icon v-else>mdi-face-profile-woman</v-icon>ข้อมูลผู้ป่วย
                    </p>
                  </div>
                </v-col>
                <v-col cols="12" md="4" sm="7" xs="6">
                  <v-text-field
                    :value="oneorder[0].name + ' ' + oneorder[0].surname"
                    label="ชื่อ-นามสกุลผู้ป่วย"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="3" md="1" sm="2" xs="6">
                  <v-text-field :value="oneorder[0].gender" label="เพศ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="3" md="1" sm="2" xs="6">
                  <v-text-field :value="setDate2(oneorder[0].DOB)" label="อายุ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="6" md="4" sm="4" xs="6">
                  <v-text-field
                    :value="setDate3(oneorder[0].DOB)"
                    label="วัน/เดือน/ปีเกิด"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" md="5" sm="7" xs="6">
                  <v-text-field :value="oneorder[0].email" label="อีเมล" filled readonly></v-text-field>
                </v-col>
                <v-col cols="6" md="2" sm="4" xs="6">
                  <v-text-field :value="oneorder[0].telno" label="เบอร์โทรศัพท์" filled readonly></v-text-field>
                </v-col>

                <v-col cols="6" md="3" sm="4" xs="6">
                  <v-text-field
                    :value="setStatus(oneorder[0].status)"
                    label="สถานะ"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
              </v-row>

              <v-form ref="form" v-model="valid" style="border:1px">
                <v-row>
                  <v-col cols="12" md="10" sm="11">
                    <div
                      style="border-left: 10px solid #5B48A2;padding:12px;background-color:#D4D7C4"
                    >
                      <v-row>
                        <p style="font-size:18px;margin:auto">
                          <v-icon>mdi-pill</v-icon>ยาที่ต้องได้รับ
                        </p>
                        <v-spacer></v-spacer>
                        <v-btn
                          style="margin-right:15px"
                          color="#76C3AF"
                          :disabled="!checkbox"
                          @click="successItem"
                        >จัดยาเรียบร้อย</v-btn>
                      </v-row>
                    </div>
                  </v-col>
                  <v-col cols="12" sm="6" md="6">
                    <v-checkbox
                      v-for="item in oneorder"
                      :key="item.medicine_generic"
                      v-model="checkbox"
                      :rules="[v => !!v || 'คุณต้องเลือกยาที่จัดแล้วก่อน']"
                      required
                      color="#76C3AF"
                      :label="
                          setMed(
                            item.medicine_generic +
                              ';' +
                              item.strength+
                              ';' +
                              item.qty +
                              ';' +
                              item.unit
                          )
                        "
                    ></v-checkbox>
                  </v-col>
                </v-row>
              </v-form>
            </v-container>
          </v-card-text>
          <!-- table in pop-up page for see each of order detial -->
        </v-card>
      </v-dialog>

      <!-- data table -->
      <v-row style="font-size:25px;margin:10px">ออร์เดอร์ที่รอการจัดยา</v-row>
      <v-row style="font-size:20px;margin:10px">{{ date }}</v-row>

      <v-data-table
        :items="p_order"
        :items-per-page="10"
        :headers="headers"
        class="elevation-1"
        @click:row="selectItem"
      >
        <template v-slot:item.name="{ item }">
          <p style="text-align:left;margin:auto">{{ item.name }} {{ item.surname }}</p>
        </template>
        <template v-slot:item.due_date="{ item }">
          <p style="text-align:center;margin:auto">{{ setDate(item.due_date) }}</p>
        </template>
        <template v-slot:item.status="{ item }">
          <v-chip :color="getColor(item.status)">
            {{
            setStatus(item.status)
            }}
          </v-chip>
        </template>
      </v-data-table>
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
    date: "",
    headers: [
      {
        text: "HN",
        align: "center",
        value: "patient_HN_order",
        divider: true,
        sortable: true
      },
      {
        text: "ชื่อ-นามสกุลผู้ป่วย",
        align: "left",
        value: "name",
        divider: true
      },
      {
        text: "วันนัดรับยา",
        align: "center",
        value: "due_date",
        divider: true
      },
      { text: "สถานะ", align: "center", value: "status", divider: true }
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
    dialog: false,
    dialog_row: false,
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
    ]
  }),
  methods: {
    reset() {
      this.$refs.form.reset();
      this.dialog_row = false;
    },
    setMed: function(m) {
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
        }
        return med_show;
      }
    },

    setDate: function(d) {
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
        return due_date;
      } else return "";
    },
    setDate2: function(m) {
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
        return dob_date;
      } else return "";
    },
    setDate3: function(d) {
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
        return dob_date3;
      } else return "";
    },
    setStatus: function(s) {
      if (s === "prepare") {
        s = "รอจัดยา";
      }
      return s;
    },
    selectItem(item) {
      this.index = this.p_order.indexOf(item);
      axios
        .post("http://localhost:3000/api/ph_prepare/one_order", {
          order_id: this.p_order[this.index].order_id
        })
        .then(res => {
          this.oneorder = res.data;
        });
      this.dialog_row = true;
    },
    successItem() {
      var id = this.oneorder[0].order_id;
      if (this.$refs.form.validate()) {
        console.log("success order");
        axios
          .post("http://localhost:3000/api/ph_prepare/success_prepare", {
            order_id: id
          })
          .then(res => {
            this.p_order.splice(this.index, 1);
            this.reset();
          });
      }
    },
    getColor(status) {
      if (status == "prepare") return "#bdc3c7";
      else return "grey";
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
