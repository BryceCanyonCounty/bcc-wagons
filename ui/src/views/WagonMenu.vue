<template>
  <div class="container">
    <div class="main">
      <div class="header">
        <div class="header-text">
          {{ shopName }}
        </div>
      </div>

      <div class="btn-menu main-nav-buttons">
        <MenuButton
          label="My Wagons"
          :selectedPage="page"
          @click="page = 'wagons'"
          class="enabled"
        />
        <MenuButton
          label="Wagon Shop"
          :selectedPage="page"
          @click="page = 'shop'"
          class="enabled"
        />
      </div>

      <div class="divider-menu-top"></div>

      <div class="scroll-container" v-if="page == 'wagons'">
        <MyWagonMenu />
      </div>

      <div class="scroll-container" v-else-if="page == 'shop'">
        <ShopMenu />
      </div>

      <div class="divider-menu-top" style="margin-top: 1rem"></div>

      <div class="btn-bottom-main btn-bottom">
        <button id="cancel" class="btn-select" @click="close()">Save</button>
        <button
          id="rotate_left"
          class="btn-select btn-rotate"
          @mousedown="startRotate('left')"
          @mouseleave="onMouseLeave"
        >
          <i class="fas fa-chevron-left center"></i>
        </button>
        <div class="rotate-text">
          <span class="grey-text center">Rotate</span>
        </div>
        <button
          id="rotate_right"
          class="btn-select btn-rotate"
          @mousedown="startRotate('right')"
          @mouseleave="onMouseLeave"
        >
          <i class="fas fa-chevron-right center"></i>
        </button>
        <button id="cancel" class="btn-select" @click="close()">Close</button>
      </div>

      <div class="divider-menu-bottom"></div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import api from "@/api";
import MenuButton from "@/components/MenuButton.vue";
import MyWagonMenu from "@/components/MyWagonMenu.vue";
import ShopMenu from "@/components/ShopMenu.vue";

export default {
  name: "HorseMenu",
  data() {
    return {
      page: "wagons",
      showModal: false,
      isRotating: false,
      rotateTimer: null,
    };
  },
  components: {
    MenuButton,
    MyWagonMenu,
    ShopMenu,
  },
  mounted() {
    window.addEventListener("mouseup", this.mouseUp, false);
  },
  unmounted() {
    window.removeEventListener("mouseup", this.mouseUp);
  },
  methods: {
    close() {
      api
        .post("CloseMenu", {
          MenuAction: "Close",
        })
        .catch((e) => {
          console.log(e.message);
        });
    },
    mouseUp() {
      this.isRotating = false;
      this.stopRotate();
    },
    onMouseLeave() {
      this.stopRotate();
    },
    startRotate(direction) {
      this.rotate(direction);
      this.isRotating = true;
    },
    stopRotate() {
      if (this.rotateTimer !== null) {
        clearTimeout(this.rotateTimer);
        this.rotateTimer = null;
      }
    },
    rotate(direction) {
      api.post("Rotate", {
        RotateWagon: direction,
      });

      this.rotateTimer = setTimeout(() => {
        this.rotate(direction);
      }, 30);
    },
  },
  computed: {
    ...mapState(["shopName"]),
    isClosed() {
      return this.activeHorse === null;
    },
  },
};
</script>

<style scoped>
.container {
  padding-bottom: 40px;
  border-radius: 0px;
  overflow: hidden;
  position: absolute;
  height: 80vh;
  left: 2%;
  top: 5%;
  width: 420px;
  color: #e7e7e7;
  background: url("/public/img/bgPanel.png");
  background-size: 100% 100%;
  display: block;
}

.header {
  margin: 0 -0.75rem;
  min-width: 420px;
  border-radius: 2px;
  overflow: hidden;
  transition: all 0.5s;
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
.header-text {
  position: relative;
  padding: 20px 20px;
  margin-top: 10px;
  margin-bottom: 10px;
  font-size: 2em;
  color: #f0f0f0;
  font-family: "crock";
  text-align: center;
  background: url("/public/img/menu_header.png");
  background-position: center;
  background-size: 85% 85%;
  background-repeat: no-repeat;
}

.btn-menu {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  border-radius: 0px;
  padding: 0px 20px;
  height: 5vh;
  background: url("/public/img/input.png");
  background-position: center;
  background-size: 95% 100%;
}
.main-nav-buttons {
  margin-top: 5px;
  margin-bottom: 15px;
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

.btn-bottom {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  border-radius: 0px;
  padding: 0px 20px;
  height: 4vh;
  background: url("/public/img/input.png");
  background-position: center;
  background-size: 95% 100%;
}

.btn-bottom-main {
  margin-top: 5px;
  margin-bottom: 5px;
}

.disabled {
  flex-grow: 1;
  font-size: 15px;
  border-radius: 0px;
  height: 4vh;
  border: 0px #fff solid;
  font-family: "robotoslab";
  font-weight: 500;
  letter-spacing: 1.5px;
  color: #4b4a4a;
  background-color: transparent;
}

.btn-select {
  flex-grow: 1;
  font-size: 15px;
  border-radius: 0px;
  height: 4vh;
  border: 0px #fff solid;
  font-family: "robotoslab";
  font-weight: 500;
  letter-spacing: 1.5px;
  color: #9e9e9e;
  background-color: transparent;
}

.btn-select:hover {
  background: url("/public/img/buttonv.png");
  background-size: 100% 100%;
  color: #f0f0f0;
}

.rotate-text {
  font-family: "robotoslab";
  font-weight: 500;
  font-size: 15px;
  margin: auto;
  padding: 0px 5px;
}

.grey-text {
  color: #9e9e9e;
}

.center {
  margin: auto;
}

.scroll-container::-webkit-scrollbar {
  display: none;
}

.scroll-container::-webkit-scrollbar-track {
  -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.1);
}

.scroll-container::-webkit-scrollbar-thumb {
  outline: 1px solid #313131;
  border-radius: 5px;
}

.scroll-container {
  overflow-y: auto;
  overflow-x: hidden;
  height: 54vh;
  width: 100%;
}

.btn-rotate {
  color: #d89a2e;
}
</style>
