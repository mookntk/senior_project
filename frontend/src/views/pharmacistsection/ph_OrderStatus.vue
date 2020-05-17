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
          <v-toolbar color="#77B3D5">
            <v-btn color="#C85D5C" fab small depressed @click="dialog_sendback = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title style="margin-left:20px">ออร์เดอร์ที่ {{ oneorder[0].order_id }}</v-toolbar-title>
          </v-toolbar>

          <v-form ref="form">
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
                  <v-col cols="12" sm="6" md="4">
                    <v-select
                      :items="note"
                      label="หมายเหตุ"
                      v-model="remark"
                      :rules="[v => !!v || 'กรุณากรอกข้อมูล']"
                      required
                      outlined
                    ></v-select>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="other"
                      :disabled="remark!='อื่นๆ'"
                      v-if="remark=='อื่นๆ'"
                    ></v-text-field>
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
                            <v-col cols="12" sm="5" md="3" :key="k">
                              <v-select
                                :items="lot_no[index]"
                                item-text="lot_no"
                                label="เลขรหัสสินค้า"
                                v-model="lot_med[index][k]"
                                @change="checkSameLot(index,k)"
                                :rules="[v=>!!v||'กรุณากรอกข้อมูล']"
                                required
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
                                label="จำนวนยา"
                                v-model="qty_med[index][k]"
                                @input="checkLotQty(index,k)"
                                :rules="[v=>!!v||'กรุณากรอกข้อมูล',
                                v=>!isNaN(v)||'กรอกเป็นตัวเลข']"
                                required
                              ></v-text-field>
                            </v-col>
                            <v-col cols="12" sm="3" md="1" :key="k">
                              <v-icon @click="remove(index,k)">mdi-minus-circle</v-icon>
                              <v-icon @click="add(index)">mdi-plus-circle</v-icon>
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
              <v-btn large color="#76C3AF" @click="sendback_confirm()">ส่งยาคืนโรงพยาบาล</v-btn>

              <v-btn large color="#C85D5C" @click="closeDialog">ยกเลิก</v-btn>
            </v-card-actions>
          </v-form>
          <!-- table in pop-up page for see each of order detial -->
        </v-card>
      </v-dialog>

      <!--  select button -->
      <v-layout>
        <v-flex d-flex xs12 sm2 md2>
          <v-layout column align-end justify-start>
            <v-btn width="200px" color="#bdc3c7" value="all" @click="filterorder('all')">ทั้งหมด</v-btn>
            <v-btn
              width="200px"
              color="#76C3AF"
              value="success"
              @click="filterorder('success')"
            >สำเร็จแล้ว</v-btn>
            <v-btn
              width="200px"
              class="#DFE4DE"
              value="missing"
              @click="filterorder('missing')"
            >ไม่พร้อมจ่ายยา</v-btn>
            <v-btn
              width="200px"
              color="#E1995E"
              value="partial"
              @click="filterorder('partial')"
            >รับยาบางส่วน</v-btn>

            <v-btn
              width="200px"
              color="#C85D5C"
              value="cancel"
              @click="filterorder('cancel')"
            >ยกเลิก</v-btn>
          </v-layout>
        </v-flex>

        <v-flex class="pr-4">
          <!-- ! data table -->
          <v-card class="red" height="100%" width="1080px">
            <v-data-table
              :headers="headers"
              :items="filterOrders"
              :search="search"
              class="elevation-1"
              sort-by="return_id"
            >
              <template v-slot:top>
                <v-toolbar flat>
                  <v-spacer></v-spacer>
                  <v-text-field
                    v-model="search"
                    append-icon="mdi-magnify"
                    label="ค้นหา"
                    single-line
                    hide-details
                    clearable
                  ></v-text-field>
                </v-toolbar>
              </template>
              <template v-slot:no-data>ไม่มีข้อมูลออร์เดอร์</template>
              <template v-slot:item.status="{item}">
                <v-chip
                  :color="getColor(item.status,item.remark)"
                >{{ setStatus(item.status,item.remark) }}</v-chip>
              </template>
              <template v-slot:item.due_date="{item}">{{setDate(item.due_date) }}</template>
              <template v-slot:item.return_id="{item}">
                <v-btn
                  color="#76C3AF"
                  @click="getindex_cancel(item)"
                  v-if="
                          item.status == 'cancel' ||(
                            item.status == 'success'&&item.remark=='รับยาบางส่วน')
                        "
                  :disabled="item.return_id!=null"
                >ส่งยากลับ</v-btn>
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
import dateFormat from "dateformat";
export default {
  data: () => ({
    s_order: [],
    inputs: [0],
    lot_no: ["lt23413", "da451274"],
    date_now: "",
    search: "",
    dialog: false,
    dialog_sendback: false,
    headers: [
      {
        text: "HN",
        align: "left",
        value: "patient_HN_order",
        divider: true
      },
      { text: "ชื่อ", align: "center", value: "name", divider: true },
      { text: "นามสกุล", align: "center", value: "surname", divider: true },
      {
        text: "วันที่ต้องมารับยา",
        align: "center",
        value: "due_date",
        divider: true
      },
      { text: "สถานะ", align: "center", value: "status", divider: true },
      {
        text: " ",
        align: "center",
        value: "return_id",
        divider: true
      }
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
    note: ["ผู้ป่วยไม่มารับ", "ยามีปัญหา", "รับยาบางส่วน", "อื่นๆ"],
    remark: null,
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
    index: 0,
    textbox: [],
    pharmacy_id: null,
    lot_med: [],
    qty_med: [],
    lot_no: [],
    numberrules: [
      v => !!v || "กรุณากรอกข้อมูล",
      v => !isNaN(v) || "กรุณากรอกข้อมูลตัวเลข"
    ],
    filters: {
      status: [],
      remark: []
    },
    other: null
  }),
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
          });
      })
      .catch(e => {
        console.log(e);
      });
  },
  methods: {
    closeDialog() {
      // this.$refs.form.reset();
      this.dialog_sendback = false;
    },
    filterorder(item) {
      this.filters = {
        status: [],
        remark: []
      };
      if (item != "all") {
        this.filters = {
          status: [item],
          remark: []
        };
        if (item == "partial") {
          this.filters = {
            status: ["success"],
            remark: ["รับยาบางส่วน"]
          };
        }
        if (item == "success") {
          this.filters = {
            status: [item],
            remark: ["รับยาครบ"]
          };
        }
      }
    },
    setStatus: function(s, r) {
      if (s === "missing") {
        s = "ไม่พร้อมจ่ายยา";
      } else if (s === "success" && r == "รับยาบางส่วน") {
        s = "รับยาบางส่วน";
      } else if (s === "cancel") {
        s = "ยกเลิก";
      } else if (s === "success") {
        s = "สำเร็จ";
      }
      return s;
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
      if (this.lot_med[index].length < this.lot_no[index].length) {
        this.lot_med[index].push("");
        this.qty_med[index].push("");
      }
    },
    remove(index, subindex) {
      this.lot_med[index].splice(subindex, 1);
      this.qty_med[index].splice(subindex, 1);
    },
    getColor(status, remark) {
      if (status == "cancel") return "#C85D5C";
      else if (status == "success" && remark == "รับยาบางส่วน")
        return "#E1995E";
      else if (status == "missing") return "#DFE4DE";
      else if (status == "success") return "#76C3AF";
    },
    getindex_cancel(item) {
      this.index = this.s_order.indexOf(item);
      this.lot_no = [];
      this.remark = null;
      this.lot_med = [];
      this.qty_med = [];
      // this.oneorder = item;
      axios
        .post("http://localhost:3000/api/order_status/one_order", {
          patient_HN_order: this.s_order[this.index].patient_HN_order,
          order_id: this.s_order[this.index].order_id
        })
        .then(res => {
          this.oneorder = res.data;
          this.selected = new Array(this.oneorder.length);
          this.selected.fill(false, 0);
          this.oneorder.forEach((item, index) => {
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
                console.log(res.data);
                this.lot_no.push(res.data);
              });
          });
        });
      this.dialog_sendback = true;
    },
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
    sendback_confirm() {
      //validate form && amount of med is complete
      if (this.$refs.form.validate()) {
        if (this.selected.every(item => item == true)) {
          if (this.remark == "อื่นๆ") {
            this.remark = this.other;
          }
          // confirm("คุณต้องการส่งยาออร์เดอร์นี้กลับใช่หรือไม่?") &&
          axios
            .post("http://localhost:3000/api/user/getuserbyid", {
              staff_id: localStorage.getItem("staff_id"),
              user_type: "pharmacist"
            })
            .then(pharmacy_id => {
              axios
                .post("http://localhost:3000/api/return/getwaitingreturn", {
                  pharmacy_id: pharmacy_id.data[0].pharmacy_id_pharmacist
                })
                .then(res => {
                  if (res.data.length == 0) {
                    //!create new orders_return(not exist)
                    console.log("new return_id");
                    axios
                      .post("http://localhost:3000/api/return/newreturn", {
                        status: "waiting-return",
                        pharmacy_id_return:
                          pharmacy_id.data[0].pharmacy_id_pharmacist
                      })
                      .then(res => {
                        var return_id = res.data.insertId;
                        //!edit order's remark , return_id

                        axios
                          .post(
                            "http://localhost:3000/api/return/editorderreturnid",
                            {
                              remark: this.remark,
                              order_id: this.oneorder[0].order_id,
                              return_id: return_id
                            }
                          )
                          .then(res => {
                            console.log("edit success");
                          })
                          .catch(e => {
                            console.log(e);
                          });
                      })
                      .catch(e => {
                        console.log(e);
                      });
                  } else {
                    //!return_id has exist
                    //!edit order's remark , return_id
                    console.log({
                      remark: this.remark,
                      order_id: this.oneorder[0].order_id,
                      return_id: res.data[0].return_id
                    });
                    axios
                      .post(
                        "http://localhost:3000/api/return/editorderreturnid",
                        {
                          remark: this.remark,
                          order_id: this.oneorder[0].order_id,
                          return_id: res.data[0].return_id
                        }
                      )
                      .then(res => {
                        console.log("edit success");
                      })
                      .catch(e => {
                        console.log(e);
                      });
                  }
                  var today = new Date();
                  this.date_now = today;

                  axios
                    .post("http://localhost:3000/api/user/getuserbyid", {
                      staff_id: localStorage.getItem("staff_id")
                    })
                    .then(res => {
                      this.pharmacy_id = res.data[0].pharmacy_id_pharmacist;

                      axios
                        .post(
                          "http://localhost:3000/api/order_status/order_with_status",
                          {
                            pharmacy_id: this.pharmacy_id
                          }
                        )
                        .then(res => {
                          this.s_order = res.data;
                        });
                    })
                    .catch(e => {
                      console.log(e);
                    });
                });

              //edit lot qty_less
              // this.lot_med.forEach((e, i) => {
              //   this.lot_med[i].forEach((item, j) => {
              //     var filter = this.lot_no[i].filter((filter, k) => {
              //       return (
              //         this.lot_no[i][k].lot_no_id ==
              //         this.lot_med[i][j].lot_no_id
              //       );
              //     });

              //     if (filter.length > 0) {
              //       axios
              //         .post("http://localhost:3000/api/lot_transfer/editlot", {
              //           lot_no_id: filter[0].lot_no_id,
              //           qty_less:
              //             filter[0].qty_less - parseInt(this.qty_med[i][j])
              //         })
              //         .catch(e => {
              //           console.log(e);
              //         });
              //     }
              //   });
              // });
              this.lot_med.forEach((element, i) => {
                this.lot_med[i].forEach((element2, j) => {
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
                });
              });
            })
            .catch(e => {
              console.log(e);
            });

          // this.s_order.splice(this.index, 1);

          this.dialog_sendback = false;
        } else {
          alert("จำนวนยาไม่ครบ");
        }
      } else {
        // alert("กรุณากรอกข้อมูลให้ครบถ้วน")
      }
    }
  },
  computed: {
    filterOrders() {
      return this.s_order.filter(d => {
        return Object.keys(this.filters).every(f => {
          return this.filters[f].length < 1 || this.filters[f].includes(d[f]);
        });
      });
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
