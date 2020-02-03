<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main">
      <v-row>
        <v-col align="left" style="font-size:25px">ชุดออร์เดอร์ที่ส่งยากลับ</v-col>
      </v-row>
      <!-- <v-row>
        <v-col align="left" style="font-size:20px">{{date}}</v-col>
      </v-row>-->
      <v-data-table :headers="headers" :items="order" :items-per-page="10" class="elevation-1">
        <template v-slot:body="{ items }">
          <tbody>
            <tr v-for="item in items" :key="item.name">
              <td style="text-align:left">{{ order.indexOf(item)+1}}</td>
              <td style="text-align:center">{{ item.create_date}}</td>
              <td style="text-align:center">{{ item.orders.length }}</td>
              <td style="text-align:center">
                <v-icon class="mr-2" @click="showdialog(item)">mdi-eye</v-icon>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>
      <v-dialog v-model="dialog_order" persistent max-width="1000px">
        <v-card class="blue-grey lighten-5 font">
          <v-card-title>
            <span>ยาที่ได้รับ</span>
          </v-card-title>
          <v-card-text>
            <v-expansion-panels multiple focusable>
              <v-expansion-panel v-for="(item,i) in order[index].orders" :key="i">
                <v-expansion-panel-header>ออร์เดอร์ที่ {{order[index].orders.indexOf(item)+1}} {{item.name}}</v-expansion-panel-header>
                <v-expansion-panel-content>
                  <br />
                  <v-label>Enalapril maleate 20 mg จำนวน 20 เม็ด</v-label>
                  <br />
                  <v-label>Metformin 500 mg จำนวน 30 เม็ด</v-label>
                </v-expansion-panel-content>
              </v-expansion-panel>
            </v-expansion-panels>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="grey" @click="dialog_order = false">ปิด</v-btn>
            <v-btn
              color="red lighten-1"
              @click="sendback"
              v-if="order[index].status!='ได้รับยาแล้ว'"
            >ส่งยากลับโรงพยาบาล</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-content>
  </v-app>
</template>
<script>
import Menu from "../../components/ph_menubar";
export default {
  data() {
    return {
      date: "",
      dialog_order: false,
      headers: [
        {
          text: "ลำดับที่",
          align: "left",
          sortable: false,
          value: "name"
        },
        { text: "วันที่จัดส่งยา", align: "center", value: "order" },
        { text: "จำนวนออร์เดอร์", align: "center", value: "order" },
        { text: "ยาที่ได้รับ", align: "center", value: "order" }
      ],
      index: 0,
      order: [
        {
          id: 0,
          name: "บ้านเภสัชกร",
          create_date: "20 กรกฏาคม 2562",
          receive_date: "22 กรกฎาคม 2562",
          orders: [
            {
              order_id: 1,
              name: "วันชัย ศุภจตุรัส",
              due_date: "15 ตุลาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              due_date: "9 มีนาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              due_date: "30 สิงหาคม 2562",
              status: "หยุดชั่วคราว"
            }
          ],
          status: "หยุดชั่วคราว"
        },
        {
          id: 1,
          name: "ลิขิตฟาร์มาซี",
          create_date: "10 กรกฏาคม 2562",
          receive_date: "",
          orders: [
            {
              order_id: 2,
              name: "สุกรี ฉัตรรัตนกุลชัย",
              due_date: "12 กันยายน 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 5,
              name: "สมาน พิทยาพิบูลพงศ์",
              due_date: "20 มีนาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 11,
              name: "วิชัย วิทุรวงศ์",
              due_date: "30 สิงหาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 39,
              name: "นภาพรรณ วัฒนประดิษฐ",
              due_date: "30 สิงหาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 40,
              name: "เฉลิม ศรีเมือง",
              due_date: "15 มกราคม 2562",
              status: "หยุดชั่วคราว"
            }
          ],
          status: "หยุดชั่วคราว"
        },
        {
          id: 2,
          name: "ร้านฟาร์มาซี สาย2",
          create_date: "15 มีนาคม 2562",
          receive_date: "18 มีนาคม 2562",

          orders: [
            {
              order_id: 1,
              name: "วันชัย ศุภจตุรัส",
              due_date: "15 ตุลาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              due_date: "9 มีนาคม 2562",
              status: "หยุดชั่วคราว"
            }
          ],
          status: "หยุดชั่วคราว"
        },
        {
          id: 3,
          name: "เวิลด์ ฟาร์มาซี",
          create_date: "11 สิงหาคม 2562",
          receive_date: "",
          orders: [
            {
              order_id: 1,
              name: "นภาพรรณ วิทุรวงศ์",
              due_date: "15 ตุลาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              due_date: "9 มีนาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 15,
              name: "สลิลลา พิทยาพิบูลพงศ์",
              due_date: "30 สิงหาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 15,
              name: "สุทธิพงศ์ ภัทรมังกร",
              due_date: "30 สิงหาคม 2562",
              status: "หยุดชั่วคราว"
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              due_date: "30 สิงหาคม 2562",
              status: "หยุดชั่วคราว"
            }
          ],
          status: "หยุดชั่วคราว"
        }
      ]
    };
  },
  methods: {
    showItem(item) {
      this.index = this.order.indexOf(item);
      this.dialog_order = true;
    },
    getColor(status) {
      if (status == "หยุดชั่วคราว") return "red";
      else if (status == "กำลังขนส่งยาคืน") return "orange";
      else return "green";
    },
    showdialog(item) {
      this.index = this.order.indexOf(item);
      this.dialog_order = true;
    },
    sendback() {
      confirm("คุณต้องการส่งชุดออร์เดอร์กลับโรงพยาบาลใช่หรือไม่?") &&
        this.order.splice(this.index, 1);
      this.dialog_order = false;
    }
  },
  components: {
    Menu
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