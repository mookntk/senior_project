import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    staff_id: null || localStorage.getItem("staff_id"),
    username: null || localStorage.getItem("username"),
    name: null || localStorage.getItem("name"),
    user_type: null || localStorage.getItem("user_type")
  },
  mutations: {
    set_user: (state, user) => (state.username = user),
    set_staff_id: (state, staff_id) => (state.staff_id = staff_id),
    set_name: (state, name) => (state.name = name),
    set_user_type: (state, user_type) => (state.user_type = user_type)
  },
  actions: {
    logout({ commit }) {
      return new Promise((resolve, reject) => {
        // commit("logout");
        localStorage.removeItem("staff_id");
        localStorage.removeItem("username");
        localStorage.removeItem("name");
        localStorage.removeItem("user_type");
        resolve();
      });
    }
  },
  getters: {
    isLoggedIn: state => !!state.username
  },
  modules: {}
});
