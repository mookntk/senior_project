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
                <v-col cols="12" md="12" sm="12">
                  <div
                    style="border-left: 10px solid #5B48A2;padding:12px;background-color:#D4D7C4"
                  >
                    <p style="font-size:18px;margin:auto">
                      <v-icon v-if="oneorder[0].gender=='ชาย'">mdi-face-profile</v-icon>
                      <v-icon v-else>mdi-face-profile-woman</v-icon>ข้อมูลผู้ป่วย
                    </p>
                  </div>
                </v-col>
                <v-col cols="12" md="4" sm="6">
                  <v-text-field
                    :value="oneorder[0].name + ' ' + oneorder[0].surname"
                    label="ชื่อ-นามสกุลผู้ป่วย"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="6" md="2" sm="3" xs="6">
                  <v-text-field :value="oneorder[0].gender" label="เพศ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="6" md="2" sm="3" xs="6">
                  <v-text-field :value="setDate2(oneorder[0].DOB)" label="อายุ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" md="4" sm="5" xs="6">
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
                <v-col cols="6" md="3" sm="3" xs="6">
                  <v-text-field :value="oneorder[0].telno" label="เบอร์โทรศัพท์" filled readonly></v-text-field>
                </v-col>
                <v-col cols="6" md="4" sm="4" xs="6">
                  <v-text-field
                    :value="setDate(oneorder[0].next_due_date)"
                    label="วันนัดครั้งถัดไป"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
              </v-row>
              <v-form ref="form">
                <v-row>
                  <v-col cols="12" md="12" sm="12">
                    <div
                      style="border-left: 10px solid #5B48A2;padding:12px;background-color:#D4D7C4"
                    >
                      <p style="font-size:18px;margin:auto">
                        <v-icon>mdi-clipboard-account</v-icon>กรอกข้อมูลผู้ป่วย
                      </p>
                    </div>
                  </v-col>
                  <v-col cols="12" sm="4" md="4">
                    <v-text-field
                      v-model="patient_selected.weight"
                      label="น้ำหนัก(kg)"
                      filled
                      clearable
                      :rules="[v=>!!v||'กรุณากรอกข้อมูล',
                      v=>!isNaN(v)||'กรุณากรอกข้อมูลตัวเลข']"
                      required
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="4" md="4">
                    <v-text-field
                      v-model="patient_selected.height"
                      label="ส่วนสูง(cm)"
                      filled
                      clearable
                      required
                      :rules="[v=>!!v||'กรุณากรอกข้อมูล',
                      v=>!isNaN(v)||'กรุณากรอกข้อมูลตัวเลข']"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="4" md="4">
                    <v-text-field
                      v-model="patient_selected.pressure"
                      label="ความดัน(mmHg)"
                      filled
                      clearable
                      required
                      :rules="[v=>!!v||'กรุณากรอกข้อมูล']"
                    ></v-text-field>
                  </v-col>
                </v-row>
              </v-form>
              <v-row>
                <v-col cols="12" md="12" sm="12">
                  <div
                    style="border-left: 10px solid #5B48A2;padding:12px;background-color:#D4D7C4"
                  >
                    <p style="font-size:18px;margin:auto">
                      <v-icon>mdi-pill</v-icon>ยาที่ได้รับ
                    </p>
                  </div>
                </v-col>
              </v-row>

              <v-list class="font">
                <template v-for="(i,index) in oneorder">
                  <v-list-item :key="i">
                    <v-list-item-content>
                      <v-checkbox
                        v-model="selected[index]"
                        color="#76C3AF"
                        :label="i.medicine_generic+' '+i.strength+' '+i.qty+' '+i.unit"
                        disabled
                      ></v-checkbox>
                      <v-row>
                        <template v-for="(item,k) in lot_med[index]">
                          <v-col cols="12" sm="5" md="2" :key="k">
                            <v-select
                              :items="lot_no[index]"
                              item-text="lot_no"
                              label="เลขรหัสสินค้า"
                              v-model="lot_med[index][k]"
                              @change="checkSameLot(index,k)"
                              return-object
                            >
                              <template v-slot:item="data">
                                <template v-if="typeof data.item !== 'object'">
                                  <v-list-item-content v-text="data.item"></v-list-item-content>
                                </template>
                                <template v-else>
                                  <v-list-item-content>
                                    <v-list-item-title
                                      class="font"
                                    >{{ data.item.lot_no }} (เหลือ: {{ data.item.qty_less }})</v-list-item-title>
                                  </v-list-item-content>
                                </template>
                              </template>
                            </v-select>
                          </v-col>
                          <v-col cols="12" sm="4" md="2" :key="k">
                            <v-text-field
                              solo
                              clearable
                              label="จำนวนยา"
                              v-model="qty_med[index][k]"
                              @input="checkLotQty(index,k)"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="12" sm="3" md="2" :key="k">
                            <v-icon
                              @click="remove(index,k)"
                              v-show="k>0 || ( !k && qty_med[index].length > 1)"
                            >mdi-minus-circle</v-icon>
                            <v-icon
                              @click="add(index)"
                              v-show="k == qty_med[index].length-1"
                            >mdi-plus-circle</v-icon>
                          </v-col>
                        </template>
                      </v-row>
                    </v-list-item-content>
                    <!-- </template> -->
                  </v-list-item>
                </template>
              </v-list>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="#76C3AF" @click="successItem(item)" large>ผู้ป่วยรับยาเรียบร้อย</v-btn>
            <v-btn color="#C85D5C" @click="cancelItem(item)" large>ยกเลิกออร์เดอร์</v-btn>
            <v-btn color="#bdc3c7" @click="reset" large>ปิด</v-btn>
          </v-card-actions>
          <!-- table in pop-up page for see each of order detial -->
        </v-card>
      </v-dialog>

      <v-row style="font-size:25px;margin:10px">ออร์เดอร์ที่พร้อมจ่ายยา</v-row>
      <v-data-table
        :items="r_order"
        :items-per-page="10"
        :headers="headers"
        class="elevation-1"
        @click:row="selectItem"
      >
        <template v-slot:item.name="{item}">{{item.name}} {{item.surname}}</template>
        <template v-slot:item.due_date="{item}">{{setDate(item.due_date)}}</template>
        <template v-slot:item.telno="{item}">{{setTelno(item.telno)}}</template>
        <template v-slot:item.status>
          <v-chip color="#E1995E">พร้อมจ่ายยา</v-chip>
        </template>
        <template v-slot:no-data>ไม่มีออร์เดอร์ที่พร้อมจ่ายยา</template>
      </v-data-table>
    </v-content>
  </v-app>
