<template>
  <v-app class="font cyan lighten-5">
    <v-alert class="alert font" type="success" :value="success_alert">บันทึกข้อมูลสำเร็จ</v-alert>
    <v-alert class="alert font" type="warning" :value="error_alert">บันทึกข้อมูลไม่สำเร็จ</v-alert>
    <div class="menu-header">
      <Menu />
    </div>

    <v-content class="font main">
      <v-card>
        <v-card-title>
          <span>สร้างออร์เดอร์</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-form ref="form">
              <v-row>
                <v-col cols="12" sm="6" md="4">
                  <v-autocomplete
                    label="เลขประจำตัวผู้ป่วย (HN)"
                    :items="patients"
                    item-text="patient_HN"
                    v-model="patient_selected"
                    outlined
                    :rules="[
                      v => !!patient_selected.patient_HN || 'กรุณากรอกข้อมูล'
                    ]"
                    required
                    return-object
                  ></v-autocomplete>
                </v-col>

                <v-col cols="12" sm="6" md="4">
                  <v-autocomplete
                    label="ชื่อผู้ป่วย"
                    :items="patients"
                    item-text="name"
                    v-model="patient_selected"
                    item-value="patient_HN"
                    outlined
                    :rules="[
                      v => !!patient_selected.name || 'กรุณากรอกข้อมูล'
                    ]"
                    required
                    return-object
                  >
                    <template v-slot:item="data">
                      <template v-if="typeof data.item !== 'object'">
                        <v-list-item-content v-text="data.item"></v-list-item-content>
                      </template>
                      <template v-else>
                        <v-list-item-content>
                          <v-list-item-title class="font">
                            {{ data.item.name }}
                            {{ data.item.surname }}
                          </v-list-item-title>
                        </v-list-item-content>
                      </template>
                    </template>
                  </v-autocomplete>
                  <!--components = ชื่อผู้ป่วยที่ดึงจากDB-->
                </v-col>

                <v-col cols="12" sm="6" md="4">
                  <v-text-field
                    label="นามสกุล"
                    v-model="patient_selected.surname"
                    readonly
                    outlined
                  ></v-text-field>
                  <!--components = นามสกุลผู้ป่วยที่ดึงจากDB-->
                </v-col>

                <v-col cols="12" sm="6" md="4">
                  <v-text-field
                    label="ร้านขายยา"
                    :items="patients"
                    item-text="pharmacy_id_patient"
                    v-model="patient_selected.pharmacy_name"
                    outlined
                    readonly
                  ></v-text-field>
                  <!--components = ร้านขายยาผู้ป่วยที่ดึงจากDB-->
                </v-col>

                <v-col cols="12" sm="6" md="4">
                  <v-menu
                    ref="menu"
                    v-model="menu"
                    :close-on-content-click="false"
                    transition="scale-transition"
                    offset-y
                    min-width="290px"
                  >
                    <template v-slot:activator="{ on }">
                      <v-text-field
                        outlined
                        v-model="dateformat"
                        label="วันที่รับยา"
                        readonly
                        v-on="on"
                        :rules="inputrules"
                        required
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      v-model="date"
                      no-title
                      scrollable
                      locale="th"
                      :min="today"
                      class="font"
                      @change="menu = false"
                    ></v-date-picker>
                  </v-menu>
                </v-col>
                <v-col cols="12" sm="6" md="4">
                  <v-menu
                    ref="menu2"
                    v-model="menu2"
                    :close-on-content-click="false"
                    transition="scale-transition"
                    offset-y
                    min-width="290px"
                  >
                    <template v-slot:activator="{ on }">
                      <v-text-field
                        outlined
                        v-model="next_dateformat"
                        label="วันนัดครั้งถัดไป"
                        readonly
                        v-on="on"
                        :rules="inputrules"
                        required
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      v-model="next_date"
                      no-title
                      scrollable
                      locale="th"
                      :min="date||today"
                      class="font"
                      @change="menu2 = false"
                    ></v-date-picker>
                  </v-menu>
                </v-col>
              </v-row>
              <v-card color="teal lighten-4" v-if="disease.length>0">
                <v-card-text>
                  <v-container>
                    <v-row>
                      <v-col cols="12" sm="1" md="1">
                        <!-- <v-checkbox v-model="checkbox1"></v-checkbox> -->
                      </v-col>
                      <v-col cols="12" sm="2" md="3">
                        <p class="subtitle-1 text-xl-center font-weight-black">โรค</p>
                      </v-col>

                      <v-col cols="12" sm="4" md="4">
                        <p class="subtitle-1 text-xl-center font-weight-black">ยา</p>
                      </v-col>

                      <v-col cols="12" sm="4" md="2">
                        <p class="subtitle-1 text-xl-center font-weight-black">วิธีการทานยา</p>
                      </v-col>

                      <v-col cols="12" sm="2" md="2">
                        <p class="subtitle-1 text-xl-center font-weight-black">จำนวน</p>
                      </v-col>
                    </v-row>

                    <v-row v-for="(k, index) in disease" :key="index">
                      <v-col cols="12" sm="1" md="1">
                        <v-checkbox
                          v-if="countItem[index]"
                          v-model="checkbox[index]"
                          color="#2A9D8F"
                        ></v-checkbox>
                      </v-col>

                      <v-col cols="12" sm="2" md="3">
                        <v-text-field
                          v-if="countItem[index]"
                          v-model="disease[index].disease_name"
                          readonly
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="3" md="3">
                        <v-autocomplete
                          :items="medicine[disease[index].disease_id]"
                          outlined
                          v-model="medicine_selected[index]"
                          item-value="medicine_id"
                          @input="checkSameMed(index)"
                        >
                          <template v-slot:selection="data">
                            {{ data.item.medicine_generic }}
                            {{ data.item.strength }}
                          </template>
                          <template v-slot:item="data">
                            <template v-if="typeof data.item !== 'object'">
                              <v-list-item-content v-text="data.item"></v-list-item-content>
                            </template>
                            <template v-else>
                              <v-list-item-content>
                                <v-list-item-title class="font">
                                  {{ data.item.medicine_generic }}
                                  {{ data.item.strength }}
                                </v-list-item-title>
                              </v-list-item-content>
                            </template>
                          </template>
                        </v-autocomplete>
                      </v-col>
                      <v-col
                        cols="12"
                        sm="1"
                        md="1"
                        style="padding:10px;margin:auto;margin-bottom:45px"
                      >
                        <v-icon
                          @click="remove(index)"
                          color="#C85D5C"
                          v-if="!countItem[index]"
                        >mdi-minus-circle</v-icon>
                        <v-icon
                          @click="add(k)"
                          v-if="countItem[index]"
                          color="#41696B"
                        >mdi-plus-circle</v-icon>
                      </v-col>
                      <v-col
                        style="text-align:center;justify-content:center;margin-top:15px;padding-right:70px"
                        cols="12"
                        sm="3"
                        md="2"
                      >
                        <v-icon
                          color="black"
                          @click="chooseTaking(index)"
                          :disabled="medicine_selected[index]==null"
                        >mdi-clock-outline</v-icon>
                      </v-col>

                      <v-col cols="12" sm="2" md="2">
                        <v-text-field outlined v-model="qty_selected[index]" disabled></v-text-field>
                      </v-col>
                    </v-row>
                  </v-container>
                </v-card-text>
              </v-card>
            </v-form>
          </v-container>
          <!-- <small>*indicates required field</small> -->
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <!-- <v-btn color="success" class="mr-4" @click="save" :disabled="validate">บันทึก</v-btn> -->
          <v-btn color="#76C3AF" class="mr-4" @click="save">บันทึก</v-btn>
          <v-btn color="#E1995E" class="mr-4" @click="reset">ล้างข้อมูล</v-btn>
        </v-card-actions>
      </v-card>

      <v-dialog v-model="dialog_taking" persistent max-width="500">
        <v-form ref="form2">
          <v-card class="font">
            <v-card-title style="background-color:#f5ce88">วิธีทานยา</v-card-title>
            <v-card-text>
              <div style="margin-top:10px">
                <!-- <p style="font-size:16px">ยา : {{medInfo.medicine_generic}} {{medInfo.strength}}</p> -->
                <v-row>
                  <v-col cols="5" sm="4" md="4">
                    <p style="margin-top:20px">รับประทานครั้งละ</p>
                  </v-col>
                  <v-col cols="4" sm="5" md="4">
                    <v-text-field
                      style="margin:0px 20px"
                      v-model="numMed[index]"
                      :rules="[v=>!!v||'กรุณากรอกข้อมูล',
                      v=>!isNaN(v)||'กรอกเป็นตัวเลข']"
                      required
                    ></v-text-field>
                  </v-col>
                  <v-col cols="3" sm="3" md="4">
                    <!-- <p style="margin-top:20px">{{medInfo.unit}}</p> -->
                  </v-col>
                </v-row>
              </div>
              <v-divider></v-divider>
              <div>
                <v-radio-group v-model="taking_medRadio[index]">
                  <v-row>
                    <v-radio
                      style="margin:10px"
                      v-for="n in 2"
                      :key="taking_med[n-1]"
                      :label="taking_med[n-1]"
                      :value="taking_med[n-1]"
                    ></v-radio>
                  </v-row>

                  <v-row>
                    <div v-for="(item,i) in taking_meal" :key="i">
                      <v-checkbox
                        :disabled="taking_medRadio[index]==null||taking_medRadio[index]=='เมื่อมีอาการ'"
                        style="margin:15px"
                        v-model="taking_medCB[index]"
                        :label="item"
                        :value="item"
                      >{{item}}</v-checkbox>
                    </div>
                  </v-row>
                  <v-divider></v-divider>
                  <v-row>
                    <v-radio
                      style="margin:10px"
                      :key="taking_med[2]"
                      :label="taking_med[2]"
                      :value="taking_med[2]"
                    ></v-radio>

                    <v-text-field
                      style="margin:0px 20px"
                      :disabled="taking_medRadio[index]!='เมื่อมีอาการ'"
                      v-model="syndrometxt[index]"
                      :rules="[v=>!!v||'กรุณากรอกข้อมูล']"
                      required
                      :hide-details="taking_medRadio[index]!='เมื่อมีอาการ'"
                    ></v-text-field>
                  </v-row>
                  <v-row>
                    <v-col cols="5" sm="4" md="4">
                      <p style="margin-top:20px">รับประทานทุก</p>
                    </v-col>
                    <v-col cols="4" sm="5" md="4">
                      <v-text-field
                        style="margin:0px 20px"
                        :disabled="taking_medRadio[index]!='เมื่อมีอาการ'"
                        v-model="everyMed[index]"
                        :rules="[v=>!!v||'กรุณากรอกข้อมูล',
                      v=>!isNaN(v)||'กรอกเป็นตัวเลข']"
                        required
                        :hide-details="taking_medRadio[index]!='เมื่อมีอาการ'"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="3" sm="3" md="4">
                      <p style="margin-top:20px">ชั่วโมง</p>
                    </v-col>
                  </v-row>
                </v-radio-group>
              </div>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <!-- <v-btn color="green darken-1" text @click="confirmAll">บันทึก</v-btn> -->
              <v-btn color="green darken-1" text @click="checkDialog">ปิด</v-btn>
            </v-card-actions>
          </v-card>
        </v-form>
      </v-dialog>
    </v-content>
  </v-app>
