<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>
    <v-content class="font main">
      <v-dialog
        v-model="dialog_row"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card class="font">
          <!-- tool-bar -->
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_row = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title
              >ออร์เดอร์ที่ {{ oneorder[0].order_id }}</v-toolbar-title
            >
            <!-- <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn dark text @click="successItem(item)">ผู้ป่วยรับยาเรียบร้อย</v-btn>
            </v-toolbar-items>-->
          </v-toolbar>
          <!-- tool-bar -->

          <v-card-title>
            <span class="headline"></span>
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
                  <v-text-field
                    :value="oneorder[0].gender"
                    label="เพศ"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="4">
                  <v-text-field
                    :value="setDate2(oneorder[0].DOB)"
                    label="อายุ"
                    filled
                    readonly
                  ></v-text-field>
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

              <v-row>
                <v-col cols="12">กรอกข้อมูลผู้ป่วย</v-col>
                <v-col>
                  <v-text-field
                    v-model="patient_selected.weight"
                    cols="12"
                    label="น้ำหนัก"
                    filled
                    clearable
                    required
                  ></v-text-field>
                </v-col>
                <v-col>
                  <v-text-field
                    v-model="patient_selected.height"
                    cols="12"
                    label="ส่วนสูง"
                    filled
                    clearable
                    required
                  ></v-text-field>
                </v-col>
                <v-col>
                  <v-text-field
                    v-model="patient_selected.pressure"
                    cols="12"
                    label="ความดัน"
                    filled
                    clearable
                    required
                  ></v-text-field>
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12">ยาที่ต้องได้รับ</v-col>
                <v-col cols="12">
                  <!-- <p>{{ selected }}</p> -->
                  <v-checkbox
                    v-model="selected"
                    color="success"
                    label="Enalapril maleate 20 mg จำนวน 90 เม็ด"
                    value="med1"
                  ></v-checkbox>
                </v-col>
                <v-row v-for="k in inputs.length" :key="k">
                  <v-col cols="8">
                    <v-select :items="lot_no" label="เลขรหัสสินค้า"></v-select>
                  </v-col>
                  <v-col cols="2">
                    <v-text-field label="จำนวน" solo clearable></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="2" md="2">
                    <v-icon
                      @click="remove(k)"
                      v-show="k || (!k && inputs.length > 1)"
                      >mdi-minus-circle</v-icon
                    >
                    <v-icon @click="add(k)" v-show="k == inputs.length"
                      >mdi-plus-circle</v-icon
                    >
                  </v-col>
                </v-row>
                <v-col cols="12">
                  <v-checkbox
                    v-model="selected"
                    color="success"
                    label="Metformin 500 mg จำนวน 90 เม็ด"
                    value="med2"
                  ></v-checkbox>
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn rounded color="success" dark @click="successItem(item)"
              >ผู้ป่วยรับยาเรียบร้อย</v-btn
            >
            <v-btn rounded color="red" dark @click="dialog_row = false"
              >ยกเลิกออร์เดอร์</v-btn
            >
            <v-btn rounded color="grey" dark @click="dialog_row = false"
              >ปิด</v-btn
            >
          </v-card-actions>
          <!-- table in pop-up page for see each of order detial -->
        </v-card>
      </v-dialog>


      <v-row style="font-size:25px;margin:10px">{{ date }}</v-row>
      <v-data-table
        v-model="selected"
        :items="r_order"
        :items-per-page="10"
        :headers="headers"
        sort-by="name"
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
              <td style="text-align:left">
                {{ item.name }} {{ item.surname }}
              </td>
              <td style="text-align:center">{{ setDate(item.due_date) }}</td>
              <td style="text-align:center">
                <v-chip :color="getColor(item.status)" dark>{{
                  setStatus(item.status)
                }}</v-chip>
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
  data: () => ({
    inputs: [0],
    dialog_wait: false,
    lot_no: ["lt23413", "da451274"],
    date: "",
    search: "",
    patient_selected:[],
    headers: [
      {
        text: "HN",
        align: "center"
      },
      { text: "ชื่อ-นามสกุลผู้ป่วย", align: "left" },
      { text: "วันนัดรับยา", align: "center" },
      { text: "สถานะ", align: "center" }
      // { text: 'Actions', value: 'action', sortable: false },
    ],
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
    click: false,
    dialog: false,
    dialog_row: false,
    dialog_record: false,
    selected: [],
    index: 0,
    r_order: [
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
  components: {
    Menubar
  },
  mounted() {
    axios
      .post("http://localhost:3000/api/user/getuserbyid", {
        staff_id: localStorage.getItem("staff_id")
      })
      .then(res => {
        this.pharmacy_id = res.data[0].pharmacy_id_pharmacist;
        axios
          .post("http://localhost:3000/api/ready_sell/ready_order", {
            pharmacy_id: this.pharmacy_id
          })
          .then(res => {
            this.r_order = res.data;
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
  },
  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "New Item" : "Edit Item";
    }
  },
  methods: {
    reset() {
      this.$refs.form.reset();
    },
    setStatus: function(s) {
      if (s === "ready") {
        s = "พร้อมจ่ายยา";
      }
      return s;
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
    add(index) {
      console.log("index=" + index);
      this.inputs.push(2);
    },
    remove(index) {
      this.inputs.splice(index, 1);
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
      this.index = this.r_order.indexOf(item);
      console.log("selected" + "this.index = " + this.index);
      // this.oneorder = item;
      axios
        .post("http://localhost:3000/api/ready_sell/one_order", {
          patient_HN_order: this.r_order[this.index].patient_HN_order
        })
        .then(res => {
          this.oneorder = res.data;
        });

      if (this.oneorder.status == "ready") {
        this.dialog_wait = true;
      } else {
        this.dialog_row = true;
      }
    },
    successItem(item) {
      console.log("success order");
      console.log(this.oneorder);
      if (this.oneorder.status == "รอการจัดยา") {
        this.oneorder.status = "พร้อมจ่ายยา";
      }
      this.dialog_row = false;
    },
    getColor(status) {
      if (status == "cancel") return "red";
      else if (status == "ready") return "orange";
      else return "grey";
    },

    editItem(item) {
      this.editedIndex = this.oneorder.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },
    deleteItem(item) {
      const index = this.oneorder.indexOf(item);
      confirm("Are you sure you want to delete this item?") &&
        this.oneorder.splice(index, 1);
    },
    close() {
      this.dialog = false;
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