</template>

<script>
import axios from "axios";
import Menubar from "../../components/ph_menubar";
import dateFormat from "dateformat";
export default {
  data: () => ({
    dialog_wait: false,
    lot_no: [],
    date: "",
    search: "",
    patient_selected: {},
    headers: [
      {
        text: "HN",
        align: "center",
        value: "patient_HN_order",
        divider: true
      },
      {
        text: "ชื่อ-นามสกุลผู้ป่วย",
        align: "left",
        value: "name",
        divider: true
      },
      {
        text: "เบอร์โทรศัพท์",
        align: "center",
        value: "telno",
        divider: true
      },
      {
        text: "อีเมล",
        align: "center",
        value: "email",
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
    r_order: [],
    textbox: [],
    pharmacy_id: null,
    lot_med: [],
    qty_med: []
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
  methods: {
    checkSameLot(index, k) {
      for (var i = 0; i < this.lot_med[index].length; i++) {
        if (i != k) {
          if (this.lot_med[index][k] == this.lot_med[index][i]) {
            alert("ใช้รหัสสินค้าซ้ำ");
            this.lot_med[index].splice(k, 1);
            this.qty_med[index].splice(k, 1);
          }
        }
      }
    },
    checkLotQty(index, k) {
      if (isNaN(this.qty_med[index][k])) {
        alert("กรอกเฉพาะตัวเลข");
        this.qty_med[index][k] = "";
      }
      if (this.lot_med[index][k] != null) {
        var qty = 0;
        if (this.qty_med[index][k] > this.lot_med[index][k].qty_less) {
          alert("รหัสสินค้านี้ยาไม่พอ");
          this.qty_med[index][k] = "";
        }
        this.qty_med[index].forEach((item, i) => {
          qty += parseInt(this.qty_med[index][i]);
        });
        if (qty > this.oneorder[index].qty) {
          alert("กรอกยาเกินจำนวนที่ได้รับ");
          this.qty_med[index][k] = "";
        } else if (qty == this.oneorder[index].qty) {
          this.selected[index] = true;
        } else if (qty < this.oneorder[index].qty) {
          this.selected[index] = false;
        }
        if (this.lot_med[index][k].qty < this.qty_med[index][k]) {
          alert("กรอกจำนวนยาเกินในล็อตนี้");
          this.qty_med[index][k] = "";
        }
      } else {
        alert("กรุณาเลือกรหัสสินค้าก่อน");
        this.qty_med[index][k] = "";
      }
    },
    setTelno(telno) {
      var str = [];
      for (var i = 0; i < telno.length; i++) {
        str.push(telno[i]);
        if (i == 2 || i == 5) {
          str.push("-");
        }
      }
      return str.join("");
    },
    reset() {
      this.$refs.form.reset();
      this.dialog_row = false;
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
    // setMed: function(m) {
    //   console.log("เข้าsetMed");
    //   console.log("m= " + m);
    //   if (m != null) {
    //     var med_detail = m.split(";");
    //     var med_name = med_detail[0];
    //     var med_name2 = med_name.split(",");
    //     var med_strenght = med_detail[1];
    //     var med_strenght2 = med_strenght.split(",");
    //     var med_qty = med_detail[2];
    //     var med_qty2 = med_qty.split(",");
    //     var med_unit = med_detail[3];
    //     var med_unit2 = med_unit.split(",");

    //     var med_show = "";
    //     for (var i = 0; i < med_name2.length; i++) {
    //       if (i === med_name2.length - 1) {
    //         med_show +=
    //           med_name2[i] +
    //           " " +
    //           med_strenght2[i] +
    //           " " +
    //           med_qty2[i] +
    //           " " +
    //           med_unit2[i];
    //       } else {
    //         med_show +=
    //           med_name2[i] +
    //           " " +
    //           med_strenght2[i] +
    //           " " +
    //           med_qty2[i] +
    //           " " +
    //           med_unit2[i] +
    //           "/";
    //       }
    //       console.log("med_show = " + med_show);
    //     }
    //     return med_show;
    //   }
    // },
    add(index) {
      console.log("index=" + index);
      if (this.lot_med[index].length < this.lot_no[index].length) {
        // this.textbox[index].push("");
        this.lot_med[index].push("");
        this.qty_med[index].push("");
      }

      // this.inputs.push("");
    },
    remove(index, subindex) {
      this.lot_med[index].splice(subindex, 1);
      this.qty_med[index].splice(subindex, 1);
    },
    // dialog: function(e) {
    //   alert(e.currentTarget);
    // },
    // logout: function() {
    //   localStorage.setItem("login", "false");
    //   console.log(localStorage.getItem("login"));
    //   this.$router.push("/");
    // },
    selectItem(item) {
      this.index = this.r_order.indexOf(item);
      this.lot_no = [];
      this.textbox = [];
      this.lot_med = [];
      this.qty_med = [];
      // patient_selected = {};
      // this.oneorder = item;
      axios
        .post("http://localhost:3000/api/ready_sell/one_order", {
          order_id: this.r_order[this.index].order_id
        })
        .then(res => {
          this.oneorder = res.data;
          this.selected = new Array(this.oneorder.length);
          this.selected.fill(false, 0);
          this.oneorder.forEach((item, index) => {
            this.textbox.push([null]);
            this.lot_med.push([null]);
            this.qty_med.push([null]);
          });
          this.oneorder.forEach((e, i) => {
            axios
              .post("http://localhost:3000/api/ready_sell/getlot", {
                pharmacy_id: this.pharmacy_id,
                medicine_id: this.oneorder[i].medicine_id
              })
              .then(res => {
                this.lot_no.push(res.data);
                this.dialog_row = true;
              });
          });
        });
    },
    refreshOfReadyTable() {
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
              console.log("r_order");
              console.log(this.r_order);
            });
        })
        .catch(e => {
          console.log(e);
        });
    },
    cancelItem(item) {
      // const index = this.oneorder.indexOf(item);
      confirm(
        "คุณต้องการที่จะยกเลิกออร์เดอร์ของคุณ " +
          this.oneorder[0].name +
          " " +
          this.oneorder[0].surname +
          " ใช่หรือไม่?"
      ) &&
        axios
          .post("http://localhost:3000/api/record/cancel_order", {
            order_id: this.oneorder[0].order_id
          })
          .then(res => {
            this.oneorder.forEach((onemed, m) => {
              axios
                .post("http://localhost:3000/api/ready_sell/editreceived", {
                  medicine_id: onemed.medicine_id,
                  order_id: this.oneorder[0].order_id,
                  received: "false"
                })
                .then(res => {
                  this.refreshOfReadyTable();
                  this.dialog_row = false;
                  this.$refs.form.reset();
                });
            });
          })
          .catch(e => {
            console.log(e);
          });
    },
    successItem(item) {
      var onecheck = this.selected.find(element => element == true);
      if (onecheck) {
        if (this.$refs.form.validate() && this.checkpressure()) {
          console.log("successOrder");
          //axios new record
          console.log({
            weight: this.patient_selected.weight,
            height: this.patient_selected.height,
            pressure_di: this.getpressure(this.patient_selected.pressure, 1),
            pressure_sys: this.getpressure(this.patient_selected.pressure, 0),
            date: dateFormat(new Date(), "yyyy/mm/dd"),
            patient_HN_record: this.oneorder[0].patient_HN_order,
            pharmacy_id_record: this.pharmacy_id,
            order_id_record: this.oneorder[0].order_id
          });
          axios
            .post("http://localhost:3000/api/record/newrecord", {
              weight: this.patient_selected.weight,
              height: this.patient_selected.height,
              pressure_di: this.getpressure(this.patient_selected.pressure, 1),
              pressure_sys: this.getpressure(this.patient_selected.pressure, 0),
              date: dateFormat(new Date(), "yyyy/mm/dd"),
              patient_HN_record: this.oneorder[0].patient_HN_order,
              pharmacy_id_record: this.pharmacy_id,
              order_id_record: this.oneorder[0].order_id,
              staff_id_record: localStorage.getItem("staff_id")
            })
            .then(res => {
              console.log(res);
            })
            .catch(e => {
              console.log(e);
            });
          //new orderlog
          // axios
          //   .post("http://localhost:3000/api/log/newlog", {
          //     status: "success",
          //     start_date: dateFormat(new Date(), "yyyy/mm/dd"),
          //     staff_id_log: localStorage.getItem("staff_id"),
          //     order_id_log: this.oneorder[0].order_id
          //   })
          //   .catch(e => {
          //     console.log(e);
          //   });
          this.lot_med.forEach((element, i) => {
            if (element != null && element != "") {
              this.lot_med[i].forEach((element2, j) => {
                if (
                  element2 != null &&
                  element2 != "" &&
                  this.qty_med[i][j] != null &&
                  this.qty_med[i][j] != ""
                ) {
                  console.log({
                    lot_no_id: element2.lot_no_id,
                    qty_less: element2.qty_less - parseInt(this.qty_med[i][j])
                  });
                  axios
                    .post("http://localhost:3000/api/lot_transfer/editlot", {
                      lot_no_id: element2.lot_no_id,
                      qty_less:
                        element2.qty_less - (parseInt(this.qty_med[i][j]) || 0)
                    })
                    .then(res => {
                      this.$refs.form.reset();
                    })
                    .catch(e => {
                      console.log(e);
                    });
                  // });
                  console.log("lot_order");
                  console.log({
                    lot_no: element2.lot_no,
                    lot_qty: this.qty_med[i][j],
                    order_id: this.oneorder[0].order_id,
                    medicine_id: element2.medicine_id,
                    lot_transfer_id: element2.lot_no_id
                  });
                  axios.post("http://localhost:3000/api/lot_order/newlot", {
                    lot_no: element2.lot_no,
                    lot_qty: this.qty_med[i][j],
                    order_id: this.oneorder[0].order_id,
                    medicine_id: element2.medicine_id,
                    lot_transfer_id: element2.lot_no_id
                  });
                }
              });
            }
          });
          //change status success
          var checkall = this.selected.every(
            (e, i) => this.selected[i] == true
          );
          if (checkall) {
            console.log({
              // status: "success",
              order_id: this.oneorder[0].order_id,
              remark: "รับยาครบ"
              // staff_id_log: localStorage.getItem("staff_id"),
            });
            axios
              .post("http://localhost:3000/api/ready_sell/success", {
                order_id: this.oneorder[0].order_id,
                remark: "รับยาครบ"
              })
              .then(res => {
                this.r_order.splice(this.index, 1);
              })
              .catch(e => {
                console.log(e);
              });
          } else {
            //partial
            console.log({
              order_id: this.oneorder[0].order_id,
              remark: "รับยาไม่ครบ"
            });
            axios
              .post("http://localhost:3000/api/ready_sell/success", {
                order_id: this.oneorder[0].order_id,
                remark: "รับยาบางส่วน"
              })
              .then(res => {
                this.r_order.splice(this.index, 1);
              })
              .catch(e => {
                console.log(e);
              });
          }

          //order detail received == true
          this.oneorder.forEach((onemed, m) => {
            console.log("detail");
            console.log({
              medicine_id: onemed.medicine_id,
              order_id: this.oneorder[0].order_id,
              received: this.selected[m] || false
            });
            axios.post("http://localhost:3000/api/ready_sell/editreceived", {
              medicine_id: onemed.medicine_id,
              order_id: this.oneorder[0].order_id,
              received: this.selected[m] || false
            });
          });
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
            date.getDate() +
            " " +
            (date.getMonth() + 1) +
            " " +
            date.getFullYear();

          this.oneorder[0].receive_date = date_format;
          this.dialog_row = false;
        }
      } else {
        alert("กรอกข้อมูลยาไม่ครบ");
      }
    },
    getpressure(pressure, i) {
      const splitpressure = pressure.split("/");
      return splitpressure[i];
    },
    checkpressure() {
      if (this.patient_selected.pressure.search("/") > -1) {
        const [sys, di] = this.patient_selected.pressure.split("/");
        if (parseInt(sys) > parseInt(di)) {
          return true;
        } else {
          alert("กรุณากรอกค่าความดันโลหิตตามค่าบน/ค่าล่าง");
          return false;
        }
      } else {
        alert("กรุณากรอกข้อมูลความดันให้ถูกต้อง");
        return false;
      }
    },

    getColor(status) {
      if (status == "cancel") return "red";
      else if (status == "ready") return "orange";
      else return "grey";
    },
    close() {
      this.dialog = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
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
