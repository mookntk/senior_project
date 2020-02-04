<template>
  <v-app class="font cyan lighten-5">
    <Menuadmin />
    <v-data-table
      :search="search"
      :headers="headers"
      :items="phamacist"
      sort-by="name"
      class="elevation-1"
    >
      <template v-slot:top>
        <v-toolbar flat color="white">
          <v-toolbar-title>เภสัชกรร้านขายยา</v-toolbar-title>
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
          <v-dialog v-model="dialog" max-width="500px">
            <template v-slot:activator="{ on }">
              <v-btn color="primary" dark class="mb-2" v-on="on">+ เพิ่มเภสัชกรร้านขายยา</v-btn>
            </template>
            <v-card class="font">
              <v-card-title>
                <span>{{ formTitle }}</span>
              </v-card-title>

              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="editedItem.name" label="ชื่อ"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="editedItem.surname" label="นามสกุล"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="editedItem.username" label="ชื่อผู้ใช้"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="editedItem.email" label="email"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="editedItem.phamacy" label="ร้านขายยาที่ประจำ"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6" md="4">
                      <v-text-field v-model="editedItem.phamacistid" label="เลขใบอนุญาตฯเภสัช"></v-text-field>
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
        <v-icon small class="mr-6" @click="editItem(item)">mdi-pencil</v-icon>
        <v-icon small class="mr-6" @click="deleteItem(item)">mdi-delete</v-icon>
        <v-icon small class="mr-6" @click="forgetpw(item)">mdi-email-send</v-icon>
      </template>
      <template v-slot:no-data>
        <v-btn color="primary" @click="initialize">Reset</v-btn>
      </template>
    </v-data-table>
  </v-app>
</template>

<script>
import Menuadmin from "../components/Menuadmin";
export default {
  data: () => ({
    search: "",
    dialog: false,
    headers: [
      { text: "ชื่อ", value: "name" },
      { text: "นามสกุล", value: "surname" },
      { text: "username", value: "username", sortable: false },
      { text: "อีเมล", value: "email", sortable: false },
      { text: "ร้านขายยาที่ประจำ", value: "phamacy", sortable: false },
      {
        text: "เลขใบอนุญาตฯเภสัช",
        value: "phamacistid",
        align: "center",
        sortable: false
      },
      {
        text: "แก้ไข / ลบ / ส่งรหัสผ่านใหม่ให้ผู้ใช้",
        value: "action",
        sortable: false
      }
    ],
    phamacist: [],
    editedIndex: -1,
    editedItem: {
      name: "",
      surname: "",
      username: "",
      email: "",
      phamacy: "",
      phamacistid: ""
    },
    defaultItem: {
      name: "",
      surname: "",
      username: "",
      email: "",
      phamacy: "",
      phamacistid: ""
    }
  }),
  components: {
    Menuadmin
  },

  computed: {
    formTitle() {
      return this.editedIndex === -1
        ? "เพิ่มเภสัชกรร้านขายยา"
        : "แก้ไขข้อมูลเภสัขกรร้านขายยา";
    }
  },

  watch: {
    dialog(val) {
      val || this.close();
    }
  },

  created() {
    this.initialize();
  },

  methods: {
    initialize() {
      this.phamacist = [
        {
          name: "วันชัย",
          surname: "ศุภจตุรัส",
          username: "phamacist01809",
          email: "xokf@hotmail.com",
          phamacy: "เอสอีซี.ฟาร์มาซี",
          phamacistid: "01809"
        },
        {
          name: "สุกรี",
          surname: "ฉัตรรัตนกุลชัย",
          username: "phamacist01545",
          email: "fofo00@hotmail.com",
          phamacy: "บ้านเภสัชกร",
          phamacistid: "01545"
        },
        {
          name: "เอก",
          surname: "เวสโกสิทธิ์",
          username: "phamacist01233",
          email: "ferrr@hotmail.com",
          phamacy: "บัณฑิตฟาม่าร",
          phamacistid: "01233"
        },
        {
          name: "สลิลลา",
          surname: "วีระรัตน์",
          username: "phamacist04453",
          email: "kougf@hotmail.com",
          phamacy: "มิตรประชาเมดิคัล",
          phamacistid: "04453"
        },
        {
          name: "สมาน",
          surname: "พิทยาพิบูลพงศ์",
          username: "phamacist04421",
          email: "sdsds@hotmail.com",
          phamacy: "บัณฑิตเภสัช",
          phamacistid: "04421"
        },
        {
          name: "วิชัย",
          surname: "วิทุรวงศ์",
          username: "phamacist02534",
          email: "dwwq@hotmail.com",
          phamacy: "นิยมเภสัช",
          phamacistid: "02534"
        },
        {
          name: "วิโรจน์",
          surname: "ศรีเมือง",
          username: "phamacist02538",
          email: "7ttt@hotmail.com",
          phamacy: "ศาลายาดรัก",
          phamacistid: "02538"
        },
        {
          name: "นภาพรรณ",
          surname: "วัฒนประดิษฐ",
          username: "phamacist01873",
          email: "df34@hotmail.com",
          phamacy: "ศาลายาเภสัช",
          phamacistid: "01873"
        },
        {
          name: "เฉลิม",
          surname: "ศิธรกุล",
          username: "phamacist01173",
          email: "jutqe5@hotmail.com",
          phamacy: "ฟาสซิโน ตลาดศาลายา",
          phamacistid: "01173"
        },
        {
          name: "สุทธิพงศ์",
          surname: "ภัทรมังกร",
          username: "phamacist04433",
          email: "loyr4@hotmail.com",
          phamacy: "รักษ์ยาเภสัช",
          phamacistid: "04433"
        }
      ];
    },

    editItem(item) {
      this.editedIndex = this.phamacist.indexOf(item);
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },

    deleteItem(item) {
      const index = this.phamacist.indexOf(item);
      confirm("คุณแน่ใจหรือที่จะลบเจ้าหน้าที่เภสัชกรคนนี้?") &&
        this.phamacist.splice(index, 1);
    },

    forgetpw(item) {
      const index = this.phamacist.indexOf(item);
      confirm("คุณแน่ใจหรือที่จะส่งรหัสผ่านใหม่ให้ผู้ใช้คนนี้?");
    },

    close() {
      this.dialog = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },

    save() {
      if (this.editedIndex > -1) {
        Object.assign(this.phamacist[this.editedIndex], this.editedItem);
      } else {
        this.phamacist.push(this.editedItem);
      }
      this.close();
    }
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