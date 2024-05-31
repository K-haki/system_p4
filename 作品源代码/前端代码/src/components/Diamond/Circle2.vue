<template>
  <div class="relative">
    <!-- 外圈 -->
    <div class="absolute top-0 left-0 w-full outer">
      <div class="relative w-full aspect-square">
        <div
          class="border-dashed rounded-full border-white border absolute top-0 left-0 w-full aspect-square"
        ></div>
        <div
          v-for="i in 6"
          class="absolute w-full aspect-square flex items-start justify-center bg-transparent"
          :class="!isEase ? 'circle-one' : 'circle-one-active'"
          :style="{
            transform: `rotateZ(${(360 / 6) * i}deg)`,
          }"
        ></div>
        <div
          class="absolute top-0 left-0 w-full flex items-center justify-center aspect-square before:bg-bottom before:w-[98%] before:rounded-full before:aspect-square"
        ></div>
      </div>
    </div>
    <!-- 中圈 -->
    <div class="absolute top-0 left-0 w-full middle">
      <div class="relative w-full aspect-square">
        <div
          v-for="i in 12"
          class="absolute w-full aspect-square flex items-center justify-center bg-transparent"
          :class="!isEase ? 'circle-two' : 'circle-two-active'"
          :style="{
            transform: `rotateZ(${(360 / 12) * i}deg)`,
          }"
        >
          >
        </div>
        <div
          v-for="i in 72"
          class="absolute w-full aspect-square flex items-center justify-center bg-transparent"
          :class="!isEase ? 'circle-three' : 'circle-three-active'"
          :style="{
            transform: `rotateZ(${(360 / 72) * i}deg)`,
          }"
        >
          >
        </div>
        <div
          class="absolute top-0 left-0 w-full flex items-center justify-center aspect-square before:bg-bottom before:w-[87%] before:rounded-full before:aspect-square"
        ></div>
      </div>
    </div>

    <!-- 内圈 -->
    <div class="absolute top-0 left-0 w-full inner">
      <div class="relative w-full animate-spin-9 aspect-square">
        <div
          class="absolute w-full aspect-square flex items-center justify-center bg-transparent"
          :class="!isEase ? 'circle-four' : 'circle-four-active'"
        ></div>
        <div
          class="absolute top-0 left-0 w-full flex items-center justify-center aspect-square before:bg-bottom before:w-[70%] before:rounded-full before:aspect-square"
        ></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useGlobalState } from "@/store";

const { isEase } = useGlobalState();
</script>

<style scoped>
.circle-one::before {
  content: "";
  position: absolute;
  width: 100%;
  border-radius: 50%;
  aspect-ratio: 1/1;
  background: conic-gradient(var(--ring-color2) 30deg, #ffffff00 0deg);
}
.circle-one-active::before {
  content: "";
  position: absolute;
  width: 100%;
  border-radius: 50%;
  aspect-ratio: 1/1;
  background: conic-gradient(var(--ring-color-active) 30deg, #ffffff00 0deg);
}

.circle-two::before {
  content: "";
  position: absolute;
  width: 95%;
  border-radius: 50%;
  aspect-ratio: 1/1;
  background: conic-gradient(var(--ring-color2) 1deg, #ffffff00 0deg);
}
.circle-two-active::before {
  content: "";
  position: absolute;
  width: 95%;
  border-radius: 50%;
  aspect-ratio: 1/1;
  background: conic-gradient(var(--ring-color-active) 1deg, #ffffff00 0deg);
}

.circle-three::before {
  content: "";
  position: absolute;
  width: 90%;
  border-radius: 50%;
  aspect-ratio: 1/1;
  background: conic-gradient(var(--ring-color2) 1deg, #ffffff00 0deg);
}

.circle-three-active::before {
  content: "";
  position: absolute;
  width: 90%;
  border-radius: 50%;
  aspect-ratio: 1/1;
  background: conic-gradient(var(--ring-color-active) 1deg, #ffffff00 0deg);
}

.circle-four::before {
  content: "";
  position: absolute;
  width: 83%;
  border-radius: 50%;
  border: #fff solid 1px;
  aspect-ratio: 1/1;
  background: conic-gradient(var(--ring-color2) 100deg, #ffffff58 0deg);
}

.circle-four-active::before {
  content: "";
  position: absolute;
  width: 83%;
  border-radius: 50%;
  border: #fff solid 1px;
  aspect-ratio: 1/1;
  background: conic-gradient(var(--ring-color-active) 100deg, #ffffff58 0deg);
}

@keyframes swing {
  0% {
    transform: rotate(0deg);
  }
  30% {
    transform: rotate(100deg);
  }
  60% {
    transform: rotate(-100deg);
  }
  100% {
    transform: rotate(0deg);
  }
}

.outer {
  animation: swing 6s ease-in-out infinite;
}
.middle {
  animation: swing 9s ease-in-out infinite;
}
.inner {
  animation: swing 12s ease-in-out infinite;
}
</style>
