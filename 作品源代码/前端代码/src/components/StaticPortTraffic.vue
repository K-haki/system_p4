<template>
  <v-chart :option="option" autoresize ref="chart" :key="key" />
</template>

<script setup>
import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";
import { PieChart, LineChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
} from "echarts/components";
import VChart, { THEME_KEY } from "vue-echarts";
import { ref, provide, reactive, onMounted } from "vue";
import { primaryColor, secondaryColor } from "../color";
import { rand } from "@vueuse/core";
import dayjs from "dayjs";
import { uniqueId } from "lodash-es";

const chart = ref();
const key = ref(uniqueId());
use([
  CanvasRenderer,
  PieChart,
  LineChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
]);

provide(THEME_KEY, "dark");
function currentHour() {
  const current = dayjs().subtract(dayjs().minute(), "minute");
  let dayArr = [];
  for (let i = 0; i < 60; i++) {
    const date = current.add(i, "minute").format("HH:mm");
    dayArr.push(date);
  }
  return dayArr;
}

const color = {
  type: "linear",
  x: 0,
  y: 0,
  x2: 1,
  y2: 0,
  colorStops: [
    {
      offset: 0.3,
      color: primaryColor,
    },
    {
      offset: 1,
      color: secondaryColor,
    },
  ],
};

const option = reactive({
  backgroundColor: "rgba(0,0,0,0)",
  // title: {
  //     text: '流量'
  // },
  xAxis: {
    type: "category",
    data: currentHour(),
  },
  yAxis: {
    type: "value",
    splitLine: {
      show: false,
    },
  },
  series: [
    {
      data: Array(60)
        .fill(0)
        .map((v, i) => {
          if (i <= dayjs().minute()) return rand(12.5, 30.12);
          else return null;
        }),
      type: "line",
      itemStyle: {
        color: primaryColor,
      },
      areaStyle: {
        color: {
          type: "linear",
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [
            {
              offset: 0,
              color: primaryColor, // 0% 处的颜色
            },
            {
              offset: 1,
              color: "rgba(1,1,1,0)", // 100% 处的颜色
            },
          ],
        },
      },
      showSymbol: false,
      animation: true,
    },
  ],
});
</script>
