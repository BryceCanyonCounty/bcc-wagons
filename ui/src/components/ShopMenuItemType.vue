<template>
  <div class="panel-shop item flex" @click="loadWagon()">
    <div class="item flex flex-auto">
      <h6 class="grey-text-shop title">
        {{ wagon.label }}
      </h6>
    </div>
    <div class="buy-buttons flex flex-auto justify-end">
      <button
        style="display: flex; justify-content: flex-start"
        class="btn-small"
        :class="{
          mr: !useGold,
        }"
        @click="openConfirmationModal(true)"
        v-if="useCash"
      >
        <img src="img/money.png" class="ml-1" />
        <span class="ml-1">
          {{ wagon.cashPrice }}
        </span>
      </button>
      <!--  -->
      <button
        style="display: flex; justify-content: flex-start"
        class="btn-small right-btn"
        @click="openConfirmationModal(false)"
        v-if="useGold"
      >
        <img src="img/gold.png" class="ml-1" />
        <span class="ml-1">
          {{ wagon.goldPrice }}
        </span>
      </button>
    </div>
  </div>

  <ConfirmationModal :visible="isVisible" title="Purchase" @close="hideModal()">
    <div class="divider-menu-top" style="margin-top: 1rem"></div>
    <div class="flex cta-wrapper">
      <button @click="buyWagon()" class="modal-btn flex flex-auto">
        Confirm
      </button>
      <button @click="hideModal" class="modal-btn flex flex-auto">
        Cancel
      </button>
    </div>
    <div class="divider-menu-bottom"></div>
  </ConfirmationModal>
</template>

<script>
import api from "@/api";
import { mapState } from "vuex";
import ConfirmationModal from "./ConfirmationModal.vue";
export default {
  name: "ShopMenuType",
  props: {
    wagon: Object,
    model: String,
  },
  data() {
    return {
      isVisible: false,
      currType: null,
    };
  },
  computed: {
    ...mapState(["currencyType", "activeWagon"]),
    isActive() {
      return this.active;
    },
    useCash() {
      return this.currencyType < 1 || this.currencyType > 1;
    },
    useGold() {
      return this.currencyType > 0;
    },
  },
  methods: {
    openConfirmationModal(currency) {
      this.isVisible = true;
      this.currType = currency;
    },
    loadWagon() {
      if (this.activeWagon) {
        this.$store.dispatch("setSelectedWagon", null);
      }

      api.post("LoadWagon", {
        WagonModel: this.model,
      });
    },
    buyWagon() {
      this.isVisible = false;
      if (this.currType !== null) {
        api.post("BuyWagon", {
          ModelW: this.model,
          Cash: this.wagon.cashPrice,
          Gold: this.wagon.goldPrice,
          IsCash: this.currType,
        });
      }
    },
    hideModal() {
      this.isVisible = false;
      this.currType = null;
    },
  },
  components: {
    ConfirmationModal,
  },
};
</script>

<style scoped lang="scss">
.flex {
  display: flex;
}

.flex-auto {
  flex: 1 1 auto;
}

.justify-end {
  justify-content: flex-end;
}

.justify-start {
  justify-content: flex-start;
}

.ml-1 {
  margin-left: 0.25rem;
}

.mr {
  margin-right: 1rem;
}

.item {
  margin-left: 25px;
}

.panel-shop.item {
  padding: 5px 0px;
  margin: 3px 10px;
  border-radius: 0px;
  width: calc(100% - 20px);
  background-color: transparent;
  overflow: hidden;
  background-image: url("/public/img/input.png"), url("/public/img/input.png");
  background-size: 100% 100%;
  background-repeat: no-repeat;
  background-position: center;
}

.panel-shop.item:hover {
  background-image: url("/public/img/selected.png"),
    url("/public/img/selection_box.png");
}

.panel-shop.item.active {
  background-image: url("/public/img/selected.png"),
    url("/public/img/selection_box.png");
}

.grey-text-shop.title {
  color: #9e9e9e;
  text-align: left;
  margin: auto 0;
}

.buy-buttons {
  display: flex;
}

.btn-small {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  text-decoration: none;
  color: #f0f0f0;
  user-select: none;
  text-align: left;
  width: 75px;
  letter-spacing: 0.5px;
  -webkit-transition: background-color 0.2s ease-out;
  transition: background-color 0.2s ease-out;
  border: 0px #fff solid;
}

.btn-small:hover {
  background: url("/public/img/buttonv.png");
  background-size: 90% 100%;
  background-repeat: no-repeat;
  background-position: right;
  border-radius: 0px;
}

.btn-small.right-btn {
  margin-right: 5px;
}

.title {
  font-size: 1em;
}

.flex {
  display: flex;
}

.flex-auto {
  flex: 1 1 auto;
}

.modal-btn {
  flex-direction: row;
  justify-content: center;
  align-items: center;
  text-decoration: none;
  color: #f0f0f0;
  user-select: none;
  text-align: left;
  width: 75px;
  letter-spacing: 0.5px;
  -webkit-transition: background-color 0.2s ease-out;
  transition: background-color 0.2s ease-out;
  border: 0px #fff solid;
}

.modal-btn:hover {
  background: url("/public/img/buttonv.png");
  background-size: 90% 100%;
  background-repeat: no-repeat;
  background-position: right;
  border-radius: 0px;
}

.cta-wrapper {
  background: url("/public/img/input.png");
  background-position: center;
  background-size: 100% 100%;
  height: 4vh;
}

.divider-menu-top,
.divider-menu-bottom {
  width: 90%;
  height: 4px;
  margin: auto auto;
  background-image: url("/public/img/divider_line.png");
  background-repeat: no-repeat;
  background-position: center;
  background-size: 100% 100%;
  opacity: 0.6;
}

.divider-menu-top {
  margin-bottom: 10px;
}

.divider-menu-bottom {
  margin-top: 10px;
}
</style>
