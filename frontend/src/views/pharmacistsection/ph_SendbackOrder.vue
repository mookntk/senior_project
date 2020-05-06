<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main font">
      <v-row>
        <v-col align="left" style="font-size:25px">ชุดออร์เดอร์ที่ส่งยากลับ</v-col>
      </v-row>
      <!-- <v-row>
        <v-col align="left" style="font-size:20px">{{date}}</v-col>
      </v-row>-->
      <v-data-table
        :headers="headers"
        :items="s_order"
        :items-per-page="10"
        class="elevation-1"
        @click:row="showItem"
      >
        <template v-slot:item.order="{item}">{{s_order.indexOf(item)+1}}</template>
        <template v-slot:item.send_date="{item}">{{setDate(item.send_date)}}</template>
        <template v-slot:item.receive_date="{item}">{{setDate(item.receive_date)}}</template>
        <template v-slot:item.name="{item}">{{item.name}} {{item.surname}}</template>
        <template v-slot:item.status="{item}">
          <v-chip :color="getColor(item.status)">{{setStatus(item.status)}}</v-chip>
        </template>
        <template v-slot:item.medicine>
          <v-icon color="#76C3AF" size="20">mdi-pill</v-icon>
        </template>
      </v-data-table>

      <v-dialog
        v-model="dialog_order"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card class="font" style="background-color:#f5f7f5">
          <v-toolbar color="#77B3D5">
            <v-btn color="#C85D5C" fab small depressed @click="dialog_order = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-spacer></v-spacer>
            <v-btn color="#f5ce88" large @click="sendMedicine">ส่งยากลับโรงพยาบาล</v-btn>
          </v-toolbar>
          <v-card-text>
            <v-row style="margin:20px">
              <v-col
                cols="12"
                md="4"
                sm="6"
                v-for="(element,i) in each_order"
                :key="element.order_id"
                class="d-flex"
              >
                <v-card class="d-flex flex-column" style="width:100%">
                  <v-card-title style="background-color:#DFE4DE;font-size:18px">
                    <v-spacer></v-spacer>
                    ออร์เดอร์ที่ {{element.order_id}}
                  </v-card-title>
                  <v-card-text>
                    <p class="font-card">คุณ{{element.name}} {{element.surname}}</p>
                    <p class="font-card">ยาที่ได้รับ</p>
                    <v-list
                      v-for="(element2,j) in element.medicineItem"
                      :key="element2.medicine_id+i"
                      style="background-color:#faf9e6;margin:5px"
                    >
                      <v-row style="margin-left:5px">
                        <p>
                          <v-icon color="#76C3AF" small>mdi-arrow-right-drop-circle</v-icon>
                          {{element2.medicine_generic}} {{element2.strength}} {{element2.qty}} {{element2.unit}}
                        </p>
                      </v-row>
                      <v-row
                        v-for="(element3,k) in element2.lotItem"
                        :key="element2.medicine_id+k+i"
                        style="margin-left:20px"
                      >
                        <p>lot {{element3.lot_no}} จำนวน {{element3.lot_qty}} {{element2.unit}}</p>
                      </v-row>
                    </v-list>
                  </v-card-text>
                  <v-card-actions style="margin-top: auto;">
                    <v-spacer></v-spacer>
                    <v-btn
                      color="#C85D5C"
                      @click="cancelReturn(element)"
                      v-if="s_order[index].status=='waiting-return'"
                    >ยกเลิกการส่งคืน</v-btn>
                  </v-card-actions>
                </v-card>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-content>
  </v-app>
