<template>
  <v-chart :option="option" autoresize />
</template>

<script setup>
import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";
import { BarChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
} from "echarts/components";
import VChart, { THEME_KEY } from "vue-echarts";
import { ref, provide } from "vue";
import { primaryColor, secondaryColor } from "../color";
import { rand } from "@vueuse/core";
import { map, sortBy } from "lodash-es";
use([
  CanvasRenderer,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
]);

provide(THEME_KEY, "dark");

const data = ref([
  {
    y: "s1-eth1",
    x: 10,
  },
  {
    y: "s2-eth1",
    x: 10,
  },
  {
    y: "s1-eth2",
    x: 10,
  },
  {
    y: "s2-eth2",
    x: 10,
  },
  {
    y: "s3-eth1",
    x: 10,
  },
]);

const color = {
  type: "linear",
  x: 0,
  y: 0,
  x2: 1,
  y2: 0,
  colorStops: [
    {
      offset: 0,
      color: secondaryColor,
    },
    {
      offset: 1,
      color: primaryColor,
    },
  ],
};

const option = ref({
  backgroundColor: "rgba(0,0,0,0)",
  // title: {
  //     text: '各端口微突发情况'
  // },
  grid: {
    left: "10%",
    top: "5%",
    bottom: "20%",
    containLabel: true,
  },
  xAxis: {
    type: "value",
    splitLine: {
      show: false,
    },
    max: 1000,
  },
  yAxis: {
    type: "category",
    data: map(data.value, "y"),
    inverse: true,
    animationDuration: 300,
    animationDurationUpdate: 300,
  },
  series: [
    {
      data: Array(5).fill(0),
      type: "bar",
      realtimeSort: true,
      itemStyle: {
        color: "rgba(1,1,1,0)",
        borderWidth: 2,
        borderColor: color,
      },
    },
  ],
});

setInterval(() => {
  data.value.forEach((e) => (e.x = rand(500, 899)));
  option.value.series[0].data = map(data.value, "x");
}, 2000);
</script>
