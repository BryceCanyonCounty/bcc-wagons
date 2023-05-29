<template>
  <div class="container">
    <div class="flex panel" @click="Expand()">
      <div class="flex flex-auto panel-title">
        <h6 class="grey-text plus">{{ wagon.name }}</h6>
      </div>
    </div>
    <div v-if="isOpen">
      <div class="item" v-for="(data, model) in wagon.types" :key="model">
        <ShopMenuItemType :wagon="data" :model="model" />
      </div>
    </div>
  </div>
</template>

<script>
import ShopMenuItemType from "./ShopMenuItemType.vue";
export default {
  name: "ShopMenuItem",
  props: {
    wagon: Object,
    index: Number,
    selected: Number,
  },
  emits: ["iExpanded"],
  computed: {
    isOpen() {
      return this.index == this.selected;
    },
  },
  methods: {
    Expand() {
      if (!this.isOpen) {
        this.$emit("iExpanded", this.index);
      }
    },
  },
  components: {
    ShopMenuItemType,
  },
};
</script>

<style scoped lang="scss">
.container {
  width: 96%;
  margin: auto;
  overflow: hidden;
}
.item {
  width: 93%;
  margin: auto;
}
.flex {
  display: flex;
}
.flex-auto {
  flex: 0 1 auto;
}
.panel {
  padding: 0px;
  margin: 3px 10px;
  border-radius: 0px;
  background-color: transparent;
  overflow: hidden;
  background: url("/public/img/input.png");
  background-size: 100% 100%;
  justify-content: center;
}
.panel-title {
  background-size: 100% 100%;
  padding: 10px 10px;
  font-size: 1.5em;
  font-weight: 400;
  text-align: center;
}

.panel-title .grey-text {
  margin: 0;
  margin-top: 5px;
  margin-bottom: 5px;
}

.grey-text.plus:hover {
  color: #f0f0f0;
}

.panel-title .grey-text {
  color: #9e9e9e;
  margin: 0;
  margin-top: 5px;
  margin-bottom: 5px;
}
</style>
