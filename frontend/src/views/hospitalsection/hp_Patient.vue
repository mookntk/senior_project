<template>
  <v-app class="cyan lighten-5">
    <div class="menu-header">
      <Menu />
    </div>

    <v-content class="font main">
      <v-row>
        <v-col align="left" style="font-size:25px">ข้อมูลผู้ป่วย</v-col>
        <v-spacer></v-spacer>
        <v-col align="right">
          <!-- ช่อง search -->
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="ค้นหา"
            single-line
            hide-details
            solo
          ></v-text-field>
        </v-col>

        <v-col align="right">
          <v-dialog v-model="dialog_edit" persistent max-width="700px">
            <template v-slot:activator="{ on }">
              <v-btn color="primary" dark v-on="on">+ เพิ่มข้อมูลผู้ป่วยรายใหม่</v-btn>
            </template>
            <v-card class="blue-grey lighten-5 font">
              <v-card-title>
                <span>{{ formTitle }}</span>
              </v-card-title>
              <v-card-text>
                <v-container>
                  <v-form ref="form">
                    <v-row>
                      <v-spacer></v-spacer>
                      <v-col cols="12" sm="3" align="right">
                        <v-text-field
                          v-model="editedItem.patient_HN"
                          label="HN"
                          outlined
                          :rules="numberrules"
                          required
                        ></v-text-field>
                      </v-col>
                    </v-row>
                    <v-row>
                      <v-col cols="12" sm="6">
                        <v-text-field
                          v-model="editedItem.name"
                          label="ชื่อ"
                          outlined
                          :rules="inputrules"
                          required
                          counter
                          maxlength="30"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" sm="6">
                        <v-text-field
                          v-model="editedItem.surname"
                          label="นามสกุล"
                          outlined
                          :rules="inputrules"
                          required
                          counter
                          maxlength="30"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" sm="6">
                        <v-radio-group
                          v-model="editedItem.gender"
                          label="เพศ"
                          row
                          required
                          :rules="[v => !!v || 'กรุณาเลือกเพศ']"
                        >
                          <v-radio label="ชาย" value="ชาย" style="margin-left:25px;"></v-radio>
                          <v-radio label="หญิง" value="หญิง" style="margin-left:25px;"></v-radio>
                        </v-radio-group>
                      </v-col>
                      <v-col cols="12" lg="6" sm="6">
                        <v-menu
                          v-model="menu1"
                          :close-on-content-click="false"
                          transition="scale-transition"
                          offset-y
                          max-width="290px"
                          min-width="290px"
                        >
                          <template v-slot:activator="{ on }">
                            <v-text-field
                              v-model="editedItem.DOB"
                              label="วัน/เดือน/ปีเกิด"
                              outlined
                              persistent-hint
                              readonly
                              v-on="on"
                              :rules="addressrules"
                            ></v-text-field>
                          </template>
                          <v-date-picker
                            v-model="date"
                            no-title
                            @input="menu1 = false"
                            locale="th"
                            class="font"
                          ></v-date-picker>
                        </v-menu>
                      </v-col>
                      <v-col cols="12" sm="6">
                        <v-text-field
                          v-model="editedItem.email"
                          label="อีเมล"
                          outlined
                          :rules="emailrules"
                          required
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" sm="6">
                        <v-text-field
                          v-model="editedItem.telno"
                          label="เบอร์โทรศัพท์"
                          outlined
                          :rules="phonerules"
                          required
                          counter
                          maxlength="10"
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" sm="12">
                        <v-text-field
                          v-model="editedItem.address"
                          label="ที่อยู่"
                          :rules="addressrules"
                          outlined
                          required
                        ></v-text-field>
                      </v-col>
                      <v-col cols="12" sm="6">
                        <ThailandAutoComplete
                          v-model="editedItem.subdistrict"
                          type="district"
                          @select="select"
                          color="#42b883"
                          size="medium"
                          placeholder="ตำบล/แขวง"
                        />
                      </v-col>
                      <v-col cols="12" sm="6">
                        <ThailandAutoComplete
                          v-model="editedItem.district"
                          type="amphoe"
                          @select="select"
                          size="medium"
                          placeholder="อำเภอ/เขต"
                        />
                      </v-col>
                      <v-col cols="12" sm="6">
                        <ThailandAutoComplete
                          v-model="editedItem.province"
                          type="province"
                          @select="select"
                          size="medium"
                          color="#35495e"
                          placeholder="จังหวัด"
                        />
                      </v-col>
                      <v-col cols="12" sm="6">
                        <ThailandAutoComplete
                          v-model="editedItem.zipcode"
                          type="zipcode"
                          @select="select"
                          size="medium"
                          color="#00a4e4"
                          placeholder="รหัสไปรษณีย์"
                        />
                      </v-col>
                      <v-col cols="12" sm="12">
                        <v-autocomplete
                          :items="disease"
                          item-text="disease_name"
                          item-value="disease_id"
                          label="เลือกโรค"
                          multiple
                          outlined
                          clearable
                          v-model="disease_selected"
                          :rules="[v => !!v || 'กรุณาเลือกโรค']"
                          required
                        ></v-autocomplete>
                      </v-col>
                      <v-col cols="12" sm="8">
                        <v-autocomplete
                          :items="pharmacy"
                          item-text="pharmacy_name"
                          item-value="pharmacy_id"
                          label="ร้านขายยา"
                          v-model="editedItem.pharmacy_id_patient"
                          outlined
                          :rules="[v => !!v || 'กรุณาเลือกร้านขายยา']"
                          required
                        ></v-autocomplete>
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
        </v-col>
      </v-row>

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
                    :value="patient_selected.name+' '+patient_selected.surname"
                    label="ชื่อ-นามสกุลผู้ป่วย"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field :value="patient_selected.gender" label="เพศ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="4">
                  <v-text-field :value="age" label="อายุ" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="8">
                  <v-text-field
                    :value="patient_selected.DOB"
                    label="วัน/เดือน/ปีเกิด"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field :value="patient_selected.email" label="อีเมล" filled readonly></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    :value="patient_selected.telno"
                    label="เบอร์โทรศัพท์"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-text-field
                    :value="patient_selected.pharmacy_name"
                    label="ร้านขายยา"
                    filled
                    readonly
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6">
                  <v-autocomplete
                    :items="disease"
                    item-text="disease_name"
                    item-value="disease_id"
                    v-model="disease_selected"
                    label="โรค"
                    filled
                    multiple
                    readonly
                    append-icon="mdi-blank"
                  ></v-autocomplete>
                </v-col>
              </v-row>
              <v-data-table :headers="record_headers" :items="record">
                <!-- <template v-slot:body="{ items }">
                  <tbody>
                    <tr v-for="(item,i) in items" :key="i">
                      <td>{{ i+1 }}</td>
                      <td>{{ setDate(item.date) }}</td>
                      <td style="text-align:center">{{ item.weight }}</td>
                      <td style="text-align:center">{{ item.height}}</td>
                      <td style="text-align:center">{{ item.pressure_sys }}/{{item.pressure_di}}</td>
                      <td style="text-align:center">{{ item.name}} {{item.surname}}</td>
                      <td style="text-align:center">{{ item.name}} {{item.surname}}</td>
                    </tr>
                  </tbody>
                </template>-->
                <template v-slot:item.no="{item}">{{record.indexOf(item)+1}}</template>
                <template v-slot:item.date="{item}">{{ setDate(item.date) }}</template>
                <template v-slot:item.pressure="{item}">{{ item.pressure_sys }}/{{item.pressure_di}}</template>
                <template v-slot:item.pharmacist="{item}">{{ item.name}} {{item.surname}}</template>
                <template v-slot:no-data>ไม่มีประวัติการตรวจ</template>
              </v-data-table>
            </v-container>
          </v-card-text>
        </v-card>
      </v-dialog>

      <!-- Data Table of patient page -->
      <v-data-table
        :headers="headers"
        :search="search"
        :items="patients"
        :items-per-page="10"
        sort-by="HN"
        class="elevation-1"
      >
        <template v-slot:item.name="{item}">{{item.name}} {{item.surname}}</template>
        <template v-slot:item.history="{item}">
          <v-icon size="20" class="mr-2" @click="showItem(item)" color="black">mdi-eye</v-icon>
        </template>
        <template v-slot:item.action="{item}">
          <v-icon size="20" class="mr-2" @click="editItem(item)" color="#77B3D5">mdi-pencil</v-icon>
          <v-icon size="20" class="mr-2" @click="deleteItem(item)" color="#C85D5C">mdi-delete</v-icon>
        </template>
        <template v-slot:no-data>ไม่มีข้อมูลผู้ป่วย</template>
      </v-data-table>
      <!-- Data Table of patient page -->
    </v-content>
  </v-app>
