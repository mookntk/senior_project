<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>

    <v-content class="font main">
      <!-- dialog for sendback order -->
      <v-dialog
        v-model="dialog_sendback"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card class="font">
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_sendback = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title
              >ออร์เดอร์ที่ {{ oneorder[0].order_id }}</v-toolbar-title
            >
          </v-toolbar>

          <v-card-title>
            <span class="font"></span>
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
                <v-col cols="12" sm="8">
                  <v-select :items="note" label="หมายเหตุ" outlined></v-select>
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12">ยาที่ต้องได้รับ</v-col>
                <v-col cols="12">
                  <v-checkbox
                    v-for="item in oneorder"
                    :key="item.name"
                    row
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

                  <v-row v-for="k in inputs" :key="k">
                    <v-col cols="8">
                      <v-select
                        :items="lot_no"
                        label="เลขรหัสสินค้า"
                      ></v-select>
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
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              rounded
              large
              color="success"
              dark
              @click="sendback_confirm()"
              >ส่งยาคืนโรงพยาบาล</v-btn
            >

            <v-btn
              rounded
              large
              color="warning"
              dark
              @click="dialog_sendback = false"
              >ยกเลิก</v-btn
            >
          </v-card-actions>
          <!-- table in pop-up page for see each of order detial -->
        </v-card>
      </v-dialog>

      <!--  select button -->
      <v-layout>
        <v-flex d-flex xs12 sm6 md4>
          <v-layout column align-end justify-start>
            <v-btn
              width="200px"
              class="blue-grey lighten-3"
              value="all"
              @click="sortdata"
              >ออร์เดอร์ทั้งหมด</v-btn
            >
            <v-btn
              width="200px"
              class="green lighten-1"
              value="success"
              @click="sortdata"
              >ออร์เดอร์ที่สำเร็จแล้ว</v-btn
            >
            <v-btn
              width="200px"
              class="gray lighten-1"
              value="not_ready"
              @click="sortdata"
              >ออร์เดอร์ที่ไม่พร้อมจ่ายยา</v-btn
            >
            <v-btn
              width="200px"
              class="orange lighten-1"
              value="received_some"
              @click="sortdata"
              >ออร์เดอร์ที่คืนบางส่วน</v-btn
            >

            <v-btn
              width="200px"
              class="red lighten-1"
              value="cancel"
              @click="sortdata"
              >ออร์เดอร์ที่ต้องยกเลิก</v-btn
            >
          </v-layout>
        </v-flex>

        <v-flex class="pr-4">
          <!-- ! data table -->
          <v-card class="red" height="100%" width="1080px">
            <v-data-table
              :headers="headers"
              :items="order_filter"
              :search="search"
              sort-by="status"
              class="elevation-1"
            >
              <template v-slot:item.status="{ item }">
                <v-chip :color="getColor(item.status)" dark>{{
                  setStatus(item.status)
                }}</v-chip>
              </template>
              <template v-slot:top>
                <v-toolbar flat>
                  <v-spacer></v-spacer>
                  <v-text-field
                    v-model="search"
                    append-icon="mdi-magnify"
                    label="Search"
                    single-line
                    hide-details
                    clearable
                  ></v-text-field>
                </v-toolbar>
              </template>
              <template v-slot:body="{ items }">
                <tbody>
                  <tr v-for="item in items" :key="item.name">
                    <td style="text-align:center">
                      {{ item.patient_HN_order }}
                    </td>
                    <td style="text-align:left">{{ item.name }}</td>
                    <td style="text-align:left">{{ item.surname }}</td>
                    <td style="text-align:left">
                      {{ setDate(item.due_date) }}
                    </td>
                    <td style="text-align:left">
                      <v-chip :color="getColor(item.status)" dark
                        >{{ setStatus(item.status) }}
                      </v-chip>
                    </td>
                    <td style="text-align:left">
                      <v-btn
                        color="primary"
                        @click="getindex_cancel(item)"
                        v-if="
                          item.status == 'cancel' ||
                            item.status == 'received_some'
                        "
                        >ส่งยากลับ</v-btn
                      >
                    </td>
                  </tr>
                </tbody>
              </template>
            </v-data-table>
          </v-card>
        </v-flex>
      </v-layout>
    </v-content>
  </v-app>
</template>

