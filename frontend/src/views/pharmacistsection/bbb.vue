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
              <v-data-table
                :items="each_order"
                :items-per-page="10"
                class="elevation-1"
                :headers="sub_headers"
              >
                <template v-slot:body="{ items }">
                  <tbody v-for="(item,index) in items" :key="item.name">
                    <tr>
                      <td>{{ item.order_id }}</td>
                      <td style="text-align:center">{{ item.name}}</td>
                      <td style="text-align:center">{{ item.create_date }}</td>
                      <td style="text-align:center">{{ setDate(item.due_date) }}</td>
                      <td>
                        <p
                          v-for="(medicine,i) in each_order[index].medicineItem"
                          :key="medicine"
                          style="display: inline"
                        >
                          <v-row>
                            <v-col cols="12" sm="6" md="6" align="right">
                              <p
                                style="margin-top:15px"
                              >{{medicine.medicine_generic}} {{medicine.qty}} {{medicine.unit}}</p>
                            </v-col>
                            <v-col cols="12" sm="4" md="4">
                              <v-text-field solo label="จำนวนยาที่ได้รับ"></v-text-field>
                              {{aaa}}
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
            </v-col>
          </v-row>
          <v-row style="margin:20px">
            <v-list subheader flat class="font">
              <v-header>จำนวนยาทั้งหมด</v-header>
              <v-list-item-group>
                <v-list-item v-for="(item,index) in sumname" :key="item.name">
                  <template v-slot:default="{ active, toggle }">
                    <v-list-item-action>
                      <v-checkbox v-model="checkbox[index]" color="primary"></v-checkbox>
                    </v-list-item-action>

                    <v-list-item-content>
                      <v-list-item-title>{{item}} {{sumqty[item]}} {{sumunit[item]}}</v-list-item-title>
                    </v-list-item-content>
                  </template>
                </v-list-item>
              </v-list-item-group>
            </v-list>
          </v-row>
        </v-card>
      </v-dialog>
      <v-row>
        <v-col align="left" style="font-size:25px">ตรวจสอบและยืนยันจำนวนยา</v-col>
        <v-col sm="2" align="right" style="font-size:12px">
          <v-text-field
            :value="date_th"
            outlined
            @click="calendar = true"
            label="เลือกวัน/เดือน/ปี"
          ></v-text-field>
        </v-col>
      </v-row>
      <v-dialog v-model="calendar" width="300px">
        <v-row justify="space-around">
          <v-date-picker
            v-model="picker2"
            color="green lighten-1"
            header-color="primary"
            locale="th"
          ></v-date-picker>
        </v-row>
      </v-dialog>
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
      each_order: [],
      pharmacy_id: null,
      medicineAll: [{ name: "", qty: "", unit: "" }],
      medicineName: [],
      medicineqty: [],
      medicineUnit: [],
      sumqty: { aaa: 10 },
      sumname: { aaa: 10 },
      sumunit: { aaa: 10 },
      checkbox: [],
      receive_qty: []
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
    setMed: function(m, index) {
      if (m != null) {
        var med_detail = m.split(";");
        var med_name = med_detail[0];
        var med_name2 = med_name.split(",");
        var med_qty = med_detail[1];
        var med_qty2 = med_qty.split(",");
        var med_unit = med_detail[2];
        var med_unit2 = med_unit.split(",");
        //show medicine
        for (var i = 0; i < med_name2.length; i++) {
          this.medicineAll[index].push(
            med_name2[i] + " " + med_qty2[i] + " " + med_unit2[i]
          );
        }

        //sum medicine
        this.medicineName = this.medicineName.concat(med_name2);
        this.medicineqty = this.medicineqty.concat(med_qty2);
        this.medicineUnit = this.medicineUnit.concat(med_unit2);

        console.log(this.medicineqty);
        // this.receive_qty.push("");
      }
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
    changestatus() {
      if (this.transfer_order[this.index].status == "transport") {
        this.transfer_order[this.index].status = "received";
      }

      //orderlog
      this.each_order.forEach((element, index) => {
        axios
          .post("http://localhost:3000/api/log/newlog", {
            status: "received",
            start_date: dateFormat(new Date(), "yyyy/mm/dd"),
            staff_id_log: localStorage.getItem("staff_id"),
            order_id_log: this.each_order[index].order_id
          })
          .catch(e => {
            console.log(e);
          });

        //change status order
        axios
          .post("http://localhost:3000/api/order/edit_orderstatus", {
            status: "received",
            transport_id: this.transfer_order[this.index].transport_id,
            order_id: this.each_order[index].order_id
          })
          .catch(e => {
            console.log(e);
          });
      });

      //add receive date
      axios
        .post("http://localhost:3000/api/receive_order/edit_receivedate", {
          transport_id: this.transfer_order[this.index].transport_id
        })
        .catch(e => {
          console.log(e);
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
        date.getDate() + " " + (date.getMonth() + 1) + " " + date.getFullYear();

      this.transfer_order[this.index].receive_date = date_format;
      this.dialog_row = false;
    },
    getColor(status) {
      if (status == "received") {
        return "orange";
      } else if (status == "received") return "success";
    },
    selectItem(item) {
      this.index = this.transfer_order.indexOf(item);
      this.each_order = [...this.transfer_order[this.index]];

      //
      this.dialog_row = true;
    },
    sumMed() {
      var filtername = [];
      var name = [];
      var qty = [];
      var unit = [];
      filtername = this.medicineName.filter(
        (item, index) => this.medicineName.indexOf(item) === index
      );

      var _this = this;
      this.medicineName.forEach(function(e, i) {
        if (qty[e] == null) {
          qty[e] = 0;
          unit[e] = _this.medicineUnit[i];
        }
        qty[e] += parseInt(_this.medicineqty[i]) || 0;
      });

      this.sumqty = qty;
      this.sumunit = unit;
      this.sumname = filtername;
      this.checkbox = new Array(filtername.length);
      this.checkbox.fill(false, 0);
    },
    receiveMed(receive, j) {
      return receive[j];
    }
  },
  computed: {
    formtitle() {
      if (this.transfer_order[this.index].status === "received") {
        return "ตรวจสอบเรียบร้อย";
      } else if (this.transfer_order[this.index].status === "receieved") {
        return "";
      }
    },
    // receiveMed() {
    //   return (i, j) => this.receive_qty[i][j];
    // },
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
      var check = new Array(this.medicineName.length);
      this.checkbox.forEach((element, index) => {
        if (this.checkbox[index]) {
          this.medicineName.forEach((e, i) => {
            if (this.sumname[index] == this.medicineName[i]) {
              check[i] = this.medicineqty[i];
            }
          });
        }
      });
      this.receive_qty.forEach((e, i) => {
        // console.log(this.receive_qty[i].length);
        for (let j = 0; j < this.receive_qty[i].length; j++) {
          if (i == 0) {
            this.receive_qty[i][j] = check[j];
          } else {
            var count = 0;
            for (let k = 0; k < i; k++) {
              count += this.receive_qty[k].length;
            }
            this.receive_qty[i][j] = check[count + j];
          }
        }
      });
      console.log(this.receive_qty);
    },
    receive_qty() {
      console.log(this.receive_qty);
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
