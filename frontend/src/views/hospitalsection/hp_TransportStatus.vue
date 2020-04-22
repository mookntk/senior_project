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
          <v-toolbar color="#77B3D5">
            <v-btn color="#C85D5C" fab small depressed @click="dialog_detail = false">
              <v-icon>mdi-close-thick</v-icon>
            </v-btn>
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
        <v-col align="left" style="font-size:25px">สถานะการจัดส่ง</v-col>
        <v-col cols="3" sm="3" md="2">
          <v-autocomplete
            :items="pharmacy"
            item-text="pharmacy_name"
            outlined
            label="ร้านขายยา"
            multiple
            chips
            small-chips
            clearable
            v-model="filters.pharmacy_name"
          ></v-autocomplete>
        </v-col>
        <v-col cols="3" sm="3" md="2" align="right">
          <v-select
            :items="default_status"
            chips
            small-chips
            label="เลือกสถานะ"
            multiple
            outlined
            v-model="filters.status"
          ></v-select>
        </v-col>
        <!-- <v-col cols="3" sm="3" md="3" align="right">
          <v-menu
            v-model="menu2"
            :close-on-content-click="true"
            :nudge-right="40"
            transition="scale-transition"
            offset-y
            min-width="250px"
          >
            <template v-slot:activator="{ on }">
              <v-text-field
                v-model="showDate"
                prepend-inner-icon="mdi-calendar-month"
                readonly
                clearable
                outlined
                v-on="on"
                label="เลือกวัน/เดือน/ปีที่จัดส่ง"
                class="font"
              ></v-text-field>
            </template>
            <v-date-picker
              v-model="filters.transport_date"
              @input="menu2 = false"
              locale="th"
              class="font"
              no-title
            ></v-date-picker>
          </v-menu>
        </v-col>-->
      </v-row>
      <v-data-table
        :headers="headers"
        :items="filterOrders"
        :items-per-page="10"
        class="elevation-1"
        @click:row="showDetail"
      >
        <template v-slot:item.transport_date="{ item }">
          <p style="text-align:center;margin:auto">{{ setDate(item.transport_date) }}</p>
        </template>
        <template v-slot:item.receive_date="{ item }">
          <p style="text-align:center;margin:auto">{{ setDate(item.receive_date) }}</p>
        </template>
        <template v-slot:item.status="{ item }">
          <v-chip :color="getColor(item.status)">{{ setStatus(item.status) }}</v-chip>
        </template>
        <template v-slot:no-data>ไม่มีออร์เดอร์ที่ถูกจัดส่ง</template>
      </v-data-table>
    </v-content>
  </v-app>
</template>

<script>
import axios from "axios";
import Menu from "../../components/hp_menubar";
import dateFormat from "dateformat";
export default {
  data() {
    return {
      picker2: "",
      calendar: false,
      picker: new Date().toISOString().substr(0, 10),
      dialog_row: false,
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
        { text: "ข้อมูลยา", align: "center", value: "medicine", divider: true }
      ],
      date: "",
      pharmacy_selected: [],
      transportstatus: [],
      datefilter: null,
      showDate: null,
      pharmacy: [],
      dialog_detail: false,
      filters: {
        status: [],
        pharmacy_name: []
      },
      default_status: [
        { text: "กำลังจัดส่ง", value: "transport" },
        { text: "ได้รับยาเรียบร้อย", value: "received" }
      ],
      search: "",
      medicineidAll: [],
      medicineAll: [{ name: "", qty: "", unit: "" }]
    };
  },

  mounted() {
    var day = [
      "วันอาทิตย์",
      "วันจันทร์",
      "วันอังคาร",
      "วันพุธ",
      "วันพฤหัสบดี",
      "วันศุกร์",
      "วันเสาร์"
    ];
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
      day[date.getDay()] +
      " " +
      date.getDate() +
      " " +
      month[date.getMonth()] +
      " " +
      (date.getFullYear() + 543);

    this.date = date_format;
    axios
      .get("http://localhost:3000/api/transport/transportstatus")
      .then(res => {
        this.transportstatus = res.data;
      });
    axios
      .get("http://localhost:3000/api/pharmacy/showpharmacy")
      .then(pharmacy => {
        this.pharmacy = pharmacy.data;
      });
  },
  components: {
    Menu
  },
  methods: {
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
    getColor(status) {
      if (status == "transport") return "#E1995E";
      else if (status == "received") return "#76C3AF";
    },
    setStatus(status) {
      if (status == "transport") return "กำลังจัดส่ง";
      else if (status == "received") return "ได้รับยาเรียบร้อย";
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
    },
    selectItem(item) {
      this.index = this.transportstatus.indexOf(item);
      this.allMedicine();
      this.dialog_row = true;
    },
    // selectpharmacy(e) {
    //   this.selectedpharmacy = e;
    //   console.log(this.selectedpharmacy);
    // },
    date_format(date) {
      if (date == null) return null;
      var dateformat = dateFormat(date, "dd/mm/yyyy");
      var [day, month, year] = dateformat.split("/");
      year = parseInt(year) + 543;
      return `${day}/${month}/${year}`;
    },
    changeStatusToTH(status) {
      if (status == "transport") {
        return "กำลังจัดส่ง";
      } else {
        return "ได้รับยาเรียบร้อย";
      }
    },
    allMedicine() {
      var order_selected = [...this.transportstatus[this.index]];
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
        name: name,
        qty: qty,
        unit: unit
      };
      console.log(this.medicineAll);
    }
  },
  computed: {
    date_th() {
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
      if (this.datefilter != null) {
        // var date = dateFormat(this.datefilter,"dd/mm/yyyy")
        var date = this.datefilter.split("-");
        date[0] = parseInt(date[0]) + 543;
        date = date[2] + "/" + date[1] + "/" + date[0];
        return date;
      } else return null;
    },
    filterItem() {
      if (this.showDate == null && this.pharmacy_selected.length < 1)
        return this.transportstatus;
      else if (this.showDate != null && this.pharmacy_selected.length > 0) {
        return this.transportstatus.filter((element, index) => {
          var dateformat = this.date_format(
            this.transportstatus[index][0].transport_date,
            "dd/mm/yyyy"
          );
          return (
            this.pharmacy_selected.includes(
              this.transportstatus[index][0].pharmacy_name
            ) && dateformat == this.showDate
          );
        });
      } else
        return this.transportstatus.filter((element, index) => {
          var dateformat = this.date_format(
            this.transportstatus[index][0].transport_date,
            "dd/mm/yyyy"
          );
          return (
            this.pharmacy_selected.includes(
              this.transportstatus[index][0].pharmacy_name
            ) || dateformat == this.showDate
          );
        });
    },
    filterOrders() {
      return this.transportstatus.filter(d => {
        return Object.keys(this.filters).every(f => {
          return this.filters[f].length < 1 || this.filters[f].includes(d[f]);
        });
      });
    }
  },
  watch: {
    datefilter() {
      if (this.datefilter != null) {
        var date = this.datefilter.split("-");
        date[0] = parseInt(date[0]) + 543;
        this.showDate = date[2] + "/" + date[1] + "/" + date[0];
      } else this.showDate = null;
    },
    filters() {
      if (this.filters.transport_date != null) {
        var date = this.filters.transport_date.split("-");
        date[0] = parseInt(date[0]) + 543;
        this.showDate = date[2] + "/" + date[1] + "/" + date[0];
      } else this.showDate = null;
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
.font label {
  font-size: 13px;
}
</style>
