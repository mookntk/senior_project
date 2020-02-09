<template>
  <v-app class="font cyan lighten-5">
    <Menuadmin />
    <v-data-table
      :search="search"
      :headers="headers"
      :items="medicine"
      sort-by="generic"
      class="font elevation-1"
    >
      <template v-slot:top>
        <v-toolbar flat color="white">
          <v-toolbar-title>การจัดการข้อมูลยา</v-toolbar-title>
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
          <!-- <v-dialog v-model="dialog1" max-width="1000px"> -->
          <!-- <template v-slot:activator="{ on }"> -->
          <v-btn color="primary" class="ma-2" @click="editItem(item)"
            >+ เพิ่มข้อมูลยา</v-btn
          >

          <v-btn color="success" dark class="ma-2" @click="editItem2()"
            >จัดการข้อมูลโรค</v-btn
          >
          <!-- </template> -->

          <v-dialog v-model="dialog1" max-width="1000px" persistent>
            <v-card class="font">
              <v-card-title>
                <span class="headline">{{ formTitle }}</span>
              </v-card-title>

              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="medicine_selected.medicine_tmt"
                        label="รหัสยา (TMT)"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="medicine_selected.medicine_generic"
                        label="ชื่อสามัญ"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="medicine_selected.medicine_trade"
                        label="ชื่อทางการค้า"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-autocomplete
                        :items="disease"
                        item-text="disease_name"
                        v-model="medicine_selected.disease_name"
                        label="โรค"
                      ></v-autocomplete>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="medicine_selected.strenght"
                        label="ปริมาณยา (strenght)"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="medicine_selected.price"
                        label="ราคาต่อหนึ่งปริมาณยา (price/strenght)"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field
                        v-model="medicine_selected.unit"
                        label="รูปแบบยา (unit)"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-container>
              </v-card-text>

              <v-card-actions>
                <div class="flex-grow-1"></div>
                <v-btn color="blue darken-1" text @click="close()"
                  >ยกเลิก</v-btn
                >
                <v-btn color="blue darken-1" text @click="save()"
                  >เสร็จสิ้น</v-btn
                >
              </v-card-actions>
            </v-card>
          </v-dialog>

          <v-dialog v-model="dialog2" max-width="500px" persistent>
            <v-card>
              <v-container>
                <v-card-title class="headline">จัดการข้อมูลโรค</v-card-title>
                <v-form ref="form">
                  <v-row class="ml-12">
                    <v-col cols="12" sm="7" md="7">
                      <v-text-field
                        v-model="dis_selected.dis_name"
                        :rules="[
                          v =>!!v || 'This field is required'
                        ]"
                        label="ระบุชื่อโรคที่ต้องการเพิ่ม"
                        required
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="5" md="5">
                      <v-btn
                        class="ma-3"
                        fab
                        small
                        @click="save2()"
                        color="primary"
                      >
                        <v-icon color="white" large>{{ icons.mdiPlus }}</v-icon>
                      </v-btn>
                    </v-col>
                  </v-row>
                  <v-row class="ml-12">
                    <v-col cols="12" sm="7" md="7">
                      <v-autocomplete
                        :items="disease"
                        item-text="disease_name"
                        v-model="medicine_selected.disease_name"
                        label="เลือกชื่อโรคที่ต้องการลบ"
                      ></v-autocomplete>
                    </v-col>
                    <v-col cols="12" sm="5" md="5">
                      <v-btn
                        class="ma-3"
                        fab
                        small
                        @click="delete2()"
                        color="red"
                      >
                        <v-icon color="white" large>{{
                          icons.mdiMinus
                        }}</v-icon>
                      </v-btn>
                    </v-col>
                  </v-row>

                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="green darken-1" text @click="close2()"
                      >ยกเลิก</v-btn
                    >
                    <!-- <v-btn color="green darken-1" text @click="save2()">เสร็จสิ้น</v-btn> -->
                  </v-card-actions>
                </v-form>
              </v-container>
            </v-card>
          </v-dialog>
          <!-- </v-dialog> -->
        </v-toolbar>
      </template>
      <template v-slot:item.action="{ item }">
        <v-icon small class="mr-2" @click="editItem(item)">mdi-pencil</v-icon>
        <v-icon small @click="deleteItem(item)">mdi-delete</v-icon>
      </template>
    </v-data-table>
  </v-app>
</template>

