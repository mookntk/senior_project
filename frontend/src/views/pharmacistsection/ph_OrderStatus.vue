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
            <v-toolbar-title>ออร์เดอร์ที่ {{ oneorder[0].order_id }}</v-toolbar-title>
          </v-toolbar>

          <v-card-title>
            <span class="font"></span>
          </v-card-title>
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
                  <v-col cols="12" sm="8">
                    <v-select
                      :items="note"
                      label="หมายเหตุ"
                      v-model="remark"
                      :rules="[v => !!v || 'กรุณากรอกข้อมูล']"
                      required
                      outlined
                    ></v-select>
                  </v-col>
                </v-row>

                <v-list class="font">
                  <template v-for="(i,index) in oneorder">
                    <v-list-item :key="i">
                      <v-list-item-content>
                        <v-checkbox
                          v-model="selected[index]"
                          color="success"
                          :label="i.medicine_generic+' '+i.strength+' '+i.qty+' '+i.unit"
                          disabled
                        ></v-checkbox>

                        <v-row>
                          <template v-for="(item,k) in textbox[index]">
                            <v-col cols="12" sm="2" md="2" :key="k">
                              <v-autocomplete
                                :items="lot_no[index]"
                                item-text="lot_no"
                                label="เลขรหัสสินค้า"
                                item-value="lot_no_id"
                                v-model="lot_med[index][k]"
                                :rules="[v => !!v || 'กรุณากรอกข้อมูล']"
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
                              </v-autocomplete>
                            </v-col>
                            <v-col cols="12" sm="2" md="2">
                              <v-text-field
                                solo
                                clearable
                                label="จำนวนยา"
                                v-model="qty_med[index][k]"
                                :rules="numberrules"
                                required
                              ></v-text-field>
                            </v-col>
                            <v-col cols="12" sm="2" md="2">
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
              >ส่งยาคืนโรงพยาบาล</v-btn>

              <v-btn rounded large color="warning" dark @click="dialog_sendback = false">ยกเลิก</v-btn>
            </v-card-actions>
          </v-form>
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
            >ออร์เดอร์ทั้งหมด</v-btn>
            <v-btn
              width="200px"
              class="green lighten-1"
              value="success"
              @click="sortdata"
            >ออร์เดอร์ที่สำเร็จแล้ว</v-btn>
            <v-btn
              width="200px"
              class="gray lighten-1"
              value="not_ready"
              @click="sortdata"
            >ออร์เดอร์ที่ไม่พร้อมจ่ายยา</v-btn>
            <v-btn
              width="200px"
              class="orange lighten-1"
              value="received_some"
              @click="sortdata"
            >ออร์เดอร์ที่คืนบางส่วน</v-btn>

            <v-btn
              width="200px"
              class="red lighten-1"
              value="cancel"
              @click="sortdata"
            >ออร์เดอร์ที่ต้องยกเลิก</v-btn>
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
                <v-chip :color="getColor(item.status)" dark>
                  {{
                  setStatus(item.status)
                  }}
                </v-chip>
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
                    <td style="text-align:center">{{ item.patient_HN_order }}</td>
                    <td style="text-align:left">{{ item.name }}</td>
                    <td style="text-align:left">{{ item.surname }}</td>
                    <td style="text-align:left">{{ setDate(item.due_date) }}</td>
                    <td style="text-align:left">
                      <v-chip :color="getColor(item.status)" dark>{{ setStatus(item.status) }}</v-chip>
                    </td>
                    <td style="text-align:left">
                      <v-btn
                        color="primary"
                        @click="getindex_cancel(item)"
                        v-if="
                          item.status == 'cancel' ||
                            item.status == 'received_some'
                        "
                        :disabled="item.return_id!=null"
                      >ส่งยากลับ</v-btn>
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
import dateFormat from "dateformat";
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
    note: ["ผู้ป่วยไม่มารับ", "ยามีปัญหา"],
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
    ]
  }),
  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "New Item" : "Edit Item";
    }
  },
  watch: {
    lot_med() {
      console.log(this.lot_med);
      this.lot_med.forEach((item, i) => {
        var object = {};
        for (let item2 of this.lot_med[i]) {
          if (item2 != "" && item2 != null) {
            if (!object[item2.lot_no_id]) object[item2.lot_no_id] = 0;
            object[item2.lot_no_id] += 1;
            if (object[item2.lot_no_id] > 1) {
              alert("the same lot_no");
              var index = this.lot_med[i].lastIndexOf(item2);
              console.log("index");
              this.lot_med[i][index] = {};
              console.log(this.lot_med);
            }
          }
        }
        // }
        //         this.lot_med[i].forEach(item2 => {
        //           if (item2 != "") {
        //             if (!object[item2]) object[item2] = 0;
        //             object[item2] += 1;
        //             if (object[item2] > 1) {
        //               alert("the same lot_no");
        //               var index = this.lot_med[i].lastIndexOf(item2);
        //               console.log("index");

        //               this.lot_med[i][index] = null;
        //               console.log(this.lot_med);
        //               // break;
        //             }
        //           }
        //         });
        // if (this.lot_med[i] != "") {
        //   if (check.indexOf(item)) {
        //     duplicate++;
        //   }
        //   check.push(item);
        //   if (duplicate > 0) {
        //     alert("the same lot_no");
        //   }
        // }
        // check = this.lot_med[i].filter((item,i)=>{
        //   return
        // })
      });
    },
    qty_med() {
      this.qty_med.forEach((item, i) => {
        var check_amount = 0;
        this.qty_med[i].forEach((qty, j) => {
          check_amount += parseInt(qty);
          console.log("check_amount");
          console.log(check_amount);
          //check qty_less
          if (this.qty_med[i][j] > this.lot_med[i][j].qty_less) {
            alert("จำนวนยาของรหัสสินค้าไม่พอ");
            this.qty_med[i][j] = this.lot_med[i][j].qty_less;
          }
          if (check_amount > this.oneorder[i].qty) {
            alert("จำนวนยาเกิน");
            console.log(
              this.oneorder[i].qty +
                " " +
                check_amount +
                " " +
                this.qty_med[i][j]
            );
            this.qty_med[i][j] =
              parseInt(this.oneorder[i].qty) -
              (check_amount - parseInt(this.qty_med[i][j]));
            check_amount = this.oneorder[i].qty;
          }
          if (check_amount == this.oneorder[i].qty) {
            this.selected[i] = true;
          } else {
            this.selected[i] = false;
          }
        });
      });
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
      console.log("add");
      console.log(this.lot_no);
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
    //     selectItem(item) {
    //       // var index = this.s_order.indexOf(item);

    //       // if (this.s_order[index].status == "ready") {
    //       //   this.index = this.s_order;
    //       //   console.log(this.s_order[index]);
    //       //   this.s_order = item;
    //       //   this.dialog_row = true;
    //       this.lot_no = [];
    //       // this.oneorder = item;
    //       axios
    //         .post("http://localhost:3000/api/ready_sell/one_order", {
    //           patient_HN_order: this.s_order[this.index].patient_HN_order
    //         })
    //         .then(res => {
    //           this.oneorder = res.data;
    //           this.selected = new Array(this.oneorder.length);
    //           this.selected.fill(false, 0);
    //           this.oneorder.forEach((item, index) => {
    //             this.textbox.push([""]);
    //             this.lot_med.push([""]);
    //             this.qty_med.push([""]);
    //           });
    //           this.oneorder.forEach((e, i) => {
    //             axios
    //               .post("http://localhost:3000/api/ready_sell/getlot", {
    //                 pharmacy_id: this.pharmacy_id,
    //                 medicine_id: this.oneorder[i].medicine_id
    //               })
    //               .then(res => {
    //                 this.lot_no.push(res.data);
    //               });
    //           });
    //           // console.log(this.lot_no);
    //         });
    //  this.dialog_row = true;

    //       }

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
      this.lot_no = [];
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
      this.dialog_sendback = true;
    },
    sendback_confirm() {
      //validate form && amount of med is complete
      if (this.$refs.form.validate()) {
        if (this.selected.every(item => item == true)) {
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
                });

              //edit lot qty_less
              this.lot_med.forEach((e, i) => {
                this.lot_med[i].forEach((item, j) => {
                  var filter = this.lot_no[i].filter((filter, k) => {
                    return (
                      this.lot_no[i][k].lot_no_id ==
                      this.lot_med[i][j].lot_no_id
                    );
                  });

                  if (filter.length > 0) {
                    axios
                      .post("http://localhost:3000/api/lot_transfer/editlot", {
                        lot_no_id: filter[0].lot_no_id,
                        qty_less:
                          filter[0].qty_less - parseInt(this.qty_med[i][j])
                      })
                      .catch(e => {
                        console.log(e);
                      });
                  }
                });
              });
            })
            .catch(e => {
              console.log(e);
            });

          // this.s_order.splice(this.index, 1);
          this.order_filter = [...this.s_order];
          this.dialog_sendback = false;
        } else {
          alert("จำนวนยาไม่ครบ");
        }
      } else {
        // alert("กรุณากรอกข้อมูลให้ครบถ้วน")
      }
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
