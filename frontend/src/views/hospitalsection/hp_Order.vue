<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main font">
      <v-row>
        <v-col align="left" style="font-size:25px">{{ date }}</v-col>
        <v-spacer></v-spacer>
        <v-col>
          <v-autocomplete
            :items="pharmacy"
            chips
            label="เลือกร้านขายยา"
            multiple
            item-text="pharmacy_name"
            item-value="pharmacy_name"
            solo
            clearable
            v-model="selected_ph"
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="2" md="2" justify="right" align="right">
          <v-btn
            color="primary"
            style="width:100%;"
            dark
            v-on="on"
            x-large
            @click="prepare_medicine"
          >ทำการจัดยา</v-btn>
        </v-col>
      </v-row>
      <!-- //! dialog edit -->
      <v-dialog v-model="dialog_edit" persistent max-width="600px">
        <v-card class="blue-grey lighten-5 font">
          <v-card-title>
            <span>แก้ไขข้อมูล</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-form ref="form">
                <v-row v-for="(item, i) in order[index].medicineItem" :key="i">
                  <v-col>
                    <v-text-field
                      v-model="order[index].medicineItem[i].medicine_generic"
                      readonly
                      disabled
                    ></v-text-field>
                  </v-col>
                  <v-col>
                    <v-text-field
                      v-model="order[index].medicineItem[i].qty"
                      solo
                      :rules="[
                        v => !!v || 'กรุณากรอกข้อมูล',
                        v => !isNaN(v) || 'กรุณากรอกข้อมูลตัวเลข'
                      ]"
                      required
                    ></v-text-field>
                  </v-col>
                  <v-col>
                    <v-text-field v-model="order[index].medicineItem[i].unit" readonly disabled></v-text-field>
                  </v-col>
                </v-row>
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
        <template v-slot:header="{ props }">
          <tr>
            <th>
              <v-checkbox
                primary
                hide-details
                label="เลือกทั้งหมด"
                v-model="selectall_order"
                @change="selectall"
              ></v-checkbox>
            </th>
            <th
              v-for="header in props.headers"
              :key="header.text"
              :style="header.align"
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
          <tbody>
            <tr
              v-for="(item, index) in items"
              :key="item.order_id"
              :class="{ selectedRow: checkbox[index] === true }"
            >
              <td>
                <v-checkbox primary v-model="checkbox[index]"></v-checkbox>
              </td>
              <td>{{ item.order_id }}</td>
              <td>{{ item.name }} {{ item.surname }}</td>
              <td style="text-align:center">{{ item.create_date }}</td>
              <td style="text-align:center">{{ item.pharmacy_name }}</td>
              <td style="text-align:center">
                <p v-for="medicine in item.medicineItem" :key="medicine.medicine_id">
                  {{ medicine.medicine_generic }} {{ medicine.qty }}
                  {{ medicine.unit }}
                </p>
              </td>
              <td style="text-align:center">
                <v-icon small class="mr-2" @click="editItem(item)">mdi-pencil</v-icon>
                <v-icon small class="mr-2" @click="deleteItem(item)">mdi-delete</v-icon>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>
      <br />

      <!-- //! table of missing medicine -->
      <!-- <v-col align="left" style="font-size:25px">ออร์เดอร์ที่ยาขาด</v-col>
      <v-data-table
        :headers="headers_missing"
        :items="order_missing_filter"
        :items-per-page="10"
        class="elevation-1"
        hide-default-header
      >
        <template v-slot:header="{ props }">
          <tr>
            <th>
              <v-checkbox
                primary
                hide-details
                label="เลือกทั้งหมด"
                v-model="selectAll_missing"
              ></v-checkbox>
            </th>
            <th
              v-for="header in props.headers"
              :key="header.text"
              style="text-align:left;"
            >
              {{ header.text }}
            </th>
        
          </tr>
        </template>
        <template v-slot:body="{ items }">
          <tbody v-for="item in items" :key="item.name">
            <tr>
              <td :rowspan="item.medicine.length">
                <v-checkbox
                  primary
                  hide-details
                  v-model="item.checkbox"
                ></v-checkbox>
              </td>
              <td :rowspan="item.medicine.length" style="text-align:center">
                {{ item.order_id }}
              </td>
              <td :rowspan="item.medicine.length" style="text-align:center">
                {{ item.patient }}
              </td>
              <td :rowspan="item.medicine.length" style="text-align:center">
                {{ item.create_date }}
              </td>
              <td :rowspan="item.medicine.length" style="text-align:center">
                {{ item.name }}
              </td>
              <td>
                <p v-for="medicine in item.medicine" :key="medicine.name">
                  {{ medicine.name }} {{ medicine.qty }} {{ medicine.unit }}
                </p>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>-->
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
      editedItem: {
        order_id: 46,
        due_date: "2020-02-21T17:00:00.000Z",
        status: "create-order",
        receive_date: null,
        remark: null,
        patient_HN_order: 2554,
        staff_id_order: 1248,
        pharmacist_id_order: null,
        create_date: "10/02/2020",
        pharmacy_id: 5,
        name: "สันติ",
        surname: "มั่นคั่ง",
        id: 21,
        lot_no: null,
        expdate: null,
        administration: "ก่อนอาหาร-เช้า,ก่อนอาหาร-กลางวัน,ก่อนอาหาร-เย็น",
        recieved: null,
        disease_id_medicine: 1,
        pharmacy_name: "จิตนาคลังยา",
        medicineItem: [
          {
            medicine_id: 1,
            medicine_tmt: 0,
            medicine_generic: "aaa",
            medicine_trade: "aaa",
            strength: "12",
            unit: "tablet",
            qty: 50,
            price: "250"
          }
        ]
      },
      index: 0,
      dialog_edit: false,
      selectall_order: false,
      selectall_missing: false,
      pharmacy: [],
      selected_ph: [],
      headers: [
        {
          text: "เลขออร์เดอร์",
          align: "center",
          sortable: false
        },
        { text: "ชื่อ-นามสกุลผู้ป่วย", align: "text-align:left" },
        { text: "วันที่สร้างออร์เดอร์", align: "text-align:center" },
        { text: "ร้านขายยา", align: "text-align:center" },
        { text: "ยาที่ได้รับ", align: "text-align:center" },
        { text: "แก้ไข/ยกเลิก", align: "text-align:center" }
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
          order_id: 48,
          due_date: "2020-02-13T17:00:00.000Z",
          status: "waiting-medicine",
          receive_date: null,
          remark: null,
          patient_HN_order: 148,
          staff_id_order: 1248,
          pharmacist_id_order: null,
          create_date: "10/02/2020",
          pharmacy_id: 3,
          transport_id: 82,
          name: "ประเสริฐ",
          surname: "มั่งคั่ง",
          id: 26,
          lot_no: null,
          expdate: null,
          administration: "หลังอาหาร-เช้า,หลังอาหาร-เย็น",
          recieved: null,
          disease_id_medicine: 4,
          pharmacy_name: "ใกล้เภสัชกร",
          province: "กรุงเทพมหานคร",
          transport_status: "waiting-medicine",
          medicineItem: [
            {
              medicine_id: 5,
              medicine_tmt: 0,
              medicine_generic: "eee",
              medicine_trade: "eee",
              strength: "20",
              unit: "tablet",
              qty: 30,
              price: "130"
            }
          ]
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
      order_missing_filter: [],
      checkbox: [],
      checknumrule: true
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

    axios
      .post("http://localhost:3000/api/order/getorder_status", {
        status: "create-order"
      })
      .then(res => {
        this.order = res.data;
        this.order_filter = [...this.order];
        this.checkbox = new Array(this.order.length);
      });
    axios.get("http://localhost:3000/api/pharmacy/showpharmacy").then(res => {
      this.pharmacy = res.data;
    });
  },
  components: {
    Menu
  },
  watch: {
    // selectAll_missing() {
    //   var count = 0;
    //   var i;
    //   if (this.selectAll_missing == true) {
    //     console.log("selectAll true");
    //     for (let key in this.order) {
    //       if (this.order_missing.hasOwnProperty(key)) {
    //         this.order_missing[key].checkbox = true;
    //       }
    //     }
    //   } else {
    //     for (let key in this.order) {
    //       if (this.order_missing.hasOwnProperty(key)) {
    //         this.order_missing[key].checkbox = false;
    //       }
    //     }
    //   }
    // },
    selected_ph() {
      if (this.selected_ph.length == 0) {
        this.order_filter = [...this.order];

        // this.order_missing_filter = [...this.order_missing];
      } else {
        this.order_filter = this.order.filter(store => {
          for (var i in this.selected_ph) {
            if (store.pharmacy_name == this.selected_ph[i]) return true;
          }
        });
        // this.order_missing_filter = this.order_missing.filter(store => {
        //   for (var i in item) {
        //     if (store.name == item[i]) return true;
        //   }
        // });
      }
      this.checkbox = new Array(this.order_filter.length);
    },
    checkbox() {
      var all = 1;
      for (var i = 0; i < this.checkbox.length; i++) {
        if (!this.checkbox[i]) {
          this.selectall_order = false;
          all = 0;
          break;
        }
      }
      if (all) {
        this.selectall_order = true;
      }
      // this.selectall_order = this.checkbox.every(item => item == true);
      // console.log(this.selectall_order);
    }
  },
  methods: {
    selectall() {
      var i;
      if (this.selectall_order == true) {
        for (i = 0; i < this.order_filter.length; i++) {
          this.checkbox[i] = true;
        }
      } else {
        for (i = 0; i < this.order_filter.length; i++) {
          this.checkbox[i] = false;
        }
      }
    },
    check_pharmacy_id() {
      var count_pharmacy = [];
      var ph_id = [];
      for (let i = 0; i < this.order_filter.length; i++) {
        if (this.checkbox[i]) {
          ph_id.push(this.order_filter[i].pharmacy_id);
        }
      }
      return ph_id.filter((item, index) => ph_id.indexOf(item) === index);
    },
    prepare_medicine() {
      var transport_pharmacy = [];
      var id_selected = this.check_pharmacy_id();
      axios
        .post("http://localhost:3000/api/transport/gettransport", {
          status: "waiting-medicine"
        })
        .then(res => {
          transport_pharmacy = res.data;
          axios
            .post("http://localhost:3000/api/transport/gettransport", {
              status: "medicine-complete"
            })
            .then(res2 => {
              for (let i = 0; i < res2.data.length; i++) {
                transport_pharmacy.push(res2.data[i]);
              }
              console.log(transport_pharmacy);
              var trans_id = transport_pharmacy.map(
                val => val.pharmacy_id_transport
              );
              console.log(trans_id);
              for (let i = 0; i < id_selected.length; i++) {
                if (trans_id.indexOf(id_selected[i]) < 0) {
                  //edit order_id
                  axios
                    .post("http://localhost:3000/api/transport/newtransport", {
                      status: "waiting-medicine",
                      pharmacy_id_transport: id_selected[i]
                    })
                    .then(res => {
                      this.changeOrderStatus(
                        [{ transport_id: res.data.insertId }],
                        id_selected[i]
                      );
                    });
                } else {
                  //add transport id
                  var t_id = transport_pharmacy.filter(
                    (item, index) =>
                      item.pharmacy_id_transport == id_selected[i]
                  );
                  this.changeOrderStatus(t_id, id_selected[i]);
                }
              }
            });
        });
    },
    changeOrderStatus(t_id, ph_id) {
      //edit order
      for (let i = 0; i < this.order_filter.length; i++) {
        if (this.checkbox[i] && this.order_filter[i].pharmacy_id == ph_id) {
          axios
            .post("http://localhost:3000/api/order/edit_orderstatus", {
              status: "waiting-medicine",
              order_id: this.order_filter[i].order_id,
              transport_id: t_id[0].transport_id
            })
            .then(res => {
              this.$router.push("/waiting_medicine");
            })
            .catch(e => {
              console.log(e);
            });
        }
      }
      //edit transport
      axios
        .post("http://localhost:3000/api/transport/edit_transportstatus", {
          status: "waiting-medicine",
          transport_id: t_id[0].transport_id
        })
        .then(res => {})
        .catch(e => {
          console.log(e);
        });
    },
    deleteItem(item) {
      const index = this.order.indexOf(item);
      confirm(
        "คุณต้องการที่จะลบออร์เดอร์ใช่หรือไม่?\nคุณ" +
          item.name +
          " " +
          item.surname
      ) &&
        axios
          .post("http://localhost:3000/api/order/del_order", {
            order_id: item.order_id
          })
          .then(res => {
            this.order_filter.splice(index, 1);
            this.order.splice(index, 1);
          })
          .catch(e => {
            console.log(e);
          });
    },
    editItem(item) {
      this.index = this.order.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialog_edit = true;
    },
    save() {
      if (this.$refs.form.validate()) {
        if (this.index > -1) {
          for (let i = 0; i < this.order[this.index].medicineItem.length; i++) {
            axios
              .post("http://localhost:3000/api/order/edit_nummed", {
                medicine_id: this.order[this.index].medicineItem[i].medicine_id,
                qty: this.order[this.index].medicineItem[i].qty,
                order_id: this.order[this.index].order_id
              })
              .then(res => {
                Object.assign(this.order[this.index], this.editedItem);
              })
              .catch(e => {
                console.log(e);
              });
          }
        } else {
          console.log("index < -1");
        }
        this.close();
      } else {
        alert("กรอกข้อมูลไม่ถูกต้อง");
      }
    },
    close() {
      if (this.$refs.form.validate()) {
        axios
          .post("http://localhost:3000/api/order/getorder_status", {
            status: "create-order"
          })
          .then(res => {
            this.order = res.data;
            this.order_filter = [...this.order];
            this.checkbox = new Array(this.order.length);
          });
        this.dialog_edit = false;
      } else {
        alert("กรอกข้อมูลไม่ถูกต้อง");
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
.selectedRow {
  background-color: #f0f0f0;
}
</style>