</template>

<script>
import Menu from "../../components/hp_menubar";
import axios from "axios";
import dateFormat from "dateformat";
export default {
  data() {
    return {
      disease: [],
      medicine: [],
      date: null,
      dateformat: null,
      next_date: null,
      next_dateformat: null,
      menu2: false,
      menu: false,
      taking_medRadio: [],
      taking_med: ["ก่อนอาหาร", "หลังอาหาร", "เมื่อมีอาการ"],
      taking_medCB: [],
      taking_meal: ["เช้า", "กลางวัน", "เย็น", "ก่อนนอน"],
      patients: [],
      patient_selected: {},
      medicine_selected: [],
      qty_selected: [],
      pharmacy: [],
      today: dateFormat(new Date(), "yyyy-mm-dd"),
      JSON: {},
      success_alert: false,
      error_alert: false,
      inputrules: [v => !!v || "กรุณากรอกข้อมูล"],
      checkbox: [],
      countItem: [],
      dialog_taking: false,
      medInfo: {},
      index: null,
      numMed: [],
      everyMed: [],
      syndrometxt: [],
      pre_patientinfo: {}
    };
  },
  components: {
    Menu
  },
  mounted() {
    axios.get("http://localhost:3000/api/patient/showpatients").then(res => {
      this.patients = res.data;
    });
    axios.get("http://localhost:3000/api/medicine/showmedicine").then(res => {
      var data = res.data;
      for (var i = 0; i < data.length; i++) {
        if (this.medicine[data[i].disease_id_medicine] == null) {
          this.medicine[data[i].disease_id_medicine] = [];
        }
        this.medicine[data[i].disease_id_medicine].push(data[i]);
      }
    });
  },

  methods: {
    checkDialog() {
      this.calculateDay();
      if (this.taking_medRadio[this.index] == "เมื่อมีอาการ") {
        if (this.$refs.form2.validate()) {
          this.dialog_taking = false;
        }
      } else {
        if (this.numMed[this.index] != null || this.numMed[this.index] != "") {
          if (!isNaN(this.numMed[this.index])) {
            this.dialog_taking = false;
          }
        } else {
          this.dialog_taking = false;
        }
      }
    },
    checkSameMed(index) {
      var checksame = [];
      this.medicine_selected.forEach(item => {
        if (item != null) {
          var i = checksame.indexOf(item);
          if (i == -1) {
            checksame.push(item);
          } else {
            alert("เลือกยาชนิดนี้ไปแล้ว");
            this.remove(index);
          }
        }
      });
    },
    calculateDay() {
      this.disease.forEach((item, i) => {
        this.qty_selected[i] = null;

        if (
          this.dateformat != null &&
          this.next_dateformat != null &&
          this.numMed[i] != null &&
          this.taking_medCB[i].length > 0 &&
          this.taking_medRadio[i] != "เมื่อมีอาการ"
        ) {
          console.log("if");
          var date1 = new Date(this.date);
          var date2 = new Date(this.next_date);
          var Difference_In_Time = date2.getTime() - date1.getTime();
          var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
          this.taking_medCB[i].forEach((element, j) => {
            if (this.taking_medCB[i][j] != null) {
              this.qty_selected[i] +=
                parseInt(Difference_In_Days) * this.numMed[i];
            }
          });
          console.log(Difference_In_Days);
        } else if (
          this.dateformat != null &&
          this.next_dateformat != null &&
          this.numMed[i] != null &&
          this.everyMed[i] != null
        ) {
          var date1 = new Date(this.date);
          var date2 = new Date(this.next_date);
          var Difference_In_Time = date2.getTime() - date1.getTime();
          var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
          console.log(Difference_In_Days);
          var med = 24 / parseInt(this.everyMed[i]);
          this.qty_selected[i] = null;
          this.qty_selected[i] +=
            parseInt(Difference_In_Days) *
            parseInt(med) *
            parseInt(this.numMed[i]);
        }
      });
    },
    chooseTaking(index) {
      if (this.medicine_selected[index] == null) {
        alert("กรุณาเลือกยาก่อน");
      } else {
        this.medInfo = {
          medicine_generic: this.medicine_selected[index].medicine_generic,
          unit: this.medicine_selected[index].unit,
          strength: this.medicine_selected[index].strength
        };
        this.index = index;
        this.dialog_taking = true;
      }
    },
    add(item) {
      var index = this.disease.indexOf(item);
      this.disease.splice(index + 1, 0, item);
      this.qty_selected.splice(index + 1, 0, null);
      this.medicine_selected.splice(index + 1, 0, null);
      this.taking_medRadio.splice(index + 1, 0, null);
      this.taking_medCB.splice(index + 1, 0, [null]);
      this.everyMed.splice(index + 1, 0, null);
      this.numMed.splice(index + 1, 0, null);
      this.syndrometxt.splice(index + 1, 0, null);
      this.checkbox[index + 1] = this.checkbox[index];
      this.count();
    },
    remove(index) {
      this.disease.splice(index, 1);
      this.medicine_selected.splice(index, 1);
      this.qty_selected.splice(index, 1);
      this.taking_medRadio.splice(index, 1);
      this.taking_medCB.splice(index, 1);
      this.everyMed.splice(index, 1);
      this.numMed.splice(index, 1);
      this.syndrometxt.splice(index, 1);
      this.checkbox.splice(index, 1);
      this.count();
    },
    count() {
      for (let i = 1; i < this.disease.length; i++) {
        if (this.disease[i].disease_name != this.disease[i - 1].disease_name) {
          this.countItem[i] = true;
        } else {
          this.countItem[i] = false;
        }
      }
    },
    reset() {
      this.$refs.form.reset();

      this.patient_selected = {};
      this.disease = [];
      this.$refs.form2.reset();
    },
    JSONformat() {
      this.JSON = {
        due_date: this.date,
        next_due_date: this.next_date,
        status: "create-order",
        patient_HN_order: this.patient_selected.patient_HN,
        staff_id_order: localStorage.getItem("staff_id"),
        pharmacy_id: this.patient_selected.pharmacy_id
      };
    },
    formatDate(date) {
      if (!date) return null;

      var [year, month, day] = date.split("-");
      year = parseInt(year) + 543;
      return `${day}/${month}/${year}`;
    },
    parseDate(date) {
      var [day, month, year] = date.split("/");
      year = parseInt(year) - 543;
      return `${year}/${month}/${day}`;
    },
    save() {
      if (this.$refs.form.validate() && this.check_checkbox()) {
        this.JSONformat();
        var check = 1;
        for (var i = 0; i < this.disease.length; i++) {
          if (this.checkbox[i]) {
            if (this.qty_selected[i] == null) {
              check = 0;
              alert("กรอกข้อมูลไม่ครบ");
            }
          }
        }
        //new order
        console.log(this.JSON);

        if (check) {
          // console.log({
          //   medicine_id: this.medicine_selected[0].medicine_id,
          //   qty: this.qty_selected[0],
          //   administration: this.parseString(0),
          //   numpertime: this.numMed[0]
          // });
          axios
            .post("http://localhost:3000/api/order/neworder", this.JSON)
            .then(res => {
              for (var i = 0; i < this.disease.length; i++) {
                console.log(this.checkbox[i]);
                if (this.checkbox[i]) {
                  axios
                    .post("http://localhost:3000/api/order/neworder_detail", {
                      order_id: res.data.insertId,
                      medicine_id: this.medicine_selected[i],
                      qty: this.qty_selected[i],
                      administration: this.parseString(i),
                      numpertime: this.numMed[i]
                    })
                    .then(detail => {
                      this.success_alert = true;
                      this.reset();
                      setTimeout(() => {
                        this.success_alert = false;
                        // this.$refs.form.reset();
                        // this.$refs.form2.reset();
                      }, 1000);
                    })
                    .catch(e => {
                      console.log(e);
                      this.delete_order(res.data.insertId);
                    });
                }
              }
              //add log :status create-order
              axios
                .post("http://localhost:3000/api/log/newlog", {
                  status: "create-order",
                  start_date: dateFormat(new Date(), "yyyy/mm/dd"),
                  staff_id_log: localStorage.getItem("staff_id"),
                  order_id_log: res.data.insertId
                })
                .catch(e => {
                  this.delete_order(res.data.insertId);
                });
            })
            .catch(e => {
              console.log(e);
              this.error_alert = true;
              setTimeout(() => {
                this.error_alert = false;
              }, 1000);
            });
        }
      }
    },
    check_checkbox() {
      return this.checkbox.find(function(element, i) {
        return element == true;
      });
    },
    parseString(index) {
      //join administration to string
      var str = [this.taking_medRadio[index]];
      if (this.taking_medRadio[index] != "เมื่อมีอาการ") {
        this.taking_medCB[index].forEach(item => {
          if (item != null) {
            str.push(item);
          }
        });
      } else {
        str.push(this.syndrometxt[index]);
        str.push(this.everyMed[index]);
      }
      return str.join("*");
    },
    delete_order(id) {
      axios
        .post("http://localhost:3000/api/order/del_order", { order_id: id })
        .catch(e => {
          console.log(e);
        });
    }
  },
  watch: {
    dateformat() {
      this.calculateDay();
    },
    next_dateformat() {
      this.calculateDay();
    },
    patient_selected() {
      if (this.patient_selected.patient_HN != null) {
        axios
          .post(
            "http://localhost:3000/api/disease-patient/getdiseasenamebyhn",
            {
              patient_HN: this.patient_selected.patient_HN
            }
          )
          .then(res => {
            axios
              .post("http://localhost:3000/api/order/getpatientinfo", {
                patient_HN: this.patient_selected.patient_HN
              })
              .then(res1 => {
                this.qty_selected = [];
                this.medicine_selected = [];
                this.taking_medCB = [[]];
                this.taking_medRadio = [];
                this.disease = res.data;
                for (let index = 0; index < this.disease.length; index++) {
                  this.countItem[index] = true;
                  this.qty_selected.push(null);
                  this.medicine_selected.push(null);
                  this.taking_medCB.push([null]);
                  this.taking_medRadio.push(null);
                }
                this.checkbox = [];
                var count = 0;
                if (res1.data.length > 0) {
                  this.date = dateFormat(
                    res1.data[0].next_due_date,
                    "yyyy-mm-dd"
                  );
                  this.dateformat = this.formatDate(this.date);
                  var order_id = res1.data[0].order_id;
                  var disease = res1.data[0].disease_id_medicine;
                  var j = 0;
                  for (var i = 0; i < res1.data.length; i++) {
                    console.log("i=" + i);
                    console.log("count" + count);
                    var item = res1.data[i];
                    if (item.order_id == order_id) {
                      if (item.disease_id_medicine == disease) {
                        if (count != 0) {
                          //add
                          this.add(this.disease[i - 1]);
                          console.log("add");
                          count++;
                        } else count++;
                      } else count = 0;
                      this.medicine_selected[i] = item.medicine_id;
                      this.numMed[i] = item.numpertime;
                      var administration = item.administration.split("*");
                      this.taking_medRadio[i] = administration[0];
                      if (administration[0] == "เมื่อมีอาการ") {
                        this.syndrometxt[i] = administration[1];
                        this.everyMed[i] = parseInt(administration[2]);
                      } else {
                        for (var k = 1; k < administration.length; k++) {
                          this.taking_medCB[i][k - 1] = administration[k];
                        }
                      }
                    } else {
                      break;
                    }
                    order_id = res1.data[i].order_id;
                    disease = res1.data[i].disease_id_medicine;
                    j++;
                  }
                  this.checkbox = [];
                } else {
                  this.date = null;
                  for (let index = 0; index < this.disease.length; index++) {
                    this.countItem[index] = true;
                    this.qty_selected.push(null);
                    this.medicine_selected.push(null);
                    this.taking_medCB.push([null]);
                    this.taking_medRadio.push(null);
                  }
                  this.checkbox = [];
                }
              });
          })
          .catch(e => {
            console.log("getdisease error " + e);
          });
      }
    },
    taking_medRadio() {
      if (this.taking_medRadio[this.index] == "เมื่อมีอาการ") {
        this.taking_medCB[this.index] = [];
      } else {
      }
    },
    date(val) {
      this.dateformat = this.formatDate(this.date);
    },
    next_date(val) {
      this.next_dateformat = this.formatDate(this.next_date);
    },
    checkbox() {
      console.log(this.countItem);
      for (let i = 0; i < this.disease.length; i++) {
        if (this.countItem[i] == true) {
          var checked = this.checkbox[i];
        }
        this.checkbox[i] = checked;
      }
    }
    // medicine_selected() {
    //   console.log(this.medicine_selected);
    // }
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
.alert {
  position: fixed;
  z-index: 2;
  width: 100%;
}
</style>
