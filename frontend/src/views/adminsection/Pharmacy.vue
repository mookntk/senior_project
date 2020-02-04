<template>
  <v-app class="font cyan lighten-5">
    <Menuadmin />
    <v-data-table
      :search="search"
      :headers="headers"
      :items="pharmacy"
      :items-per-page="10"
      sort-by="name"
      class="elevation-1"
    >
      <template v-slot:top>
        <v-toolbar flat color="white">
          <v-toolbar-title>ร้านขายยา</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="ค้นหา"
            single-line
            hide-details
          ></v-text-field>
          <v-divider class="mx-4" inset vertical></v-divider>
          <div class="flex-grow-1"></div>
          <v-dialog v-model="dialog" max-width="600px">
            <template v-slot:activator="{ on }">
              <v-btn color="primary" dark class="mb-2" v-on="on">+ เพิ่มร้านขายยา</v-btn>
            </template>
            <v-card class="font">
              <v-card-title>
                <span>{{ formTitle }}</span>
              </v-card-title>

              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="pharmacy_selected.pharmacy_name" label="ชื่อร้านขายยา"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="pharmacy_selected.address" label="ที่อยู่"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="pharmacy_selected.subdistrict" label="ตำบล/แขวง"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="pharmacy_selected.district" label="อำเภอ/เขต"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="pharmacy_selected.province" label="จังหวัด"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="pharmacy_selected.zipcode" label="รหัสไปรษณีย์"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="pharmacy_selected.Telno"
                        label="เบอร์ติดต่อ"
                        :maxlength="maxtelno"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-container>
              </v-card-text>

              <v-card-actions>
                <div class="flex-grow-1"></div>
                <v-btn color="blue darken-1" text @click="close">ยกเลิก</v-btn>
                <v-btn color="blue darken-1" text @click="save">เสร็จสิ้น</v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-toolbar>
      </template>
      <template v-slot:item.action="{ item }">
        <v-icon small class="mr-2" @click="editItem(item)">mdi-pencil</v-icon>
        <v-icon small class="mr-5" @click="deleteItem(item)">mdi-delete</v-icon>
      </template>
    </v-data-table>
  </v-app>
</template>

<script>
import Menuadmin from "../../components/Menuadmin";
import axios from "axios";
export default {
  data: () => ({
    search: "",
    dialog: false,
    maxtelno: 10,
    headers: [
      { text: "ชื่อร้านขายยา", value: "pharmacy_name" },
      { text: "ที่อยู่", value: "address" },
      { text: "ตำบล / แขวง", value: "subdistrict" },
      { text: "อำเภอ/เขต", value: "district" },
      { text: "จังหวัด", value: "province" },
      { text: "เบอร์ติดต่อ", value: "Telno" },
      { text: "รหัสไปรษณีย์", value: "zipcode" },
      { text: "แก้ไข / ลบ", value: "action", align: "center" }
    ],
    pharmacy: [],
    pharmacy_selected: [],
    editedIndex: -1,
    editedItem: {
      pharmacy_name: "",
      address: "",
      subdistrict: "",
      district: "",
      province: "",
      Telno: "",
      zipcode: ""
    },
    defaultItem: {
      pharmacy_name: "",
      address: "",
      subdistrict: "",
      district: "",
      province: "",
      Telno: "",
      zipcode: ""
    }
  }),
  components: {
    Menuadmin
  },

  computed: {
    formTitle() {
      return this.editedIndex === -1
        ? "เพิ่มร้านขายยา"
        : "แก้ไขข้อมูลร้านขายยา";
    }
  },

  methods: {
    editItem(item) {
      console.log(this.pharmacy);
      this.editedIndex = this.pharmacy.indexOf(item);
      this.pharmacy_selected = Object.assign({}, item);
      this.dialog = true;
    },
    deleteItem(item) {
      const index = this.pharmacy.indexOf(item);
      console.log(this.pharmacy[index].pharmacy_id);
      confirm("คุณแน่ใจหรือที่จะลบร้านขายยานี้??\nร้าน" + item.pharmacy_name) &&
        axios
          .post("http://localhost:3000/api/pharmacy/deletepharmacy", {
            pharmacy_id: item.pharmacy_id
          })
          .then(res => {
            this.pharmacy.splice(index, 1);
          })
          .catch(e => {
            console.log("delete error " + e);
          });
    },

    close() {
      console.log(this.editedIndex);
      this.dialog = false;
      setTimeout(() => {
        this.pharmacy_selected = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },

    save() {
      if (this.editedIndex > -1) {
        axios
          .post(
            "http://localhost:3000/api/pharmacy/editpharmacy",
            this.pharmacy_selected
          )
          .then(res => {
            // Object.assign(
            //   this.hosstaff[this.editedIndex],
            //   this.hosstaff_selected
            // );
            this.getallpharmacy();
          });
      } else {
        // var check = 0;
        // axios.get("http://localhost:3000/api/pharmacy/showpharmacy").then(res => {
        //   for (var i = 0; i < res.data.length; i++) {
        //     if (
        //       this.pharmacy_selected.pharmacy_name === res.data[i].pharmacy_name
        //     ) {
        //       check = 1;
        //       console.log("มีชื่อผู้ใช้นี้แล้ว");
        //       break;
        //     }
        //   }
        //   if (check == 0) {
        // this.generate();
        axios
          .post("http://localhost:3000/api/pharmacy/newpharmacy", {
            pharmacy_name: this.pharmacy_selected.pharmacy_name,
            address: this.pharmacy_selected.address,
            subdistrict: this.pharmacy_selected.subdistrict,
            district: this.pharmacy_selected.district,
            province: this.pharmacy_selected.province,
            Telno: this.pharmacy_selected.Telno,
            zipcode: this.pharmacy_selected.zipcode
          })
          .then(res => {
            this.getallpharmacy();
          });
        //   }
        // });
      }
      this.close();
    },
    getallpharmacy() {
      axios.get("http://localhost:3000/api/pharmacy/showpharmacy").then(res => {
        this.pharmacy = res.data;
      });
    }
  },
  mounted() {
    axios.get("http://localhost:3000/api/pharmacy/showpharmacy").then(res => {
      this.pharmacy = res.data;
    });
  }
};
</script>
<style >
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.font {
  font-family: "Sarabun", sans-serif;
}
thead {
  background-color: #ffd54f;
}
</style>