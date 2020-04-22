<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main font">
      <v-dialog
        v-model="dialog_detail"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card class="font">
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_detail = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title></v-toolbar-title>
            <v-spacer></v-spacer>
          </v-toolbar>
          <v-row></v-row>
          <v-row style="margin:20px">
            <v-col cols="12" sm="12">
              <v-data-table
                :items="transport_order"
                :items-per-page="10"
                class="elevation-1"
                :headers="sub_headers"
              >
                <template v-slot:item.create_date="{ item }">
                  <p style="text-align:center;margin:auto">{{ setDate(item.create_date) }}</p>
                </template>
                <template v-slot:item.due_date="{ item }">
                  <p style="text-align:center;margin:auto">{{ setDate(item.due_date) }}</p>
                </template>
                <template v-slot:item.name="{ item }">
                  <p style="text-align:center;margin:auto">{{ item.name }} {{item.surname}}</p>
                </template>
                <template v-slot:item.medicine="{ item }">
                  <td
                    style="vertical-align:middle; text-align:center; white-space:pre-wrap; word-wrap:break-word; "
                  >{{ setMed(item.medicineItem)}}</td>
                </template>
                <template v-slot:item.status="{ item }">
                  <v-chip :color="getColor(item.status)" dark>{{ setStatus(item.status) }}</v-chip>
                </template>
              </v-data-table>
            </v-col>
          </v-row>
          <v-row style="margin:20px">
            <v-list flat class="font">
              <v-header>จำนวนยาทั้งหมด</v-header>
              <template v-for="(item, i) in medicineAll">
                <v-list-item :key="i">
                  <v-list-item-content>
                    <v-list-item-title>{{item.name}} {{item.qty}} {{item.unit}}</v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </template>
            </v-list>
          </v-row>
        </v-card>
      </v-dialog>
      <v-row>
        <v-col align="left" style="font-size:25px">ประวัติการจัดส่งยา</v-col>
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
        :search="search"
        @click:row="showDetail"
      >
        <template v-slot:item.transport_date="{ item }">
          <p style="text-align:center;margin:auto">{{ setDate(item.transport_date) }}</p>
        </template>
        <template v-slot:item.receive_date="{ item }">
          <p style="text-align:center;margin:auto">{{ setDate(item.receive_date) }}</p>
        </template>
        <template v-slot:item.status="{ item }">
          <v-chip :color="getColor(item.status)" dark>{{ setStatus(item.status) }}</v-chip>
        </template>
        <template v-slot:no-data>ไม่มีออร์เดอร์ที่ถูกจัดส่ง</template>
      </v-data-table>
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
      dialog_detail: false,
      pharmacy: "",
      headers: [
        {
          text: "ชื่อร้านขายยา",
          align: "left",
          sortable: false,
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
        { text: "สถานะ", align: "center", value: "status", divider: true }
      ],
      sub_headers: [
        {
          text: "เลขออร์เดอร์",
          align: "left",
          sortable: true,
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
        { text: "สถานะ", align: "center", value: "status", divider: true }
      ],
      orders: [],
      filters: {
        status: [],
        pharmacy_name: []
      },
      default_status: [
        { text: "รอจัดยา", value: "waiting-medicine" },
        { text: "จัดยาเรียบร้อย", value: "medicine-complete" },
        { text: "รอจัดส่ง", value: "waiting-transport" },
        { text: "กำลังจัดส่ง", value: "transport" },
        { text: "ได้รับยาเรียบร้อย", value: "received" }
      ],
      search: "",
      transport_order: [],
      medicineidAll: [],
      medicineAll: [{ name: "", qty: "", unit: "" }]
    };
  },
  components: {
    Menu
  },
  mounted() {
    this.getTransportHistory();
    this.getPharmacyname();
  },
  methods: {
    getColor(status) {
      if (status == "cancel") return "red";
      else if (status == "ready") return "orange";
      else if (status == "prepare") return "grey";
      else if (status == "success") return "green";
      else if (status == "waiting-medicine") return "grey";
      else if (status == "medicine-complete") return "grey";
      else if (status == "waiting-transport") return "grey";
      else if (status == "transport") return "orange";
      else return "green";
    },
    getTransportHistory() {
      axios
        .get("http://localhost:3000/api/transport/transporthistory")
        .then(res => {
          this.orders = res.data;
        });
    },
    getPharmacyname() {
      axios.get("http://localhost:3000/api/pharmacy/showpharmacy").then(res => {
        this.pharmacy = res.data;
      });
    },
    setDate(date) {
      if (date == null) return null;
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
      date = dateFormat(date, "dd/mm/yyyy");
      var [d, m, y] = date.split("/");
      return d + " " + month[parseInt(m) - 1] + " " + (parseInt(y) + 543);
    },
    setStatus(status) {
      if (status == "waiting-medicine") return "รอจัดยา";
      else if (status == "medicine-complete") return "จัดยาเรียบร้อย";
      else if (status == "waiting-transport") return "รอจัดส่ง";
      else if (status == "transport") return "กำลังจัดส่ง";
      else if (status == "received") return "ได้รับยาเรียบร้อย";
      else if (status == "prepare") return "รอจัดยา";
      else if (status == "ready") return "พร้อมจ่ายยา";
      else if (status == "success") return "สำเร็จ";
      else if (status == "cancel") return "ยกเลิก";
    },
    showDetail(item) {
      axios
        .post("http://localhost:3000/api/transport/transport_order", {
          transport_id: item.transport_id
        })
        .then(res => {
          var transport = res.data;
          var format = [];
          var pre_orderid = null;
          this.medicineidAll = [];
          this.medicineAll = [{ id: "", name: "", qty: "", unit: "" }];
          transport.forEach((item, i) => {
            var medicine = {
              id: item.medicine_id,
              medicine_generic: item.medicine_generic,
              strength: item.strength,
              unit: item.unit,
              qty: item.qty
            };
            if (i == 0) {
              this.medicineidAll.push(item.medicine_id);
              this.medicineAll[0].id = item.medicine_id;
              this.medicineAll[0].name = item.medicine_generic;
              this.medicineAll[0].qty = item.qty;
              this.medicineAll[0].unit = item.unit;
              pre_orderid = item.order_id;
              item["medicineItem"] = [medicine];
              format.push(item);
            } else {
              if (item.order_id == pre_orderid) {
                format[format.length - 1].medicineItem.push(medicine);
              } else {
                item["medicineItem"] = [medicine];
                format.push(item);
              }
              pre_orderid = item.order_id;
              var index = this.medicineidAll.indexOf(item.medicine_id);
              if (index == -1) {
                var med = {
                  id: item.medicine_id,
                  name: item.medicine_generic,
                  qty: item.qty,
                  unit: item.unit
                };
                this.medicineidAll.push(item.medicine_id);
                this.medicineAll.push(med);
              } else {
                this.medicineAll[index].qty += parseInt(item.qty);
              }
            }
          });

          this.transport_order = [...format];
        })
        .catch(e => {
          console.log(e);
        });
      this.dialog_detail = true;
    },
    setMed(medicineItem) {
      var setmed = "";
      medicineItem.forEach(item => {
        setmed +=
          item.medicine_generic +
          " " +
          item.strength +
          " " +
          item.qty +
          " " +
          item.unit +
          "\n";
      });
      console.log(setmed);
      return setmed;
    }
  },
  computed: {
    filterOrders() {
      return this.orders.filter(d => {
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