</template>
<script>
import Menu from "../../components/ph_menubar";
import axios from "axios";
import dateformat from "dateformat";
export default {
  data() {
    return {
      date: "",
      dialog_order: false,
      headers: [
        {
          text: "ลำดับที่",
          align: "left",
          value: "order"
        },
        { text: "วันที่จัดส่งยา", align: "center", value: "send_date" },
        { text: "วันที่ได้รับยา", align: "center", value: "receive_date" },
        { text: "จำนวนออร์เดอร์", align: "center", value: "num_order" },
        { text: "ผู้จัดส่ง", align: "center", value: "name" },
        { text: "สถานะ", align: "center", value: "status" },
        { text: "ยาที่ได้รับ", align: "center", value: "medicine" }
      ],
      index: 0,
      s_order: [],
      each_order: []
    };
  },
  components: {
    Menu
  },
  mounted() {
    axios
      .post("http://localhost:3000/api/user/getuserbyid", {
        staff_id: localStorage.getItem("staff_id")
      })
      .then(res => {
        this.pharmacy_id = res.data[0].pharmacy_id_pharmacist;
        axios
          .post("http://localhost:3000/api/return/getreturnstatus", {
            pharmacy_id: this.pharmacy_id
          })
          .then(res => {
            this.s_order = res.data;
          });
      })
      .catch(e => {
        console.log(e);
      });
  },
  methods: {
    setDate: function(d) {
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
      if (d != null) {
        var date_transport = d.split(" ");
        console.log(date_transport);
        date_transport[0] = parseInt(date_transport[0]) + 543;
        date_transport =
          date_transport[2] +
          " " +
          month[date_transport[1] - 1] +
          " " +
          date_transport[0];
        return date_transport;
      } else return "";
    },
    showItem(item) {
      this.index = this.s_order.indexOf(item);
      console.log(item);
      axios
        .post("http://localhost:3000/api/return/getorderbyid", {
          return_id: item.return_id
        })
        .then(res => {
          var returnorder = res.data;
          var format = [];
          var pre_order = null;
          var pre_medicine = null;
          returnorder.forEach((element, i) => {
            var medicine = {
              medicine_id: element.medicine_id,
              medicine_generic: element.medicine_generic,
              strength: element.strength,
              unit: element.unit,
              qty: element.qty
            };
            var lot = {
              lot_no_id: element.lot_no_id,
              lot_no: element.lot_no,
              lot_qty: element.lot_qty,
              lot_transfer_id: element.lot_transfer_id
            };
            if (i == 0) {
              element["medicineItem"] = [medicine];
              element.medicineItem[0]["lotItem"] = [lot];
              format.push(element);
            } else {
              if (pre_order == element.order_id) {
                if (pre_medicine == element.medicine_id) {
                  format[format.length - 1].medicineItem[
                    format[format.length - 1].medicineItem.length - 1
                  ].lotItem.push(lot);
                } else {
                  medicine["lotItem"] = [lot];
                  format[format.length - 1].medicineItem.push(medicine);
                }
              } else {
                element["medicineItem"] = [medicine];
                element.medicineItem[0]["lotItem"] = [lot];
                format.push(element);
              }
            }
            pre_medicine = element.medicine_id;
            pre_order = element.order_id;
            console.log("format");
            console.log(format);
            this.each_order = [...format];
          });
        });
      this.dialog_order = true;
    },
    getColor(status) {
      if (status == "waiting-return") return "#bdc3c7";
      else if (status == "sending") return "#E1995E";
      else if (status == "received") return "#76C3AF";
    },
    setStatus(status) {
      if (status == "waiting-return") return "รอการจัดส่ง";
      else if (status == "sending") return "กำลังจัดส่ง";
      else if (status == "received") return "ได้รับยาเรียบร้อย";
    },
    sendback() {
      confirm("คุณต้องการส่งชุดออร์เดอร์กลับโรงพยาบาลใช่หรือไม่?") &&
        this.order.splice(this.index, 1);
      this.dialog_order = false;
    },
    cancelReturn(element) {
      element.medicineItem.forEach((med, i) => {
        med.lotItem.forEach((lot, j) => {
          axios
            .post("http://localhost:3000/api/lot_transfer/editlotreturn", {
              lot_no_id: lot.lot_transfer_id,
              qty_less: parseInt(lot.lot_qty)
            })
            .then(res => {
              if (j == med.lotItem.length - 1) {
              }

              axios
                .post("http://localhost:3000/api/user/getuserbyid", {
                  staff_id: localStorage.getItem("staff_id")
                })
                .then(res => {
                  this.pharmacy_id = res.data[0].pharmacy_id_pharmacist;
                  axios
                    .post("http://localhost:3000/api/return/getreturnstatus", {
                      pharmacy_id: this.pharmacy_id
                    })
                    .then(res => {
                      this.s_order = res.data;
                    });
                })
                .catch(e => {
                  console.log(e);
                });
            })
            .catch(e => {
              console.log(e);
            });
          axios
            .post("http://localhost:3000/api/lot_order/dellot", {
              lot_no_id: lot.lot_no_id
            })
            .catch(e => {
              console.log(e);
            });
        });
      });
      var remark = null;
      if (element.remark == "รับยาบางส่วน") {
        remark = "รับยาบางส่วน";
      }
      axios
        .post("http://localhost:3000/api/return/editorderreturnid", {
          remark: remark,
          order_id: element.order_id,
          return_id: null
        })
        .then(res => {
          setTimeout(() => {
            var index = this.each_order.indexOf(element);
            console.log("index");
            this.each_order.splice(index, 1);
          }, 200);
          console.log("edit success");
        })
        .catch(e => {
          console.log(e);
        });
    },
    sendMedicine() {
      confirm("คุณต้องการส่งชุดออร์เดอร์กลับโรงพยาบาลใช่หรือไม่?") &&
        axios
          .post("http://localhost:3000/api/return/editstatus", {
            status: "sending",
            pharmacist_id: localStorage.getItem("staff_id"),
            return_id: this.s_order[this.index].return_id,
            send_date: dateformat(new Date(), "yyyy-mm-dd HH:MM:ss"),
            receive_date: null
          })
          .then(res => {
            axios
              .post("http://localhost:3000/api/user/getuserbyid", {
                staff_id: localStorage.getItem("staff_id")
              })
              .then(res => {
                this.pharmacy_id = res.data[0].pharmacy_id_pharmacist;
                axios
                  .post("http://localhost:3000/api/return/getreturnstatus", {
                    pharmacy_id: this.pharmacy_id
                  })
                  .then(res => {
                    this.s_order = res.data;
                    this.dialog_order = false;
                  });
              })
              .catch(e => {
                console.log(e);
              });
          });
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