<template>
  <v-app class="font cyan lighten-5">
    <v-alert class="alert font" type="success" :value="success_alert">
      บันทึกข้อมูลสำเร็จ
    </v-alert>
    <v-alert class="alert font" type="warning" :value="error_alert">
      บันทึกข้อมูลไม่สำเร็จ
    </v-alert>
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
            <!-- <v-row>
              <v-col cols="12" sm="6" md="12" align="right">order id : {{order_id}}</v-col>
            </v-row> -->
            <v-form ref="form">
              <v-row>
                <v-col cols="12" sm="6" md="6">
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
              </v-row>

              <v-row>
                <v-col cols="12" sm="6" md="6">
                  <v-autocomplete
                    label="ชื่อผู้ป่วย"
                    :items="patients"
                    item-text="name"
                    v-model="patient_selected"
                    outlined
                    return-object
                  >
                    <template v-slot:item="data">
                      <template v-if="typeof data.item !== 'object'">
                        <v-list-item-content
                          v-text="data.item"
                        ></v-list-item-content>
                      </template>
                      <template v-else>
                        <v-list-item-content>
                          <v-list-item-title class="font"
                            >{{ data.item.name }}
                            {{ data.item.surname }}</v-list-item-title
                          >
                        </v-list-item-content>
                      </template>
                    </template></v-autocomplete
                  >
                  <!--components = ชื่อผู้ป่วยที่ดึงจากDB-->
                </v-col>

                <v-col cols="12" sm="6" md="6">
                  <v-text-field
                    label="นามสกุล"
                    v-model="patient_selected.surname"
                    readonly
                    outlined
                  ></v-text-field>
                  <!--components = นามสกุลผู้ป่วยที่ดึงจากDB-->
                </v-col>

                <v-col cols="12" sm="6">
                  <!-- <v-text-field
                  @click="click=!click"
                  label="วันที่รับยา"
                  required
                  v-model="picker"
                  outlined
                ></v-text-field>-->
                  <v-menu
                    ref="menu"
                    v-model="menu"
                    :close-on-content-click="false"
                    :return-value.sync="date"
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
                        persistent-hint
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
                    >
                      <v-spacer></v-spacer>
                      <v-btn text color="primary" @click="menu = false"
                        >Cancel</v-btn
                      >
                      <v-btn text color="primary" @click="$refs.menu.save(date)"
                        >OK</v-btn
                      >
                    </v-date-picker>
                  </v-menu>
                </v-col>

                <v-col cols="12" sm="6" md="6">
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
              </v-row>
              <v-card color="teal lighten-4">
                <v-card-text>
                  <v-container>
                    <v-row>
                      <v-col cols="12" sm="1" md="1">
                        <!-- <v-checkbox v-model="checkbox1"></v-checkbox> -->
                      </v-col>
                      <v-col cols="12" sm="3" md="3">
                        <p class="subtitle-1 text-xl-center font-weight-black">
                          โรค
                        </p>
                      </v-col>

                      <v-col cols="12" sm="3" md="3">
                        <p class="subtitle-1 text-xl-center font-weight-black">
                          ยา
                        </p>
                      </v-col>

                      <v-col cols="12" sm="4" md="3">
                        <p class="subtitle-1 text-xl-center font-weight-black">
                          วิธีการรับประทานยา
                        </p>
                      </v-col>

                      <v-col cols="12" sm="2" md="2">
                        <p class="subtitle-1 text-xl-center font-weight-black">
                          จำนวน
                        </p>
                      </v-col>
                    </v-row>

                    <v-row v-for="(k, index) in disease.length" :key="k">
                      <v-col cols="12" sm="1" md="1">
                        <v-checkbox v-model="checkbox[index]"></v-checkbox>
                      </v-col>

                      <v-col cols="12" sm="3" md="3">
                        <v-text-field
                          v-model="disease[index].name"
                          readonly
                        ></v-text-field>
                      </v-col>

                      <v-col cols="12" sm="3" md="3">
                        <v-autocomplete
                          :items="medicine[disease[index].disease_id]"
                          item-text="medicine_generic"
                          item-value="medicine_id"
                          v-model="medicine_selected[disease[index].disease_id]"
                          outlined
                        ></v-autocomplete>
                      </v-col>

                      <v-col cols="12" sm="3" md="3">
                        <v-autocomplete
                          :items="taking"
                          multiple
                          outlined
                          clearable
                          v-model="taking_selected[disease[index].disease_id]"
                        ></v-autocomplete>
                      </v-col>

                      <v-col cols="12" sm="2" md="2">
                        <v-text-field
                          solo
                          clearable
                          v-model="qty_selected[disease[index].disease_id]"
                        ></v-text-field>
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
          <v-btn color="success" class="mr-4" @click="save">บันทึก</v-btn>
          <v-btn color="warning" class="mr-4" @click="reset">ล้างข้อมูล</v-btn>
        </v-card-actions>
      </v-card>
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
      disease: [""],
      medicine: [[]],
      date: null,
      dateformat: null,
      menu: false,
      patients: [],
      taking: [
        "ก่อนอาหาร-เช้า",
        "ก่อนอาหาร-กลางวัน",
        "ก่อนอาหาร-เย็น",
        "ก่อนอาหาร-ก่อนนอน",
        "หลังอาหาร-เช้า",
        "หลังอาหาร-กลางวัน",
        "หลังอาหาร-เย็น",
        "หลังอาหาร-ก่อนนอน"
      ],
      taking_selected: [],
      patient_selected: {},
      medicine_selected: [],
      qty_selected: [],
      pharmacy: [],
      today: dateFormat(new Date(), "yyyy-mm-dd"),
      JSON: {},
      success_alert: false,
      error_alert: false,
      inputrules: [v => !!v || "กรุณากรอกข้อมูล"],
      checkbox: []
    };
  },
  components: {
    Menu
  },
  watch: {
    patient_selected() {
      axios
        .post("http://localhost:3000/api/disease-patient/getdiseasenamebyhn", {
          patient_HN: this.patient_selected.patient_HN
        })
        .then(res => {
          this.disease = res.data;
          // console.log(this.disease);
        })
        .catch(e => {
          console.log("getdisease error " + e);
        });
    },
    date(val) {
      this.dateformat = this.formatDate(this.date);
      console.log(this.dateformat);
    }
  },
  methods: {
    reset() {
      this.$refs.form.reset();
      this.patient_selected = {};
    },
    JSONformat() {
      this.JSON = {
        due_date: this.parseDate(this.dateformat),
        status: "create-order",
        patient_HN_order: this.patient_selected.patient_HN,
        staff_id_order: localStorage.getItem("staff_id")
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
        //new order
        axios
          .post("http://localhost:3000/api/order/neworder", this.JSON)
          .then(res => {
            for (var i = 0; i < this.disease.length; i++) {
              if (this.checkbox[i] == true) {
                //add  detail each medicine (only selected)
                axios
                  .post("http://localhost:3000/api/order/neworder_detail", {
                    order_id: res.data.insertId,
                    medicine_id: this.medicine_selected[
                      this.disease[i].disease_id
                    ],
                    qty: this.qty_selected[this.disease[i].disease_id],
                    administration: this.parseString(
                      this.taking_selected[this.disease[i].disease_id]
                    )
                  })
                  .then(detail => {
                    this.success_alert = true;
                    this.reset();
                    setTimeout(() => {
                      this.success_alert = false;
                    }, 5000);
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
            }, 5000);
          });
      }
    },
    check_checkbox() {
      return this.checkbox.find(function(element) {
        return element == true;
      });
    },
    parseString(item) {
      return item.join(",");
    },
    delete_order(id) {
      axios
        .post("http://localhost:3000/api/order/del_order", { order_id: id })
        .catch(e => {
          console.log(e);
        });
    }
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
          this.taking_selected[data[i].disease_id_medicine] = [];
          this.medicine_selected[data[i].disease_id_medicine] = [];
          this.qty_selected[data[i].disease_id_medicine] = [];
        }
        this.medicine[data[i].disease_id_medicine].push(data[i]);
      }
      // console.log(this.medicine);
    });
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
