<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>
    <v-content class="main">
      <v-dialog v-model="dialog_row" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font">
          <!-- tool-bar -->
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_row = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title>ออร์เดอร์ที่ {{oneorder.orderid}}</v-toolbar-title>
            <!-- <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn dark text @click="successItem(item)">ผู้ป่วยรับยาเรียบร้อย</v-btn>
            </v-toolbar-items>-->
          </v-toolbar>
          <!-- tool-bar -->

          <v-card-title>
            <span class="headline"></span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    :value="oneorder[index].name"
                    label="ชื่อ-นามสกุลผู้ป่วย"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field :value="oneorder[index].gender" label="เพศ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="4">
                  <v-text-field :value="oneorder[index].age" label="อายุ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="8">
                  <v-text-field
                    :value="oneorder[index].dob"
                    label="วัน/เดือน/ปีเกิด"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="4" md="6">
                  <v-text-field :value="oneorder[index].status" label="สถานะ" filled readonly></v-text-field>
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12">ยาที่ต้องได้รับ</v-col>
                <v-col cols="12">
                  <!-- <p>{{ selected }}</p> -->
                  <v-checkbox
                    v-model="selected"
                    color="success"
                    label="Enalapril maleate 20 mg จำนวน 90 เม็ด"
                    value="med1"
                  ></v-checkbox>
                  <v-checkbox
                    v-model="selected"
                    color="success"
                    label="Metformin 500 mg จำนวน 90 เม็ด"
                    value="med2"
                  ></v-checkbox>
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn rounded color="success" dark @click="successItem">จัดยาเรียบร้อย</v-btn>
            <!-- <v-btn rounded color="red" dark @click="dialog_row = false">ยกเลิกออร์เดอร์</v-btn> -->
            <v-btn rounded color="grey" dark @click="dialog_row = false">ปิด</v-btn>
          </v-card-actions>
          <!-- table in pop-up page for see each of order detial -->
        </v-card>
      </v-dialog>
      <v-dialog v-model="dialog_wait" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font">
          <!-- tool-bar -->
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_wait = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title>ออร์เดอร์ที่ {{oneorder[index].orderid}}</v-toolbar-title>
            <!-- <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn dark text @click="successItem(item)">ผู้ป่วยรับยาเรียบร้อย</v-btn>
            </v-toolbar-items>-->
          </v-toolbar>
          <!-- tool-bar -->

          <v-card-title>
            <span></span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field :value="oneorder.name" label="ชื่อ-นามสกุลผู้ป่วย" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field :value="oneorder.gender" label="เพศ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="4">
                  <v-text-field :value="oneorder.age" label="อายุ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="8">
                  <v-text-field :value="oneorder.dob" label="วัน/เดือน/ปีเกิด" filled readonly></v-text-field>
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12">ยาที่ต้องได้รับ</v-col>
                <v-col cols="12">
                  <!-- <p>{{ selected }}</p> -->
                  <v-checkbox
                    v-model="selected"
                    color="success"
                    label="Enalapril maleate 20 mg จำนวน 25 เม็ด"
                    value="med1"
                  ></v-checkbox>
                  <v-checkbox
                    v-model="selected"
                    color="success"
                    label="Metformin 500 mg จำนวน 25 เม็ด"
                    value="med2"
                  ></v-checkbox>
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn rounded color="success" dark @click="dialog_wait = false">จัดยาเรียบร้อย</v-btn>
            <v-btn rounded color="red" dark @click="dialog_wait = false">ยกเลิกออร์เดอร์</v-btn>
            <v-btn rounded color="grey" dark @click="dialog_wait = false">ปิด</v-btn>
          </v-card-actions>
          <!-- table in pop-up page for see each of order detial -->
        </v-card>
      </v-dialog>
      <v-row style="font-size:25px;margin:10px">{{date}}</v-row>
      <v-data-table
        v-model="selected"
        :items="oneorder"
        :items-per-page="10"
        :headers="headers"
        sort-by="name"
        class="elevation-1"
      >
        <template v-slot:body="{ items }">
          <tbody>
            <tr
              v-for="item in items"
              :key="item.HN"
              @click="selectItem(item)"
              :class="{'selectedRow': item === selectedItem}"
            >
              <td style="text-align:center">{{ item.HN }}</td>
              <td style="text-align:left">{{ item.name }} {{ item.surname }}</td>
              <td style="text-align:center">{{ item.duedate }}</td>
              <td style="text-align:center">
                <v-chip :color="getColor(item.status)" dark>{{ item.status }}</v-chip>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>
      <!-- <v-btn @click="logout">logout</v-btn> -->
    </v-content>
  </v-app>
</template>

