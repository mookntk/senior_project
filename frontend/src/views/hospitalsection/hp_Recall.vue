<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main font">
      <v-row>
        <v-col align="left" style="font-size:25px">ระบบคืนยา</v-col>
        <v-spacer></v-spacer>
        <v-col cols="12" sm="2" md="2" align="right">
          <v-text-field v-model="search" label="ค้นหา" solo></v-text-field>
        </v-col>
        <v-col cols="12" sm="2" md="2" align="right">
          <v-select
            :items="default_status"
            chips
            label="เลือกสถานะ"
            multiple
            solo
            v-model="filters.status"
          ></v-select>
        </v-col>
        <v-col cols="12" sm="2" md="2" align="right">
          <v-select
            :items="pharmacy"
            item-text="pharmacy_name"
            chips
            label="เลือกร้านขายยา"
            multiple
            solo
            v-model="filters.pharmacy_name"
          ></v-select>
        </v-col>
      </v-row>
      <v-data-table
        :headers="headers"
        :items="filterOrders"
        :items-per-page="10"
        class="elevation-1"
        @click:row="selectItem"
        :search="search"
      >
        <template v-slot:item.status="{item}">
          <v-chip :color="getColor(item.status)">{{ setStatus(item.status) }}</v-chip>
        </template>
        <template v-slot:item.confirm="{item}">
          <v-btn
            color="#76C3AF"
            :disabled="item.status=='received'"
            v-if="item.status=='received'||item.status=='sending'"
          >ยืนยัน</v-btn>
        </template>
        <template v-slot:item.send_date="{item}">{{setDate(item.send_date)}}</template>
        <template v-slot:item.receive_date="{item}">{{setDate(item.receive_date)}}</template>
        <template v-slot:no-data>ไม่มีประวัติออร์เดอร์ที่ส่งยาคืน</template>
      </v-data-table>

      <v-dialog
        v-model="dialog_order"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card class="font" style="background-color:#f5f7f5">
          <v-toolbar color="#77B3D5">
            <v-btn color="#C85D5C" fab small depressed @click="dialog_order = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-spacer></v-spacer>
            <v-btn
              color="#f5ce88"
              large
              @click="confirm"
              v-if="order[index].status=='sending'"
            >ได้รับยาเรียบร้อย</v-btn>
          </v-toolbar>
          <v-card-text>
            <v-row style="margin:20px">
              <v-col cols="12" sm="12">
                <v-data-table
                  :items="oneorder"
                  :items-per-page="10"
                  class="elevation-1"
                  :headers="sub_headers"
                  show-expand
                  :expanded.sync="expanded"
                  item-key="order_id"
                >
                  <template v-slot:item.status="{item}">
                    <v-chip :color="getColor(item.status)">{{ setStatus(item.status) }}</v-chip>
                  </template>
                  <template v-slot:item.name="{item}">{{item.name}} {{item.surname}}</template>
                  <template v-slot:item.receive_date="{item}">{{setDate(item.receive_date)}}</template>
                  <template v-slot:expanded-item="{ headers, item }">
                    <td :colspan="headers.length" style="background-color:#f7f7f2">
                      <v-list
                        v-for="(med) in item.medicineItem"
                        :key="med.medicine_id"
                        style="background-color:#f7f7f2"
                      >
                        <v-list-item>
                          <v-icon color="black">mdi-pill</v-icon>
                          {{med.medicine_generic}} {{med.strength}} {{med.qty}} {{med.unit}}
                        </v-list-item>
                        <v-row>
                          <v-col
                            v-for="lot in med.lotItem"
                            :key="lot.lot_no_id"
                            cols="12"
                            md="2"
                            sm="6"
                            style="text-align:left;margin-left:20px"
                          >
                            <v-icon>mdi-circle-small</v-icon>
                            {{lot.lot_no}} จำนวน {{lot.lot_qty}} {{med.unit}}
                          </v-col>
                        </v-row>
                      </v-list>
                    </td>
                  </template>
                </v-data-table>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-content>
  </v-app>
</template>

