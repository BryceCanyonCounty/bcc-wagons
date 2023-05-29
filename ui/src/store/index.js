import { createStore } from "vuex";

export default createStore({
  state: {
    currencyType: 2,
    myWagons: null,
    wagons: null,
    shopName: null,
    activeWagon: null,
  },
  getters: {},
  mutations: {
    SET_MY_WAGONS(state, payload) {
      state.myWagons = payload;
    },
    SET_WAGONS(state, payload) {
      state.wagons = payload;
    },
    SET_SHOP_NAME(state, payload) {
      state.shopName = payload;
    },
    SET_ACTIVE_WAGON(state, payload) {
      state.activeWagon = payload;
    },
    SET_CURRENCY_TYPE(state, payload) {
      state.currencyType = payload;
    },
  },
  actions: {
    setMyWagons(context, payload) {
      context.commit("SET_MY_WAGONS", payload);
    },
    setWagons(context, payload) {
      context.commit("SET_WAGONS", payload);
    },
    setShopName(context, payload) {
      context.commit("SET_SHOP_NAME", payload);
    },
    setSelectedWagon(context, payload) {
      context.commit("SET_ACTIVE_WAGON", payload);
    },
    setCurrencyType(context, payload) {
      context.commit("SET_CURRENCY_TYPE", payload);
    },
  },
  modules: {},
});
