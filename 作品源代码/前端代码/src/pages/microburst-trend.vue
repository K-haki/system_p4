<template>
  <div class="p-4">
    <BorderBox10 :color="['white', 'white']">
      <div class="p-4 w-full h-full flex flex-col">
        <div class="flex items-center p-4 gap-2">
          <Selector
            :selected="selected"
            @update:selected="(s) => (selected = s)"
          />
          <p>微突发趋势</p>
          <NSelect class="w-32" v-model:value="timeChoice" :options="timeOptions" />
        </div>
        <MicroBurstTrendBarChart class="h-full" :timeType="timeChoice" />
      </div>
    </BorderBox10>
  </div>
</template>

<script setup>
import { BorderBox10 } from "@kjgl77/datav-vue3";
import { ref } from "vue";
import Selector from "@/components/Selector.vue";
import MicroBurstTrendBarChart from "@/components/MicroBurstTrendBarChart.vue";
import { NSelect } from "naive-ui";
const selected = ref("S1");
const timeChoice = ref("day");
const timeOptions = [
  {
    label: "时时",
    value: "hour",
  },
  {
    label: "日时",
    value: "day",
  },
];
</script>