<script>
// import ConnectDatabase from '../server/server'
import axios from "axios";
import Menu from "../../components/hp_menubar";
import dateFormat from "dateformat";
export default {
  data() {
    return {
      index: 0,
      headers: [
        {
          text: "ชื่อร้านขายยา",
          align: "left",
          value: "pharmacy_name",
          divider: true
        },
        {
          text: "จำนวนออร์เดอร์",
          align: "center",
          value: "num_order",
          divider: true
        },
        {
          text: "วันที่ร้านยาส่งคืน",
          align: "center",
          value: "send_date",
          divider: true
        },
        {
          text: "วันที่ได้รับยาคืน",
          align: "center",
          value: "receive_date",
          divider: true
        },
        { text: "สถานะ", align: "center", value: "status", divider: true },
        { text: "ได้รับยา", align: "center", value: "confirm" }
      ],
      sub_headers: [
        {
          text: "เลขออร์เดอร์",
          align: "right",
          value: "order_id",
          divider: true,
          width: "10%"
        },
        {
          text: "ชื่อ-นามสกุลผู้ป่วย",
          align: "center",
          value: "name",
          divider: true,
          width: "25%"
        },
        {
          text: "วันที่รับยา",
          align: "center",
          value: "receive_date",
          divider: true,
          width: "20%"
        },
        {
          text: "สถานะ",
          align: "center",
          value: "status",
          divider: true,
          width: "15%"
        },
        {
          text: "หมายเหตุ",
          align: "center",
          value: "remark",
          divider: true,
          width: "20%"
        },
        {
          text: "ข้อมูลยา",
          align: "center",
          value: "data-table-expand",
          width: "10%"
        }
      ],
      order: [],
      dialog_order: false,
      oneorder: [],
      expanded: [],
      filters: {
        status: [],
        pharmacy_name: []
      },
      default_status: [
        { text: "รอจัดส่ง", value: "waiting-return" },
        { text: "กำลังจัดส่ง", value: "sending" },
        { text: "ได้รับยาเรียบร้อย", value: "received" }
      ],
      pharmacy: [],
      search: ""
    };
  },
  components: {
    Menu
  },
  mounted() {
    axios.get("http://localhost:3000/api/return/getreturnorder").then(res => {
      this.order = res.data;
      console.log(this.order);
    });
    axios.get("http://localhost:3000/api/pharmacy/showpharmacy").then(res => {
      this.pharmacy = res.data;
    });
  },

  methods: {
    getColor(status) {
      if (status == "waiting-return") return "#bdc3c7";
      else if (status == "sending") return "#E1995E";
      else if (status == "received" || status == "success") return "#76C3AF";
      else if (status == "cancel") return "#C85D5C";
    },
    setStatus(status) {
      if (status == "waiting-return") return "รอจัดส่ง";
      else if (status == "sending") return "กำลังขนส่ง";
      else if (status == "received") return "ได้รับยาเรียบร้อย";
      else if (status == "cancel") return "ยกเลิก";
      else if (status == "success") return "สำเร็จ";
    },
    setDate(date) {
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
      if (date == null) return null;
      var d = dateFormat(date, "d/m/yyyy");
      var [date, m, y] = d.split("/");
      return date + " " + month[m - 1] + " " + (parseInt(y) + 543);
    },
    selectItem(item) {
      this.index = this.order.indexOf(item);
      axios
        .post("http://localhost:3000/api/return/getonereturnorder", {
          return_id: item.return_id
        })
        .then(res => {
          this.oneorder = res.data;
          var format = [];
          var pre_order = null;
          var pre_medicine = null;
          res.data.forEach((element, i) => {
            var medicine = {
              medicine_id: element.medicine_id,
              medicine_generic: element.medicine_generic,
              strength: element.strength,
              unit: element.unit,
              qty: element.qty
            };
            var lot = {
              lot_no_id: element.lot_no_id,
              lot_no: element.lot_no,
              lot_qty: element.lot_qty,
              lot_transfer_id: element.lot_transfer_id
            };
            if (i == 0) {
              element["medicineItem"] = [medicine];
              element.medicineItem[0]["lotItem"] = [lot];
              format.push(element);
            } else {
              if (pre_order == element.order_id) {
                if (pre_medicine == element.medicine_id) {
                  format[format.length - 1].medicineItem[
                    format[format.length - 1].medicineItem.length - 1
                  ].lotItem.push(lot);
                } else {
                  medicine["lotItem"] = [lot];
                  format[format.length - 1].medicineItem.push(medicine);
                }
              } else {
                element["medicineItem"] = [medicine];
                element.medicineItem[0]["lotItem"] = [lot];
                format.push(element);
              }
            }
            pre_medicine = element.medicine_id;
            pre_order = element.order_id;
            console.log("format");
            console.log(format);
            this.oneorder = [...format];
          });
        });
      // this.pharmacy = item.name;
      this.dialog_order = true;
    },
    confirm() {
      confirm("ยืนยันการรับยาคืนใช่หรือไม่") &&
        axios
          .post("http://localhost:3000/api/return/editstatus", {
            status: "received",
            pharmacist_id: localStorage.getItem("staff_id"),
            return_id: this.order[this.index].return_id,
            send_date: dateFormat(
              new Date(this.order[this.index].send_date),
              "yyyy-mm-dd hh:mm:ss"
            ),
            receive_date: dateFormat(new Date(), "yyyy-mm-dd hh:mm:ss")
          })
          .then(res => {
            axios
              .get("http://localhost:3000/api/return/getreturnorder")
              .then(res => {
                this.order = res.data;
                this.dialog_order = false;
              });
          });
    }
  },
  computed: {
    filterOrders() {
      return this.order.filter(d => {
        return Object.keys(this.filters).every(f => {
          return this.filters[f].length < 1 || this.filters[f].includes(d[f]);
        });
      });
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