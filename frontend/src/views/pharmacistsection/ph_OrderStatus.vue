<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menubar />
    </div>
    <v-content class="main">
      <!-- <v-dialog v-model="dialog_row" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card>
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_row = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title>ออร์เดอร์ที่ {{order.orderid}}</v-toolbar-title>
          </v-toolbar>

          <v-card-title>
            <span class="headline"></span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field :value="order.name" label="ชื่อ-นามสกุลผู้ป่วย" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field :value="order.gender" label="เพศ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="4">
                  <v-text-field :value="order.age" label="อายุ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="8">
                  <v-text-field :value="order.dob" label="วัน/เดือน/ปีเกิด" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="4" md="6">
                  <v-text-field :value="order.status" label="สถานะ" filled readonly></v-text-field>
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12">กรอกข้อมูลผู้ป่วย</v-col>
                <v-col>
                  <v-text-field cols="12" label="น้ำหนัก" filled clearable></v-text-field>
                </v-col>
                <v-col>
                  <v-text-field cols="12" label="ส่วนสูง" filled clearable></v-text-field>
                </v-col>
                <v-col>
                  <v-text-field cols="12" label="ความดัน" filled clearable></v-text-field>
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12">ยาที่ต้องได้รับ</v-col>
                <v-col cols="12">
      <p>{{ selected }}</p>-->
      <!-- <v-checkbox
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
            <v-btn
              rounded
              color="success"
              dark
              text
              @click="successItem(item)"
            >ผู้ป่วยรับยาเรียบร้อย</v-btn>

            <v-btn rounded color="warning" dark text @click="dialog_row = false">ยกเลิก</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>-->

      <v-dialog
        v-model="dialog_sendback"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card>
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_sendback = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title>ออร์เดอร์ที่ {{order[index].HN}}</v-toolbar-title>
          </v-toolbar>

          <v-card-title>
            <span class="headline"></span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    :value="order[index].name"
                    label="ชื่อ-นามสกุลผู้ป่วย"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field :value="order[index].gender" label="เพศ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="4">
                  <v-text-field :value="order[index].age" label="อายุ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="8">
                  <v-text-field :value="order[index].dob" label="วัน/เดือน/ปีเกิด" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="8">
                  <v-select :items="note" label="หมายเหตุ" outlined></v-select>
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
                </v-col>
                <v-row v-for="k in inputs.length" :key="k">
                  <v-col cols="8">
                    <v-select :items="lot_no" label="เลขรหัสสินค้า"></v-select>
                  </v-col>
                  <v-col cols="2">
                    <v-text-field label="จำนวน" solo clearable></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="2" md="2">
                    <v-icon
                      @click="remove(k)"
                      v-show="k || ( !k && inputs.length > 1)"
                    >mdi-minus-circle</v-icon>
                    <v-icon @click="add(k)" v-show="k == inputs.length">mdi-plus-circle</v-icon>
                  </v-col>
                </v-row>
                <v-col cols="12">
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
            <v-btn rounded large color="success" dark @click="sendback_confirm()">ส่งยาคืนโรงพยาบาล</v-btn>

            <v-btn rounded large color="warning" dark @click="dialog_sendback = false">ยกเลิก</v-btn>
          </v-card-actions>
          <!-- table in pop-up page for see each of order detial -->
        </v-card>
      </v-dialog>

      <!-- //! select button -->
      <v-layout>
        <v-flex d-flex xs12 sm6 md4>
          <v-layout column align-end justify-start>
            <v-btn
              width="200px"
              class="blue-grey lighten-3"
              value="ทั้งหมด"
              @click="sortdata"
            >ออร์เดอร์ทั้งหมด</v-btn>
            <v-btn
              width="200px"
              class="green lighten-1"
              value="สำเร็จ"
              @click="sortdata"
            >ออร์เดอร์ที่สำเร็จแล้ว</v-btn>
            <v-btn
              width="200px"
              class="gray lighten-1"
              value="ไม่พร้อมจ่ายยา"
              @click="sortdata"
            >ออร์เดอร์ที่ไม่พร้อมจ่ายยา</v-btn>
            <v-btn
              width="200px"
              class="orange lighten-1"
              value="คืนยาบางส่วน"
              @click="sortdata"
            >ออร์เดอร์ที่คืนบางส่วน</v-btn>

            <v-btn
              width="200px"
              class="red lighten-1"
              value="ยกเลิก"
              @click="sortdata"
            >ออร์เดอร์ที่ต้องยกเลิก</v-btn>
          </v-layout>
        </v-flex>
        <v-flex class="pr-4">
          <!-- //! data table -->
          <v-card class="red" height="100%" width="1080px">
            <v-data-table
              :headers="headers"
              :items="order_filter"
              :search="search"
              sort-by="status"
              class="elevation-1"
            >
              <template v-slot:item.status="{ item }">
                <v-chip :color="getColor(item.status)" dark>{{ item.status }}</v-chip>
              </template>
              <template v-slot:top>
                <v-toolbar flat>
                  <v-spacer></v-spacer>
                  <v-text-field
                    v-model="search"
                    append-icon="mdi-magnify"
                    label="Search"
                    single-line
                    hide-details
                    clearable
                  ></v-text-field>
                </v-toolbar>
              </template>
              <template v-slot:body="{ items }">
                <tbody>
                  <tr v-for="item in items" :key="item.HN">
                    <td style="text-align:center">{{ item.HN }}</td>
                    <td style="text-align:left">{{ item.name }}</td>
                    <td style="text-align:left">{{ item.surname }}</td>
                    <td style="text-align:left">{{ item.duedate }}</td>
                    <td style="text-align:left">
                      <v-chip :color="getColor(item.status)" dark>{{ item.status }}</v-chip>
                    </td>
                    <td style="text-align:left">
                      <v-btn
                        color="primary"
                        @click="getindex_cancel(item)"
                        v-if="item.status=='ยกเลิก'||item.status=='คืนยาบางส่วน'"
                      >ส่งยากลับ</v-btn>
                    </td>
                  </tr>
                </tbody>
              </template>
            </v-data-table>
          </v-card>
        </v-flex>
      </v-layout>
    </v-content>
  </v-app>
