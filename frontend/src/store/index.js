import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    staff_id: localStorage.getItem("staff_id") || null,
    username: localStorage.getItem("username") || null,
    name: localStorage.getItem("name") || null
  },
  mutations: {},
  actions: {},
  getters: {
    isLoggedIn: state => !!state.username
  },
  modules: {}
});
