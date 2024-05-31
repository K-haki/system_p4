<template>
  <div
    class="p-1 overflow-hidden w-full flex items-center justify-center h-full"
    ref="panel"
  >
    <BorderBox11
      class="font-bold flex relative pt-8 main-view"
      :color="['white', 'rgb(255,255,255,0.5)']"
      title="网络总览"
      :style="{
        height: `${scalableHeight}px`,
        width: `${scalableWidth}px`,
      }"
    >
      <div
        class="absolute -top-10 right-2 text-white px-4 w-48 text-center font-bold"
      >
        {{ time }}
      </div>

      <!-- 上方 -->
      <div
        class="text-white p-8 pt-[5%] pb-0 flex gap-2 h-2/5 items-center justify-between w-full"
      >
        <!-- 网络流量分布  -->
        <div
          class="h-full relative w-[33%] flex flex-col gap-2 justify-start pl-8"
        >
          <img src="../assets/Group4.svg" alt="" class="ab-center" />
          <div class="absolute -top-[12%] left-[16%]">网络流量分布</div>
          <StreamProportionPieChart class="h-1/2 w-5/6" />
          <PackageProportionPieChart class="h-1/2 w-5/6" />
        </div>

        <!-- 微突发 -->
        <RouterLink class="relative h-full w-[33%]" to="/microburst-trend">
          <img
            src="../assets/Group5.svg"
            alt=""
            class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
          />
          <MicroBurstTrendBarChartForIndex class="absolute right-0 bottom-0 w-5/6" />
        </RouterLink>
      </div>

      <!-- 中部 -->
      <div class="flex justify-between items-end h-1/5">
        <div class="h-1/2 w-1/4 -scale-x-100 col-span-2">
          <Decoration1 :key="scalableHeight" :color="['white', 'white']" />
        </div>
        <div class="h-1/2 w-1/4 justify-self-end col-span-2">
          <Decoration1 :key="scalableHeight" :color="['white', 'white']" />
        </div>
      </div>

      <!-- 下方 -->
      <div class="flex justify-between items-center h-2/5 px-8">
        <!-- 流量记录 -->
        <RouterLink
          class="h-full relative w-[36%] cursor-pointer"
          to="/nodes/port"
        >
          <div
            class="absolute top-24 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full"
          >
            <img src="../assets/Group3.svg" alt="" class="-scale-x-100" />
            <div
              class="absolute top-0 left-4 text-black font-bold"
              :style="{
                color: 'white',
                // color: `white`, //改成其他颜色范例
              }"
            >
              网络流量状况
            </div>
          </div>
          <PortTrafficLineChart
            class="absolute left-0 bottom-0 h-4/5"
            ref="portLineChart"
          />
        </RouterLink>

        <div class="h-full relative w-[36%]">
          <div
            class="absolute top-24 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full"
          >
            <img src="../assets/Group3.svg" alt="" />
            <div
              class="absolute top-0 right-4 text-black font-bold text-base"
              :style="{
                color: 'white',
              }"
            >
              端口微突发情况
            </div>
          </div>
          <MicroBurstPortBarChart
            class="absolute right-0 bottom-0 h-4/5 w-4/5"
          />
        </div>
      </div>

      <!-- 五边形 -->
      <div class="absolute top-24 w-full h-full pointer-events-none z-10">
        <Diamond2 class="h-[94%] m-auto aspect-square" />
      </div>

      <EventTableForIndex class="absolute left-1/2 -translate-x-1/2 top-6 w-[28%]" />
    </BorderBox11>
  </div>
</template>

<script setup>
import { BorderBox11, Decoration1 } from "@kjgl77/datav-vue3";
import PortTrafficLineChart from "../components/PortTrafficLineChart.vue";
import MicroBurstPortBarChart from "../components/MicroBurstPortBarChart.vue";
import PackageProportionPieChart from "../components/PackageProportionPieChart.vue";
import StreamProportionPieChart from "../components/StreamProportionPieChart.vue";
import Diamond2 from "@/components/Diamond/Diamond2.vue";
import { computed, nextTick, ref, watch } from "vue";
import { useDateFormat, useElementSize,useNow } from "@vueuse/core";
import EventTableForIndex from "@/components/EventTableForIndex.vue";
import MicroBurstTrendBarChartForIndex from "@/components/MicroBurstTrendBarChartForIndex.vue";

const time = useDateFormat(useNow())
const panel = ref();
const { width, height } = useElementSize(panel);
const scalableHeight = computed(() => {
  return Math.min(width.value * (9 / 16), height.value);
});

const scalableWidth = computed(() => {
  return Math.min(height.value * (16 / 9), width.value);
});
</script>

<style>
.main-view::before {
  content: "";
  position: absolute;
  top: 8;
  left: 1%;
  width: 98%;
  height: 95%;
  background: url("/background.jpg");
  opacity: 0.3;
  border-radius: 5px;
}

/* *{
  color:rgb(6, 40, 59)
} */
</style>
