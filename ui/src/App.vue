<template>
  <div id="content" v-if="visible || devmode">
    <router-view />
  </div>
</template>
<script>
export default {
  name: "DefaultLayout",
  data() {
    return {
      devmode: false,
      visible: false,
    };
  },
  mounted() {
    window.addEventListener("message", this.onMessage);
  },
  unmounted() {
    window.removeEventListener("message", this.onMessage);
  },
  methods: {
    onMessage(event) {
      switch (event.data.action) {
        case "show":
          this.visible = true;
          this.$store.dispatch("setWagons", event.data.shopData);
          this.$store.dispatch("setShopName", event.data.location);
          this.$store.dispatch("setCurrencyType", event.data.currencyType);
          break;
        case "updateMyWagons":
          this.$store.dispatch("setMyWagons", event.data.myWagonsData);
          break;
        case "hide":
          this.visible = false;
          this.$store.dispatch("setMyWagons", null);
          this.$store.dispatch("setWagons", null);
          this.$store.dispatch("setShopName", null);
          this.$store.dispatch("setCurrencyType", 2);
          break;
        default:
          break;
      }
    },
  },
};
</script>
<style lang="scss">
#content {
  overflow: hidden;
}
</style>
