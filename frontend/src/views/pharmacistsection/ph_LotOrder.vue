<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main font">
      <v-row>
        <v-col align="left" style="font-size:25px">รหัสสินค้า</v-col>
        <v-spacer></v-spacer>
        <v-col cols="12" sm="2" md="3" align="right">
          <v-text-field v-model="search" label="ค้นหารหัสสินค้า" solo></v-text-field>
        </v-col>
        <v-col cols="12" sm="2" md="3" align="right">
          <v-select
            :items="disease"
            item-text="disease_name"
            chips
            label="เลือกโรค"
            multiple
            solo
            v-model="filters.disease_name"
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
        <template v-slot:item.order="{item}">{{allLot.indexOf(item)+1}}</template>
        <template v-slot:item.medicine="{item}">{{item.medicine_generic}} {{item.strength}}</template>
        <template v-slot:item.exp_date="{item}">{{setDate(item.exp_date)}}</template>
        <template v-slot:no-data>ไม่มีข้อมูลรหัสสินค้า</template>
      </v-data-table>

      <v-dialog v-model="dialog_lot" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font" style="background-color:#f5f7f5">
          <v-toolbar color="#77B3D5">
            <v-btn color="#C85D5C" fab small depressed @click="dialog_lot = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title style="margin-left:15px">รหัสสินค้า {{lot_no_selected}}</v-toolbar-title>
            <v-spacer></v-spacer>
          </v-toolbar>
          <v-card-text>
            <v-row style="margin:20px">
              <v-col cols="12" sm="12">
                <v-data-table
                  :items="oneLot"
                  :items-per-page="10"
                  class="elevation-1"
                  :headers="sub_headers"
                >
                  <template v-slot:item.status="{item}">
                    <v-chip :color="getColor(item.status)">{{ setStatus(item.status) }}</v-chip>
                  </template>
                  <template v-slot:item.name="{item}">{{item.name}} {{item.surname}}</template>
                  <template v-slot:item.telno="{item}">{{setTelno(item.telno)}}</template>
                  <template v-slot:item.receive_date="{item}">{{setDate(item.receive_date)}}</template>
                  <template v-slot:no-data>ไม่มีข้อมูลผู้ป่วยที่รับรหัสสินค้านี้</template>
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
import Menu from "../../components/ph_menubar";
import dateFormat from "dateformat";
export default {
  data() {
    return {
      index: 0,
      headers: [
        {
          text: "",
          align: "right",
          value: "order",
          divider: true
        },
        {
          text: "รหัสสินค้า",
          align: "center",
          value: "lot_no",
          divider: true
        },

        { text: "จำนวน", align: "center", value: "qty", divider: true },
        {
          text: "วันหมดอายุ",
          align: "center",
          value: "exp_date",
          divider: true
        },
        {
          text: "ข้อมูลยา",
          align: "center",
          value: "medicine",
          divider: true
        },
        {
          text: "โรค",
          align: "center",
          value: "disease_name",
          divider: true
        }
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
          width: "18%"
        },
        {
          text: "เบอร์โทรศัพท์",
          align: "center",
          value: "telno",
          divider: true,
          width: "12%"
        },
        {
          text: "อีเมล",
          align: "center",
          value: "email",
          divider: true,
          width: "15%"
        },
        {
          text: "วันที่รับยา",
          align: "center",
          value: "receive_date",
          divider: true,
          width: "15%"
        },
        {
          text: "สถานะ",
          align: "center",
          value: "status",
          divider: true,
          width: "10%"
        },
        {
          text: "หมายเหตุ",
          align: "center",
          value: "remark",
          divider: true,
          width: "12%"
        },
        {
          text: "จำนวน",
          align: "center",
          value: "lot_qty",
          width: "15%"
        }
      ],
      allLot: [],
      dialog_lot: false,
      oneLot: [],
      expanded: [],
      filters: {
        disease_name: []
      },
      default_status: [
        { text: "รอจัดส่ง", value: "waiting-return" },
        { text: "กำลังจัดส่ง", value: "sending" },
        { text: "ได้รับยาเรียบร้อย", value: "received" }
      ],
      disease: [],
      search: "",
      pharmacy_id: [],
      lot_no_selected: ""
    };
  },
  components: {
    Menu
  },
  mounted() {
    axios
      .post("http://localhost:3000/api/user/getuserbyid", {
        staff_id: localStorage.getItem("staff_id")
      })
      .then(res => {
        this.pharmacy_id = res.data[0].pharmacy_id_pharmacist;
        console.log(this.pharmacy_id);
        axios
          .post("http://localhost:3000/api/lot_transfer/getallot_ph", {
            pharmacy_id: this.pharmacy_id
          })
          .then(res => {
            this.allLot = res.data;
            console.log(this.allLot);
          });
      })
      .catch(e => {
        console.log(e);
      });
    axios.get("http://localhost:3000/api/disease/getdiseases").then(res => {
      this.disease = res.data;
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
    selectItem(item) {
      this.lot_no_selected = item.lot_no;
      this.index = this.allLot.indexOf(item);
      console.log(item.lot_no_id);
      axios
        .post("http://localhost:3000/api/lot_order/getlot_byid", {
          lot_no_id: item.lot_no_id
        })
        .then(res => {
          if (res.data.length > 0) {
            this.oneLot = res.data;
          } else {
            this.oneLot = [];
          }
          this.dialog_lot = true;
        });
    }
  },
  computed: {
    filterOrders() {
      return this.allLot.filter(d => {
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