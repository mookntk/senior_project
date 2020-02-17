<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main font">
      <v-row>
        <v-col align="left" style="font-size:25px">{{date}}</v-col>
        <v-spacer></v-spacer>
        <v-col cols="12" sm="2" md="2" align="right">
          <v-btn color="primary" x-large dark v-on="on" @click="transportStatus">ทำการจัดส่ง</v-btn>
        </v-col>
      </v-row>
      <!--  dialog edit -->
      <v-dialog v-model="dialog_details" persistent max-width="700px">
        <v-card class="blue-grey lighten-5 font">
          <v-card-title>
            <span>ยาที่จัดส่ง</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-list class="blue-grey lighten-5 font" elevation>
                <template v-for="(item, i) in transport[index]">
                  <v-list-item :key="i">
                    <template v-slot:default="{ active, toggle }">
                      <v-list-item-content>
                        <v-list-item-title>HN:{{item.patient_HN_order}} คุณ{{item.name}} {{item.surname}}</v-list-item-title>
                      </v-list-item-content>
                    </template>
                  </v-list-item>
                  <v-divider :key="i"></v-divider>
                </template>
              </v-list>
              <br />
              <br />
              <v-subheader>จำนวนยาทั้งหมด</v-subheader>
              <v-list class="blue-grey lighten-4 font">
                <template v-for="(item, i) in medicineAll.qty">
                  <v-list-item :key="i">
                    <!-- <template v-slot:default="{ active, toggle }"> -->
                    <v-list-item-content>
                      <v-list-item-title>{{medicineAll.name[i]}} {{medicineAll.qty[i]}} {{medicineAll.unit[i]}}</v-list-item-title>
                      <v-row v-for="(item,k) in medicineAll.lot[i]" :key="i+k">
                        <!-- <v-row v-for="(item2,j) in medicineAll.lot[k]" :key="j"> -->
                        <v-col cols="12" sm="5" md="5">
                          <v-text-field
                            label="เลขรหัสสินค้า"
                            v-model="medicineAll.lot[i][k]"
                            outlined
                            readonly
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="4" md="4">
                          <v-text-field
                            label="วันหมดอายุ"
                            v-model="medicineAll.exp[i][k]"
                            outlined
                            readonly
                            hint="วัน/เดือน/ปี"
                            persistent-hint
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="3" md="3">
                          <v-text-field
                            label="จำนวน"
                            v-model="medicineAll.lot_qty[i][k]"
                            outlined
                            readonly
                          ></v-text-field>
                        </v-col>

                        <!-- </v-row> -->
                      </v-row>
                    </v-list-item-content>
                    <!-- </template> -->
                  </v-list-item>
                  <v-divider :key="i"></v-divider>
                </template>
              </v-list>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn @click="close" rounded color="red lighten-1" large>ปิด</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <!--  table of order -->
      <v-data-table
        :headers="headers"
        :items="transport"
        :items-per-page="10"
        class="elevation-1 font"
        hide-default-header
      >
        <template v-slot:header="{props}">
          <tr>
            <th>
              <v-checkbox
                primary
                hide-details
                label="เลือกทั้งหมด"
                v-model="selectAll_order"
                @change="selectAll"
              ></v-checkbox>
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
              :class="{'selectedRow': checkbox[index] }"
            >
              <td>
                <v-checkbox primary hide-details v-model="checkbox[index]"></v-checkbox>
              </td>
              <td @click="Showdetail(item)">{{ item[0].pharmacy_name }}</td>
              <td style="text-align:center" @click="Showdetail(item)">{{ item[0].province }}</td>
              <td style="text-align:center" @click="Showdetail(item)">{{ item.length }}</td>
              <!-- <td style="text-align:center" @click="Showdetails(item)">{{ item.name }}</td> -->
              <td style="text-align:center">
                <v-icon class="mr-2" @click="deleteItem(item)">mdi-delete</v-icon>
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
      date: "",
      editedItem: "",
      index: 0,
      selectAll_order: false,
      dialog_details: false,
      check_medicine: [],
      headers: [
        {
          text: "ร้านขายยา",
          align: "left",
          sortable: false
        },
        { text: "จังหวัด", align: "center" },
        { text: "จำนวนออร์เดอร์", align: "center" },
        { text: "ยกเลิก", align: "center" }
      ],
      transport: [],
      medicineAll: { medicine_id: [], qty: [], lot: [[]], exp: [[]] },
      checkbox: null
    };
  },
  mounted() {
    axios
      .post("http://localhost:3000/api/transport/sorttransportid", {
        status: "waiting-transport"
      })
      .then(res => {
        this.transport = res.data;
        this.checkbox = new Array(this.transport.length);
        this.checkbox.fill(false, 0, this.checkbox.length);
        console.log(this.transport[0]);
      });
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
    transportStatus() {
      this.checkbox.forEach((element, index) => {
        if (this.checkbox[index] == true) {
          axios
            .post("http://localhost:3000/api/transport/edit_transportdate", {
              status: "transport",
              transport_id: this.transport[index][0].transport_id
            })

            .catch(e => {
              console.log(e);
            });
          for (let i = 0; i < this.transport[index].length; i++) {
            axios
              .post("http://localhost:3000/api/order/edit_orderstatus", {
                status: "transport",
                transport_id: this.transport[index][0].transport_id,
                order_id: this.transport[index][i].order_id
              })
              .then(res2 => {
                this.transport.splice(index, 1);
                this.checkbox.splice(index, 1);
              });
          }
        }
      });
    },
    getinfo() {
      axios
        .post("http://localhost:3000/api/transport/sorttransportid", {
          status: "waiting-transport"
        })
        .then(res => {
          this.transport = res.data;
          this.checkbox = new Array(this.transport.length);
          console.log(this.transport);
        });
    },
    getLot() {
      axios
        .post("http://localhost:3000/api/lot_transfer/getlot", {
          trans_id: this.transport[this.index][0].transport_id
        })
        .then(res => {
          var getlot = res.data;
          var id = [];
          var name = [];
          var lot = [];
          var exp = [];
          var order_selected = [...this.transport[this.index]];
          var qty = [];
          var lot_qty = [];
          var unit = [];

          for (let index = 0; index < order_selected.length; index++) {
            for (
              let j = 0;
              j < order_selected[index].medicineItem.length;
              j++
            ) {
              var indexof = id.indexOf(
                order_selected[index].medicineItem[j].medicine_id
              );

              if (indexof > -1) {
                qty[indexof] += parseInt(
                  order_selected[index].medicineItem[j].qty
                );
              } else {
                qty.push(0);
                id.push(order_selected[index].medicineItem[j].medicine_id);
                qty[qty.length - 1] += parseInt(
                  order_selected[index].medicineItem[j].qty
                );

                name.push(
                  order_selected[index].medicineItem[j].medicine_generic
                );
                unit.push(order_selected[index].medicineItem[j].unit);

                var filter = getlot.filter((item, sub) => {
                  return (
                    getlot[sub].medicine_id ==
                    order_selected[index].medicineItem[j].medicine_id
                  );
                });

                var lastindex = lot.length;
                for (let k = 0; k < filter.length; k++) {
                  if (k == 0) {
                    lot.push([filter[k].lot_no]);
                    exp.push([this.date_Format(filter[k].exp_date)]);
                    lot_qty.push([filter[k].qty]);
                    // this.errorMessage.push([""]);
                  } else {
                    lot[lastindex].push(filter[k].lot_no);
                    exp[lastindex].push(this.date_Format(filter[k].exp_date));
                    lot_qty[lastindex].push(filter[k].qty);
                    // this.errorMessage[lastindex].push("");
                  }
                }
              }
            }
          }
          this.medicineAll = {
            id: id,
            name: name,
            qty: qty,
            lot: lot,
            lot_qty: lot_qty,
            exp: exp,
            unit: unit
          };
        });
    },
    date_Format(date) {
      if (date == null) return null;
      return dateFormat(date, "dd/mm/yyyy");
    },
    deleteItem(item) {
      const index = this.transport.indexOf(item);
      confirm("คุณต้องการลบออร์เดอร์ใช่หรือไม่?") &&
        axios
          .post("http://localhost:3000/api/transport/edit_transportstatus", {
            status: "medicine-complete",
            transport_id: this.transport[index][0].transport_id
          })
          .then(res => {
            for (let i = 0; i < this.transport[index].length; i++) {
              axios
                .post("http://localhost:3000/api/order/edit_orderstatus", {
                  status: "waiting-medicine",
                  transport_id: this.transport[index][0].transport_id,
                  order_id: this.transport[index][i].order_id
                })
                .then(res => {
                  this.transport.splice(this.index, 1);
                })
                .catch(e => {
                  console.log(e);
                });
            }
          })

          .catch(e => {
            console.log(e);
          });
    },
    close() {
      this.dialog_details = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    Showdetail(item) {
      this.index = this.transport.indexOf(item);
      this.dialog_details = true;
      this.getLot();
    },
    selectAll() {
      this.checkbox.forEach((element, i) => {
        this.checkbox[i] = this.selectAll_order;
      });
    }
  },
  watch: {
    checkbox() {
      this.selectAll_order = this.checkbox.every(
        (item, index) => this.checkbox[index] == true
      );
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
/* #styled-input {
  height: 50px;
  font-size: 10pt;
}
.v-text-field {
  height: 70px;
} */
th {
  background-color: #ffd54f;
}
.selectedRow {
  background-color: #f0f0f0;
}
</style>