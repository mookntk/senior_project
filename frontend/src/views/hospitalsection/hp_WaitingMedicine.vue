<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main font">
      <v-row>
        <v-col align="left" style="font-size:25px">{{date}}</v-col>
        <v-spacer></v-spacer>
        <v-col cols="12" sm="2" md="2" justify="right" align="right">
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
                <template v-for="(item, i) in order_filter[index]">
                  <v-list-item :key="i">
                    <template v-slot:default="{ active, toggle }">
                      <v-list-item-content>
                        <v-list-item-title>HN:{{item.patient_HN_order}}</v-list-item-title>
                      </v-list-item-content>
                      <v-list-item-action>
                        <v-btn color="red" dark @click="cancel_order(item)">ยกเลิก</v-btn>
                      </v-list-item-action>
                    </template>
                  </v-list-item>
                  <v-list-item two-line :key="i">
                    <v-list-item-content>
                      <v-list-item-title>คุณ{{item.name}} {{item.surname}}</v-list-item-title>
                    </v-list-item-content>
                  </v-list-item>
                  <v-divider :key="i"></v-divider>
                </template>
              </v-list>
              <br />
              <br />
              <v-subheader>จำนวนยาทั้งหมด</v-subheader>
              <v-form ref="form">
                <v-list class="blue-grey lighten-4 font">
                  <template v-for="(item, i) in medicineAll.qty">
                    <v-list-item :key="i">
                      <!-- <template v-slot:default="{ active, toggle }"> -->
                      <v-list-item-action>
                        <v-checkbox primary hide-details v-model="check_medicine[i]" disabled></v-checkbox>
                      </v-list-item-action>
                      <v-list-item-content>
                        <v-list-item-title>{{medicineAll.name[i]}} {{medicineAll.qty[i]}} {{medicineAll.unit[i]}}</v-list-item-title>
                        <v-row v-for="(item,k) in medicineAll.lot[i]" :key="i+k">
                          <!-- <v-row v-for="(item2,j) in medicineAll.lot[k]" :key="j"> -->
                          <v-col cols="12" sm="6" md="6">
                            <v-text-field
                              label="เลขรหัสสินค้า"
                              v-model="medicineAll.lot[i][k]"
                              solo
                              clearable
                            ></v-text-field>
                          </v-col>
                          <v-col cols="12" sm="6" md="6">
                            <v-text-field
                              label="วันหมดอายุ"
                              v-model="medicineAll.exp[i][k]"
                              solo
                              clearable
                              hint="DD/MM/YYYY"
                              persistent-hint
                            ></v-text-field>
                          </v-col>
                          <v-col cols="12" sm="4" md="4">
                            <v-text-field
                              label="จำนวน"
                              v-model="medicineAll.lot_qty[i][k]"
                              solo
                              clearable
                              :error-messages="errorMessage[i][k]"
                            ></v-text-field>
                          </v-col>

                          <v-col cols="12" sm="2" md="2">
                            <v-icon
                              @click="remove(i,k)"
                              v-show="k>0 || ( !k && medicineAll.lot[i].length > 1)"
                            >mdi-minus-circle</v-icon>
                            <v-icon
                              @click="add(i)"
                              v-show="k == medicineAll.lot[i].length-1"
                            >mdi-plus-circle</v-icon>
                          </v-col>
                          <!-- </v-row> -->
                        </v-row>
                      </v-list-item-content>
                      <!-- </template> -->
                    </v-list-item>
                    <v-divider :key="i"></v-divider>
                  </template>
                </v-list>
              </v-form>
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
              v-for="(item,index) in items"
              :key="item.name"
              :class="{'selectedRow': item === selectedItem}"
            >
              <td>
                <v-checkbox
                  primary
                  hide-details
                  v-model="check_order[index]"
                  v-if="item[0].transport_status=='medicine-complete'"
                ></v-checkbox>
              </td>
              <td @click="showdetail(item)">{{ item[0].pharmacy_name }}</td>
              <td style="text-align:center" @click="showdetail(item)">{{ item[0].province}}</td>
              <td style="text-align:center" @click="showdetail(item)">{{ item.length }}</td>
              <!-- <td style="text-align:center" @click="showdetail(item)">{{ item.name }}</td> -->
              <td style="text-align:center" @click="showdetail(item)">
                <v-chip :color="getColor(status[index])" dark>{{ status[index] }}</v-chip>
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
import dateFormat from "dateformat";
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
      check_order: [],
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
      order_filter: [],
      medicineAll: { medicine_id: [], qty: [], lot: [[]], exp: [[]] },
      status: [],
      errorMessage: [],
      mask: "##/##/####"
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

    //get orders that have waitinf-medicine

    this.getInfo();
  },
  components: {
    Menu
  },
  methods: {
    getInfo() {
      this.status = [];
      axios
        .post("http://localhost:3000/api/order/getorder_status", {
          status: "waiting-medicine"
        })
        .then(res => {
          this.order = res.data;
          axios
            .post("http://localhost:3000/api/order/getorder_status", {
              status: "medicine-complete"
            })
            .then(res2 => {
              for (let index = 0; index < res2.data.length; index++) {
                this.order.push(res2.data[index]);
                this.order_filter = [...this.order];
              }
              var id = [];
              var trans_status = [];
              //order group by transport_id
              for (let i = 0; i < this.order.length; i++) {
                id.push(this.order[i].transport_id);
              }
              id = id.filter((item, index) => id.indexOf(item) === index);
              var sorttransport = [];
              for (let index = 0; index < id.length; index++) {
                this.check_order.push(false);
                sorttransport[index] = this.order.filter((item, i) => {
                  return this.order[i].transport_id == id[index];
                });
                //change status en->th
                var sortstatus = [];
                sortstatus = this.order.filter((item, k) => {
                  return this.order[k].transport_id == id[index];
                });
                if (sortstatus[0].transport_status === "waiting-medicine") {
                  this.status.push("รอการจัดยา");
                } else if (
                  sortstatus[0].transport_status === "medicine-complete"
                ) {
                  console.log(sortstatus);
                  this.status.push("จัดยาเรียบร้อย");
                }
              }
              this.order_filter = [...sorttransport];
            });
        });
    },
    waiting_transport() {
      var check = 0;
      this.order_filter.forEach((element, index) => {
        if (this.check_order[index] == true) {
          //change status => waiting-transport
          axios
            .post("http://localhost:3000/api/transport/edit_transportstatus", {
              status: "waiting-transport",
              transport_id: this.order_filter[index][0].transport_id
            })
            .then(res => {
              for (var item in this.order_filter[index]) {
                console.log(this.order_filter[index]);
                console.log(item);
                axios
                  .post("http://localhost:3000/api/order/edit_orderstatus", {
                    status: "waiting-transport",
                    transport_id: this.order_filter[index][0].transport_id,
                    order_id: this.order_filter[index][item].order_id
                  })
                  .then(res2 => {
                    this.order_filter.splice(index, 1);
                    this.order.splice(index, 1);
                    this.check_order.splice(index, 1);
                  });
              }
            })
            .catch(e => {
              console.log(e);
            });
        }
      });

      // if (check == 1) {
      //   this.$router.push("/waiting_transport");
      // } else if (check == 0) {
      //   alert("เลือกร้านขายยาที่ต้องการจัดส่ง");
      // } else {
      //   alert("ยังจัดยาไม่เสร็จ");
      // }
    },
    add(index) {
      console.log("index=" + index);
      this.medicineAll.lot[index].push("");
      this.medicineAll.lot_qty[index].push("");
      this.medicineAll.exp[index].push("");
    },
    remove(index, subindex) {
      this.medicineAll.lot[index].splice(subindex, 1);
      this.medicineAll.lot_qty[index].splice(subindex, 1);
      this.medicineAll.exp[index].splice(subindex, 1);
    },
    cancel_order(item) {
      var index = this.order_filter[this.index].indexOf(item);
      confirm("คุณต้องการที่จะลบออร์เดอร์นี้ใช่หรือไม่?") &&
        axios
          .post("http://localhost:3000/api/order/edit_orderstatus", {
            status: "create-order",
            transport_id: null,
            order_id: item.order_id
          })
          .then(res => {
            this.order_filter[this.index].splice(index, 1);
            this.order[this.index].splice(index, 1);
            this.medicineAll = this.check_medicine();
          });
    },
    save() {
      var item = this.order_filter[this.index];
      //! edit lot_transfer
      var check = 1;
      for (let i = 0; i < this.check_medicine.length; i++) {
        if (!this.check_medicine[i]) {
          check--;
          break;
        }
      }
      if (check) {
        axios
          .post("http://localhost:3000/api/transport/edit_transportstatus", {
            status: "medicine-complete",
            transport_id: this.order_filter[this.index][0].transport_id
          })
          .then(res => {
            this.getInfo();
          })
          .catch(e => {
            console.log(e);
          });
        // for (let i = 0; i < this.order_filter[this.index].length; i++) {
        //   axios
        //     .post("http://localhost:3000/api/order/edit_orderstatus", {
        //       status: "medicine-complete",
        //       transport_id: this.order_filter[this.index][0].transport_id,
        //       order_id: this.order_filter[this.index][i].order_id
        //     })
        //     .catch(e => {
        //       console.log(e);
        //     });
        // }
      } else {
        axios
          .post("http://localhost:3000/api/transport/edit_transportstatus", {
            status: "waiting-medicine",
            transport_id: this.order_filter[this.index][0].transport_id
          })
          .then(res => {
            this.status[this.index] = "รอการจัดยา";
            this.getInfo();
          })
          .catch(e => {
            console.log(e);
          });
      }
      axios
        .post("http://localhost:3000/api/lot_transfer/deletelot", {
          trans_id: item[0].transport_id
        })
        .then(res => {
          for (let i = 0; i < this.medicineAll.lot.length; i++) {
            for (let j = 0; j < this.medicineAll.lot[i].length; j++) {
              axios
                .post("http://localhost:3000/api/lot_transfer/newlot", {
                  medicine_id: this.medicineAll.id[i],
                  qty: parseInt(this.medicineAll.lot_qty[i][j]),
                  transport_id: item[0].transport_id,
                  exp_date: this.parseDate(this.medicineAll.exp[i][j]) || null,
                  lot_no: this.medicineAll.lot[i][j]
                })
                .then(res => {})
                .catch(e => {
                  console.log(e);
                });
            }
          }
        });
      this.close();
    },
    close() {
      this.dialog_details = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    showdetail(item) {
      this.index = this.order_filter.indexOf(item);
      // console.log(this.order_filter[this.index]);
      this.dialog_details = true;
      //!calculate qty each medicine
      var getlot = [];
      axios
        .post("http://localhost:3000/api/lot_transfer/getlot", {
          trans_id: this.order_filter[this.index][0].transport_id
        })
        .then(res => {
          getlot = res.data;
          console.log(getlot);
          this.medicineAll = this.all_medicines(getlot);
        });
    },
    all_medicines(getlot) {
      var id = [];
      var name = [];
      var lot = [];
      var exp = [];
      var order_selected = [...this.order_filter[this.index]];
      var qty = [];
      var lot_qty = [];
      var unit = [];

      for (let index = 0; index < order_selected.length; index++) {
        for (let j = 0; j < order_selected[index].medicineItem.length; j++) {
          var indexof = id.indexOf(
            order_selected[index].medicineItem[j].medicine_id
          );

          if (indexof > -1) {
            qty[indexof] += parseInt(order_selected[index].medicineItem[j].qty);
          } else {
            qty.push(0);
            id.push(order_selected[index].medicineItem[j].medicine_id);
            qty[qty.length - 1] += parseInt(
              order_selected[index].medicineItem[j].qty
            );
            unit.push(order_selected[index].medicineItem[j].unit);
            name.push(order_selected[index].medicineItem[j].medicine_generic);
            var filter = getlot.filter((item, sub) => {
              return (
                getlot[sub].medicine_id ==
                order_selected[index].medicineItem[j].medicine_id
              );
            });
            if (filter.length > 0) {
              var lastindex = lot.length;
              for (let k = 0; k < filter.length; k++) {
                if (k == 0) {
                  lot.push([filter[k].lot_no]);
                  exp.push([this.date_Format(filter[k].exp_date)]);
                  lot_qty.push([filter[k].qty]);
                  this.errorMessage.push([""]);
                } else {
                  lot[lastindex].push(filter[k].lot_no);
                  exp[lastindex].push(this.date_Format(filter[k].exp_date));
                  lot_qty[lastindex].push(filter[k].qty);
                  this.errorMessage[lastindex].push("");
                }
              }
            } else {
              lot.push([""]);
              exp.push([""]);
              lot_qty.push([""]);
              this.errorMessage.push([""]);
            }
          }
        }
      }
      return {
        id: id,
        name: name,
        qty: qty,
        lot: lot,
        lot_qty: lot_qty,
        exp: exp,
        unit: unit
      };
    },
    checkMedInfo(i, k) {
      // this.errorMessage = [...this.medicineAll.lot]
      console.log(i, k);
      for (let index = 0; index < this.medicineAll.qty.length; index++) {
        for (let sub = 0; sub < this.medicineAll.qty[index].length; sub++) {
          this.errorMessage[i][j] = "";
        }
      }
      console.log(this.medicineAll.lot_qty[i][k]);
      if (isNaN(this.medicineAll.lot_qty[i][k])) {
        this.errorMessage[i][k] = "กรุณากรอกข้อมูลตัวเลข";
      } else {
        this.errorMessage[i][k] = "";
      }
    },
    getColor(status) {
      if (status == "จัดยาเรียบร้อย") return "green";
      else return "grey";
    },
    parseDate(date) {
      if (date == "") return null;

      var [day, month, year] = date.split("/");
      // year = parseInt(year) - 543;
      return `${year}/${month}/${day}`;
    },
    date_Format(date) {
      if (date == null) return null;
      return dateFormat(date, "dd/mm/yyyy");
    }
  },
  watch: {
    selectAll_order(index) {
      var count = 0;
      if (this.selectAll_order == true) {
        for (let i = 0; i < this.check_order.length; i++) {
          if (this.order_filter[i][0].transport_status == "medicine-complete") {
            this.check_order[i] = true;
          } else {
            this.check_order[i] = false;
          }
        }
      } else {
        for (let i = 0; i < this.check_order.length; i++) {
          this.check_order[i] = false;
        }
      }
    },
    medicineAll: {
      handler(val) {
        console.log(this.medicineAll.lot_qty);
        if (this.medicineAll.lot_qty)
          for (let i = 0; i < this.medicineAll.lot_qty.length; i++) {
            var qty = 0;
            var lot = 0;
            var exp = 0;
            if (
              this.medicineAll.lot_qty[i] == null ||
              this.medicineAll.lot[i] == "" ||
              this.medicineAll.exp[i] == ""
            ) {
              this.check_medicine[i] = false;
            } else {
              for (let j = 0; j < this.medicineAll.lot_qty[i].length; j++) {
                qty += parseInt(this.medicineAll.lot_qty[i][j]);
                if (this.medicineAll.lot[i][j] != "") {
                  lot++;
                }
                if (this.medicineAll.exp[i][j] != "") {
                  exp++;
                }
                if (
                  qty == this.medicineAll.qty[i] &&
                  lot == this.medicineAll.lot[i].length &&
                  exp == this.medicineAll.exp[i].length
                ) {
                  this.check_medicine[i] = true;
                } else if (qty > this.medicineAll.qty[i]) {
                  alert("จำนวนยาเกิน");
                } else {
                  this.check_medicine[i] = false;
                }
              }
            }
          }
      },
      deep: true
    },
    check_medicine() {
      if (this.medicine.every(item => item == true)) {
        this.status[this.index];
      }
    }
  }
};
</script>
<style scoped>
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
th {
  background-color: #ffd54f;
}
</style>