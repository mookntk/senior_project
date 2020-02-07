<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main">
      <v-row>
        <v-col cols="12" sm="6" md="6" align="left" style="font-size:25px">ประวัติการรับยา</v-col>
        <v-col cols="12" sm="6" md="6" align="right">
          <v-select
            :items="pharmacy"
            chips
            label="เลือกร้านขายยา"
            multiple
            solo
            @change="selectpharmacy"
          ></v-select>
        </v-col>
      </v-row>

      <v-dialog
        v-model="dialog_record"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card class="font">
          <v-card-title class="teal lighten-2 elevation-3">
            <v-btn icon dark @click="dialog_record = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <span>ข้อมูลผู้ป่วย</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    :value="patient_selected"
                    label="ชื่อ-นามสกุลผู้ป่วย"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field :value="patients[index].gender" label="เพศ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="4">
                  <v-text-field :value="patients[index].age" label="อายุ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="8">
                  <v-text-field
                    :value="patients[index].dob"
                    label="วัน/เดือน/ปีเกิด"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="12">
                  <v-text-field :value="patients[index].pharmacy" label="ร้านขายยา" filled readonly></v-text-field>
                </v-col>
              </v-row>
              <v-data-table :headers="record_headers" :items="patients[index].record"></v-data-table>
            </v-container>
          </v-card-text>
        </v-card>
      </v-dialog>
      <v-data-table
        :headers="headers"
        :items="select_order"
        :items-per-page="10"
        class="elevation-1"
      >
        <template v-slot:body="{ items }">
          <tbody>
            <tr v-for="item in items" :key="item.name">
              <td style="text-align:right">{{ item.order_id }}</td>
              <td style="text-align:center">{{ item.name }} {{item.surname}}</td>
              <td style="text-align:center">{{ item.create_date }}</td>
              <td style="text-align:center">{{ item.due_date }}</td>
              <td style="text-align:center">
                <v-chip :color="getColor(item.status)" dark>{{ item.status }}</v-chip>
              </td>
              <td style="text-align:center">
                <v-icon small class="mr-2" @click="showItem(item)">mdi-eye</v-icon>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>
    </v-content>
  </v-app>
