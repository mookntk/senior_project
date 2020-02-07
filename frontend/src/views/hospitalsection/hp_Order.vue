<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main">
      <v-row>
        <v-col align="left" style="font-size:25px">{{date}}</v-col>
        <v-spacer></v-spacer>
        <v-col>
          <v-select
            :items="pharmacy"
            chips
            label="เลือกร้านขายยา"
            multiple
            solo
            clearable
            @change="selectpharmacy"
          ></v-select>
        </v-col>
        <v-col cols="12" sm="1" md="1" justify="right" align="right">
          <v-btn color="primary" x-large dark v-on="on" @click="prepare_medicine">ทำการจัดยา</v-btn>
        </v-col>
      </v-row>
      <!-- //! dialog edit -->
      <v-dialog v-model="dialog_edit" persistent max-width="700px">
        <v-card class="blue-grey lighten-5 font">
          <v-card-title>
            <span>แก้ไขข้อมูล</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field v-model="editedItem.patient" label="ชื่อ-นามสกุล" outlined readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="8">
                  <v-text-field label="ร้านขายยา" outlined v-model="editedItem.name" readonly></v-text-field>
                </v-col>
              </v-row>
              <v-row v-for="(item,subindex) in editedItem.medicine" :key="item">
                <v-col cols="12" sm="7">
                  <v-text-field
                    v-model="editedItem.medicine[subindex].name"
                    outlined
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="3">
                  <v-text-field v-model="editedItem.medicine[subindex].qty" outlined></v-text-field>
                </v-col>
                <v-col cols="12" sm="2">
                  <v-label>{{editedItem.medicine[subindex].unit}}</v-label>
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn rounded color="green lighten-1" large @click="save">เสร็จสิ้น</v-btn>
            <v-btn @click="close" rounded color="red lighten-1" large>ปิด</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <!-- //! table of order -->
      <v-data-table
        :headers="headers"
        :items="order_filter"
        :items-per-page="10"
        class="elevation-1"
        hide-default-header
      >
        <template v-slot:header="{props}">
          <tr>
            <th>
              <v-checkbox primary hide-details label="เลือกทั้งหมด" v-model="selectAll_order"></v-checkbox>
            </th>
            <th
              v-for="header in props.headers"
              :key="header.text"
              style="text-align:center"
            >{{ header.text }}</th>
          </tr>
        </template>
        <!-- <template v-slot:header="{props}">
          <tr>
            <th>
              <v-checkbox primary></v-checkbox>
            </th>
            <th v-for="header in props.headers" :key="header.text" style="text-align:center">
              <v-icon small>arrow_upward</v-icon>
              {{ header.text }}
            </th>
          </tr>
        </template>-->
        <template v-slot:body="{ items }">
          <tbody v-for="item in items"
              :key="item.name"
              :class="{'selectedRow': item === selectedItem}">
            <tr>
              <td :rowspan="item.medicine.length" style="vertical-align: middle">
                <v-checkbox primary hide-details v-model="item.checkbox"></v-checkbox>
              </td>
              <td :rowspan="item.medicine.length"  style="text-align:center">{{ item.order_id }}</tdrowspan="2">
              <td :rowspan="item.medicine.length" style="text-align:center">{{ item.patient }}</td>
              <td :rowspan="item.medicine.length" style="text-align:center">{{ item.create_date }}</td>
              <td :rowspan="item.medicine.length" style="text-align:center">{{ item.name }}</td>
              <td>
              <p v-for="medicine in item.medicine"
              :key="medicine.name" >{{ medicine.name }} {{medicine.qty}} {{medicine.unit}}</p>
              </td>
              <td rowspan="2" style="text-align:center">
                <v-icon small class="mr-2" @click="editItem(item)">mdi-pencil</v-icon>
                <v-icon small class="mr-2" @click="deleteItem(item)">mdi-delete</v-icon>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>
      <br />

      <!-- //! table of missing medicine -->
      <v-col align="left" style="font-size:25px">ออร์เดอร์ที่ยาขาด</v-col>
      <v-data-table
        :headers="headers_missing"
        :items="order_missing_filter"
        :items-per-page="10"
        class="elevation-1"
        hide-default-header
      >
        <template v-slot:header="{props}">
          <tr>
            <th>
              <v-checkbox primary hide-details label="เลือกทั้งหมด" v-model="selectAll_missing"></v-checkbox>
            </th>
            <th
              v-for="header in props.headers"
              :key="header.text"
              style="text-align:center"
            >{{ header.text }}</th>
            <!-- <th v-for="header in props.headers" :key="header.text">{{ header.text }}</th> -->
          </tr>
        </template>
        <template v-slot:body="{ items }">
          <tbody v-for="item in items"
              :key="item.name">
            <tr 
            >
              <td :rowspan="item.medicine.length" >
                <v-checkbox primary hide-details v-model="item.checkbox"></v-checkbox>
              </td>
              <td :rowspan="item.medicine.length" style="text-align:center">{{ item.order_id }}</td>
              <td :rowspan="item.medicine.length" style="text-align:center">{{ item.patient }}</td>
              <td :rowspan="item.medicine.length" style="text-align:center">{{ item.create_date }}</td>
              <td :rowspan="item.medicine.length" style="text-align:center">{{ item.name }}</td>
              <td>
              <p v-for="medicine in item.medicine"
              :key="medicine.name">{{ medicine.name }} {{medicine.qty}} {{medicine.unit}}</p>
              </td>
            </tr>
            <!-- <tr v-for="item in items"
              :key="item.name">
              <td>
              <p v-for="medicine in item.medicine"
              :key="medicine.name" style="text-align:center">{{ medicine.name }}</p>
              </td>
         
            </tr> -->
          </tbody>
        </template>
      </v-data-table>
    </v-content>
  </v-app>