</template>
<script>
import Menu from "../../components/hp_menubar";
import ThailandAutoComplete from "../../components/vue-thailand-autocomplete";
import axios from "axios";
import dateFormat from "dateformat";
export default {
  data() {
    return {
      disease: {},
      disease_selected: [],
      dialog_record: false,
      dialog_edit: false,
      index: 0,
      date: null,
      search: "",
      menu1: false,
      editedIndex: -1,
      headers: [
        {
          text: "HN",
          align: "left",
          value: "patient_HN",
          divider: true,
          width: "8%"
        },
        {
          text: "ชื่อ-นามสกุลผู้ป่วย",
          align: "center",
          value: "name",
          divider: true,
          width: "22%"
        },
        {
          text: "อีเมล",
          align: "center",
          value: "email",
          divider: true,
          width: "22%"
        },
        {
          text: "เบอร์โทรศัพท์",
          align: "center",
          value: "telno",
          divider: true,
          width: "12%"
        },
        {
          text: "ร้านขายยา",
          align: "center",
          value: "pharmacy_name",
          divider: true,
          width: "16%"
        },
        {
          text: "ประวัติการตรวจ",
          align: "center",
          value: "history",
          divider: true,
          width: "10%"
        },
        { text: "แก้ไข/ลบ", align: "center", value: "action", width: "10%" }
      ],
      record_headers: [
        {
          text: "ลำดับที่",
          align: "right",
          sortable: true,
          value: "no",
          divider: true,
          width: "7%"
        },
        {
          text: "วันที่บันทึก",
          align: "center",
          value: "date",
          divider: true,
          width: "18%"
        },
        {
          text: "น้ำหนัก",
          align: "center",
          value: "weight",
          divider: true,
          width: "10%"
        },
        {
          text: "ส่วนสูง",
          align: "center",
          value: "height",
          divider: true,
          width: "10%"
        },
        {
          text: "ความดันเลือด",
          align: "center",
          value: "pressure",
          divider: true,
          width: "10%"
        },
        { text: "ยาที่ได้", align: "center", value: "medicine", divider: true },
        {
          text: "ผู้ตรวจ",
          align: "center",
          value: "pharmacist",
          divider: true,
          width: "15%"
        }
      ],
      patients: [],
      pharmacy: [],
      emailrules: [
        v => !!v || "กรุณากรอกข้อมูล",
        v => /.+@.+\..+/.test(v) || "รูปแบบอีเมลไม่ถูกต้อง"
      ],
      inputrules: [
        v => !!v || "กรุณากรอกข้อมูล",
        v =>
          !/^[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]*$/.test(v) ||
          "ห้ามใช้อักขระพิเศษ(!@#$%^&*()_+|~-=`{}[]:" + `"` + ";'<>?,./)"
      ],
      numberrules: [
        v => !!v || "กรุณากรอกข้อมูล",
        v => !isNaN(v) || "กรุณากรอกข้อมูลตัวเลข"
      ],
      phonerules: [
        v => !!v || "กรุณากรอกข้อมูล",
        v => (!isNaN(v) && v.length == 10) || "กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง"
      ],
      addressrules: [v => !!v || "กรุณากรอกข้อมูล"],
      age: "",
      patient_selected: {},
      editedItem: {
        name: "",
        surname: "",
        gender: "",
        DOB: "",
        email: "",
        telno: "",
        pharmacy_id_patient: "",
        address: "",
        subdistrict: "",
        district: "",
        province: "",
        zipcode: ""
      },
      defaultItem: {},
      disease_selected: [],
      record: []
    };
  },
  computed: {
    formTitle() {
      return this.editedIndex === -1
        ? "ข้อมูลผู้ป่วยรายใหม่"
        : "แก้ไขข้อมูลผู้ป่วย";
    }
  },
  watch: {
    date(val) {
      this.editedItem.DOB = this.formatDate(this.date);
    }
  },
  components: {
    Menu,
    ThailandAutoComplete
  },
  methods: {
    select(address) {
      console.log(address);
      this.editedItem.subdistrict = address.district;
      this.editedItem.district = address.amphoe;
      this.editedItem.province = address.province;
      this.editedItem.zipcode = address.zipcode;
    },
    formatDate(date) {
      if (!date) return null;

      var [year, month, day] = date.split("-");
      year = parseInt(year) + 543;
      return `${day}/${month}/${year}`;
    },
    setDate(date) {
      if (!date) return null;
      var month_th = [
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
      var [day, month, year] = date.split("/");
      year = parseInt(year) + 543;
      return `${day} ${month_th[parseInt(month) - 1]} ${year}`;
    },
    showItem(item) {
      this.disease_selected = [];
      axios
        .post("http://localhost:3000/api/disease-patient/getdiseasebyhn", {
          patient_HN: item.patient_HN
        })
        .then(res => {
          console.log(res.data);
          for (var i = 0; i < res.data.length; i++) {
            this.disease_selected.push(res.data[i].disease_id);
            console.log(this.disease_selected);
          }
          this.patient_selected = item;
          this.index = this.patients.indexOf(item);
          this.calulate_age();

          this.dialog_record = true;
        })
        .catch(e => {
          console.log("getdisease error " + e);
        }); //get record
      axios
        .post("http://localhost:3000/api/record/getrecord", {
          patient_HN: item.patient_HN
        })
        .then(res => {
          this.record = res.data;
        })
        .catch(e => {
          console.log(e);
        });
    },
    editItem(item) {
      this.disease_selected = [];
      axios
        .post("http://localhost:3000/api/disease-patient/getdiseasebyhn", {
          patient_HN: item.patient_HN
        })
        .then(res => {
          console.log(res.data);
          for (var i = 0; i < res.data.length; i++) {
            this.disease_selected.push(res.data[i].disease_id);
            console.log(this.disease_selected);
          }

          this.calulate_age();
          this.index = this.patients.indexOf(item);
          this.editedIndex = this.patients.indexOf(item);
          this.editedItem = Object.assign({}, item);
          this.dialog_edit = true;
        })
        .catch(e => {
          console.log("getdisease error " + e);
        });
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
      if (this.$refs.form.validate()) {
        delete this.editedItem.pharmacy_id;
        delete this.editedItem.pharmacy_name;
        delete this.editedItem.create_date;
        delete this.editedItem.lastupdate;
        if (this.editedIndex > -1) {
          axios
            .post(
              "http://localhost:3000/api/patient/editpatient",
              this.editedItem
            )
            .then(res => {
              this.deletedisease();
            })
            .catch(e => {
              console.log("edit error " + e);
            });
        } else {
          axios
            .post(
              "http://localhost:3000/api/patient/newpatient",
              this.editedItem
            )
            .then(res => {
              this.adddisease();
            })
            .catch(e => {
              console.log("newpatient error " + e);
            });
          console.log(this.editedItem);
        }
        console.log(this.editedItem);
        this.close();
      }
    },
    close() {
      this.dialog_edit = false;
      setTimeout(() => {
        this.$refs.form.reset();
        // this.editedIndex = -1;
      }, 400);
    },
    calulate_age() {
      var item = this.patients[this.index].DOB;
      var date = new Date();
      item = item.split("/");
      var date_item = item[0];
      item[0] = item[1];
      item[1] = date_item;
      var dob = new Date(item);
      var age = date.getFullYear() + 543 - dob.getFullYear();
      this.age = age;
    },
    getallpatient() {
      axios.get("http://localhost:3000/api/patient/showpatients").then(res => {
        this.patients = res.data;
      });
    },
    adddisease() {
      var count = 0;
      for (var i = 0; i < this.disease_selected.length; i++) {
        axios
          .post("http://localhost:3000/api/disease-patient/addd_p", {
            disease_id: this.disease_selected[i],
            patient_HN: this.editedItem.patient_HN
          })
          .then(res => {
            count++;
            if (count == this.disease_selected.length) {
              this.getallpatient();
            }
          })
          .catch(e => {
            console.log("edit error " + e);
          });
      }
    },
    deletedisease() {
      axios
        .post("http://localhost:3000/api/disease-patient/deleted_p", {
          patient_HN: this.editedItem.patient_HN
        })
        .then(res => {
          this.adddisease();
        })
        .catch(e => {
          console.log("edit error " + e);
        });
    }
  },

  mounted() {
    axios.get("http://localhost:3000/api/patient/showpatients").then(res => {
      this.patients = res.data;
    });
    axios
      .get("http://localhost:3000/api/pharmacy/showpharmacy")
      .then(pharmacy => {
        this.pharmacy = pharmacy.data;
      });
    axios.get("http://localhost:3000/api/disease/getdiseases").then(disease => {
      this.disease = disease.data;
    });
  }
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.menu-header {
  position: fixed;
  width: 100%;
  top: 0px;
  right: 0px;
  z-index: 1;
}
.main {
  margin: 20px;
  margin-top: 80px;
}
</style>
