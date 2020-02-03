<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main">
      <v-row>
        <v-col align="left" style="font-size:25px">{{date}}</v-col>
        <v-spacer></v-spacer>
        <v-col cols="12" sm="1" md="1" justify="right" align="right">
          <v-btn color="primary" x-large dark v-on="on" @click="waiting_transport">รอจัดส่ง</v-btn>
        </v-col>
      </v-row>
      <!-- //! dialog edit -->
      <v-dialog v-model="dialog_details" persistent max-width="700px">
        <v-card class="blue-grey lighten-5 font">
          <v-card-title>
            <span>ยาที่จัดส่ง</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-list class="blue-grey lighten-5 font" elevation>
                <template v-for="(item, i) in order_filter[index].orders">
                  <v-list-item :key="i">
                    <template v-slot:default="{ active, toggle }">
                      <v-list-item-content>
                        <v-list-item-title>คุณ{{item.name}}</v-list-item-title>
                      </v-list-item-content>
                      <v-list-item-action>
                        <v-btn color="red" dark @click="cancel_order(item)">ยกเลิก</v-btn>
                      </v-list-item-action>
                    </template>
                  </v-list-item>
                  <v-divider :key="i"></v-divider>
                </template>
              </v-list>
              <br />
              <br />
              <v-subheader>จำนวนยาทั้งหมด</v-subheader>
              <v-list class="blue-grey lighten-4 font">
                <template v-for="(item, i,int) in all_medicine">
                  <v-list-item :key="i">
                    <template v-slot:default="{ active, toggle }">
                      <v-list-item-action>
                        <v-checkbox primary hide-details v-model="check_medicine[int]"></v-checkbox>
                      </v-list-item-action>
                      <v-list-item-content>
                        <v-list-item-title>{{i}} {{item.qty}} แผง</v-list-item-title>
                        <v-row v-for="k in inputs.length" :key="k">
                          <v-col cols="12" sm="10" md="10">
                            <v-text-field label="เลขรหัสสินค้า" solo clearable></v-text-field>
                          </v-col>
                          <v-col cols="12" sm="2" md="2">
                            <v-icon
                              @click="remove(k)"
                              v-show="k || ( !k && inputs.length > 1)"
                            >mdi-minus-circle</v-icon>
                            <v-icon @click="add(k)" v-show="k == inputs.length">mdi-plus-circle</v-icon>
                          </v-col>
                        </v-row>
                      </v-list-item-content>
                    </template>
                  </v-list-item>
                  <v-divider :key="i"></v-divider>
                </template>
              </v-list>
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
              :style="'text-align:'+header.align"
            >{{ header.text }}</th>
          </tr>
        </template>
        <template v-slot:body="{ items }">
          <tbody>
            <tr
              v-for="item in items"
              :key="item.name"
              :class="{'selectedRow': item === selectedItem}"
            >
              <td>
                <v-checkbox primary hide-details v-model="item.checkbox"></v-checkbox>
              </td>
              <td @click="Showdetails(item)">{{ item.name }}</td>
              <td style="text-align:center" @click="Showdetails(item)">{{ item.province }}</td>
              <td style="text-align:center" @click="Showdetails(item)">{{ item.orders.length }}</td>
              <!-- <td style="text-align:center" @click="Showdetails(item)">{{ item.name }}</td> -->
              <td style="text-align:center" @click="Showdetails(item)">
                <v-chip :color="getColor(item.status)" dark>{{ item.status }}</v-chip>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>
      <br />
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
      inputs: [0, 1],
      picker: new Date().toISOString().substr(0, 10),
      date: "",
      selectedItem: "",
      order_selected: "",
      editedItem: "",
      index: 0,
      dialog_edit: false,
      selectAll_order: false,
      selectAll_missing: false,
      dialog_details: false,
      all_medicine: {},
      check_medicine: [],
      pharmacy: [
        "บ้านเภสัชกร",
        "ลิขิตฟาร์มาซี",
        "ร้านฟาร์มาซี สาย2",
        "เวิลด์ ฟาร์มาซี",
        "ซิตี้ฟาร์มาซี"
      ],
      headers: [
        {
          text: "ร้านขายยา",
          align: "left",
          sortable: false,
          value: "name"
        },
        { text: "จังหวัด", align: "center", value: "order" },
        { text: "จำนวนออร์เดอร์", align: "center", value: "order" },
        // { text: "ร้านขายยา", align: "center", value: "order" },
        { text: "สถานะ", align: "center", value: "status" }
      ],
      order: [
        {
          order_id: 234,
          name: "บ้านเภสัชกร",
          province: "นครปฐม",
          patient: "วันชัย ศุภจตุรัส",
          create_date: "20 กรกฏาคม 2562",
          receive_date: "22 กรกฎาคม 2562",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Sara",
              qty: 5,
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
          status: "รอการจัดยา"
        },
        {
          order_id: 309,
          name: "ลิขิตฟาร์มาซี",
          province: "ชลบุรี",
          patient: "สุกรี ฉัตรรัตนกุลชัย",
          create_date: "22 กรกฎาคม 2562",
          receive_date: "",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Sara",
              qty: 3,
              unit: "tablet"
            },
            { tmt: "1234", name: "Decolgen", qty: 1, unit: "tablet" }
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
          province: "กรุงเทพ",
          patient: "เอก เวสโกสิทธิ์",
          create_date: "15 มีนาคม 2562",
          receive_date: "18 มีนาคม 2562",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Tylenol",
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
          status: "รอการจัดยา"
        },
        {
          order_id: 227,
          name: "เวิลด์ ฟาร์มาซี",
          province: "นครปฐม",
          patient: "สลิลลา พิทยาพิบูลพงศ์",
          create_date: "22 กรกฎาคม 2562",
          receive_date: "",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Decolgen",
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
          status: "จัดยาเรียบร้อย"
        },
        {
          order_id: 456,
          name: "ซิตี้ฟาร์มาซี",
          province: "นครปฐม",
          patient: "สุทธิพงศ์ ภัทรมังกร",
          create_date: "25 กรกฏาคม 2562",
          receive_date: "",
          checkbox: false,
          medicine: [
            {
              tmt: "1234",
              name: "Tiffy",
              qty: 3,
              unit: "tablet"
            },
            { tmt: "1234", name: "Tylenol", qty: 3, unit: "tablet" }
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
          status: "จัดยาเรียบร้อย"
        }
      ],

      order_filter: []
    };
  },
  mounted() {
    this.order_filter = [...this.order];
    console.log(this.order_filter);
    for (var i = 0; i < this.order.length; i++) {
      for (var j = 0; j < this.order[i].medicine.length; j++) {
        if (!this.all_medicine.hasOwnProperty(this.order[i].medicine[j].name)) {
          this.all_medicine[this.order[i].medicine[j].name] = {};
          this.all_medicine[this.order[i].medicine[j].name]["qty"] = 0;
          this.all_medicine[this.order[i].medicine[j].name]["success"] = false;
          this.check_medicine.push(false);
        }
        this.all_medicine[this.order[i].medicine[j].name]["qty"] =
          this.all_medicine[this.order[i].medicine[j].name]["qty"] +
          this.order[i].medicine[j].qty;
      }
    }
    console.log("this.all_medicine");
    console.log(this.all_medicine);
    console.log(this.check_medicine);
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
    waiting_transport() {
      var check = 0;
      for (var i in this.order) {
        if (this.order[i].checkbox == true) {
          if (this.order[i].status == "จัดยาเรียบร้อย") {
            check = 1;
            this.$router.push("/waiting_transport");
          } else {
            check = 2;
            break;
          }
        }
      }
      if (check == 1) {
        this.$router.push("/waiting_transport");
      } else if (check == 0) {
        alert("เลือกร้านขายยาที่ต้องการจัดส่ง");
      } else {
        alert("ยังจัดยาไม่เสร็จ");
      }
    },
    add(index) {
      console.log("index=" + index);
      this.inputs.push(2);
    },
    remove(index) {
      this.inputs.splice(index, 1);
    },
    cancel_order(item) {
      console.log(item);
      var index = this.order_filter[this.index].orders.indexOf(item);
      confirm("คุณต้องการที่จะลบออร์เดอร์นี้ใช่หรือไม่?") &&
        this.order_filter[this.index].orders.splice(index, 1);
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
      this.dialog_details = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    Showdetails(item) {
      this.index = this.order_filter.indexOf(item);
      this.dialog_details = true;
      console.log(item);
      //! num of medicine each order
      //   this.all_medicine = {}
      //   for (var i = 0; i < this.order_filter[this.index].medicine.length; i++) {
      //     if (!this.all_medicine.hasOwnProperty(this.order_filter[this.index].medicine[i].name)) {
      //       this.all_medicine[this.order_filter[this.index].medicine[i].name] = {};
      //       this.all_medicine[this.order_filter[this.index].medicine[i].name]["qty"] = 0;
      //       this.all_medicine[this.order_filter[this.index].medicine[i].name]["success"] = false;
      //       this.check_medicine.push(false);
      //     }
      //     this.all_medicine[this.order_filter[this.index].medicine[i].name]["qty"] =
      //       this.all_medicine[this.order_filter[this.index].medicine[i].name]["qty"] +
      //       this.order[i].medicine[j].qty;
      // }
      // console.log("all medicine")
      // console.log(this.all_medicine)
      if (this.order_filter[this.index].status == "จัดยาเรียบร้อย") {
        for (var i in this.check_medicine) {
          this.check_medicine[i] = true;
        }
      } else {
        for (var i in this.check_medicine) {
          this.check_medicine[i] = false;
        }
      }
    },
    getColor(status) {
      if (status == "จัดยาเรียบร้อย") return "green";
      else return "grey";
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
    all_medicine() {
      this.all_medicine = {};
      for (var i = 0; i < this.order.length; i++) {
        for (var j = 0; j < this.order[i].medicine.length; j++) {
          if (
            !this.all_medicine.hasOwnProperty(this.order[i].medicine[j].name)
          ) {
            this.all_medicine[this.order[i].medicine[j].name] = 0;
          }
          this.all_medicine[this.order[i].medicine[j].name] =
            this.all_medicine[this.order[i].medicine[j].name] +
            this.order[i].medicine[j].qty;
        }
      }
    }
  }
};
</script>
<style>
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.font {
  font-family: "Sarabun", sans-serif;
}
th {
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