</template>
<script>
import Menu from "../../components/hp_menubar";
export default {
  data() {
    return {
      dialog_record: false,
      index: 0,
      patient_selected: null,
      pharmacy: [
        "บ้านเภสัชกร",
        "ลิขิตฟาร์มาซี",
        "ร้านฟาร์มาซี สาย2",
        "เวิลด์ ฟาร์มาซี"
      ],
      headers: [
        {
          text: "เลขออร์เดอร์",
          align: "right",
          sortable: false,
          value: "hn"
        },
        { text: "ชื่อ-นามสกุลผู้ป่วย", align: "center", value: "name" },
        { text: "วันที่สร้างออร์เดอร์", align: "center", value: "email" },
        { text: "วันที่ผู้ป่วยมารับยา", align: "center", value: "pharmacy" },
        { text: "สถานะ", align: "center", value: "pharmacy" },
        { text: "ประวัติและยา", align: "center", value: "history" }
      ],
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
      patients: [
        {
          order_id: 15,
          create_date: "9 มีนาคม 2562",
          due_date: "15 มีนาคม 2562",
          status: "สำเร็จ",
          HN: "0041523",
          name: "ณัชชา",
          surname: "ยินดี",
          age: 40,
          gender: "หญิง",
          dob: "9 สิงหาคม 2522",
          email: "natcha_yindee@hotmail.com",
          phone: "0851477526",
          pharmacy: "ลิขิตฟาร์มาซี",
          record: [
            {
              no: 1,
              date: "15 มีนาคม 2562",
              weight: 60,
              height: 167,
              pressure: "130/85",
              pharmacist: "เอก เวสโกสิทธิ์"
            },
            {
              no: 2,
              date: "20 ตุลาคม 2562",
              weight: 59,
              height: 167,
              pressure: "120/83",
              pharmacist: "เอก เวสโกสิทธิ์"
            }
          ]
        },
        {
          order_id: 5,
          create_date: "15 สิงหาคม 2562",
          due_date: "22 สิงหาคม 2562",
          status: "สำเร็จ",
          HN: "0048543",
          name: "วรพรรณ",
          surname: "พุ่มประทุม",
          age: 32,
          gender: "หญิง",
          dob: "8 สิงหาคม 2530",
          email: "worrapan@gmail.com",
          phone: "0864588223",
          pharmacy: "ลิขิตฟาร์มาซี",
          record: [
            {
              no: 1,
              date: "15 มีนาคม 2562",
              weight: 60,
              height: 167,
              pressure: "130/85",
              pharmacist: "เอก เวสโกสิทธิ์"
            },
            {
              no: 2,
              date: "20 ตุลาคม 2562",
              weight: 59,
              height: 167,
              pressure: "120/83",
              pharmacist: "เอก เวสโกสิทธิ์"
            }
          ]
        },
        {
          order_id: 14,
          create_date: "20 สิงหาคม 2562",
          due_date: "",
          status: "พร้อมจ่ายยา",
          HN: "0521483",
          name: "ณัฐพล",
          surname: "ตันเสวกวงษ์",
          age: 41,
          gender: "ชาย",
          dob: "20 กุมภาพันธ์ 2521",
          email: "nattapol.t@gmail.com",
          phone: "0857773239",
          pharmacy: "บ้านเภสัชกร",
          record: [
            {
              no: 1,
              date: "15 มีนาคม 2562",
              weight: 60,
              height: 167,
              pressure: "130/85",
              pharmacist: "เอก เวสโกสิทธิ์"
            },
            {
              no: 2,
              date: "20 ตุลาคม 2562",
              weight: 59,
              height: 167,
              pressure: "120/83",
              pharmacist: "เอก เวสโกสิทธิ์"
            }
          ]
        },
        {
          order_id: 52,
          create_date: "15 สิงหาคม 2562",
          due_date: "20 สิงหาคม 2562",
          status: "สำเร็จ",
          HN: "0065893",
          name: "วริศรา",
          surname: "ใจดี",
          age: 30,
          gender: "หญิง",
          dob: "20 กรกฎาคม 2532",
          email: "ploy_warisara@hotmail.com",
          phone: "0852880026",
          pharmacy: "เวิลด์ ฟาร์มาซี",
          record: [
            {
              no: 1,
              date: "15 มีนาคม 2562",
              weight: 60,
              height: 167,
              pressure: "130/85",
              pharmacist: "เอก เวสโกสิทธิ์"
            },
            {
              no: 2,
              date: "20 ตุลาคม 2562",
              weight: 59,
              height: 167,
              pressure: "120/83",
              pharmacist: "เอก เวสโกสิทธิ์"
            }
          ]
        },
        {
          order_id: 7,
          create_date: "5 สิงหาคม 2562",
          due_date: "",
          status: "ยกเลิก",
          HN: "0011254",
          name: "ภควัตน์",
          surname: "อัศววิวัฒน์",
          age: 28,
          gender: "ชาย",
          dob: "15 กันยายน 2534",
          email: "phakawat@hotmail.com",
          phone: "0851856921",
          pharmacy: "ร้านฟาร์มาซี สาย2",
          record: [
            {
              no: 1,
              date: "20 กุมภาพันธ์ 2562",
              weight: 70,
              height: 175,
              pressure: "125/82",
              pharmacist: "สลิลลา วีระรัตน์"
            },
            {
              no: 2,
              date: "20 กันยายน 2562",
              weight: 69,
              height: 175,
              pressure: "120/80",
              pharmacist: "สลิลลา วีระรัตน์"
            },
            {
              no: 3,
              date: "15 ธันวาคม 2562",
              weight: 69,
              height: 175,
              pressure: "110/75",
              pharmacist: "สลิลลา วีระรัตน์"
            }
          ]
        },
        {
          order_id: 7,
          create_date: "5 สิงหาคม 2562",
          due_date: "",
          status: "รอการจัดยา",
          HN: "0011254",
          name: "จริน",
          surname: "จันมี",
          age: 28,
          gender: "หญิง",
          dob: "15 กันยายน 2534",
          email: "jarin@hotmail.com",
          phone: "0851856921",
          pharmacy: "ร้านฟาร์มาซี สาย2",
          record: [
            {
              no: 1,
              date: "20 กุมภาพันธ์ 2562",
              weight: 70,
              height: 175,
              pressure: "125/82",
              pharmacist: "สลิลลา วีระรัตน์"
            },
            {
              no: 2,
              date: "20 กันยายน 2562",
              weight: 69,
              height: 175,
              pressure: "120/80",
              pharmacist: "สลิลลา วีระรัตน์"
            },
            {
              no: 3,
              date: "15 ธันวาคม 2562",
              weight: 69,
              height: 175,
              pressure: "110/75",
              pharmacist: "สลิลลา วีระรัตน์"
            }
          ]
        }
      ],
      select_order: [],
      selectedpharmacy: []
    };
  },
  components: {
    Menu
  },
  methods: {
    showItem(item) {
      this.patient_selected = item.name + " " + item.surname;
      this.index = this.patients.indexOf(item);
      this.dialog_record = true;
    },
    selectpharmacy(item) {
      console.log(item.length);
      this.selectedpharmacy = item;
      if (item.length == 0) {
        this.select_order = [];
        for (var i = 0; i < this.patients.length; i++) {
          this.select_order.push(this.patients[i]);
        }
      } else {
        var count = 0;
        this.select_order = [];
        for (var i = 0; i < item.length; i++) {
          for (var j = 0; j < this.patients.length; j++) {
            if (this.patients[j].pharmacy == item[i]) {
              this.select_order.push(this.patients[j]);
            }
          }
        }
      }
    },
    getColor(status) {
      if (status == "ยกเลิก") return "red";
      else if (status == "พร้อมจ่ายยา") return "orange";
      else if (status == "รอการจัดยา") return "grey";
      else return "green";
    }
  },
  mounted() {
    for (var i = 0; i < this.patients.length; i++) {
      this.select_order.push(this.patients[i]);
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