<script>
import Menubar from "../../components/ph_menubar";
import axios from "axios";
export default {
  components: {
    Menubar
  },
  mounted() {
    var today = new Date();
    this.date_now = today;

    axios
      .post("http://localhost:3000/api/user/getuserbyid", {
        staff_id: localStorage.getItem("staff_id")
      })
      .then(res => {
        this.pharmacy_id = res.data[0].pharmacy_id_pharmacist;
        axios
          .post("http://localhost:3000/api/order_status/order_with_status", {
            pharmacy_id: this.pharmacy_id
          })
          .then(res => {
            this.s_order = res.data;
            this.initialize();
          });
      })
      .catch(e => {
        console.log(e);
      });
  },
  data: () => ({
    s_order: [
      {
        order_id: "",
        patient_HN_order: "",
        name: "",
        surname: "",
        status: "",
        due_date: ""
      }
    ],
    inputs: [0],
    lot_no: ["lt23413", "da451274"],
    date_now: "",
    search: "",
    dialog: false,
    dialog_sendback: false,
    headers: [
      {
        text: "HN",
        align: "left"
      },
      { text: "ชื่อ" },
      { text: "นามสกุล" },
      { text: "วันที่ต้องมารับยา" },
      { text: "สถานะ" },
      { text: " " }
      // ,
      // { text: "Actions", value: "action", sortable: false }
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
    order_filter: [],
    note: ["ผู้ป่วยไม่มารับ", "ยามีปัญหา", "ผู้ป่วยได้รับยาไปบางส่วน"],
    editedIndex: -1,
    editedItem: {
      name: "",
      calories: 0,
      fat: 0,
      status: 0
    },
    defaultItem: {
      name: "",
      calories: 0,
      fat: 0,
      status: 0
    },
    click: false,
    dialog: false,
    dialog_row: false,
    dialog_record: false,
    selected: [],
    index: 0
  }),
  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "New Item" : "Edit Item";
    }
  },
  watch: {
    dialog(val) {
      val || this.close();
    },
    dialogdetail(val) {
      val || this.close();
    }
  },
  // created() {
  //   this.initialize();
  // },
  methods: {
    setStatus: function(s) {
      if (s === "not_ready") {
        s = "ไม่พร้อมจ่ายยา";
      } else if (s === "received_some") {
        s = "คืนยาบางส่วน";
      } else if (s === "cancel") {
        s = "ยกเลิก";
      } else if (s === "success") {
        s = "สำเร็จแล้ว";
      }
      return s;
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
    dialogdetail: function(e) {
      alert(e.currentTarget);
    },
    logout: function() {
      localStorage.setItem("login", "false");
      console.log(localStorage.getItem("login"));
      this.$router.push("/");
    },
    sortdata: function(e) {
      console.log(e.currentTarget.value);

      if (e.currentTarget.value == "all") {
        this.order_filter = [...this.s_order];
      } else {
        this.order_filter = this.s_order.filter(item => {
          for (var i in item) {
            if (item.status == e.currentTarget.value) return true;
          }
        });
      }
    },
    getColor(status) {
      if (status == "cancel") return "red";
      else if (status == "received_some") return "orange";
      else if (status == "not_ready") return "light gray";
      else if (status == "success") return "green";
    },
    initialize() {
      this.order_filter = [...this.s_order];
    },
    selectItem(item) {
      var index = this.s_order.indexOf(item);

      if (this.s_order[index].status == "ready") {
        this.index = this.s_order;
        console.log(this.s_order[index]);
        this.s_order = item;
        this.dialog_row = true;
      }
    },
    successItem(item) {
      console.log("success order");
      console.log(this.s_order);
      if (this.s_order.status == "ready") {
        this.s_order.status = "success";
      }
      this.dialog_row = false;
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
        Object.assign(this.s_order[this.editedIndex], this.editedItem);
      } else {
        this.order.push(this.editedItem);
      }
      this.close();
    },
    getindex_cancel(item) {
      this.index = this.s_order.indexOf(item);
      console.log("selected" + "this.index = " + this.index);
      // this.oneorder = item;
      axios
        .post("http://localhost:3000/api/order_status/one_order", {
          patient_HN_order: this.s_order[this.index].patient_HN_order,
          order_id: this.s_order[this.index].order_id
        })
        .then(res => {
          this.oneorder = res.data;
        });

      this.dialog_sendback = true;
    },
    sendback_confirm() {
      confirm("คุณต้องการส่งยาออร์เดอร์นี้กลับใช่หรือไม่?") &&
        this.s_order.splice(this.index, 1);
      this.order_filter = [...this.s_order];
      this.dialog_sendback = false;
    }
  }
};
</script>
<style scoped>
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
