<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main">
      <v-card>
        <v-card-title>
          <span>สร้างออร์เดอร์</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-date-picker v-model="picker" v-if="click"></v-date-picker>
            <v-row>
              <v-col cols="12" sm="6" md="12" align="right">order id : {{order_id}}</v-col>
            </v-row>
            <v-row>
              <v-col cols="12" sm="6" md="6">
                <v-autocomplete
                  label="เลขประจำตัวผู้ป่วย (HN)"
                  :items="patients"
                  item-text="patient_HN"
                  v-model="patient_selected"
                  return-object
                  outlined
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
                ></v-autocomplete>
                <!--components = ชื่อผู้ป่วยที่ดึงจากDB-->
              </v-col>

              <v-col cols="12" sm="6" md="6">
                <v-autocomplete
                  label="นามสกุล"
                  :items="patients"
                  item-text="surname"
                  v-model="patient_selected"
                  readonly
                  outlined
                ></v-autocomplete>
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
                    <v-text-field v-model="date" label="วันที่รับยา" readonly v-on="on"></v-text-field>
                  </template>
                  <v-date-picker v-model="date" no-title scrollable locale="th">
                    <v-spacer></v-spacer>
                    <v-btn text color="primary" @click="menu = false">Cancel</v-btn>
                    <v-btn text color="primary" @click="$refs.menu.save(date)">OK</v-btn>
                  </v-date-picker>
                </v-menu>
              </v-col>

              <v-col cols="12" sm="6" md="6">
                <v-autocomplete
                  label="ร้านขายยา"
                  :items="patients"
                  item-text="pharmacy_id_patient"
                  v-model="patient_selected"
                  outlined
                  readonly
                ></v-autocomplete>
                <!--components = ร้านขายยาผู้ป่วยที่ดึงจากDB-->
              </v-col>
            </v-row>
            <v-card color="teal lighten-4">
              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col cols="12" sm="3" md="3">
                      <p class="subtitle-1 text-xl-center font-weight-black">โรค</p>
                    </v-col>

                    <v-col cols="12" sm="3" md="3">
                      <p class="subtitle-1 text-xl-center font-weight-black">ยา</p>
                    </v-col>

                    <v-col cols="12" sm="4" md="4">
                      <p class="subtitle-1 text-xl-center font-weight-black">วิธีการรับประทานยา</p>
                    </v-col>

                    <v-col cols="12" sm="2" md="2">
                      <p class="subtitle-1 text-xl-center font-weight-black">จำนวน</p>
                    </v-col>
                  </v-row>

                  <v-row v-for="k in inputs.length" :key="k">
                    <v-col cols="12" sm="1" md="1">
                      <v-checkbox v-model="checkbox1"></v-checkbox>
                    </v-col>

                    <v-col cols="12" sm="3" md="3">
                      <v-text-field label="โรค"></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="3" md="3">
                      <v-text-field label="ยา"></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="3" md="3">
                      <v-text-field label="วิธีการรับประทานยา"></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="2" md="2">
                      <v-text-field label="จำนวน" solo clearable></v-text-field>
                    </v-col>
                  </v-row>
                </v-container>
              </v-card-text>
            </v-card>
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
export default {
  data() {
    return {
      inputs: [1, 2],
      date: new Date().toISOString().substr(0, 10),
      menu: false,
      dialog_record: false,
      index: 0,
      patient_selected: null,
      select_order: [],
      selectedpharmacy: [],
      patients: [],
      patient_selected: {},
      pharmacy: []
    };
  },
  components: {
    Menu
  },
  methods: {
    reset() {
      this.$refs.form.reset();
    },
    showItem(item) {
      this.patient_selected = item.name + " " + item.surname;
      this.index = this.patients.indexOf(item);
      this.dialog_record = true;
    },
    selectpharmacy(item) {
      console.log(item.length);
      this.selectedpharmacy = item;
      if (item.length == 0) {
        this.select_order = [];
        for (var i = 0; i < this.patients.length; i++) {
          this.select_order.push(this.patients[i]);
        }
      } else {
        var count = 0;
        this.select_order = [];
        for (var i = 0; i < item.length; i++) {
          for (var j = 0; j < this.patients.length; j++) {
            if (this.patients[j].pharmacy == item[i]) {
              this.select_order.push(this.patients[j]);
            }
          }
        }
      }
    }
  },
  mounted() {
    for (var i = 0; i < this.patients.length; i++) {
      this.select_order.push(this.patients[i]);
    }
    axios.get("http://localhost:3000/api/patient/showpatients").then(res => {
      this.patients = res.data;
    });
    axios.get("http://localhost:3000/api/user/showpharmacy").then(pharmacy => {
      this.pharmacy = pharmacy.data;
    });
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