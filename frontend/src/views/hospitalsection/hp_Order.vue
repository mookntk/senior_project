<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main font">
      <v-row>
        <v-col align="left" style="font-size:25px">ออร์เดอร์</v-col>
      </v-row>
      <v-row>
        <v-spacer></v-spacer>
        <v-col cols="6" sm="4" md="2">
          <v-text-field label="ค้นหา" solo clearable v-model="search" append-icon="mdi-magnify"></v-text-field>
        </v-col>
        <v-col cols="6" sm="5" md="3">
          <v-autocomplete
            :items="pharmacy"
            chips
            label="เลือกร้านขายยา"
            multiple
            item-text="pharmacy_name"
            item-value="pharmacy_name"
            solo
            clearable
            v-model="filters.pharmacy_name"
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="2" md="2" style="margin:0 5px">
          <v-btn color="#207B8E" style="width:90%;" dark large @click="prepare_medicine">ทำการจัดยา</v-btn>
        </v-col>
      </v-row>

      <!-- ! table of order -->

      <v-data-table
        :search="search"
        :headers="headers"
        :items="filterOrders"
        :items-per-page="10"
        class="elevation-1"
        show-select
        v-model="selectedItem"
      >
        <template v-slot:no-data>ไม่มีข้อมูลออร์เดอร์</template>
        <template v-slot:item.due_date="{item}">{{ setDate(item.due_date) }}</template>
        <template v-slot:item.name="{item}">{{ item.name }} {{item.surname}}</template>
        <template v-slot:item.medicine="{item}">
          <p v-for="medicine in item.medicineItem" :key="medicine.medicine_id">
            {{ medicine.medicine_generic }} {{medicine.strength}}
            <span
              style="font-weight:bold"
            >{{ medicine.qty }}</span>
            {{ medicine.unit }}
          </p>
        </template>
        <template v-slot:item.action="{item}">
          <v-icon class="mr-2" @click="editDialog(item)" color="#77B3D5" size="18">mdi-pencil</v-icon>
          <v-icon class="mr-2" @click="deleteDialog(item)" color="#C85D5C" size="18">mdi-delete</v-icon>
        </template>
      </v-data-table>
      <br />

      <!-- ! dialog edit -->
      <v-dialog v-model="dialog_edit" persistent max-width="450px">
        <v-card class="font">
          <v-card-title style="background-color:#77B3D5">แก้ไขข้อมูล</v-card-title>
          <v-divider></v-divider>
          <br />
          <v-card-text>
            <v-container>
              <v-form ref="form">
                <v-row v-for="(item, i) in order_selected.medicineItem" :key="i">
                  <v-col cols="4" sm="6" md="6">
                    <v-row>
                      <p style="margin-top:15px">{{item.medicine_generic}} {{item.strength}}</p>
                      <v-spacer></v-spacer>
                      <p style="margin-top:15px">จำนวน</p>
                    </v-row>
                  </v-col>
                  <v-col cols="4" sm="3" md="3">
                    <v-text-field
                      v-model="qty_txt[i]"
                      solo
                      :rules="[
                        v => !!v || 'กรุณากรอกข้อมูล',
                        v => !isNaN(v) || 'กรุณากรอกข้อมูลตัวเลข'
                      ]"
                      required
                    ></v-text-field>
                  </v-col>
                  <v-col cols="4" sm="3" md="3">
                    <p style="margin-top:15px">{{item.unit}}</p>
                  </v-col>
                </v-row>
              </v-form>
            </v-container>
          </v-card-text>
          <v-divider></v-divider>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green lighten-1" text @click="editItem">เสร็จสิ้น</v-btn>
            <v-btn color="red lighten-1" text @click="dialog_edit=false">ปิด</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <v-dialog v-model="dialog_delete" persistent max-width="350">
        <v-card class="font">
          <v-card-title style="background-color:#C85D5C">ลบออร์เดอร์</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <br />
            <p>ต้องการลบออร์เดอร์ที่ {{order_selected.order_id}} ของคุณ{{order_selected.name}} {{order_selected.surname}}</p>
          </v-card-text>
          <v-divider></v-divider>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" text @click="deleteItem">ยืนยัน</v-btn>
            <v-btn color="green darken-1" text @click="dialog_delete=false">ปิด</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <v-row>
        <v-col align="left" style="font-size:25px">ออร์เดอร์ที่มียาขาด</v-col>
      </v-row>
      <v-data-table
        :search="search_missing"
        :headers="headers_missing"
        :items="filterOrdersMissing"
        :items-per-page="10"
        class="elevation-1"
        show-select
        v-model="selectedItem"
      >
        <template v-slot:no-data>ไม่มีข้อมูลออร์เดอร์</template>

        <template v-slot:item.due_date="{item}">{{ setDate(item.due_date) }}</template>
        <template v-slot:item.name="{item}">{{ item.name }} {{item.surname}}</template>
        <template v-slot:item.medicine="{item}">
          <div v-for="medicine in item.medicineItem" :key="medicine.medicine_id">
            <p v-if="medicine.qty_missing>0">
              {{ medicine.medicine_generic }} {{medicine.strength}}
              <span
                style="font-weight:bold"
              >{{ medicine.qty_missing }}</span>
              {{ medicine.unit }}
            </p>
          </div>
        </template>
      </v-data-table>
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
      index: 0,
      dialog_edit: false,
      dialog_delete: false,
      pharmacy: [],
      selectedItem: [],
      headers: [
        {
          text: "เลขออร์เดอร์",
          align: "left",
          value: "order_id",
          divider: true
        },
        {
          text: "ชื่อ-นามสกุลผู้ป่วย",
          align: "left",
          value: "name",
          divider: true
        },
        {
          text: "วันที่นัดรับยา",
          align: "center",
          value: "due_date",
          divider: true
        },
        {
          text: "ร้านขายยา",
          align: "center",
          value: "pharmacy_name",
          divider: true
        },
        {
          text: "ยาที่ได้รับ",
          align: "center",
          value: "medicine",
          divider: true
        },
        {
          text: "แก้ไข/ยกเลิก",
          align: "center",
          value: "action",
          divider: true
        }
      ],
      headers_missing: [
        {
          text: "เลขออร์เดอร์",
          align: "left",
          value: "order_id",
          divider: true
        },
        {
          text: "ชื่อ-นามสกุลผู้ป่วย",
          align: "left",
          value: "name",
          divider: true
        },
        {
          text: "วันที่นัดรับยา",
          align: "center",
          value: "due_date",
          divider: true
        },
        {
          text: "ร้านขายยา",
          align: "center",
          value: "pharmacy_name",
          divider: true
        },
        {
          text: "ยาที่ขาด",
          align: "center",
          value: "medicine",
          divider: true
        }
      ],
      order: [],
      order_filter: [],
      order_missing_filter: [],
      filters: {
        pharmacy_name: []
      },
      search: "",
      search_missing: "",
      order_missing: [],
      dialog_delete: false,
      order_selected: [],
      qty_txt: []
    };
  },
  components: {
    Menu
  },
  mounted() {
    axios
      .post("http://localhost:3000/api/order/getorder_status", {
        status: "create-order"
      })
      .then(res => {
        this.order = res.data;
      });
    axios
      .post("http://localhost:3000/api/order/getorder_status", {
        status: "missing"
      })
      .then(res => {
        this.order_missing = res.data;
      });
    axios.get("http://localhost:3000/api/pharmacy/showpharmacy").then(res => {
      this.pharmacy = res.data;
    });
  },

  methods: {
    setDate(date) {
      if (date == null) return null;
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
      date = dateFormat(date, "dd/mm/yyyy");
      var [d, m, y] = date.split("/");
      return d + " " + month[parseInt(m) - 1] + " " + (parseInt(y) + 543);
    },
    checkPharmacyId() {
      var ph_id = this.selectedItem.map(v => v.pharmacy_id);
      return ph_id.filter((item, index) => ph_id.indexOf(item) === index);
    },
    prepare_medicine() {
      var transport_pharmacy = [];
      var id_selected = this.checkPharmacyId();
      //ดีง transport_id ของ waiting-medicine && medicine-complete
      axios
        .get("http://localhost:3000/api/transport/gettransport")
        .then(res => {
          transport_pharmacy = res.data;

          var trans_id = transport_pharmacy.map(
            val => val.pharmacy_id_transport
          );

          for (let i = 0; i < id_selected.length; i++) {
            if (trans_id.indexOf(id_selected[i]) < 0) {
              //ยังไม่มีของส่งร้านขายยานี้
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
              //t_id =
              var t_id = transport_pharmacy.filter(
                (item, index) => item.pharmacy_id_transport == id_selected[i]
              );
              this.changeOrderStatus(t_id, id_selected[i]);
            }
          }
        });
    },
    changeOrderStatus(t_id, ph_id) {
      //edit order
      for (let i = 0; i < this.selectedItem.length; i++) {
        if (this.selectedItem[i].pharmacy_id == ph_id) {
          axios
            .post("http://localhost:3000/api/order/edit_orderstatus", {
              status: "waiting-medicine",
              order_id: this.selectedItem[i].order_id,
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
    deleteDialog(item) {
      this.order_selected = item;
      this.dialog_delete = true;
    },
    deleteItem() {
      axios
        .post("http://localhost:3000/api/order/del_order", {
          order_id: this.order_selected.order_id
        })
        .then(res => {
          var index = this.order.indexOf(this.order_selected);
          this.order.splice(index, 1);
          this.dialog_delete = false;
        })
        .catch(e => {
          console.log(e);
          this.dialog_delete = false;
        });
    },
    editDialog(item) {
      this.order_selected = Object.assign({}, item);
      this.index = this.order.indexOf(item);
      item.medicineItem.forEach((element, i) => {
        this.qty_txt[i] = element.qty;
      });
      this.dialog_edit = true;
    },
    editItem() {
      if (this.$refs.form.validate()) {
        for (let i = 0; i < this.order_selected.medicineItem.length; i++) {
          console.log("object");
          this.order_selected.medicineItem[i].qty = this.qty_txt[i];
          axios
            .post("http://localhost:3000/api/order/edit_nummed", {
              medicine_id: this.order_selected.medicineItem[i].medicine_id,
              qty: parseInt(this.qty_txt[i]),
              order_id: this.order_selected.order_id
            })
            .then(res => {
              Object.assign(this.order[this.index], this.order_selected);
              this.dialog_edit = false;
            })
            .catch(e => {
              console.log(e);
            });
        }
      }
    }
  },
  computed: {
    filterOrders() {
      return this.order.filter(d => {
        return Object.keys(this.filters).every(f => {
          return this.filters[f].length < 1 || this.filters[f].includes(d[f]);
        });
      });
    },
    filterOrdersMissing() {
      return this.order_missing.filter(d => {
        return Object.keys(this.filters).every(f => {
          return this.filters[f].length < 1 || this.filters[f].includes(d[f]);
        });
      });
    }
  },
  watch: {
    selectedItem(newValue, oldValue) {
      console.log(this.selectedItem);
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
</style>