</template>

<script>
import Menubar from "../../components/ph_menubar";
export default {
  components: {
    Menubar
  },
  mounted() {
    var today = new Date();
    this.date_now = today;
    // this.date_now = today.getDate()+"/"+today.getMonth()+"/"+today.getYear()
  },
  data: () => ({
    inputs: [0],
    lot_no: ["lt23413", "da451274"],
    date_now: "",
    search: "",
    dialog: false,
    dialog_sendback: false,
    headers: [
      {
        text: "HN",
        align: "left",
        value: "HN"
      },
      { text: "ชื่อ", value: "name" },
      { text: "นามสกุล", value: "surname" },
      { text: "วันที่ต้องมารับยา", value: "duedate" },
      { text: "สถานะ", value: "status" },
      { text: " ", value: "status" }
      // ,
      // { text: "Actions", value: "action", sortable: false }
    ],
    order: [],
    order_filter: [],
    note: ["ผู้ป่วยไม่มารับ", "ยามีปัญหา", "ผู้ป่วยได้รับยาไปบางส่วน"],
    editedIndex: -1,
    editedItem: {
      name: "",
      calories: 0,
      fat: 0,
      status: 0
    },
    defaultItem: {
      name: "",
      calories: 0,
      fat: 0,
      status: 0
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
    },
    dialogdetail(val) {
      val || this.close();
    }
  },
  created() {
    this.initialize();
  },
  methods: {
    add(index) {
      console.log("index=" + index);
      this.inputs.push(2);
    },
    remove(index) {
      this.inputs.splice(index, 1);
    },
    dialog: function(e) {
      alert(e.currentTarget);
    },
    dialogdetail: function(e) {
      alert(e.currentTarget);
    },
    logout: function() {
      localStorage.setItem("login", "false");
      console.log(localStorage.getItem("login"));
      this.$router.push("/");
    },
    sortdata: function(e) {
      console.log(e.currentTarget.value);

      if (e.currentTarget.value == "ทั้งหมด") {
        this.order_filter = [...this.order];
      } else {
        this.order_filter = this.order.filter(item => {
          for (var i in item) {
            if (item.status == e.currentTarget.value) return true;
          }
        });
      }
    },
    getColor(status) {
      if (status == "ยกเลิก") return "red";
      else if (status == "คืนยาบางส่วน") return "orange";
      else if (status == "ไม่พร้อมจ่ายยา") return "light gray";
      else return "green";
    },
    initialize() {
      this.order = [
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
          duedate: "11/10/2562",
          status: "ยกเลิก",
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
          duedate: "11/10/2562",
          status: "ไม่พร้อมจ่ายยา",
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
          duedate: "15/10/2562",
          status: "สำเร็จ",
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
          duedate: "17/10/2562",
          status: "สำเร็จ",
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
          duedate: "18/10/2562",
          status: "ยกเลิก",
          orderid: "0011254009",
          weight: "",
          height: "",
          blood: ""
        },
        {
          HN: "0033754",
          name: "ภาคิน",
          surname: "วัฒนพิพัฒน์",
          age: 78,
          gender: "ชาย",
          dob: "31 ตุลาคม 2484",
          email: "phakin@hotmail.com",
          phone: "0886048834",
          pharmacy: "ร้านฟาร์มาซี สาย2",
          duedate: "18/10/2562",
          status: "คืนยาบางส่วน",
          orderid: "003375521",
          weight: "",
          height: "",
          blood: ""
        },
        {
          HN: "0030964",
          name: "อำนวย",
          surname: "วิไกล",
          age: 34,
          gender: "ชาย",
          dob: "7 ธันวาคม 2528",
          email: "OOnuy@hotmail.com",
          phone: "0800066645",
          pharmacy: "ร้านฟาร์มาซีแสนดี",
          duedate: "15/12/2562",
          status: "ไม่พร้อมจ่ายยา",
          orderid: "003096422",
          weight: "",
          height: "",
          blood: ""
        },
        {
          HN: "1178403",
          name: "รัศมี",
          surname: "วิภพพา",
          age: 67,
          gender: "หญิง",
          dob: "7 กรกฎาคม 2495",
          email: "ratsamee@hotmail.com",
          phone: "0834436654",
          pharmacy: "เวิลด์ ฟาร์มาซี",
          duedate: "17/11/2562",
          status: "ยกเลิก",
          orderid: "1178403027",
          weight: "",
          height: "",
          blood: ""
        }
      ];
      this.order_filter = [...this.order];
    },
    selectItem(item) {
      var index = this.order.indexOf(item);

      if (this.order[index].status == "ready") {
        this.index = this.order;
        console.log(this.order[index]);
        this.order = item;
        this.dialog_row = true;
      }
    },
    successItem(item) {
      console.log("success order");
      console.log(this.order);
      if (this.order.status == "ready") {
        this.order.status = "success";
      }
      this.dialog_row = false;
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
        Object.assign(this.order[this.editedIndex], this.editedItem);
      } else {
        this.order.push(this.editedItem);
      }
      this.close();
    },
    getindex_cancel(item) {
      this.index = this.order.indexOf(item);
      this.dialog_sendback = true;
    },
    sendback_confirm() {
      confirm("คุณต้องการส่งยาออร์เดอร์นี้กลับใช่หรือไม่?") &&
        this.order.splice(this.index, 1);
      this.order_filter = [...this.order];
      this.dialog_sendback = false;
    }
  }
};
</script>
<style scoped>
/* @import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.font {
  font-family: "Sarabun", sans-serif;
} */
@import url("https://fonts.googleapis.com/css?family=Prompt&display=swap");
.font {
  font-family: "Prompt", sans-serif;
}
thead {
  background-color: antiquewhite;
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