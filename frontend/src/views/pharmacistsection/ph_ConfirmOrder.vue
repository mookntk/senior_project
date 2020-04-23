<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>

    <v-content class="main font">
      <v-dialog v-model="dialog_all" persistent max-width="500">
        <v-form ref="form">
          <v-card class="font">
            <v-card-title style="background-color:#f5ce88">ยาที่ได้รับทั้งหมด</v-card-title>
            <v-card-text>
              <div style="margin-top:10px">
                <p style="font-size:12px">
                  *กรุณา
                  <v-icon color="#76C3AF" small>mdi-checkbox-marked</v-icon>เมื่อยาที่ได้รับครบตามจำนวน หากไม่ครบกรุณากรอกจำนวนยาที่ได้รับ
                </p>
              </div>
              <v-list v-for="(item,i) in medicineAll" :key="item.medicine_id">
                <v-list-item>
                  <v-row>
                    <v-col cols="1">
                      <v-checkbox color="#76C3AF" v-model="cb_all[i]" @change="checkBoxMedAll(i)"></v-checkbox>
                    </v-col>
                    <v-col cols="6">
                      <p
                        style="padding-top:17px"
                      >{{item.medicine_generic}} {{item.strength}} {{item.qty}} {{item.unit}}</p>
                    </v-col>
                    <v-col cols="5">
                      <v-text-field
                        solo
                        label="จำนวนยาที่ได้รับ"
                        v-model="medall_txt[i]"
                        @input="checkQtyAll(i)"
                        required
                        :rules="[v=>!!v||'กรุณากรอกข้อมูล',v => !isNaN(v) || 'กรุณากรอกข้อมูลตัวเลข']"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-list-item>
              </v-list>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="green darken-1" text @click="confirmAll">ยืนยันการตรวจยา</v-btn>
              <v-btn color="green darken-1" text @click="resetDialog">ปิด</v-btn>
            </v-card-actions>
          </v-card>
        </v-form>
      </v-dialog>

      <v-dialog
        v-model="dialog_missing"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card class="font" style="background-color:#f5f7f5">
          <v-toolbar color="#77B3D5">
            <v-btn
              fab
              small
              depressed
              @click="dialog_missing = false"
              @mouseover="tooltips=true"
              @mouseleave="tooltips=false"
            >
              <v-icon>mdi-arrow-left-thick</v-icon>
            </v-btn>
            <v-tooltip bottom v-model="tooltips">
              <span class="font" style="font-size:12px">กลับไปยังหน้ายาที่ได้รับทั้งหมด</span>
            </v-tooltip>
            <v-spacer></v-spacer>
            <v-btn color="#f5ce88" large @click="confirmMissing">บันทึก</v-btn>
          </v-toolbar>
          <v-card-text>
            <v-form ref="form2">
              <v-row style="margin:10px">
                <v-col cols="12">
                  <div
                    style="border-left: 10px solid #5B48A2;padding:12px;background-color:#D4D7C4"
                  >
                    <p style="font-size:18px;margin:auto">ข้อมูลยาที่ขาด</p>
                  </div>
                </v-col>
                <v-col style="margin-left:10px">
                  <v-list style="background-color:#f5f7f5">
                    <p style="font-size:16px;margin:0">จำนวนยาที่ได้รับ</p>
                    <p style="font-size:11px;margin:0;color:red">*เลือกรหัสสินค้าและจำนวนยาที่ได้รับ</p>
                    <v-list-item v-for="(element,i) in missing_medinfo" :key="element.medicine_id">
                      <v-list-item-content>
                        <!-- <v-col cols="3"> -->
                        <v-row color="orange" style="margin-left:5px">
                          <v-checkbox disabled v-model="cb_missing[i]"></v-checkbox>
                          <p
                            style="padding-top:17px"
                          >{{element.medicine_generic}} {{element.strength}} {{element.qty}} {{element.unit}}</p>
                        </v-row>
                        <!-- </v-col> -->
                        <v-row v-for="(item,k) in lot_notxt[i]" :key="element.medicine_id*k">
                          <v-col cols="12" sm="5" md="2">
                            <v-select
                              :items="lot_no[i]"
                              item-text="lot_no"
                              label="เลขรหัสสินค้า"
                              v-model="lot_notxt[i][k]"
                              @change="checksameLot(i,k)"
                              :rules="[v=>!!v||'กรุณากรอกข้อมูล']"
                              required
                              return-object
                            ></v-select>
                          </v-col>
                          <v-col cols="8" sm="4" md="2">
                            <v-text-field
                              solo
                              label="จำนวนยา"
                              v-model="lot_qtytxt[i][k]"
                              @input="checkLotQty(i,k)"
                              :rules="[v=>!!v||'กรุณากรอกข้อมูล',
                              v=>!isNaN(v)||'กรอกเป็นตัวเลข']"
                              required
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4" sm="3" md="2">
                            <v-icon @click="remove(i,k)">mdi-minus-circle</v-icon>
                            <v-icon @click="add(i,k)">mdi-plus-circle</v-icon>
                          </v-col>
                        </v-row>

                        <!-- <v-row v-for="(lot,j) in 2" :key="lot">
                        <v-col cols="4" md>
                          <v-autocomplete :items="missing_lot_no"></v-autocomplete>
                        </v-col>
                        <v-col cols="4" md>
                          <v-text-field solo label="จำนวนยา"></v-text-field>
                        </v-col>
                        <v-col cols="2">
                          <v-icon
                            @click="remove(index,k)"
                            v-show="k>0 || ( !k && textbox[index].length > 1)"
                          >mdi-minus-circle</v-icon>
                          <v-icon
                            @click="add(index)"
                            v-show="k == textbox[index].length-1"
                          >mdi-plus-circle</v-icon>
                        </v-col>
                        </v-row>-->
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-col>
              </v-row>
            </v-form>
            <v-row style="margin:10px">
              <v-col cols="12">
                <div style="border-left: 10px solid #5B48A2;padding:12px;background-color:#D4D7C4">
                  <p style="font-size:18px;margin:auto">ออร์เดอร์ที่มียาขาด</p>
                </div>
              </v-col>
            </v-row>
            <v-row style="margin:20px">
              <v-col
                cols="12"
                md="4"
                v-for="(element,i) in missing_order"
                :key="element.order_id"
                class="d-flex"
              >
                <v-card class="d-flex flex-column">
                  <v-card-title style="background-color:#DFE4DE;padding:0 15px;font-size:18px">
                    <v-checkbox disabled v-model="cb_missing_card[i]"></v-checkbox>
                    <v-spacer></v-spacer>
                    ออร์เดอร์ที่ {{element.order_id}}
                  </v-card-title>
                  <v-card-text>
                    <p class="font-card">คุณ{{element.name}} {{element.surname}}</p>
                    <p class="font-card">
                      วันที่นัดรับยา
                      <span
                        style="background-color:#E1995E"
                      >{{setDate(element.due_date)}}</span>
                    </p>
                    <p class="font-card">ยาที่ได้รับ</p>
                    <v-list>
                      <v-list-item
                        v-for="(element2,j) in element.medicineItem"
                        :key="element2.medicine_id+i"
                      >
                        <v-row>
                          <v-col cols="6">
                            <p
                              style="padding-top:10px"
                            >{{element2.medicine_generic}} {{element2.strength}} {{element2.qty}} {{element2.unit}}</p>
                          </v-col>
                          <v-col cols="6">
                            <v-text-field
                              solo
                              label="จำนวนยา"
                              v-model="missing_medtxt[i][j]"
                              v-if="missing_medid.indexOf(element2.medicine_id)>-1"
                              @input="checkOrderMissing(i,j,element2)"
                            ></v-text-field>
                          </v-col>
                        </v-row>
                      </v-list-item>
                    </v-list>
                  </v-card-text>
                </v-card>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-dialog>
      <v-row>
        <v-col align="left" style="font-size:25px">ตรวจสอบและยืนยันจำนวนยา</v-col>
      </v-row>
      <v-data-table
        :headers="headers"
        :items="transfer_order"
        :items-per-page="10"
        class="elevation-1"
        @click:row="selectItem"
      >
        <template v-slot:no-data>ไม่มีออร์เดอร์ที่รอการตรวจสอบ</template>
        <template v-slot:item.transport_date="{item}">{{ setDate(item.transport_date) }}</template>
        <template v-slot:item.receive_date="{item}">{{ setDate(item.receive_date) }}</template>
        <template v-slot:item.status>
          <v-chip color="#E1995E">รอการตรวจสอบ</v-chip>
        </template>
      </v-data-table>
    </v-content>
  </v-app>
