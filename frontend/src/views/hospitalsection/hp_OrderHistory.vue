<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header font">
      <Menu />
    </div>
    <v-content class="main font">
      <v-row>
        <v-col cols="12" sm="3" md="3" align="left" style="font-size:25px">ประวัติการรับยา</v-col>
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
        <v-col cols="12" sm="2" md="2" align="right" class="font">
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
        @click:row="showDetail"
        :search="search"
      >
        <template v-slot:item.name="{ item }">{{ item.name }} {{item.surname}}</template>
        <template v-slot:item.create_date="{ item }">{{ setDate(item.create_date) }}</template>
        <template v-slot:item.receive_date="{ item }">{{ setDate(item.receive_date) }}</template>
        <template v-slot:item.status="{ item }">
          <v-chip :color="getColor(item.status)">{{ setStatus(item.status) }}</v-chip>
        </template>
      </v-data-table>
      <v-dialog v-model="dialog_detail" max-width="500" class="bg">
        <div class="blue-grey lighten-3" style="padding:20px">
          <v-card class="font">
            <v-card-title class="teal lighten-3 font">ยา</v-card-title>
            <v-card-text>
              <v-list v-for="item in medicine_order" :key="item">
                <v-list-item>
                  <v-list-item-action>
                    <v-checkbox disabled v-model="item.received"></v-checkbox>
                  </v-list-item-action>
                  <v-list-item-content>
                    <v-list-item-title>{{item.medicine_generic}} {{item.strength}} {{item.qty}} {{item.unit}}</v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list>
            </v-card-text>
          </v-card>
        </div>
        <v-divider></v-divider>
        <div class="blue-grey lighten-3" style="padding:20px">
          <v-card class="font">
            <v-card-title class="teal lighten-3 font">ข้อมูลการตรวจ</v-card-title>
            <v-card-text v-if="record_order.length>0">
              <!-- <v-row>
                <v-col>น้ำหนัก</v-col>
                <v-col></v-col>
              </v-row>
              <v-row>
                <v-col></v-col>
                <v-col></v-col>
              </v-row>
              <v-row>
                <v-col></v-col>
                <v-col></v-col>
              </v-row>-->
              <v-list v-for="item in record_order" :key="item">
                <v-list-item>
                  <v-list-item-content>
                    <v-list-item-title>น้ำหนัก</v-list-item-title>
                  </v-list-item-content>
                  <v-list-item-action>
                    <v-text-field disabled solo :value="item.weight"></v-text-field>
                  </v-list-item-action>
                </v-list-item>
                <v-list-item>
                  <v-list-item-content>
                    <v-list-item-title>ส่วนสูง</v-list-item-title>
                  </v-list-item-content>
                  <v-list-item-action>
                    <v-text-field disabled solo :value="item.height"></v-text-field>
                  </v-list-item-action>
                </v-list-item>
                <v-list-item>
                  <v-list-item-content>
                    <v-list-item-title>ความดันเลือด</v-list-item-title>
                  </v-list-item-content>
                  <v-list-item-action>
                    <v-text-field
                      disabled
                      solo
                      :value="item.pressure_sys+'/'+item.pressure_di"
                    >{{item}}</v-text-field>
                  </v-list-item-action>
                </v-list-item>
              </v-list>
            </v-card-text>
            <v-card-text v-if="record_order.length==0">ยังไม่ได้รับการตรวจ</v-card-text>
          </v-card>
        </div>
      </v-dialog>
    </v-content>
  </v-app>
</template>
<script>
import Menu from "../../components/hp_menubar";
import axios from "axios";
import dateFormat from "dateformat";
export default {
  data() {
    return {
      dialog_detail: false,
      pharmacy: [],
      headers: [
        {
          text: "เลขออร์เดอร์",
          align: "center",
          value: "order_id",
          divider: true
        },
        {
          text: "รหัสผู้ป่วย",
          align: "center",
          value: "patient_HN_order",
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
          text: "วันที่ผู้ป่วยมารับยา",
          align: "center",
          value: "receive_date",
          divider: true
        },
        {
          text: "ร้านขายยา",
          align: "center",
          value: "pharmacy_name",
          divider: true
        },
        { text: "สถานะ", align: "center", value: "status", divider: true },
        { text: "หมายเหตุ", align: "center", value: "remark", divider: true }
      ],
      orders: [],
      record_headers: [
        {
          text: "ลำดับที่",
          align: "right",
          sortable: true,
          value: "no"
        },
        { text: "วันที่บันทึก", align: "center", value: "date" },
        { text: "น้ำหนัก", align: "center", value: "weight" },
        { text: "ส่วนสูง", align: "center", value: "height" },
        { text: "ความดันเลือด", align: "center", value: "pressure" },
        { text: "ผู้ตรวจ", align: "center", value: "pharmacist" }
      ],
      search: "",
      default_status: [
        { text: "รอจัดยา", value: "prepare" },
        { text: "พร้อมจ่ายยา", value: "ready" },
        { text: "ไม่พร้อมจ่ายยา", value: "missing" },
        { text: "สำเร็จ", value: "success" },
        { text: "ยกเลิก", value: "cancel" }
      ],
      filters: {
        status: [],
        pharmacy_name: []
      },
      medicine_order: [],
      record_order: []
    };
  },
  components: {
    Menu
  },
  methods: {
    getColor(status) {
      if (status == "cancel") return "#C85D5C";
      else if (status == "ready") return "#E1995E";
      else if (status == "prepare") return "#bdc3c7";
      else if (status == "missing") return "#bdc3c7";
      else return "#76C3AF";
    },
    getAllOrder() {
      axios
        .get("http://localhost:3000/api/order/getorder_history")
        .then(res => {
          this.orders = res.data;
          console.log(this.orders);
        })
        .catch(e => {
          console.log(e);
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
      if (status == "prepare") return "รอจัดยา";
      else if (status == "ready") return "พร้อมจ่ายยา";
      else if (status == "success") return "สำเร็จ";
      else if (status == "missing") return "ไม่พร้อมจ่ายยา";
      else if (status == "cancel") return "ยกเลิก";
    },
    showDetail(item) {
      var order_id = item.order_id;
      console.log(order_id);

      axios
        .post("http://localhost:3000/api/order/getorder_detail", {
          order_id: order_id
        })
        .then(res => {
          this.medicine_order = res.data;
          console.log(this.medicine_order);
        })
        .catch(e => {
          console.log(e);
        });
      axios
        .post("http://localhost:3000/api/record/getrecordorder", {
          order_id: item.order_id
        })
        .then(res => {
          this.record_order = res.data;
        })
        .catch(e => {
          console.log(e);
        });
      this.dialog_detail = true;
    }
  },
  mounted() {
    this.getAllOrder();
    this.getPharmacyname();
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
td {
  text-align: center;
  vertical-align: middle;
}
</style>