<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>

    <v-content class="main font">
      <v-dialog v-model="dialog_row" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font">
          <v-toolbar color="#77B3D5">
            <v-btn color="#C85D5C" fab small depressed @click="dialog_row = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn
                text
                @click="changestatus"
                v-if="transfer_order[index].status === 'transport'"
              >ได้รับยาเรียบร้อย</v-btn>
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
                <template v-slot:item.name="{item}">{{ item.name }} {{ item.surname }}</template>
                <template v-slot:item.create_date="{item}">{{ setDate(item.create_date) }}</template>
                <template v-slot:item.due_date="{item}">{{ setDate(item.due_date) }}</template>
                <template v-slot:item.medicine="{item}">
                  <p
                    style="vertical-align:middle; text-align:center; white-space:pre-wrap; word-wrap:break-word; margin:auto"
                  >{{setMed(item.medicine_generic + ";" +item.strength+";" +item.qty +";" +item.unit+";" +item.qty_missing ,item.remark)}}</p>
                </template>
              </v-data-table>
            </v-col>
          </v-row>
        </v-card>
      </v-dialog>

      <v-row>
        <v-col align="left" style="font-size:25px">ยืนยันรับออร์เดอร์จากโรงพยาบาล</v-col>
      </v-row>

      <!-- data-transport_order -->
      <v-data-table
        :headers="headers"
        :items="transfer_order"
        :items-per-page="10"
        class="elevation-1"
        @click:row="selectItem"
      >
        <template v-slot:item.transport_date="{item}">{{setDate(item.transport_date)}}</template>
        <template v-slot:item.receive_date="{item}">{{setDate(item.receive_date)}}</template>
        <template v-slot:item.name="{item}">{{item.name}} {{item.surname}}</template>
        <template v-slot:item.status="{item}">
          <v-chip :color="getColor(item.status)">{{setStatus(item.status)}}</v-chip>
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
      dialog_row: false,
      transfer_order: [{ status: "" }],
      each_order: [],
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
          value: "qty_orders",
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
        {
          text: "ชื่อผู้รับ",
          align: "center",
          value: "name",
          divider: true
        },
        { text: "สถานะ", align: "center", value: "status", divider: true }
      ],
      sub_headers: [
        {
          text: "เลขออร์เดอร์",
          align: "left",
          value: "order_id",
          divider: true
        },
        {
          text: "ชื่อ-นามสกุลผู้ป่วย",
          align: "center",
          value: "name",
          divider: true
        },
        {
          text: "วันที่สร้างออร์เดอร์",
          align: "center",
          value: "create_date",
          divider: true
        },
        {
          text: "วันนัดรับยา",
          align: "center",
          value: "due_date",
          divider: true
        },
        { text: "ข้อมูลยา", align: "center", value: "medicine", divider: true },
        { text: "หมายเหตุ", align: "center", value: "remark", divider: true }
      ],
      date: "",
      pharmacy_id: null
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
  },
  methods: {
    setStatus: function(s) {
      if (s === "transport") {
        s = "กำลังจัดส่ง";
      } else if (s === "received") {
        s = "ได้รับเรียบร้อยแล้ว";
      }
      return s;
    },
    setMed: function(m, remark) {
      if (m != null) {
        var med_detail = m.split(";");
        var med_name = med_detail[0];
        var med_name2 = med_name.split(",");
        var med_strength = med_detail[1];
        var med_strength2 = med_strength.split(",");
        var med_qty = med_detail[2];
        var med_qty2 = med_qty.split(",");
        var med_unit = med_detail[3];
        var med_unit2 = med_unit.split(",");
        var med_qty_missing = med_detail[4];
        var med_qty_missing2 = med_qty_missing.split(",");

        var med_show = "";
        for (var i = 0; i < med_name2.length; i++) {
          var qty = 0;
          if (med_qty_missing2[i] != "NULL") {
            qty = med_qty_missing2[i];
          } else qty = med_qty2[i];
          if (
            (remark == "ยาขาด" && med_qty_missing2[i] > 0) ||
            remark != "ยาขาด"
          ) {
            if (i === med_name2.length - 1) {
              med_show +=
                med_name2[i] +
                " " +
                med_strength2[i] +
                " " +
                qty +
                " " +
                med_unit2[i];
            } else {
              med_show +=
                med_name2[i] +
                " " +
                med_strength2[i] +
                " " +
                qty +
                " " +
                med_unit2[i] +
                "\n";
            }
          }
        }
        return med_show;
      }
    },
    setDate: function(d) {
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
        return "#E1995E";
      } else if (status == "received") return "#75C3AE";
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
