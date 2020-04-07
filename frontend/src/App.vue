<template>
  <v-app>
    <v-content>
      <router-view></router-view>
    </v-content>
  </v-app>
</template>

<script>
export default {
  name: "App",

  data: () => ({
    //
  })
};
</script>

<style>
@import url("https://fonts.googleapis.com/css?family=Sarabun&display=swap");
.font {
  font-family: "Sarabun", sans-serif;
}
thead.v-data-table-header {
  background-color: #f5ce88;
}
tbody tr:nth-of-type(even) {
  background-color: #f5f3e4;
}

tbody tr:nth-of-type(odd) {
  background-color: rgb(250, 250, 250);
}
.v-input--selection-controls .v-input__slot .v-label {
  font-size: 16px;
  color: black;
}
.v-input__slot .v-label {
  font-size: 14px;
  color: black;
}
</style>