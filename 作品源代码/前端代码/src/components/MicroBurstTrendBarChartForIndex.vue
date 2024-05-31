<template>
  <v-chart :option="option" autoresize />
</template>

<script setup>
import dayjs, { Dayjs } from "dayjs";
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
import { ref, provide, computed } from "vue";
import { primaryColor, secondaryColor } from "../color";
import { rand } from "@vueuse/core";
import { sum } from "lodash-es";

use([
  CanvasRenderer,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
]);

provide(THEME_KEY, "dark");

const props = defineProps(["timeType"]);
function currentHour() {
  const current = dayjs().subtract(dayjs().hour(), "hour");
  let dayArr = [];
  for (let i = 0; i < 24; i++) {
    const date = current.add(i, "hour").format("HH:00");
    dayArr.push(date);
  }
  return dayArr;
}

function currentDate() {
  const current = dayjs().subtract(dayjs().date(), "day");
  let dayArr = [];
  for (let i = 1; i <= dayjs().daysInMonth(); i++) {
    const date = current.add(i, "day").format("MM.DD");
    dayArr.push(date);
  }
  console.log(dayArr);
  return dayArr;
}
const yData = Array(dayjs().daysInMonth())
  .fill(0)
  .map(() => []);

for (let i = 0; i < yData.length; i++) {
  for (let j = 0; j < 24; j++) {
    if (j >= dayjs().hour() && yData.length - 1 >= i) break;
    yData[i].push(rand(2,50));
  }
}
console.log(yData)
const color = {
  type: "linear",
  x: 0,
  y: 0,
  x2: 0,
  y2: 1,
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

const option = computed(() => {
  const op = {
    backgroundColor: "rgba(0,0,0,0)",
    title: {
      text: "微突发历史趋势",
      textStyle: {
        fontSize: 16,
      },
      right: "15%",
    },
    grid: {
      bottom: "0%",
      top: "10%",
      right: "18%",
      containLabel: true,
    },
    xAxis: {
      type: "category",
      data: currentHour(),
      boundaryGap: true,
    },
    yAxis: {
      type: "value",
      splitLine: {
        show: false,
      },
    },
    series: [
      {
        data: [],
        type: "bar",
        itemStyle: {
          color,
        },
      },
    ],
  };
  if (props.timeType === "day") {
    op.xAxis.data = currentDate();
    op.series[0].data = yData.map((v) => sum(v));
  } else {
    op.series[0].data = yData[dayjs().date() - 1];
  }
  return op;
});
</script>
