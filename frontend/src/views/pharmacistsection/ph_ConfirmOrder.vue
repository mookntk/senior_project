<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>

    <v-content class="main font">
      <v-dialog v-model="dialog_row" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font">
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_row = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <!-- <v-toolbar-title>{{pharmacy}}</v-toolbar-title> -->
            <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn dark text @click="changestatus">{{formtitle}}</v-btn>
            </v-toolbar-items>
          </v-toolbar>
          <v-row></v-row>
          <v-row style="margin:20px">
            <v-col cols="12" sm="12">
              <v-form ref="form">
                <v-data-table
                  :items="each_order"
                  :items-per-page="10"
                  class="elevation-1"
                  :headers="sub_headers"
                >
                  <template v-slot:body="{ items }">
                    <tbody v-for="(item,index) in items" :key="item.order_id">
                      <tr>
                        <td>{{ item.order_id }}</td>
                        <td style="text-align:center">{{ item.name}}</td>
                        <td style="text-align:center">{{ setDate2(item.create_date)}}</td>
                        <td style="text-align:center">{{ setDate(item.due_date) }}</td>
                        <td>
                          <p
                            v-for="(medicine,i) in each_order[index].medicineItem"
                            :key="medicine.medicineid"
                            style="display: inline"
                          >
                            <v-row>
                              <v-col cols="12" sm="6" md="6" align="right">
                                <p
                                  style="margin-top:15px"
                                >{{medicine.medicine_generic}} {{medicine.qty}} {{medicine.unit}}</p>
                              </v-col>
                              <v-col cols="12" sm="4" md="4">
                                <v-text-field
                                  solo
                                  label="จำนวนยาที่ได้รับ"
                                  v-model="each_order[index].medicineItem[i].qty_received"
                                  :rules="[v => !!v || 'กรุณากรอกข้อมูล',
                                          v => !isNaN(v) || 'กรุณากรอกข้อมูลตัวเลข']"
                                  required
                                ></v-text-field>
                              </v-col>
                            </v-row>
                            <br />
                          </p>
                        </td>
                      </tr>
                      <v-divider></v-divider>
                    </tbody>
                  </template>
                </v-data-table>
              </v-form>
            </v-col>
          </v-row>
          <v-row style="margin:20px">
            <v-list flat class="font">
              <v-header>จำนวนยาทั้งหมด</v-header>
              <template v-for="(item, i) in medicineAll.qty">
                <v-list-item :key="i">
                  <v-list-item-action>
                    <v-checkbox v-model="checkbox[i]" color="primary"></v-checkbox>
                  </v-list-item-action>
                  <v-list-item-content>
                    <v-list-item-title>{{medicineAll.name[i]}} {{medicineAll.qty[i]}} {{medicineAll.unit[i]}}</v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
                <!-- <v-divider :key="i"></v-divider> -->
              </template>
            </v-list>
          </v-row>
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
      >
        <template v-slot:body="{ items }">
          <tbody>
            <tr v-for="item in items" :key="item.transport_id" @click="selectItem(item)">
              <td>{{ item[0].transport_id }}</td>
              <td style="text-align:center">{{ item.length }}</td>
              <td style="text-align:center">{{ setDate(item[0].transport_date) }}</td>
              <td style="text-align:center">{{ setDate(item[0].receive_date) }}</td>
              <td style="text-align:center">
                <v-chip :color="getColor(item[0].status)" dark>
                  {{
                  setStatus(item[0].status)
                  }}
                </v-chip>
              </td>
            </tr>
          </tbody>
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
          sortable: false,
          value: "name"
        },
        { text: "จำนวนออร์เดอร์", align: "center", value: "order" },
        { text: "วันที่จัดส่งยา", align: "center", value: "order" },
        { text: "วันที่ร้านยาได้รับ", align: "center", value: "order" },
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
      date: "",
      transfer_order: [{ status: "" }],
      each_order: [{ status: "" }],
      pharmacy_id: null,
      medicineAll: [{ name: "", qty: "", unit: "" }],
      checkbox: []
    };
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
            console.log(this.transfer_order);
          });
      })
      .catch(e => {
        console.log(e);
      });
  },
  components: {
    Menubar
  },
  methods: {
    setStatus: function(s) {
      if (s === "received") {
        s = "รอการตรวจสอบ";
      } else if (s === "received") {
        s = "ได้รับเรียบร้อยแล้ว";
      }
      return s;
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
      // if (this.transfer_order[this.index].status == "transport") {
      //   this.transfer_order[this.index].status = "received";
      // }
      if (this.$refs.form.validate()) {
        // add orderlog
        this.each_order.forEach((element, index) => {
          axios
            .post("http://localhost:3000/api/log/newlog", {
              status: "confirm",
              start_date: dateFormat(new Date(), "yyyy/mm/dd"),
              staff_id_log: localStorage.getItem("staff_id"),
              order_id_log: this.each_order[index].order_id
            })
            .catch(e => {
              console.log(e);
            });

          //change status order => prepare
          axios
            .post("http://localhost:3000/api/order/edit_orderstatus", {
              status: "prepare",
              transport_id: this.each_order[index].transport_id,
              order_id: this.each_order[index].order_id
            })
            .then(res => {
              this.transfer_order.splice(this.index, 1);
            })
            .catch(e => {
              console.log(e);
            });
        });
        //loop by no of medicineAll
        this.medicineAll.id.forEach((e, i) => {
          axios
            .post("http://localhost:3000/api/lot_transfer/getlotonemed", {
              transport_id: this.each_order[0].transport_id,
              medicine_id: this.medicineAll.id[i]
            })
            .then(res => {
              var lot = res.data;
              console.log("lot");
              console.log(lot);
              lot.forEach((item, j) => {
                axios.post("http://localhost:3000/api/lot_transfer/editlot", {
                  lot_no_id: lot[j].lot_no_id,
                  qty_less: lot[j].qty
                });
              });
            })
            .catch(e => {
              console.log(e);
            });
        });

        this.dialog_row = false;
      }
    },
    getColor(status) {
      if (status == "received") {
        return "orange";
      } else if (status == "received") return "success";
    },
    selectItem(item) {
      this.index = this.transfer_order.indexOf(item);
      this.each_order = [...this.transfer_order[this.index]];
      this.checkbox = new Array(this.each_order.length);
      this.checkbox.fill(false, 0);
      this.allMedicine();
      //
      this.dialog_row = true;
    },
    allMedicine() {
      var order_selected = [...this.transfer_order[this.index]];
      var name = [];
      var qty = [];
      var unit = [];
      var id = [];
      for (let index = 0; index < order_selected.length; index++) {
        for (let j = 0; j < order_selected[index].medicineItem.length; j++) {
          var indexof = id.indexOf(
            order_selected[index].medicineItem[j].medicine_id
          );
          if (indexof > -1) {
            qty[indexof] += parseInt(order_selected[index].medicineItem[j].qty);
          } else {
            qty.push(0);
            qty[qty.length - 1] += parseInt(
              order_selected[index].medicineItem[j].qty
            );
            id.push(order_selected[index].medicineItem[j].medicine_id);
            name.push(order_selected[index].medicineItem[j].medicine_generic);
            unit.push(order_selected[index].medicineItem[j].unit);
          }
        }
      }
      this.medicineAll = {
        id: id,
        name: name,
        qty: qty,
        unit: unit
      };
    }
  },
  computed: {
    formtitle() {
      if (this.each_order[0].status === "received") {
        return "ตรวจสอบเรียบร้อย";
      } else if (this.each_order[0].status === "receieved") {
        return "";
      }
    },
    date_th() {
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
      if (this.picker2 != "") {
        var date = this.picker2.split("-");
        date[0] = parseInt(date[0]) + 543;
        date = date[2] + " " + month[date[1] - 1] + " " + date[0];
        console.log(date);
        return date;
      } else return "";
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
</style>
