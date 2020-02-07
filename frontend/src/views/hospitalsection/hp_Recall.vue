<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main">
      <v-dialog v-model="dialog_row" fullscreen hide-overlay transition="dialog-bottom-transition">
        <v-card class="font">
          <v-toolbar dark color="primary">
            <v-btn icon dark @click="dialog_row = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title>{{pharmacy}}</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn dark text @click="changestatus" v-if="!order[index].confirm">ได้รับยาเรียบร้อย</v-btn>
            </v-toolbar-items>
          </v-toolbar>
          <v-row></v-row>
          <v-row style="margin:20px">
            <v-col cols="12" sm="12">
              <v-data-table
                v-model="selected"
                :items="order[index].orders"
                :items-per-page="10"
                class="elevation-1"
                :headers="sub_headers"
              >
                <template v-slot:body="{ items }">
                  <tbody>
                    <tr v-for="item in items" :key="item.name">
                      <td>{{ item.order_id }}</td>
                      <td style="text-align:center">{{ item.name }}</td>
                      <td style="text-align:center">{{ item.due_date }}</td>

                      <td style="text-align:center">
                        <v-icon small class="mr-2" @click="selectmed(item)">mdi-eye</v-icon>
                      </td>
                    </tr>
                  </tbody>
                </template>
              </v-data-table>
            </v-col>
          </v-row>
          <v-row style="margin:20px">
            <v-list subheader two-line flat>
              <v-header>ยาที่ได้รับกลับทั้งหมด</v-header>
              <v-list-item-group v-model="settings" multiple>
                <v-list-item>
                  <template v-slot:default="{ active, toggle }">
                    <v-list-item-action>
                      <v-checkbox v-model="active" color="primary" @click="toggle"></v-checkbox>
                    </v-list-item-action>

                    <v-list-item-content>
                      <v-list-item-title>Januvia 100 mg 20 tablets</v-list-item-title>
                    </v-list-item-content>
                  </template>
                </v-list-item>

                <v-list-item>
                  <template v-slot:default="{ active, toggle }">
                    <v-list-item-action>
                      <v-checkbox v-model="active" color="primary" @click="toggle"></v-checkbox>
                    </v-list-item-action>

                    <v-list-item-content>
                      <v-list-item-title>Enalapril 20 mg 25 tablets</v-list-item-title>
                    </v-list-item-content>
                  </template>
                </v-list-item>
              </v-list-item-group>
            </v-list>
          </v-row>
        </v-card>
      </v-dialog>
      <v-row>
        <v-col align="left" style="font-size:25px">ระบบคืนยา</v-col>
      </v-row>
      <v-dialog v-model="dialog_med" persistent max-width="700px">
        <v-card class="blue-grey lighten-5 font">
          <v-card-title>
            <span>ข้อมูลยา</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-data-table
                :headers="med_headers"
                :items="order[index].orders[index_med].medicine"
                :items-per-page="10"
                class="elevation-1"
              >
                <template v-slot:body="{ items }">
                  <tbody>
                    <tr v-for="item in items" :key="item.name">
                      <td>{{ item.TMT }}</td>
                      <td style="text-align:center">{{ item.generic }}</td>
                      <td style="text-align:center">{{ item.trade }}</td>
                      <td style="text-align:center">{{ item.qty }}</td>
                      <td style="text-align:center">{{ item.unit }}</td>
                    </tr>
                  </tbody>
                </template>
              </v-data-table>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn @click="dialog_med=false" rounded color="red lighten-1" large>ปิด</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-data-table
        v-model="selected"
        :headers="headers"
        :items="order"
        :items-per-page="10"
        class="elevation-1"
      >
        <template v-slot:body="{ items }">
          <tbody>
            <tr
              v-for="item in items"
              :key="item.name"
              @click="selectItem(item)"
              :class="{'selectedRow': item === selectedItem}"
            >
              <td>{{ item.name }}</td>
              <td style="text-align:center">{{ item.orders.length }}</td>
              <td style="text-align:center">{{ item.create_date }}</td>
              <td style="text-align:center">{{ item.receive_date }}</td>
              <td style="text-align:center">
                <v-chip :color="getColor(item.status)" dark>{{ item.status }}</v-chip>
              </td>
              <td style="text-align:center">{{ item.note }}</td>
              <td style="text-align:center">
                <v-btn color="success" :disabled="item.confirm" @click="listmed">ยืนยัน</v-btn>
              </td>
            </tr>
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
      order_id: 1,
      order_name: null,
      order_surname: null,
      order_date: null,
      click: false,
      dialog: false,
      dialog_row: false,
      selected: [],
      pharmacy: "",
      index: 0,
      dialog_med: false,
      headers: [
        {
          text: "ชื่อร้านขายยา",
          align: "left",
          sortable: false,
          value: "name"
        },
        { text: "จำนวนออร์เดอร์", align: "center", value: "order" },
        { text: "วันที่สร้างออร์เดอร์", align: "center", value: "order" },
        { text: "วันที่ร้านยาได้รับ", align: "center", value: "order" },
        { text: "สถานะ", align: "center", value: "status" },
        { text: "หมายเหตุ", align: "center", value: "status" },
        { text: "ได้รับยา", align: "center", value: "status" }
      ],
      sub_headers: [
        {
          text: "เลขออร์เดอร์",
          align: "left",
          sortable: false,
          value: "name"
        },
        { text: "ชื่อ-นามสกุลผู้ป่วย", align: "center", value: "order" },
        { text: "วันรับยา", align: "center", value: "status" },
        { text: "ข้อมูลยา", align: "center", value: "status" }
      ],
      med_headers: [
        {
          text: "TMT",
          align: "left",
          sortable: false,
          value: "TMT"
        },
        { text: "ชื่อสามัญ", align: "center", value: "generic" },
        { text: "ยี่ห้อ", align: "center", value: "trade" },
        { text: "จำนวน", align: "center", value: "qty" },
        { text: "หน่วย", align: "center", value: "unit" }
      ],
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
              medicine: [
                {
                  TMT: "0000WWWW",
                  generic: "DDD",
                  trade: "DDD",
                  strenght: "400",
                  unit: "Liquid",
                  qty: 2
                }
              ]
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  TMT: "0000WWWW",
                  generic: "DDD",
                  trade: "DDD",
                  strenght: "400",
                  unit: "Liquid",
                  qty: 1
                }
              ]
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  TMT: "0000ZZZ",
                  generic: "CCC",
                  trade: "CCC",
                  strenght: "300",
                  unit: "Tablet",
                  qty: 2
                },
                {
                  TMT: "0000WWWW",
                  generic: "DDD",
                  trade: "DDD",
                  strenght: "400",
                  unit: "Liquid",
                  qty: 1
                }
              ]
            }
          ],
          status: "ยกเลิก",
          note: "ผู้ป่วยไม่มารับ",
          confirm: false
        },
        {
          id: 1,
          name: "ลิขิตฟาร์มาซี",
          create_date: "10 กรกฏาคม 2562",
          receive_date: "18 กรกฎาคม 2562",
          orders: [
            {
              order_id: 2,
              name: "สุกรี ฉัตรรัตนกุลชัย",
              due_date: "12 กันยายน 2562",
              medicine: [
                {
                  TMT: "0000XXXX",
                  generic: "AAA",
                  trade: "AAA",
                  strenght: "100",
                  unit: "Tablet",
                  qty: 3
                }
              ],
              confirm: false
            },
            {
              order_id: 5,
              name: "สมาน พิทยาพิบูลพงศ์",
              due_date: "20 มีนาคม 2562",
              medicine: [
                {
                  TMT: "0000ZZZ",
                  generic: "CCC",
                  trade: "CCC",
                  strenght: "300",
                  unit: "Tablet",
                  qty: 2
                },
                {
                  TMT: "0000WWWW",
                  generic: "DDD",
                  trade: "DDD",
                  strenght: "400",
                  unit: "Liquid",
                  qty: 1
                }
              ],
              confirm: true
            },
            {
              order_id: 11,
              name: "วิชัย วิทุรวงศ์",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  TMT: "0000XXXX",
                  generic: "AAA",
                  trade: "AAA",
                  strenght: "100",
                  unit: "Tablet",
                  qty: 3
                }
              ],
              confirm: true
            },
            {
              order_id: 39,
              name: "นภาพรรณ วัฒนประดิษฐ",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  TMT: "0000XXXX",
                  generic: "AAA",
                  trade: "AAA",
                  strenght: "100",
                  unit: "Tablet",
                  qty: 3
                }
              ],
              confirm: true
            },
            {
              order_id: 40,
              name: "เฉลิม ศรีเมือง",
              due_date: "15 มกราคม 2562",
              medicine: [
                {
                  TMT: "0000ZZZ",
                  generic: "CCC",
                  trade: "CCC",
                  strenght: "300",
                  unit: "Tablet",
                  qty: 2
                },
                {
                  TMT: "0000WWWW",
                  generic: "DDD",
                  trade: "DDD",
                  strenght: "400",
                  unit: "Liquid",
                  qty: 1
                }
              ],
              confirm: true
            }
          ],
          status: "ยกเลิก",
          note: "ผู้ป่วยไม่มารับ",
          confirm: true
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
              medicine: [
                {
                  TMT: "0000ZZZ",
                  generic: "CCC",
                  trade: "CCC",
                  strenght: "300",
                  unit: "Tablet",
                  qty: 2
                },
                {
                  TMT: "0000WWWW",
                  generic: "DDD",
                  trade: "DDD",
                  strenght: "400",
                  unit: "Liquid",
                  qty: 1
                }
              ],
              confirm: true
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  TMT: "0000XXXX",
                  generic: "AAA",
                  trade: "AAA",
                  strenght: "100",
                  unit: "Tablet",
                  qty: 3
                }
              ],
              confirm: true
            }
          ],
          status: "ยกเลิก",
          note: "ผู้ป่วยไม่มารับ",
          confirm: false
        },
        {
          id: 3,
          name: "เวิลด์ ฟาร์มาซี",
          create_date: "11 สิงหาคม 2562",
          receive_date: "15 สิงหาคม 2562",
          orders: [
            {
              order_id: 1,
              name: "นภาพรรณ วิทุรวงศ์",
              due_date: "15 ตุลาคม 2562",
              medicine: [
                {
                  TMT: "0000ZZZ",
                  generic: "CCC",
                  trade: "CCC",
                  strenght: "300",
                  unit: "Tablet",
                  qty: 2
                },
                {
                  TMT: "0000WWWW",
                  generic: "DDD",
                  trade: "DDD",
                  strenght: "400",
                  unit: "Liquid",
                  qty: 1
                }
              ],
              confirm: true
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  TMT: "0000XXXX",
                  generic: "AAA",
                  trade: "AAA",
                  strenght: "100",
                  unit: "Tablet",
                  qty: 3
                }
              ],
              confirm: true
            },
            {
              order_id: 15,
              name: "สลิลลา พิทยาพิบูลพงศ์",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  TMT: "0000XXXX",
                  generic: "AAA",
                  trade: "AAA",
                  strenght: "100",
                  unit: "Tablet",
                  qty: 3
                }
              ],
              confirm: true
            }
          ],
          status: "ยกเลิก",
          note: "ตัวยามีปัญหา",
          confirm: false
        },
        {
          id: 4,
          name: "ซิตี้ฟาร์มาซี",
          create_date: "25 กรกฏาคม 2562",
          receive_date: "29 กรกฎาคม 2562",
          orders: [
            {
              order_id: 1,
              name: "สุทธิพงศ์ ภัทรมังกร",
              due_date: "15 ตุลาคม 2562",
              medicine: [
                {
                  TMT: "0000ZZZ",
                  generic: "CCC",
                  trade: "CCC",
                  strenght: "300",
                  unit: "Tablet",
                  qty: 2
                },
                {
                  TMT: "0000WWWW",
                  generic: "DDD",
                  trade: "DDD",
                  strenght: "400",
                  unit: "Liquid",
                  qty: 1
                }
              ],
              confirm: true
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  TMT: "0000WWWW",
                  generic: "DDD",
                  trade: "DDD",
                  strenght: "400",
                  unit: "Liquid",
                  qty: 1
                }
              ],
              confirm: true
            },
            {
              order_id: 15,
              name: "เฉลิม วัฒนประดิษฐ",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  TMT: "0000ZZZ",
                  generic: "CCC",
                  trade: "CCC",
                  strenght: "300",
                  unit: "Tablet",
                  qty: 2
                }
              ],
              confirm: true
            }
          ],
          status: "ยกเลิก",
          note: "ตัวยาปัญหา",
          confirm: true
        }
      ],

      date: "",
      selectedpharmacy: "",
      selectedItem: "",
      index_med: 0
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
  },
  components: {
    Menu
  },
  methods: {
    getColor(status) {
      if (status == "หยุดชั่วคราว") return "red";
      else return "grey";
    },
    changestatus() {
      var check = confirm("ต้องการยืนยันว่าได้รับยาเรียบร้อย?");
      if (check) {
        this.order[this.index].confirm = true;
      }
      this.dialog_row = false;
    },
    listmed(item) {
      this.index = this.order.indexOf(item);
    },
    selectItem(item) {
      this.index = this.order.indexOf(item);
      // if (item.status == "") {
      // }
      this.pharmacy = item.name;
      this.dialog_row = true;
    },
    selectmed(item) {
      console.log(this.order[this.index]);
      this.index_med = this.order[this.index].orders.indexOf(item);
      console.log(this.index_med);
      // this.pharmacy = item.name;
      this.dialog_med = true;
    },
    selectpharmacy(e) {
      this.selectedpharmacy = e;
      console.log(this.selectedpharmacy);
    }
  },
  computed: {
    formtitle() {
      if (true) {
      }
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