</template>

<script>
// import ConnectDatabase from '../server/server'
import axios from "axios";
import Menu from "../../components/hp_menubar";
export default {
  data() {
    return {
      picker: new Date().toISOString().substr(0, 10),
      date: "",
      selectedItem: "",
      order_selected: "",
      editedItem: "",
      index: 0,
      dialog_edit: false,
      selectAll_order: false,
      selectAll_missing: false,
      pharmacy: [
        "บ้านเภสัชกร",
        "ลิขิตฟาร์มาซี",
        "ร้านฟาร์มาซี สาย2",
        "เวิลด์ ฟาร์มาซี",
        "ซิตี้ฟาร์มาซี"
      ],
      headers: [
        // {
        //   text: " ",
        //   align: "left",
        //   sortable: false,
        //   value: "name"
        // },
        {
          text: "เลขออร์เดอร์",
          align: "center",
          sortable: false,
          value: "name"
        },
        { text: "ชื่อ-นามสกุลผู้ป่วย", align: "center", value: "order" },
        { text: "วันที่สร้างออร์เดอร์", align: "center", value: "order" },
        { text: "ร้านขายยา", align: "center", value: "order" },
        { text: "ยาที่ได้รับ", align: "center", value: "order" },
        { text: "แก้ไข/ยกเลิก", align: "center", value: "status" }
      ],
      headers_missing: [
        {
          text: "เลขออร์เดอร์",
          align: "center",
          sortable: false,
          value: "name"
        },
        { text: "ชื่อ-นามสกุลผู้ป่วย", align: "center", value: "order" },
        { text: "วันที่สร้างออร์เดอร์", align: "center", value: "order" },
        { text: "ร้านขายยา", align: "center", value: "order" },
        { text: "ยาที่ได้รับ", align: "center", value: "order" }
      ],
      order: [
        {
          order_id: 234,
          name: "บ้านเภสัชกร",
          patient: "วันชัย ศุภจตุรัส",
          create_date: "20 กรกฏาคม 2562",
          receive_date: "22 กรกฎาคม 2562",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Aspirin",
              qty: 1,
              unit: "tablet"
            },
          ],
          orders: [
            {
              order_id: 1,
              name: "วันชัย ศุภจตุรัส",
              create_date: "7 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "2 มีนาคม 2562",
              due_date: "9 มีนาคม 2562"
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              create_date: "7 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            }
          ],
          status: "หยุดชั่วคราว"
        },
        {
          order_id: 309,
          name: "ลิขิตฟาร์มาซี",
          patient: "สุกรี ฉัตรรัตนกุลชัย",
          create_date: "22 กรกฎาคม 2562",
          receive_date: "",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Tiffy",
              qty: 3,
              unit: "tablet"
            },
            { tmt: "1234", name: "Sara", qty: 3, unit: "tablet" },
            { tmt: "1234", name: "Aspirin", qty: 2, unit: "tablet" },
          ],
          orders: [
            {
              order_id: 2,
              name: "สุกรี ฉัตรรัตนกุลชัย",
              create_date: "7 กันยายน 2562",
              due_date: "12 กันยายน 2562"
            },
            {
              order_id: 5,
              name: "สมาน พิทยาพิบูลพงศ์",
              create_date: "10 มีนาคม 2562",
              due_date: "20 มีนาคม 2562"
            },
            {
              order_id: 11,
              name: "วิชัย วิทุรวงศ์",
              create_date: "15 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            },
            {
              order_id: 39,
              name: "นภาพรรณ วัฒนประดิษฐ",
              create_date: "7 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            },
            {
              order_id: 40,
              name: "เฉลิม ศรีเมือง",
              create_date: "7 มกราคม 2562",
              due_date: "15 มกราคม 2562"
            }
          ],
          status: "รอการจัดยา"
        },
        {
          order_id: 801,
          name: "ร้านฟาร์มาซี สาย2",
          patient: "เอก เวสโกสิทธิ์",
          create_date: "15 มีนาคม 2562",
          receive_date: "18 มีนาคม 2562",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Paracetamol",
              qty: 3,
              unit: "tablet"
            },
            { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" }
          ],

          orders: [
            {
              order_id: 1,
              name: "วันชัย ศุภจตุรัส",
              create_date: "7 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "1 มีนาคม 2562",
              due_date: "9 มีนาคม 2562"
            }
          ],
          status: "หยุดชั่วคราว"
        },
        {
          order_id: 227,
          name: "เวิลด์ ฟาร์มาซี",
          patient: "สลิลลา พิทยาพิบูลพงศ์",
          create_date: "22 กรกฎาคม 2562",
          receive_date: "",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Aspirin",
              qty: 2,
              unit: "tablet"
            },
            { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
          ],
          orders: [
            {
              order_id: 1,
              name: "นภาพรรณ วิทุรวงศ์",
              create_date: "5 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "5 ตุลาคม 2562",
              due_date: "9 มีนาคม 2562"
            },
            {
              order_id: 15,
              name: "สลิลลา พิทยาพิบูลพงศ์",
              create_date: "5 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            },
            {
              order_id: 15,
              name: "สุทธิพงศ์ ภัทรมังกร",
              create_date: "5 สิงหาคมม 2562",
              due_date: "30 สิงหาคม 2562"
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              create_date: "5 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            }
          ],
          status: "รอการจัดส่ง"
        },
        {
          order_id: 456,
          name: "ซิตี้ฟาร์มาซี",
          patient: "สุทธิพงศ์ ภัทรมังกร",
          create_date: "25 กรกฏาคม 2562",
          receive_date: "",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Apracur",
              qty: 3,
              unit: "tablet"
            }
          ],
          orders: [
            {
              order_id: 1,
              name: "สุทธิพงศ์ ภัทรมังกร",
              create_date: "10 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "5 มีนาคม 2562",
              due_date: "9 มีนาคม 2562"
            },
            {
              order_id: 15,
              name: "เฉลิม วัฒนประดิษฐ",
              create_date: "15 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            }
          ],
          status: "กำลังจัดส่ง"
        }
      ],
      order_missing: [
        {
          order_id: 234,
          name: "บ้านเภสัชกร",
          patient: "วันชัย ศุภจตุรัส",
          create_date: "20 กรกฏาคม 2562",
          receive_date: "22 กรกฎาคม 2562",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Sara",
              qty: 4,
              unit: "tablet"
            },
            { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" },
            { tmt: "1234", name: "Paracetamol", qty: 3, unit: "tablet" }
          ],
          orders: [
            {
              order_id: 1,
              name: "วันชัย ศุภจตุรัส",
              create_date: "7 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "2 มีนาคม 2562",
              due_date: "9 มีนาคม 2562"
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              create_date: "7 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            }
          ],
          status: "หยุดชั่วคราว"
        },

        {
          order_id: 227,
          name: "เวิลด์ ฟาร์มาซี",
          patient: "สลิลลา พิทยาพิบูลพงศ์",
          create_date: "22 กรกฎาคม 2562",
          receive_date: "",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Aspirin",
              qty: 2,
              unit: "tablet"
            },
            { tmt: "1234", name: "Tiffy", qty: 2, unit: "tablet" }
          ],
          orders: [
            {
              order_id: 1,
              name: "นภาพรรณ วิทุรวงศ์",
              create_date: "5 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "5 ตุลาคม 2562",
              due_date: "9 มีนาคม 2562"
            },
            {
              order_id: 15,
              name: "สลิลลา พิทยาพิบูลพงศ์",
              create_date: "5 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            },
            {
              order_id: 15,
              name: "สุทธิพงศ์ ภัทรมังกร",
              create_date: "5 สิงหาคมม 2562",
              due_date: "30 สิงหาคม 2562"
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              create_date: "5 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            }
          ],
          status: "รอการจัดส่ง"
        },
        {
          order_id: 456,
          name: "ซิตี้ฟาร์มาซี",
          patient: "สุทธิพงศ์ ภัทรมังกร",
          create_date: "25 กรกฏาคม 2562",
          receive_date: "",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Paracetamol",
              qty: 4,
              unit: "tablet"
            },
            { tmt: "1234", name: "Sara", qty: 3, unit: "tablet" }
          ],
          orders: [
            {
              order_id: 1,
              name: "สุทธิพงศ์ ภัทรมังกร",
              create_date: "10 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562"
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "5 มีนาคม 2562",
              due_date: "9 มีนาคม 2562"
            },
            {
              order_id: 15,
              name: "เฉลิม วัฒนประดิษฐ",
              create_date: "15 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562"
            }
          ],
          status: "กำลังจัดส่ง"
        }
      ],
      order_filter: [],
      order_missing_filter: []
    };
  },
  mounted() {
    for (var i = 0; i < this.order.length; i++) {
      this.order_filter = [...this.order];
      this.order_missing_filter = [...this.order_missing];
    }
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
  components: {
    Menu
  },
  methods: {
    prepare_medicine() {
      this.$router.push("/prepare");
    },
    selectpharmacy(item) {
      if (item.length == 0) {
        this.order_filter = [...this.order];
        this.order_missing_filter = [...this.order_missing];
      } else {
        this.order_filter = this.order.filter(store => {
          for (var i in item) {
            if (store.name == item[i]) return true;
          }
        });
        this.order_missing_filter = this.order_missing.filter(store => {
          for (var i in item) {
            if (store.name == item[i]) return true;
          }
        });
      }
    },
    deleteItem(item) {
      console.log("delete item");
      const index = this.order.indexOf(item);
      confirm(
        "คุณต้องการที่จะลบออร์เดอร์ใช่หรือไม่?\nคุณ" + item.patient + " "
      ) && this.order.splice(index, 1);
    },
    editItem(item) {
      this.index = this.order.indexOf(item);
      //   this.editedIndex = this.order.indexOf(item);
      this.order_selected = item.name;
      this.editedItem = Object.assign({}, item);
      this.dialog_edit = true;
    },
    save() {
      if (this.index > -1) {
        Object.assign(this.order[this.index], this.editedItem);
      } else {
        this.order.push(this.editedItem);
      }
      this.close();
    },
    close() {
      this.dialog_edit = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    }
  },
  watch: {
    selectAll_order() {
      var count = 0;
      var i;
      if (this.selectAll_order == true) {
        for (let key in this.order_filter) {
          if (this.order_filter.hasOwnProperty(key)) {
            this.order_filter[key].checkbox = true;
          }
        }
      } else {
        for (let key in this.order_filter) {
          if (this.order_filter.hasOwnProperty(key)) {
            this.order_filter[key].checkbox = false;
          }
        }
      }
    },
    selectAll_missing() {
      var count = 0;
      var i;
      if (this.selectAll_missing == true) {
        console.log("selectAll true");
        for (let key in this.order) {
          if (this.order_missing.hasOwnProperty(key)) {
            this.order_missing[key].checkbox = true;
          }
        }
      } else {
        for (let key in this.order) {
          if (this.order_missing.hasOwnProperty(key)) {
            this.order_missing[key].checkbox = false;
          }
        }
      }
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