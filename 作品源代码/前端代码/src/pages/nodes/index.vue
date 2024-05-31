<template>
  <div class="p-4">
    <BorderBox10 :color="['white', 'rgb(4,24,31)']">
      <div class="p-4 w-full h-full flex flex-col">
        <div class="flex items-center p-4 gap-2">
          <p>各端口微突发情况</p>
        </div>
        <MicroBurstLineChart class="h-full" />
      </div>
    </BorderBox10>
  </div>
</template>

<script setup>
import MicroBurstLineChart from "@/components/MicroBurstLineChart.vue";
import { BorderBox10 } from "@kjgl77/datav-vue3";
</script>
