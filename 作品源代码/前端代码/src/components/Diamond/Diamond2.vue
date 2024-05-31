<template>
  <div class="relative overflow-hidden">
    <!-- <img
      src="@/assets/DiamondBg.svg"
      alt=""
      class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full"
    /> -->
    <!-- <img src="@/assets/Group6.svg" alt="" class="ab-center" />
    <img src="@/assets/Group7.svg" alt="" class="ab-center" /> -->
    <img src="@/assets/Diamond.svg" alt="" class="ab-center" />
    <!-- <Center
      class="w-[22%] absolute top-[45%] left-1/2 -translate-x-1/2 -translate-y-1/2"
    /> -->
    <div
      class="w-[32%] h-[20%] absolute top-[45%] left-1/2 -translate-x-1/2 -translate-y-1/2 z-20"
    >
      <BorderBox7 class="w-full h-full" :color="[`${level.color}`]">
        <div class="flex flex-col items-center h-full font-thin">
          <div class="text-xs mt-[14%]">风险等级</div>
          <div
            class="text-4xl font-bold"
            :style="{
              color: `${level.color}`,
            }"
          >
            {{ level.label }}
          </div>
        </div>
      </BorderBox7>
    </div>
    <div class="w-[22%] absolute top-[12%] left-[20%] aspect-square">
      <Circle1 />
      <div
        class="absolute top-[45%] left-1/2 -translate-x-1/2 -translate-y-1/2 font-thin text-xs w-full"
      >
        <div class="text-center">微突发 <br />平均持续时间</div>
        <div class="text-2xl font-bold flex items-end justify-center">
          <div>{{ randoms[0] }}</div>
          <div class="text-xs">us</div>
        </div>
      </div>
    </div>
    <div class="w-[22%] absolute top-[12%] left-[58%] aspect-square">
      <Circle1 />
      <div class="ab-center text-xs font-thin">
        <div>微突发数量</div>
        <div class="text-2xl font-bold flex items-end justify-center">
          <div>
            {{ randoms[1] }}
          </div>
        </div>
      </div>
    </div>
    <div class="w-[22%] absolute top-[37%] left-[10%] aspect-square">
      <Circle2 />
      <div class="ab-center font-thin text-xs relative w-full">
        <div class="text-center">网络平均速率</div>
        <div class="text-2xl font-bold flex items-end justify-center">
          <div>{{ randoms[2] }}</div>
          <div class="text-xs">bps</div>
        </div>
      </div>
    </div>
    <div class="w-[22%] absolute top-[37%] left-[69%] aspect-square">
      <Circle2 />
      <div class="ab-center text-xs font-thin text-center">
        <div>max速率</div>
        <div class="text-2xl font-bold flex items-end justify-center">
          <div>{{ randoms[3] }}</div>
          <div class="text-xs">bps</div>
        </div>
      </div>
    </div>
    <div
      class="w-[22%] absolute left-1/2 -translate-x-1/2 -translate-y-1/2 top-[70%] aspect-square"
    >
      <Circle2 />
      <div class="ab-center text-xs font-thin text-center">
        <div>丢包率</div>
        <div class="text-2xl font-bold flex items-end justify-center">
          <div>{{ randoms[4] }}</div>
          <div class="text-xs">%</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from "vue";
import Circle1 from "./Circle1.vue";
import Circle2 from "./Circle2.vue";
import { BorderBox7 } from "@kjgl77/datav-vue3";
import { useGlobalState } from "@/store.js";
import { primaryColor } from "@/color";
const { isEase } = useGlobalState();
const level = computed(() =>
  isEase.value
    ? {
        label: "低",
        color: primaryColor,
      }
    : {
        label: "高",
        color: "red",
      }
);
const randoms = computed(() =>
  isEase.value ? [30, 2202, 11.9, 19, 9, 0.73] : [37, 2453, 9.98, 31.1, 1.03]
);
</script>