<script>
import Menuadmin from "../../components/Menuadmin";
import axios from "axios";
import { mdiDelete, mdiPlus, mdiMinus } from "@mdi/js";
export default {
  data: () => ({
    search: "",
    icons: {
      mdiDelete,
      mdiPlus,
      mdiMinus
    },
    dialog1: false,
    dialog2: false,
    headers: [
      { text: "รหัสยา (TMT)", value: "medicine_tmt" },
      { text: "ชื่อสามัญ", value: "medicine_generic", align: "center" },
      { text: "ชื่อทางการค้า", value: "medicine_trade", align: "center" },
      { text: "โรค", value: "disease_name", align: "center" },
      {
        text: "ปริมาณยา (strenght)",
        value: "strenght",
        align: "center",
        sortable: false
      },
      {
        text: "ราคาต่อหนึ่งปริมาณยา (price/strenght)",
        value: "price",
        align: "center",
        sortable: false
      },
      {
        text: "รูปแบบยา (unit)",
        value: "unit",
        align: "center",
        sortable: false
      },

      { text: "แก้ไข / ลบ", value: "action", align: "center", sortable: false }
    ],
    disease: [],
    medicine: [],
    medicine_selected: [],
    editedIndex: -1,
    editedIndex: {
      medicine_tmt: "",
      medicine_generic: "",
      medicine_trade: "",
      disease_name: "",
      strenght: "",
      price: "",
      unit: ""
    },
    defaultItem: {
      medicine_tmt: "",
      medicine_generic: "",
      medicine_trade: "",
      disease_name: "",
      strenght: "",
      price: "",
      unit: ""
    },
    dis_selected: [],
    defaultItem2: {
      dis_name: ""
    }
  }),

  components: {
    Menuadmin
  },

  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "เพิ่มข้อมูลยา" : "แก้ไขข้อมูลยา";
    }
  },

  methods: {
    reset() {
      this.$refs.form.reset();
    },

    editItem(item) {
      this.getallmedicine();
      this.editedIndex = this.medicine.indexOf(item);
      this.medicine_selected = Object.assign({}, item);
      this.dialog1 = true;
    },

    deleteItem(item) {
      const index = this.medicine.indexOf(item);
      confirm(
        "คุณต้องการที่จะลบข้อมูลยานี้ใช่หรือไม่?\n" +
          " " +
          item.medicine_generic
      ) &&
        axios
          .post("http://localhost:3000/api/medicine/deletemedicine", {
            medicine_id: item.medicine_id
          })
          .then(res => {
            this.medicine.splice(index, 1);
          })
          .catch(e => {
            console.log("delete error " + e);
          });
    },

    close() {
      this.dialog1 = false;

      setTimeout(() => {
        this.medicine_selected = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },

    editItem2() {
      this.getallmedicine();
      this.dialog2 = true;
    },

    save2() {
      // var length = String[this.dis_selected.dis_name].length();
      // if (length === "") {
      //   console.log("null value");
      // } else {
      axios.post("http://localhost:3000/api/medicine/newdisease", {
        dis_name: this.dis_selected.dis_name
      });
      this.close2();

      // }
    },

    delete2() {
      axios.post("http://localhost:3000/api/medicine/deletedisease", {
        delete_name: this.medicine_selected.disease_name
      });
      this.close2();
    },

    close2() {
      this.reset();
      this.dialog2 = false;
      setTimeout(() => {
        this.dis_selected = Object.assign({}, this.defaultItem2);
        this.medicine_selected = Object.assign({}, this.defaultItem);
      }, 300);
    },

    save() {
      if (this.editedIndex > -1) {
        axios
          .post(
            "http://localhost:3000/api/medicine/editmedicine",
            this.medicine_selected
          )
          .then(res => {
            this.getallmedicine();
          });
      } else {
        axios
          .post("http://localhost:3000/api/medicine/newmedicine", {
            medicine_tmt: this.medicine_selected.medicine_tmt,
            medicine_generic: this.medicine_selected.medicine_generic,
            medicine_trade: this.medicine_selected.medicine_trade,
            strenght: this.medicine_selected.strenght,
            price: this.medicine_selected.price,
            unit: this.medicine_selected.unit,
            disease_name: this.medicine_selected.disease_name
          })
          .then(res => {
            this.getallmedicine();
          });
      }
      this.close();
    },

    getallmedicine() {
      axios.get("http://localhost:3000/api/medicine/showmedicine").then(res => {
        this.medicine = res.data;
      });
      axios.get("http://localhost:3000/api/medicine/showdisease").then(res => {
        this.disease = res.data;
      });
    }
  },

  mounted() {
    axios.get("http://localhost:3000/api/medicine/showmedicine").then(res => {
      this.medicine = res.data;
    });
    axios.get("http://localhost:3000/api/medicine/showdisease").then(res => {
      this.disease = res.data;
    });
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
</style>