</template>

<script>
// import ConnectDatabase from '../server/server'
import axios from "axios";
import Menubar from "../../components/ph_menubar";
import dateFormat from "dateformat";
export default {
  data() {
    return {
      picker2: "",
      calendar: false,
      picker: new Date().toISOString().substr(0, 10),
      order_id: 1,
      click: false,
      dialog_row: false,
      index: 0,
      headers: [
        {
          text: "ออร์เดอร์ที่",
          align: "left",
          value: "transport_id",
          divider: true
        },
        {
          text: "จำนวนออร์เดอร์",
          align: "center",
          value: "num_order",
          divider: true
        },
        {
          text: "วันที่จัดส่งยา",
          align: "center",
          value: "transport_date",
          divider: true
        },
        {
          text: "วันที่ร้านยาได้รับ",
          align: "center",
          value: "receive_date",
          divider: true
        },
        { text: "สถานะ", align: "center", value: "status" }
      ],
      sub_headers: [
        {
          text: "เลขออร์เดอร์",
          align: "left",
          sortable: false,
          value: "name"
        },
        { text: "ชื่อ-นามสกุลผู้ป่วย", align: "center", value: "order" },
        { text: "วันที่สร้างออร์เดอร์", align: "center", value: "order" },
        { text: "วันนัดรับยา", align: "center", value: "status" },
        { text: "ข้อมูลยา", align: "center", value: "status" }
      ],
      transport_id: null,
      dialog_missing: false,
      dialog_all: false,
      tooltips: false,
      medicineAll: [],
      cb_all: [],
      cb_missing: [],
      cb_missing_card: [],
      medall_txt: [],
      missing_medtxt: [],
      missing_lot_no: [],
      missing_order: [],
      missing_medid: [],
      missing_medinfo: [],
      date: "",
      transfer_order: [],
      each_transfer: [],
      each_order: [{ status: "" }],
      pharmacy_id: null,
      lot_no: [],
      lot_notxt: [],
      lot_qtytxt: [],
      checkbox: []
    };
  },
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
          .post("http://localhost:3000/api/transport/transportreceived", {
            pharmacy_id: this.pharmacy_id
          })
          .then(res => {
            this.transfer_order = res.data;
          });
      })
      .catch(e => {
        console.log(e);
      });
  },

  methods: {
    add(index) {
      console.log("index=" + index);
      if (this.lot_notxt[index].length < this.lot_no[index].length) {
        // this.textbox[index].push("");
        this.lot_notxt[index].push(null);
        this.lot_qtytxt[index].push(null);
      }
    },
    remove(index, subindex) {
      this.lot_notxt[index].splice(subindex, 1);
      this.lot_qtytxt[index].splice(subindex, 1);
    },
    checkLotQty(index, k) {
      if (this.lot_notxt[index][k] != null) {
        var qty = 0;
        console.log(this.lot_notxt[index][k].qty);
        console.log(this.lot_qtytxt[index][k]);
        this.lot_qtytxt[index].forEach((item, i) => {
          qty += parseInt(this.lot_qtytxt[index][i]);
        });
        if (qty > this.missing_medinfo[index].qty) {
          alert("กรอกยาเกินจำนวนที่ได้รับ");
          this.lot_qtytxt[index][k] = "";
        } else if (qty == this.missing_medinfo[index].qty) {
          this.cb_missing[index] = true;
        } else if (qty < this.missing_medinfo[index].qty) {
          this.cb_missing[index] = false;
        }
        if (this.lot_notxt[index][k].qty < this.lot_qtytxt[index][k]) {
          alert("กรอกจำนวนยาเกินในล็อตนี้");
          this.lot_qtytxt[index][k] = "";
        }
      } else {
        alert("กรุณาเลือกรหัสสินค้าก่อน");
        this.lot_qtytxt[index][k] = "";
      }
    },
    checksameLot(index, k) {
      for (var i = 0; i < this.lot_notxt[index].length; i++) {
        if (i != k) {
          if (this.lot_notxt[index][k] == this.lot_notxt[index][i]) {
            alert("ใช้รหัสสินค้าซ้ำ");
            this.lot_notxt[index].splice(k, 1);
            this.lot_qtytxt[index].splice(k, 1);
          }
        }
      }
    },
    resetDialog() {
      this.dialog_all = false;
      setTimeout(() => {
        this.$refs.form.reset();
      }, 300);
    },
    checkBoxMedAll(index) {
      if (this.cb_all[index] == true) {
        this.medall_txt[index] = this.medicineAll[index].qty;
      } else {
        this.medall_txt[index] = "";
      }
    },
    checkQtyAll(index) {
      if (!isNaN(this.medall_txt[index])) {
        if (this.medall_txt[index] == this.medicineAll[index].qty) {
          this.cb_all[index] = true;
        } else if (this.medall_txt[index] < this.medicineAll[index].qty) {
          this.cb_all[index] = false;
        } else {
          alert("กรอกจำนวนยาเกิน กรุณากรอกใหม่");
          this.medall_txt[index] = "";
          this.cb_all[index] = false;
        }
      }
    },
    confirmAll() {
      if (this.$refs.form.validate()) {
        if (this.cb_all.every(element => element)) {
          //complete
          this.resetDialog();
        } else {
          //missing
          this.missing_medid = [];
          this.missing_medinfo = [];
          this.missing_lot_no = [];
          this.medicineAll.forEach((element, i) => {
            if (!this.cb_all[i]) {
              this.missing_medid.push(element.medicine_id);
              this.missing_medinfo.push({
                medicine_id: element.medicine_id,
                medicine_generic: element.medicine_generic,
                strength: element.strength,
                unit: element.unit,
                qty: this.medall_txt[i]
              });
              this.missing_lot_no.push([]);
            }
          });
          this.getMissingLotno();
          this.filterMissingOrder();
          this.dialog_missing = true;
        }
      }
    },
    confirmMissing() {
      var check = this.cb_missing.every(element => element == true);
      console.log(check);
      if (this.$refs.form2.validate() && check) {
        this.each_transfer.forEach((element, index) => {
          // axios
          //   .post("http://localhost:3000/api/log/newlog", {
          //     status: "confirm",
          //     start_date: dateFormat(new Date(), "yyyy/mm/dd"),
          //     staff_id_log: localStorage.getItem("staff_id"),
          //     order_id_log: this.each_transfer[index].order_id
          //   })
          //   .catch(e => {
          //     console.log(e);
          //   });
          //change status order => prepare
          var checkmissingorder = this.missing_order.indexOf(
            this.each_transfer[index]
          );
          if (
            checkmissingorder == -1 ||
            this.cb_missing_card[checkmissingorder] == true
          ) {
            //prepare
            console.log({
              status: "prepare",
              transport_id: this.transport_id,
              order_id: this.each_transfer[index].order_id
            });
            axios
              .post("http://localhost:3000/api/order/edit_orderstatus", {
                status: "prepare",
                transport_id: this.transport_id,
                order_id: this.each_transfer[index].order_id
              })
              .then(res => {})
              .catch(e => {
                console.log(e);
              });
            // }
          } else {
            console.log({
              status: "missing",
              transport_id: this.transport_id,
              order_id: this.each_transfer[index].order_id
            });
            this.missing_order[checkmissingorder].medicineItem.forEach(
              (qtymissing, i) => {
                if (this.missing_medid.indexOf(qtymissing.medicine_id) > -1) {
                  axios.post(
                    "http://localhost:3000/api/order/edit_qtymissing",
                    {
                      qty_missing:
                        qtymissing.qty -
                        (parseInt(this.missing_medtxt[checkmissingorder][i]) ||
                          0),
                      order_id: this.each_transfer[index].order_id,
                      medicine_id: qtymissing.medicine_id
                    }
                  );
                }
              }
            );
            axios
              .post("http://localhost:3000/api/order/edit_orderstatus", {
                status: "missing",
                transport_id: this.transport_id,
                order_id: this.each_transfer[index].order_id
              })
              .then(res => {})
              .catch(e => {
                console.log(e);
              });
            // }
          }
        });
        //loop by no of medicineAll
        this.medicineAll.forEach((e, i) => {
          axios
            .post("http://localhost:3000/api/lot_transfer/getlotonemed", {
              transport_id: this.transport_id,
              medicine_id: e.medicine_id
            })
            .then(res => {
              var lot = res.data;
              var index_missing = this.missing_medid.indexOf(e.medicine_id);
              if (index_missing == -1) {
                lot.forEach((item, j) => {
                  console.log("completeoreder");
                  console.log({
                    lot_no_id: lot[j].lot_no_id,
                    qty_less: lot[j].qty
                  });
                  axios.post("http://localhost:3000/api/lot_transfer/editlot", {
                    lot_no_id: lot[j].lot_no_id,
                    qty_less: lot[j].qty
                  });
                });
              } else {
                // var usedlot = lot.filter((lot,index)=>{
                //   lot.indexOf(this.lot_notxt[index_missing][index]==
                // })
                lot.forEach((item, j) => {
                  var check = 1;

                  this.lot_notxt[index_missing].forEach((item2, j2) => {
                    if (item.lot_no_id == item2.lot_no_id) {
                      check = 0;
                      console.log("missing");
                      console.log({
                        lot_no_id: lot[j].lot_no_id,
                        qty_less: this.lot_qtytxt[index_missing][j2]
                      });
                      axios
                        .post(
                          "http://localhost:3000/api/lot_transfer/editlot",
                          {
                            lot_no_id: lot[j].lot_no_id,
                            qty_less: this.lot_qtytxt[index_missing][j2]
                          }
                        )
                        .then(res => {
                          check = 0;
                        });
                    }
                  });
                  if (check) {
                    console.log({
                      lot_no_id: lot[j].lot_no_id,
                      qty_less: 0
                    });
                    axios
                      .post("http://localhost:3000/api/lot_transfer/editlot", {
                        lot_no_id: lot[j].lot_no_id,
                        qty_less: 0
                      })
                      .then(res => {
                        check = 0;
                      });
                  }
                });
              }

              console.log("lot");
              console.log(lot);
            })
            .catch(e => {
              console.log(e);
            });
        });
        this.dialog_missing = true;
      }
    },
    getMissingLotno() {
      this.lot_no = [];
      this.missing_medid.forEach((element, i) => {
        console.log(element);
        axios
          .post("http://localhost:3000/api/lot_transfer/getlotonemed", {
            transport_id: this.transport_id,
            medicine_id: element
          })
          .then(res => {
            // this.lot_no.push(null);
            this.lot_no.push(res.data);
            this.lot_notxt.push([null]);
            this.lot_qtytxt.push([null]);
          });
      });
    },
    filterMissingOrder() {
      var filters = { medicine_id: this.missing_medid };
      this.missing_order = this.each_transfer.filter(d => {
        var a = null;
        a = d.medicineItem.filter(e => {
          return Object.keys(filters).every(f => {
            return filters[f].includes(e[f]);
          });
        });
        if (a.length > 0) {
          this.missing_medtxt.push([]);
          return true;
        }
      });
    },
    checkOrderMissing(i, j, med) {
      if (this.missing_medtxt[i][j] > med.qty) {
        alert("กรอกจำนวนยาเกิน กรุณากรอกใหม่");
        this.missing_medtxt[i][j] = "";
      }
      var qty = [];
      var check = 1;
      // var qty_order = 0
      this.missing_order.forEach((element, index) => {
        // ele;
        element.medicineItem.forEach((element2, index2) => {
          if (index == i) {
            if (this.missing_medid.indexOf(element2.medicine_id) > -1) {
              if (this.missing_medtxt[index][index2] == med.qty) {
              } else {
                check = 0;
              }
            }
          }

          // var checkqty = this.missing_medid.indexOf(element2.medicine_id);
          // if (checkqty > -1) {
          //   //ยาเป็นยาที่ขาด
          //   if (
          //     this.missing_medtxt[index][index2] != null ||
          //     this.missing_medtxt[index][index2] != ""
          //   ) {
          //     if (qty[checkqty] == null) {
          //       qty[checkqty] = 0;
          //       qty[checkqty] += parseInt(this.missing_medtxt[index][index2]);
          //     }
          //     qty[checkqty] += parseInt(this.missing_medtxt[index][index2]);
          //   }
          // }
        });
        if (check) {
          this.cb_missing_card[i] = true;
        } else {
          this.cb_missing_card[i] = false;
        }
      });
    },
    setDate: function(d) {
      var month_th = [
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
        var date_transport = dateFormat(d, "dd/mm/yyyy");
        var [day, month, year] = date_transport.split("/");
        year = parseInt(year) + 543;
        month = month_th[parseInt(month) - 1];
        return `${day} ${month} ${year}`;
      } else return "";
    },
    setDate2: function(d) {
      var month_th = [
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
        var [day, month, year] = d.split("/");
        year = parseInt(year) + 543;
        month = month_th[parseInt(month) - 1];
        return `${day} ${month} ${year}`;
      } else return "";
    },
    changestatus() {
      // // if (this.transfer_order[this.index].status == "transport") {
      // //   this.transfer_order[this.index].status = "received";
      // // }
      // if (this.$refs.form.validate()) {
      //   // add orderlog
      //   this.each_order.forEach((element, index) => {
      //     axios
      //       .post("http://localhost:3000/api/log/newlog", {
      //         status: "confirm",
      //         start_date: dateFormat(new Date(), "yyyy/mm/dd"),
      //         staff_id_log: localStorage.getItem("staff_id"),
      //         order_id_log: this.each_order[index].order_id
      //       })
      //       .catch(e => {
      //         console.log(e);
      //       });
      //     //change status order => prepare
      //     axios
      //       .post("http://localhost:3000/api/order/edit_orderstatus", {
      //         status: "prepare",
      //         transport_id: this.each_order[index].transport_id,
      //         order_id: this.each_order[index].order_id
      //       })
      //       .then(res => {
      //         this.transfer_order.splice(this.index, 1);
      //       })
      //       .catch(e => {
      //         console.log(e);
      //       });
      //   });
      //   //loop by no of medicineAll
      //   this.medicineAll.id.forEach((e, i) => {
      //     axios
      //       .post("http://localhost:3000/api/lot_transfer/getlotonemed", {
      //         transport_id: this.each_order[0].transport_id,
      //         medicine_id: this.medicineAll.id[i]
      //       })
      //       .then(res => {
      //         var lot = res.data;
      //         console.log("lot");
      //         console.log(lot);
      //         lot.forEach((item, j) => {
      //           axios.post("http://localhost:3000/api/lot_transfer/editlot", {
      //             lot_no_id: lot[j].lot_no_id,
      //             qty_less: lot[j].qty
      //           });
      //         });
      //       })
      //       .catch(e => {
      //         console.log(e);
      //       });
      //   });
      //   this.dialog_row = false;
      // }
    },
    selectItem(item) {
      this.transport_id = item.transport_id;
      axios
        .post("http://localhost:3000/api/transport/transport_order", {
          transport_id: item.transport_id
        })
        .then(res => {
          this.each_transfer = res.data;
          var res_data = [...res.data];
          var format = [];
          this.medicineAll = [];
          var med_id = [];
          var pre_orderid = null;

          res_data.forEach((item, i) => {
            var element = { ...item };
            var medicine = {
              medicine_id: element.medicine_id,
              medicine_generic: element.medicine_generic,
              strength: element.strength,
              unit: element.unit,
              qty: element.qty
            };
            if (i == 0) {
              med_id.push(item.medicine_id);
              this.medicineAll[0] = { ...medicine };
              element["medicineItem"] = [];
              element["medicineItem"][0] = { ...medicine };
              format.push(element);
              console.log(format);
            } else {
              if (pre_orderid === element.order_id) {
                format[format.length - 1].medicineItem[
                  format[format.length - 1].medicineItem.length
                ] = { ...medicine };
              } else {
                element["medicineItem"] = [];
                element["medicineItem"][0] = { ...medicine };
                format.push(element);
              }
              var index = med_id.indexOf(item.medicine_id);
              if (index > -1) {
                this.medicineAll[index].qty += parseInt(item.qty);
              } else {
                this.medicineAll.push(medicine);
                med_id.push(item.medicine_id);
              }
            }
            pre_orderid = element.order_id;
          });

          this.each_transfer = [...format];
          this.dialog_all = true;
        });
    }
  },
  watch: {
    checkbox() {
      this.checkbox.forEach((element, index) => {
        if (this.checkbox[index]) {
          this.each_order.forEach((e, i) => {
            var medicine = this.each_order[i].medicineItem;
            for (let j = 0; j < medicine.length; j++) {
              if (
                medicine[j].medicine_generic == this.medicineAll.name[index]
              ) {
                this.each_order[i].medicineItem[j].qty_received =
                  medicine[j].qty;
              }
            }
          });
        } else {
          this.each_order.forEach((e, i) => {
            var medicine = this.each_order[i].medicineItem;
            for (let j = 0; j < medicine.length; j++) {
              if (
                medicine[j].medicine_generic == this.medicineAll.name[index]
              ) {
                this.each_order[i].medicineItem[j].qty_received = "";
              }
            }
          });
        }
      });
    },
    each_order: {
      handler() {
        console.log(this.each_order);
      },
      deep: true
    }
  }
};
</script>
<style >
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
.font-card {
  font-size: 16px;
  margin-top: 10px;
}
</style>
