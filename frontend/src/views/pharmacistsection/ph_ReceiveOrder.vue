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
                v-model="selected"
                :items="each_order"
                :items-per-page="10"
                class="elevation-1"
                :headers="sub_headers"
              >
                <template v-slot:body="{ items }">
                  <tbody v-for="item in items" :key="item.name">
                    <tr>
                      <td>{{ item.order_id }}</td>
                      <td style="text-align:center">{{ item.name }} {{ item.surname }}</td>
                      <td style="text-align:center">{{ setDate(item.create_date) }}</td>
                      <td style="text-align:center">{{ setDate(item.due_date) }}</td>
                      <td
                        style="vertical-align:middle; text-align:center; white-space:pre-wrap; word-wrap:break-word; "
                      >
                        {{
                        setMed(
                        item.medicine_generic +
                        ";" +
                        item.qty +
                        ";" +
                        item.unit
                        )
                        }}
                      </td>
                    </tr>
                  </tbody>
                </template>
              </v-data-table>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>

      <v-row>
        <v-col align="left" style="font-size:25px">ยืนยันรับออร์เดอร์จากโรงพยาบาล</v-col>
        <v-col sm="2" align="right" style="font-size:12px">
          <!-- <v-text-field
            :value="date_th"
            outlined
            @click="calendar = true"
            label="เลือกวัน/เดือน/ปี"
          ></v-text-field>-->
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

      <!-- data-transport_order -->
      <v-data-table
        :headers="headers"
        :items="transfer_order"
        :items-per-page="10"
        class="elevation-1"
      >
        <template v-slot:body="{ items }">
          <tbody>
            <tr
              v-for="item in items"
              :key="item.transport_id"
              @click="selectItem(item)"
              :class="{ selectedRow: item === selectedItem }"
            >
              <td>{{ item.transport_id }}</td>
              <td style="text-align:center">{{ item.qty_orders }}</td>
              <!--รวมจำนวนออรเดอร์ว่า transport นี้ มีกี่ตัว-->
              <td style="text-align:center">{{ setDate(item.transport_date) }}</td>
              <td style="text-align:center">{{ setDate(item.receive_date) }}</td>
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
      order_name: null,
      order_surname: null,
      order_date: null,
      click: false,
      dialog: false,
      dialog_row: false,
      selected: [],
      transfer_order: [{ status: "" }],
      each_order: [],
      pharmacy: "",
      index: 0,
      receive_date: "",
      headers: [
        {
          text: "ออร์เดอร์ที่",
          align: "left",
          sortable: false
        },
        { text: "จำนวนออร์เดอร์", align: "center" },
        { text: "วันที่จัดส่งยา", align: "center" },
        { text: "วันที่ร้านยาได้รับ", align: "center" },
        { text: "สถานะ", align: "center" }
      ],
      sub_headers: [
        {
          text: "เลขออร์เดอร์",
          align: "left",
          sortable: false
        },
        { text: "ชื่อ-นามสกุลผู้ป่วย", align: "center" },
        { text: "วันที่สร้างออร์เดอร์", align: "center" },
        { text: "วันนัดรับยา", align: "center" },
        { text: "ข้อมูลยา", align: "center" }
      ],
      date: "",
      selectedpharmacy: "",
      selectedItem: "",
      each_medicine: "",
      med_gerenic: "",
      pharmacy_id: null
    };
  },
  components: {
    Menubar
  },
  methods: {
    // get_medicine(medicine_gerenic) {
    // axios.get("http://localhost:3000/api/receive_order/show_order").then(res => {
    //     var medicine = res.data.length;
    //     for (var i = 0; i < medicine; i++) {
    //       if (res.data[i].medicine_gerenic != ""){
    //       var each_med = this.medicine_gerenic.split(",");
    //       each_med = res.data[i].medicine_gerenic;
    //       console.log(each_med);}
    //     }
    //   });
    // },
    setStatus: function(s) {
      if (s === "transport") {
        s = "กำลังจัดส่ง";
      } else if (s === "received") {
        s = "ได้รับเรียบร้อยแล้ว";
      }
      return s;
    },
    setMed: function(m) {
      console.log(m);
      if (m != null) {
        var med_detail = m.split(";");
        var med_name = med_detail[0];
        var med_name2 = med_name.split(",");
        var med_qty = med_detail[1];
        var med_qty2 = med_qty.split(",");
        var med_unit = med_detail[2];
        var med_unit2 = med_unit.split(",");

        var med_show = "";
        for (var i = 0; i < med_name2.length; i++) {
          if (i === med_name2.length - 1) {
            med_show += med_name2[i] + " " + med_qty2[i] + " " + med_unit2[i];
          } else {
            med_show +=
              med_name2[i] + " " + med_qty2[i] + " " + med_unit2[i] + "\n";
          }

          console.log(med_show);
        }
        return med_show;
      }
    },
    setDate: function(d) {
      console.log("setName");
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
        var date_transport = d.split(" ");
        date_transport[2] = parseInt(date_transport[2]) + 543;
        date_transport =
          date_transport[0] +
          " " +
          month[date_transport[1] - 1] +
          " " +
          date_transport[2];
        console.log(date_transport);
        return date_transport;
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
      if (status == "transport") {
        return "orange";
      } else if (status == "received") return "success";
    },
    selectItem(item) {
      this.index = this.transfer_order.indexOf(item);
      axios
        .post("http://localhost:3000/api/receive_order/show_order", {
          transport_id: item.transport_id,
          pharmacy_id: this.pharmacy_id
        })
        .then(res => {
          this.each_order = res.data;
        });
      this.dialog_row = true;
      //
      // if (item.status == "") {
      // }
      // this.pharmacy = item.name;
    }
    // save() {
    //   this.dialog = false;
    //   var count = 0;
    //   var i = 0;
    //   var new_detail = {
    //     order_id: this.order_id,
    //     name: this.order_name + " " + this.order_surname,
    //     due_date: this.picker
    //   };
    //   console.log(new_detail);
    //   for (i = 0; i < this.order.length; i++) {
    //     if (this.order[i].status == "ยังไม่ได้จัดส่ง") {
    //       if (this.selectedpharmacy == this.order[i].name) {
    //         this.order[i].orders.push(new_detail);
    //         count++;
    //         console.log(this.order);
    //         break;
    //       }
    //     }
    //   }
    //   if (count == 0) {
    //     var new_order = {
    //       id: this.order.length,
    //       name: this.selectedpharmacy,
    //       orders: [new_detail],
    //       status: "กำลังจัดส่ง"
    //     };
    //     this.order.push(new_order);
    //   }
    //   this.order_id++;
    //   this.order_name = "";
    //   this.order_surname = "";
    //   this.order_date = "";
    // },
    // selectpharmacy(e) {
    //   this.selectedpharmacy = e;
    //   console.log(this.selectedpharmacy);
    // }
  },
  computed: {
    formtitle() {
      console.log("formtitle");
      console.log(this.transfer_order[this.index].status);
      if (this.transfer_order[this.index].status === "transport") {
        return "received";
      } else if (this.transfer_order[this.index].status === "receieved") {
        return "";
      }
    }
  },
  mounted() {
    axios
      .post("http://localhost:3000/api/user/getuserbyid", {
        staff_id: localStorage.getItem("staff_id")
      })
      .then(res => {
        this.pharmacy_id = res.data[0].pharmacy_id_pharmacist;
        axios
          .post("http://localhost:3000/api/receive_order/show_transfer_order", {
            pharmacy_id: this.pharmacy_id
          })
          .then(res => {
            this.transfer_order = res.data;
          });
      })
      .catch(e => {
        console.log(e);
      });

    axios
      .get("http://localhost:3000/api/receive_order/show_order")
      .then(res => {
        this.each_order = res.data;
      });
    // var day = [
    //   "วันอาทิตย์",
    //   "วันจันทร์",
    //   "วันอังคาร",
    //   "วันพุธ",
    //   "วันพฤหัสบดี",
    //   "วันศุกร์",
    //   "วันเสาร์"
    // ];
    // var month = [
    //   "มกราคม",
    //   "กุมภาพันธ์",
    //   "มีนาคม",
    //   "เมษายน",
    //   "พฤษภาคม",
    //   "มิถุนายน",
    //   "กรกฎาคม",
    //   "สิงหาคม",
    //   "กันยายน",
    //   "ตุลาคม",
    //   "พฤศจิกายน",
    //   "ธันวาคม"
    // ];
    // var date = new Date();
    // var date_format =
    //   day[date.getDay()] +
    //   " " +
    //   date.getDate() +
    //   " " +
    //   month[date.getMonth()] +
    //   " " +
    //   (date.getFullYear() + 543);

    // this.date = date_format;
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
