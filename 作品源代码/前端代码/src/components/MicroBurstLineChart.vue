<template>
    <v-chart :option="option" autoresize />
</template>

<script setup>
import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";
import { LineChart } from "echarts/charts";
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
    LineChart,
    TitleComponent,
    TooltipComponent,
    LegendComponent,
    GridComponent
]);

provide(THEME_KEY, "dark");

const color = {
    type: 'linear',
    x: 0,
    y: 0,
    x2: 1,
    y2: 0,
    colorStops: [
        {
            offset: 0,
            color: secondaryColor
        },
        {
            offset: 1,
            color: primaryColor
        }
    ]
}

const option = ref({
    backgroundColor: 'rgba(0,0,0,0)',
    // title: {
    //     text: '各端口微突发情况'
    // },
    yAxis: {
        type: 'value',
        splitLine: {
            show: false
        }
    },
    xAxis: {
        type: 'category',
    },
    series: [
        {
            data: Array(5).fill(0),
            type: 'line',
            itemStyle: {
                color: '#000',
                borderWidth: 2,
                borderColor: color
            },
            areaStyle: {
                color
            },
            smooth: true
        },
    ]
});

setInterval(() => {
    option.value.series[0].data.push(Math.random() * 10)
    option.value.series[0].data.shift()
}, 1000)
</script>