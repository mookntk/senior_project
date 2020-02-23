<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>
    <v-content class="font main">
      <v-dialog v-model="dialog_row" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font">
          <!-- tool-bar -->
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_row = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title>ออร์เดอร์ที่ {{ oneorder[0].order_id }}</v-toolbar-title>
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
              <v-form ref="form">
                <v-row>
                  <v-col cols="12">กรอกข้อมูลผู้ป่วย</v-col>
                  <v-col>
                    <v-text-field
                      v-model="patient_selected.weight"
                      cols="12"
                      label="น้ำหนัก"
                      filled
                      clearable
                      :rules="[v=>!!v||'กรุณากรอกข้อมูล',
                      v=>!isNaN(v)||'กรุณากรอกข้อมูลตัวเลข']"
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
                      :rules="[v=>!!v||'กรุณากรอกข้อมูล',
                      v=>!isNaN(v)||'กรุณากรอกข้อมูลตัวเลข']"
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
                      :rules="[v=>!!v||'กรุณากรอกข้อมูล']"
                    ></v-text-field>
                  </v-col>
                </v-row>
              </v-form>
              <v-row>
                <v-col cols="12">ยาที่ต้องได้รับ</v-col>
              </v-row>

              <v-list class="font">
                <template v-for="(i,index) in oneorder">
                  <v-list-item :key="i">
                    <v-list-item-content>
                      <v-checkbox
                        v-model="selected[index]"
                        color="success"
                        :label="i.medicine_generic+' '+i.strength+' '+i.qty+' '+i.unit"
                      ></v-checkbox>
                      <v-row>
                        <template v-for="(item,k) in textbox[index]">
                          <v-col cols="12" sm="2" md="2" :key="k">
                            <v-select
                              :items="lot_no[index]"
                              item-text="lot_no"
                              label="เลขรหัสสินค้า"
                              item-value="lot_no_id"
                              v-model="lot_med[index][k]"
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
                          <v-col cols="12" sm="2" md="2" :key="k">
                            <v-text-field
                              solo
                              clearable
                              label="จำนวนยา"
                              v-model="qty_med[index][k]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="12" sm="2" md="2" :key="k">
                            <v-icon
                              @click="remove(index,k)"
                              v-show="k>0 || ( !k && textbox[index].length > 1)"
                            >mdi-minus-circle</v-icon>
                            <v-icon
                              @click="add(index)"
                              v-show="k == textbox[index].length-1"
                            >mdi-plus-circle</v-icon>
                          </v-col>
                        </template>
                      </v-row>
                    </v-list-item-content>
                    <!-- </template> -->
                  </v-list-item>
                </template>
              </v-list>
              <!-- <v-row v-for="k in inputs.length" :key="k">
                  <v-col cols="4">
                    <v-select :items="lot_no[index]" item-text="lot_no" label="เลขรหัสสินค้า">
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
                  <v-col cols="3">
                    <v-text-field label="จำนวน" solo clearable></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="2" md="2">
                    <v-icon
                      @click="remove(k)"
                      v-show="k || (!k && inputs.length > 1)"
                    >mdi-minus-circle</v-row>
                    <v-icon @click="add(k)" v-show="k == inputs.length">mdi-plus-circle</v-icon>
                  </v-col>
              </v-row>-->

              <!-- </v-row> -->
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn rounded color="success" dark @click="successItem(item)">ผู้ป่วยรับยาเรียบร้อย</v-btn>
            <v-btn rounded color="red" dark @click="cancelItem(item)">ยกเลิกออร์เดอร์</v-btn>
            <v-btn rounded color="grey" dark @click="dialog_row = false">ปิด</v-btn>
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
    ],
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
            console.log("r_order");
            console.log(this.r_order);
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
      if (this.textbox[index].length < this.lot_no[index].length) {
        this.textbox[index].push("");
        this.lot_med[index].push("");
        this.qty_med[index].push("");
      }

      // this.inputs.push("");
    },
    remove(index, subindex) {
      this.textbox[index].splice(subindex, 1);
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
      console.log("selected" + "this.index = " + this.index);
      this.lot_no = [];
      // this.oneorder = item;
      axios
        .post("http://localhost:3000/api/ready_sell/one_order", {
          patient_HN_order: this.r_order[this.index].patient_HN_order
        })
        .then(res => {
          this.oneorder = res.data;
          this.selected = new Array(this.oneorder.length);
          this.selected.fill(false, 0);
          this.oneorder.forEach((item, index) => {
            this.textbox.push([""]);
            this.lot_med.push([""]);
            this.qty_med.push([""]);
          });
          this.oneorder.forEach((e, i) => {
            axios
              .post("http://localhost:3000/api/ready_sell/getlot", {
                pharmacy_id: this.pharmacy_id,
                medicine_id: this.oneorder[i].medicine_id
              })
              .then(res => {
                this.lot_no.push(res.data);
              });
          });
          // console.log(this.lot_no);
        });

      if (this.oneorder.status == "ready") {
        this.dialog_wait = true;
      } else {
        this.dialog_row = true;
      }
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
    cancelItem(item){
      // const index = this.oneorder.indexOf(item);
      confirm(
        "คุณต้องการที่จะยกเลิกออร์เดอร์ของคุณ "+ this.oneorder[0].name + ' ' + this.oneorder[0].surname +" ใช่หรือไม่?"
          
      ) &&
      axios
          .post("http://localhost:3000/api/record/cancel_order", {
            order_id: this.oneorder[0].order_id
          })
          .then(res => {
            console.log(res);
            this.refreshOfReadyTable();
            this.dialog_row = false;
          })
          .catch(e => {
            console.log(e);
          });
    },
    successItem(item) {
      if (this.$refs.form.validate() && this.checkpressure()) {
        console.log("successOrder");
        //axios new record
        axios
          .post("http://localhost:3000/api/record/newrecord", {
            weight: this.patient_selected.weight,
            height: this.patient_selected.height,
            pressure_di: this.getpressure(this.patient_selected.pressure, 1),
            pressure_sys: this.getpressure(this.patient_selected.pressure, 0),
            date: dateFormat(new Date(), "yyyy/mm/dd"),
            patient_HN_record: this.oneorder[0].patient_HN_order,
            pharmacy_id_record: this.pharmacy_id,
            order_id_record: this.oneorder[0].order_id
          })
          .then(res => {
            console.log(res);
          })
          .catch(e => {
            console.log(e);
          });
        //new orderlog
        axios
          .post("http://localhost:3000/api/log/newlog", {
            status: "success",
            start_date: dateFormat(new Date(), "yyyy/mm/dd"),
            staff_id_log: localStorage.getItem("staff_id"),
            order_id_log: this.oneorder[0].order_id
          })
          .catch(e => {
            console.log(e);
          });

        //edit lot qty_less
        this.lot_med.forEach((e, i) => {
          this.lot_med[i].forEach((item, j) => {
            var filter = this.lot_no[i].filter((filter, k) => {
              return this.lot_no[i][k].lot_no_id == this.lot_med[i][j];
            });

            console.log("object");
            //filter[0] = lot_no_id
            console.log(filter);
            if (filter.length > 0) {
              axios
                .post("http://localhost:3000/api/lot_transfer/editlot", {
                  lot_no_id: filter[0].lot_no_id,
                  qty_less: filter[0].qty_less - parseInt(this.qty_med[i][j])
                })
                .catch(e => {
                  console.log(e);
                });
            }
          });
        });

        //change status success
        var checkall = this.selected.every((e, i) => this.selected[i] == true);
        if (checkall) {
          console.log("yeah!!!");
          axios
            .post("http://localhost:3000/api/ready_sell/success", {
              status: "success",
              order_id: this.oneorder[0].order_id
              // staff_id_log: localStorage.getItem("staff_id"),
            })
            .then(res => {
              this.r_order.splice(this.index, 1);
            })
            .catch(e => {
              console.log(e);
            });
        }
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
        date.getDate() + " " + (date.getMonth() + 1) + " " + date.getFullYear();

      this.oneorder[0].receive_date = date_format;
        this.dialog_row = false;
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
  },
  watch: {
    lot_med() {
      console.log(this.lot_med);
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
