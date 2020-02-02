<template>
  <v-app class="font cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>
    <v-content class="main">
      <v-row>
        <v-col align="left" style="font-size:25px">ข้อมูลผู้ป่วย</v-col>
        <v-col align="right">
          <v-dialog v-model="dialog_edit" persistent max-width="700px">
            <template v-slot:activator="{ on }">
              <v-btn color="primary" dark v-on="on">+ เพิ่มข้อมูลผู้ป่วยรายใหม่</v-btn>
            </template>
            <v-card class="blue-grey lighten-5 font">
              <v-card-title>
                <span>{{formTitle}}</span>
              </v-card-title>
              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col cols="12" sm="12" align="right">HN: {{patients[index].HN}}</v-col>
                    <v-col cols="12" sm="6">
                      <v-text-field v-model="editedItem.name" label="ชื่อ" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6">
                      <v-text-field v-model="editedItem.surname" label="นามสกุล" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="4">
                      <v-text-field v-model="editedItem.gender" label="เพศ" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="2">
                      <v-text-field v-model="age" label="อายุ" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6">
                      <v-text-field v-model="editedItem.DOB" label="วัน/เดือน/ปีเกิด" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6">
                      <v-text-field v-model="editedItem.email" label="อีเมล" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6">
                      <v-text-field v-model="editedItem.Telno" label="เบอร์โทรศัพท์" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="12">
                      <v-text-field v-model="editedItem.address" label="ที่อยู่" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="4">
                      <v-text-field v-model="editedItem.subdistrict" label="ตำบล/แขวง" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="4">
                      <v-text-field v-model="editedItem.district" label="อำเภอ/เขต" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="4">
                      <v-text-field v-model="editedItem.province" label="จังหวัด" outlined></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="12">
                      <v-select :items="disease" chips label="เลือกโรค" multiple outlined clearable></v-select>
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-select
                        :items="pharmacy"
                        item-text="pharmacy_name"
                        item-value="pharmacy_id"
                        label="ร้านขายยา"
                        outlined
                        v-model="editedItem.pharmacy_id_patient"
                      ></v-select>
                      <!-- <v-text-field v-model="editedItem.pharmacy" label="ร้านขายยา" outlined></v-text-field> -->
                    </v-col>
                  </v-row>
                </v-container>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn @click="close" rounded color="red lighten-1" large>ปิด</v-btn>
                <v-btn rounded color="green lighten-1" large @click="save">เสร็จสิ้น</v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-col>
      </v-row>
      <!-- End of Add new patient -->

      <!-- watch patient history -->
      <v-dialog
        v-model="dialog_record"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card class="font">
          <v-card-title class="teal lighten-2 elevation-3">
            <v-btn icon dark @click="dialog_record = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <span>ข้อมูลผู้ป่วย</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12" sm="6">
                  <v-text-field
                    :value="patient_selected"
                    label="ชื่อ-นามสกุลผู้ป่วย"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field :value="patients[index].gender" label="เพศ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="4">
                  <v-text-field :value="age" label="อายุ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="8">
                  <v-text-field
                    :value="patients[index].DOB"
                    label="วัน/เดือน/ปีเกิด"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field :value="patients[index].email" label="อีเมล" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    :value="patients[index].Telno"
                    label="เบอร์โทรศัพท์"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    :value="patients[index].pharmacy_name"
                    label="ร้านขายยา"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field value="Januvia 100 mg 2 tablets" label="ยา" filled readonly></v-text-field>
                </v-col>
              </v-row>
              <v-data-table :headers="record_headers" :items="patients[index].record"></v-data-table>
            </v-container>
          </v-card-text>
        </v-card>
      </v-dialog>

      <!-- Data Table of patient page -->
      <v-data-table :headers="headers" :items="patients" :items-per-page="10" class="elevation-1">
        <template v-slot:body="{ items }">
          <tbody>
            <tr v-for="item in items" :key="item.name">
              <td>{{ item.patient_HN }}</td>
              <td>{{ item.name }} {{item.surname}}</td>
              <td style="text-align:center">{{ item.email }}</td>
              <td style="text-align:center">{{ item.Telno }}</td>
              <td style="text-align:center">{{ item.pharmacy_name}}</td>
              <td style="text-align:center">
                <v-icon small class="mr-2" @click="showItem(item)">mdi-eye</v-icon>
              </td>
              <td style="text-align:center">
                <v-icon small class="mr-2" @click="editItem(item)">mdi-pencil</v-icon>
                <v-icon small class="mr-2" @click="deleteItem(item)">mdi-delete</v-icon>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>
      <!-- Data Table of patient page -->
    </v-content>
  </v-app>
