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
              <v-btn dark text @click="changestatus">{{formtitle}}</v-btn>
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
                  <tbody v-for="item in items" :key="item.name">
                    <tr>
                      <td :rowspan="item.medicine.length">{{ item.order_id }}</td>
                      <td :rowspan="item.medicine.length" style="text-align:center">{{ item.name }}</td>
                      <td
                        :rowspan="item.medicine.length"
                        style="text-align:center"
                      >{{ item.create_date }}</td>
                      <td
                        :rowspan="item.medicine.length"
                        style="text-align:center"
                      >{{ item.due_date }}</td>
                      <td>
                        <p
                          v-for="medicine in item.medicine"
                          :key="medicine.name"
                        >{{ medicine.name }} {{medicine.qty}} {{medicine.unit}}</p>
                      </td>
                    </tr>
                  </tbody>
                </template>
              </v-data-table>
            </v-col>
          </v-row>
          <v-row style="margin:20px">
            <v-list subheader two-line flat class="font">
              <v-header>จำนวนยาทั้งหมด</v-header>
              <v-list-item-group v-model="settings" multiple>
                <v-list-item>
                  <template v-slot:default="{ active, toggle }">
                    <v-list-item-action>
                      <v-checkbox v-model="active" color="primary" @click="toggle"></v-checkbox>
                    </v-list-item-action>

                    <v-list-item-content>
                      <v-list-item-title>Enalapril 20 mg 20 tablet</v-list-item-title>
                    </v-list-item-content>
                  </template>
                </v-list-item>
              </v-list-item-group>
            </v-list>
            <!-- <v-spacer></v-spacer>
            <!-- <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn
            rounded-->
            <!-- color="success"
                dark
                @click="changestatus"
                v-if="order[index].status=='กำลังจัดส่ง'"
              >จัดยาเรียบร้อย</v-btn>
              <v-btn rounded color="grey" dark @click="dialog_row = false">ปิด</v-btn>
            </v-card-actions>-->
          </v-row>
        </v-card>
      </v-dialog>
      <v-row>
        <v-col align="left" style="font-size:25px">สถานะการจัดส่ง</v-col>
        <v-col sm="2" align="right" style="font-size:12px">
          <v-text-field
            :value="date_th"
            outlined
            @click="calendar = true"
            label="เลือกวัน/เดือน/ปี"
          ></v-text-field>
        </v-col>
      </v-row>
      <v-dialog v-model="calendar" width="300px">
        <v-row justify="space-around">
          <v-date-picker
            v-model="picker2"
            color="green lighten-1"
            header-color="primary"
            locale="th"
          ></v-date-picker>
        </v-row>
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
      picker2: "",
      calendar: false,
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
      order: [
        {
          id: 0,
          name: "บ้านเภสัชกร",
          create_date: "20 กรกฏาคม 2562",
          receive_date: "22 กรกฎาคม 2562",
          medicine: [
            {
              tmt: "1234",
              name: "Aspirin",
              qty: 1,
              unit: "tablet"
            }
          ],
          orders: [
            {
              order_id: 1,
              name: "วันชัย ศุภจตุรัส",
              create_date: "7 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
              ]
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "2 มีนาคม 2562",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Sara",
                  qty: 4,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" },
                { tmt: "1234", name: "Paracetamol", qty: 3, unit: "tablet" }
              ]
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              create_date: "7 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Sara",
                  qty: 4,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" },
                { tmt: "1234", name: "Paracetamol", qty: 3, unit: "tablet" }
              ]
            }
          ],
          status: "ได้รับยาแล้ว"
        },
        {
          id: 1,
          name: "ลิขิตฟาร์มาซี",
          create_date: "24 พฤศจิกายน 2562",
          receive_date: "",
          orders: [
            {
              order_id: 2,
              name: "สุกรี ฉัตรรัตนกุลชัย",
              create_date: "7 กันยายน 2562",
              due_date: "12 กันยายน 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Tiffy",
                  qty: 3,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 3, unit: "tablet" },
                { tmt: "1234", name: "Aspirin", qty: 2, unit: "tablet" }
              ]
            },
            {
              order_id: 5,
              name: "สมาน พิทยาพิบูลพงศ์",
              create_date: "10 มีนาคม 2562",
              due_date: "20 มีนาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Paracetamol",
                  qty: 3,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" }
              ]
            },
            {
              order_id: 11,
              name: "วิชัย วิทุรวงศ์",
              create_date: "15 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Paracetamol",
                  qty: 3,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" }
              ]
            },
            {
              order_id: 39,
              name: "นภาพรรณ วัฒนประดิษฐ",
              create_date: "7 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
              ]
            },
            {
              order_id: 40,
              name: "เฉลิม ศรีเมือง",
              create_date: "7 มกราคม 2562",
              due_date: "15 มกราคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 2, unit: "tablet" }
              ]
            }
          ],
          status: "กำลังจัดส่ง"
        },
        {
          id: 2,
          name: "ร้านฟาร์มาซี สาย2",
          create_date: "16 มีนาคม 2562",
          receive_date: "18 มีนาคม 2562",

          orders: [
            {
              order_id: 1,
              name: "วันชัย ศุภจตุรัส",
              create_date: "7 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Paracetamol",
                  qty: 3,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" }
              ]
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "1 มีนาคม 2562",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
              ]
            }
          ],
          status: "ได้รับยาแล้ว"
        },
        {
          id: 3,
          name: "เวิลด์ ฟาร์มาซี",
          create_date: "24 พฤศจิกายน 2562",
          receive_date: "",
          orders: [
            {
              order_id: 1,
              name: "นภาพรรณ วิทุรวงศ์",
              create_date: "5 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 2, unit: "tablet" }
              ]
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "5 ตุลาคม 2562",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Paracetamol",
                  qty: 3,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" }
              ]
            },
            {
              order_id: 15,
              name: "สลิลลา พิทยาพิบูลพงศ์",
              create_date: "5 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Apracur",
                  qty: 3,
                  unit: "tablet"
                }
              ]
            },
            {
              order_id: 15,
              name: "สุทธิพงศ์ ภัทรมังกร",
              create_date: "5 สิงหาคมม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Apracur",
                  qty: 3,
                  unit: "tablet"
                }
              ]
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              create_date: "5 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Paracetamol",
                  qty: 3,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" }
              ]
            }
          ],
          status: "กำลังจัดส่ง"
        },
        {
          id: 4,
          name: "ซิตี้ฟาร์มาซี",
          create_date: "24 พฤศจิกายน 2562",
          receive_date: "",
          orders: [
            {
              order_id: 1,
              name: "สุทธิพงศ์ ภัทรมังกร",
              create_date: "10 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
              ]
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "5 มีนาคม 2562",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Apracur",
                  qty: 3,
                  unit: "tablet"
                }
              ]
            },
            {
              order_id: 15,
              name: "เฉลิม วัฒนประดิษฐ",
              create_date: "15 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Paracetamol",
                  qty: 4,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 3, unit: "tablet" }
              ]
            }
          ],
          status: "กำลังจัดส่ง"
        },
        {
          id: 0,
          name: "บ้านเภสัชกร",
          create_date: "25 กรกฏาคม 2562",
          receive_date: "30 กรกฎาคม 2562",
          orders: [
            {
              order_id: 1,
              name: "วันชัย ศุภจตุรัส",
              create_date: "7 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
              ]
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "2 มีนาคม 2562",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Apracur",
                  qty: 3,
                  unit: "tablet"
                }
              ]
            },
            {
              order_id: 15,
              name: "วิชัย วิทุรวงศ์",
              create_date: "7 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
              ]
            },
            {
              order_id: 70,
              name: "วันชัย ศุภจตุรัส",
              create_date: "25 ตุลาคม 2562",
              due_date: "31 ตุลาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Paracetamol",
                  qty: 4,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 3, unit: "tablet" }
              ]
            }
          ],
          status: "ได้รับยาแล้ว"
        },
        {
          id: 1,
          name: "ลิขิตฟาร์มาซี",
          create_date: "10 มกราคม 2562",
          receive_date: "20 มกราคม 2562",
          orders: [
            {
              order_id: 2,
              name: "สุกรี ฉัตรรัตนกุลชัย",
              create_date: "7 กันยายน 2562",
              due_date: "12 กันยายน 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Sara",
                  qty: 4,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" },
                { tmt: "1234", name: "Paracetamol", qty: 3, unit: "tablet" }
              ]
            },
            {
              order_id: 5,
              name: "สมาน พิทยาพิบูลพงศ์",
              create_date: "10 มีนาคม 2562",
              due_date: "20 มีนาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
              ]
            },
            {
              order_id: 11,
              name: "วิชัย วิทุรวงศ์",
              create_date: "15 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
              ]
            },
            {
              order_id: 39,
              name: "นภาพรรณ วัฒนประดิษฐ",
              create_date: "7 สิงหาคม 2562",
              due_date: "30 สิงหาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Sara",
                  qty: 4,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 3, unit: "tablet" },
                { tmt: "1234", name: "Paracetamol", qty: 3, unit: "tablet" }
              ]
            }
          ],
          status: "ได้รับยาแล้ว"
        },
        {
          id: 2,
          name: "ร้านฟาร์มาซี สาย2",
          create_date: "20 พฤศจิกายน 2562",
          receive_date: "",

          orders: [
            {
              order_id: 1,
              name: "วันชัย ศุภจตุรัส",
              create_date: "7 ตุลาคม 2562",
              due_date: "15 ตุลาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Tiffy", qty: 2, unit: "tablet" }
              ]
            },
            {
              order_id: 3,
              name: "เอก เวสโกสิทธิ์",
              create_date: "1 มีนาคม 2562",
              due_date: "9 มีนาคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Paracetamol",
                  qty: 4,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 3, unit: "tablet" }
              ]
            },
            {
              order_id: 40,
              name: "เฉลิม ศรีเมือง",
              create_date: "7 มกราคม 2562",
              due_date: "15 มกราคม 2562",
              medicine: [
                {
                  tmt: "1234",
                  name: "Aspirin",
                  qty: 2,
                  unit: "tablet"
                },
                { tmt: "1234", name: "Sara", qty: 5, unit: "tablet" }
              ]
            }
          ],
          status: "กำลังจัดส่ง"
        }
      ],
      date: "",
      selectedpharmacy: "",
      selectedItem: ""
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
    changestatus() {
      if (this.order[this.index].status == "กำลังจัดส่ง") {
        this.order[this.index].status = "ได้รับยาแล้ว";
      } else if (this.order[this.index].status == "รอการจัดยา") {
        this.order[this.index].status = "รอการจัดส่ง";
      } else if (this.order[this.index].status == "หยุดชั่วคราว") {
        this.order[this.index].status = "รอการจัดยา";
      }
      // var day = [
      //   "วันอาทิตย์",
      //   "วันจันทร์",
      //   "วันอังคาร",
      //   "วันพุธ",
      //   "วันพฤหัสบดี",
      //   "วันศุกร์",
      //   "วันเสาร์"
      // ];
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
      // var date = new Date();
      // var date_format =
      //   date.getDate() +
      //   " " +
      //   month[date.getMonth()] +
      //   " " +
      //   (date.getFullYear() + 543);

      // this.order[this.index].receive_date = date_format;
      this.dialog_row = false;
    },
    getColor(status) {
      if (status == "หยุดชั่วคราว") return "red";
      else if (status == "รอการจัดส่ง") return "grey";
      else if (status == "รอการจัดยา") return "grey";
      else if (status == "กำลังจัดส่ง") return "orange";
      else return "green";
    },
    selectItem(item) {
      this.index = this.order.indexOf(item);
      if (item.status == "") {
      }
      this.pharmacy = item.name;
      this.dialog_row = true;
    },
    save() {
      this.dialog = false;
      var count = 0;
      var i = 0;
      var new_detail = {
        order_id: this.order_id,
        name: this.order_name + " " + this.order_surname,
        due_date: this.picker
      };
      console.log(new_detail);
      for (i = 0; i < this.order.length; i++) {
        if (this.order[i].status == "ยังไม่ได้จัดส่ง") {
          if (this.selectedpharmacy == this.order[i].name) {
            this.order[i].orders.push(new_detail);
            count++;
            console.log(this.order);
            break;
          }
        }
      }
      if (count == 0) {
        var new_order = {
          id: this.order.length,
          name: this.selectedpharmacy,
          orders: [new_detail],
          status: "ยังไม่ได้จัดส่ง"
        };
        this.order.push(new_order);
      }
      this.order_id++;
      this.order_name = "";
      this.order_surname = "";
      this.order_date = "";
    },
    selectpharmacy(e) {
      this.selectedpharmacy = e;
      console.log(this.selectedpharmacy);
    }
  },
  computed: {
    formtitle() {
      if (this.order[this.index].status == "หยุดชั่วคราว") {
        return "ได้รับยาเรียบร้อย";
      } else if (this.order[this.index].status == "รอการจัดส่ง") {
        return "จัดส่ง";
      } else if (this.order[this.index].status == "รอการจัดยา") {
        return "จัดยาเรียบร้อย";
      } else if (this.order[this.index].status == "กำลังจัดส่ง") {
        return "";
      } else if (this.order[this.index].status == "ได้รับยาแล้ว") {
        return "";
      }
    },
    date_th() {
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
      if (this.picker2 != "") {
        var date = this.picker2.split("-");
        date[0] = parseInt(date[0]) + 543;
        date = date[2] + " " + month[date[1] - 1] + " " + date[0];
        console.log(date);
        return date;
      } else return "";
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
