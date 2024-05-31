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
function recentHour(){
  const today = dayjs();
  let dayArr = [];
  for (let i = 0; i < 60; i++) {
    const date = today.subtract(i, "minute").format("HH:mm");
    dayArr.push(date);
  }
  return dayArr.reverse();
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
    data: recentHour(),
  },
  yAxis: {
    type: "value",
    splitLine: {
      show: false,
    },
    max: 100,
  },
  series: [
    {
      data: Array(60)
        .fill(0)
        .map(() => rand(2, 100)),
      type: "line",
      itemStyle: {
        color,
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
      animationDuration: 3000,
    },
  ],
});

setInterval(() => {
  // setInterval(() => {
  //   option.series[0].data.push(rand(2, 100));
  //   option.series[0].data.shift();
  //   option.xAxis.data.push(dayjs().format("HH:mm"));
  //   option.xAxis.data.shift();
  // }, 1000);
  key.value = uniqueId();
  option.xAxis.data = recentHour()
}, 3000);
</script>
