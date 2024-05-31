<template>
  <v-chart :option="option" autoresize />
</template>

<script setup>
import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";
import { PieChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
} from "echarts/components";
import VChart, { THEME_KEY } from "vue-echarts";
import { ref, provide } from "vue";
import { primaryColor, secondaryColor } from "../color";

use([
  CanvasRenderer,
  PieChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
]);

provide(THEME_KEY, "dark");

const option = ref({
  backgroundColor: "rgba(0,0,0,0)",
  title: {
    text: "微突发数据包占比",
    textStyle: {
      fontSize: 14,
    },
    right: "10%",
    top: "20%",
  },
  tooltip: {
    trigger: "item",
  },
  legend: {
    orient: "vertical",
    right: '10%',
    bottom: "10%",
  },
  series: [
    {
      name: "Access From",
      type: "pie",
      radius: ["0%", "80%"],
      center: ["24%", "50%"],
      avoidLabelOverlap: false,
      itemStyle: {
        color: ({ dataIndex }) => {
          if (dataIndex === 0) return primaryColor;
          else if (dataIndex === 1) return secondaryColor;
        },
      },
      label: {
        show: false,
        position: "center",
      },
      emphasis: {
        label: {
          show: true,
          fontSize: 40,
          fontWeight: "bold",
        },
      },
      labelLine: {
        show: false,
      },
      data: [
        { value: 99.87, name: "正常数据包" },
        { value: 0.13, name: "微突发数据包" },
      ],
    },
  ],
});

// setInterval(() => {
//     option.value.series[0].data[0].value = Math.random() * 10
//     option.value.series[0].data[1].value = Math.random() * 10
// }, 1000)
</script>