</template>
<script>
import Menu from "../../components/hp_menubar";
import axios from "axios";
export default {
  data() {
    return {
      disease: ["เบาหวาน", "หอบหืด", "ความดันโลหิตสูง", "จิตเวช"],
      dialog: false,
      dialog_record: false,
      dialog_edit: false,
      index: 0,
      editedIndex: -1,
      headers: [
        {
          text: "HN",
          align: "left",
          sortable: false,
          value: "hn"
        },
        { text: "ชื่อ-นามสกุลผู้ป่วย", align: "center", value: "name" },
        { text: "อีเมล", align: "center", value: "email" },
        { text: "เบอร์โทรศัพท์", align: "center", value: "phone" },
        { text: "ร้านขายยา", align: "center", value: "pharmacy" },
        { text: "ประวัติการตรวจ", align: "center", value: "history" },
        { text: "แก้ไข/ลบ", align: "center", value: "edit" }
      ],
      record_headers: [
        {
          text: "ลำดับที่",
          align: "right",
          sortable: true,
          value: "no"
        },
        { text: "วันที่บันทึก", align: "center", value: "date" },
        { text: "น้ำหนัก", align: "center", value: "weight" },
        { text: "ส่วนสูง", align: "center", value: "height" },
        { text: "ความดันเลือด", align: "center", value: "pressure" },
        { text: "ผู้ตรวจ", align: "center", value: "pharmacist" }
      ],
      patients: [],
      pharmacy: [],
      age: "",
      patient_selected: null,
      editedItem: {
        name: "",
        surname: "",
        gender: "",
        DOB: "",
        email: "",
        Telno: "",
        pharmacy_id_patient: "",
        address: "",
        subdistrict: "",
        district: "",
        province: ""
      },
      defaultItem: {
        name: "",
        surname: "",
        gender: "",
        dob: "",
        email: "",
        phone: "",
        pharmacy: "",
        address: "",
        record: []
      }
    };
  },
  computed: {
    formTitle() {
      return this.editedIndex === -1
        ? "ข้อมูลผู้ป่วยรายใหม่"
        : "แก้ไขข้อมูลผู้ป่วย";
    }
  },
  components: {
    Menu
  },
  methods: {
    showItem(item) {
      this.patient_selected = item.name + " " + item.surname;
      this.index = this.patients.indexOf(item);
      var date = new Date();
      var dob = new Date(this.patients[this.index].DOB);
      console.log("dob" + dob.getFullYear());
      var age = date.getFullYear() + 543 - dob.getFullYear();
      this.age = age;
      this.dialog_record = true;
    },
    editItem(item) {
      this.index = this.patients.indexOf(item);
      this.editedIndex = this.patients.indexOf(item);
      this.patient_selected = item.name + " " + item.surname;
      this.editedItem = Object.assign({}, item);
      this.dialog_edit = true;
    },
    deleteItem(item) {
      const index = this.patients.indexOf(item);
      const hn = { patient_HN: this.patients[index].patient_HN };
      confirm(
        "คุณต้องการที่จะลบข้อมูลผู้ป่วยใช่หรือไม่?\nคุณ" +
          item.name +
          " " +
          item.surname
      ) &&
        axios
          .post("http://localhost:3000/api/patient/deletepatient", hn)
          .then(res => {
            this.patients.splice(index, 1);
          })
          .catch(e => {
            console.log("delete error " + e);
          });
    },
    save() {
      console.log(this.editedItem);
      if (this.editedIndex > -1) {
        axios
          .post(
            "http://localhost:3000/api/patient/editpatient",
            this.editedItem
          )
          .then(res => {
            Object.assign(this.patients[this.editedIndex], this.editedItem);
          })
          .catch(e => {
            console.log("edit error " + e);
          });
      } else {
        axios
          .post("http://localhost:3000/api/patient/newpatient", this.editedItem)
          .then(res => {
            this.patients.push(this.editedItem);
          })
          .catch(e => {
            console.log("newpatient error " + e);
          });
      }
      this.close();
    },
    close() {
      this.dialog_edit = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.age = null;
        this.editedIndex = -1;
      }, 300);
    }
  },
  mounted() {
    axios.get("http://localhost:3000/api/patient/showpatients").then(res => {
      this.patients = res.data;
    });
    axios.get("http://localhost:3000/api/user/showpharmacy").then(pharmacy => {
      this.pharmacy = pharmacy.data;
    });
  },
  watch: {
    age() {
      // var date = new Date();
      // var dob = new Date(this.patients[index].DOB);
      // var age = date.getFullYear - dob.getFullYear;
      // console.log(age);
    }
  }
};
</script>

<style>
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.font {
  font-family: "Sarabun", sans-serif;
}
thead {
  background-color: #ffd54f;
}
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