<script>
// import ConnectDatabase from '../server/server'
import axios from "axios";
import Menubar from "../../components/ph_menubar";
export default {
  components: {
    Menubar
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
  },
  data: () => ({
    dialog_wait: false,
    date: "",
    search: "",
    headers: [
      {
        text: "HN",
        align: "center",
        value: "HN"
      },
      { text: "ชื่อ-นามสกุลผู้ป่วย", value: "name", align: "left" },
      { text: "วันนัดรับยา", value: "duedate", align: "center" },
      { text: "สถานะ", value: "status", align: "center" }
      // { text: 'Actions', value: 'action', sortable: false },
    ],
    oneorder: [],
    editedIndex: -1,
    editedItem: {
      HN: "",
      name: "",
      duedate: "",
      status: ""
    },
    defaultItem: {
      HN: "",
      name: "",
      duedate: "",
      status: ""
    },
    click: false,
    dialog: false,
    dialog_row: false,
    dialog_record: false,
    selected: [],
    index: 0
  }),
  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "New Item" : "Edit Item";
    }
  },
  watch: {
    dialog(val) {
      val || this.close();
    }
  },
  created() {
    this.initialize();
  },
  methods: {
    dialog: function(e) {
      alert(e.currentTarget);
    },
    logout: function() {
      localStorage.setItem("login", "false");
      console.log(localStorage.getItem("login"));
      this.$router.push("/");
    },
    selectItem(item) {
      this.index = this.oneorder.indexOf(item);
      console.log("selected");
      // this.oneorder = item;
      if (this.oneorder.status == "รอการจัดยา") {
        this.dialog_wait = true;
      } else {
        this.dialog_row = true;
      }
    },
    successItem() {
      console.log("success order");
      console.log(this.oneorder);
      this.oneorder.splice(this.index, 1);
      this.dialog_row = false;
    },
    getColor(status) {
      if (status == "cancel") return "red";
      else if (status == "พร้อมจ่ายยา") return "orange";
      else return "grey";
    },
    initialize() {
      this.oneorder = [
        {
          HN: "0041523",
          name: "ณัชชา",
          surname: "ยินดี",
          age: 40,
          gender: "หญิง",
          dob: "9 สิงหาคม 2522",
          email: "natcha_yindee@hotmail.com",
          phone: "0851477526",
          pharmacy: "บ้านเภสัชกร",
          duedate: "11 ตุลาคม 2562",
          status: "รอการจัดยา",
          orderid: "0041523011",
          weight: "",
          height: "",
          blood: ""
        },
        {
          HN: "0048543",
          name: "วรพรรณ",
          surname: "พุ่มประทุม",
          age: 32,
          gender: "หญิง",
          dob: "8 สิงหาคม 2530",
          email: "worrapan@gmail.com",
          phone: "0864588223",
          pharmacy: "ลิขิตฟาร์มาซี",
          duedate: "29 ตุลาคม 2562",
          status: "รอการจัดยา",
          orderid: "0048543010",
          weight: "",
          height: "",
          blood: ""
        },
        {
          HN: "0521483",
          name: "ณัฐวุฒิ",
          surname: "ตันเสวกวงษ์",
          age: 41,
          gender: "ชาย",
          dob: "20 กุมภาพันธ์ 2521",
          email: "nattawut.t@gmail.com",
          phone: "0857773239",
          pharmacy: "บ้านเภสัชกร",
          duedate: "25 ตุลาคม 2562",
          status: "รอการจัดยา",
          orderid: "0521483098",
          weight: "",
          height: "",
          blood: ""
        },
        {
          HN: "0065893",
          name: "วริศรา",
          surname: "ใจดี",
          age: 30,
          gender: "หญิง",
          dob: "20 กรกฎาคม 2532",
          email: "ploy_warisara@hotmail.com",
          phone: "0852880026",
          pharmacy: "เวิลด์ ฟาร์มาซี",
          duedate: "17 ตุลาคม 2562",
          status: "รอการจัดยา",
          orderid: "0065893013",
          weight: "",
          height: "",
          blood: ""
        },
        {
          HN: "0011254",
          name: "ภควัตน์",
          surname: "อัศววิวัฒน์",
          age: 28,
          gender: "ชาย",
          dob: "15 กันยายน 2534",
          email: "phakawat@hotmail.com",
          phone: "0851856921",
          pharmacy: "ร้านฟาร์มาซี สาย2",
          duedate: "18 ตุลาคม 2562",
          status: "รอการจัดยา",
          orderid: "0011254009",
          weight: "",
          height: "",
          blood: ""
        }
      ];
    },

    editItem(item) {
      this.editedIndex = this.oneorder.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },
    deleteItem(item) {
      const index = this.oneorder.indexOf(item);
      confirm("Are you sure you want to delete this item?") &&
        this.oneorder.splice(index, 1);
    },
    close() {
      this.dialog = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    save() {
      if (this.editedIndex > -1) {
        Object.assign(this.oneorder[this.editedIndex], this.editedItem);
      } else {
        this.oneorder.push(this.editedItem);
      }
      this.close();
    }
  }
};
</script>
<style>
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.font {
  font-family: "Sarabun", sans-serif;
}
thead {
  background-color: #ffd54f;
}
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