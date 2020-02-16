<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main font">
      <v-dialog v-model="dialog_row" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font">
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_row = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title>{{transportstatus[index][0].pharmacy_name}}</v-toolbar-title>
          </v-toolbar>
          <v-row></v-row>
          <v-row style="margin:20px">
            <v-col cols="12" sm="12">
              <v-data-table
                :items="transportstatus[index]"
                :items-per-page="10"
                class="elevation-1"
                :headers="sub_headers"
              >
                <template v-slot:body="{ items }">
                  <tbody>
                    <tr v-for="item in items" :key="item.order_id">
                      <td>{{ item.order_id }}</td>
                      <td style="text-align:center">{{ item.name }} {{ item.surname }}</td>
                      <td style="text-align:center">{{ item.create_date }}</td>
                      <td style="text-align:center">{{ date_format(item.due_date) }}</td>
                      <td>
                        <p
                          v-for="medicine in item.medicineItem"
                          :key="medicine.medicine_id"
                        >{{ medicine.medicine_generic }} {{medicine.qty}} {{medicine.unit}}</p>
                      </td>
                    </tr>
                  </tbody>
                </template>
              </v-data-table>
            </v-col>
          </v-row>
          <v-row style="margin:20px">
            <v-list subheader two-line flat class="font">
              <v-subheader>จำนวนยาทั้งหมด</v-subheader>
              <template v-for="(item, i) in medicineAll.qty">
                <v-list-item :key="i">
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
        <v-col align="left" style="font-size:25px">สถานะการจัดส่ง</v-col>
        <!-- <v-col sm="2" align="right" style="font-size:12px">
          <v-text-field
            :value="date_th"
            outlined
            @click="calendar = true"
            label="เลือกวัน/เดือน/ปี"
          ></v-text-field>
        </v-col>-->
        <v-col cols="12" sm="2" md="2">
          <v-autocomplete
            :items="pharmacy"
            item-text="pharmacy_name"
            outlined
            label="ร้านขายยา"
            multiple
            chips
            small-chips
            clearable
            v-model="pharmacy_selected"
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="2" md="2" align="right">
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
              v-model="datefilter"
              @input="menu2 = false"
              locale="th"
              class="font"
              no-title
            ></v-date-picker>
          </v-menu>
        </v-col>
      </v-row>
      <v-data-table :headers="headers" :items="filterItem" :items-per-page="10" class="elevation-1">
        <template v-slot:body="{ items }">
          <tbody>
            <tr v-for="item in items" :key="item.name" @click="selectItem(item)">
              <td>{{ item[0].pharmacy_name }}</td>
              <td style="text-align:center">{{ item.length }}</td>
              <td style="text-align:center">{{ date_format(item[0].transport_date) }}</td>
              <td style="text-align:center">{{ date_format(item[0].receive_date) }}</td>
              <td style="text-align:center">
                <v-chip
                  :color="getColor(item[0].transport_status)"
                  dark
                >{{ changeStatusToTH(item[0].transport_status) }}</v-chip>
              </td>
            </tr>
          </tbody>
        </template>
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
      pharmacy_selected: [],
      transportstatus: [],
      datefilter: null,
      showDate: null,
      pharmacy: [],
      medicineAll: { medicine_id: [], qty: [], lot: [[]], exp: [[]] }
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
    getColor(status) {
      if (status == "หยุดชั่วคราว") return "red";
      else if (status == "transport") return "orange";
      else if (status == "receive") return "green";
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
    }
  },
  watch: {
    datefilter() {
      if (this.datefilter != null) {
        var date = this.datefilter.split("-");
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
