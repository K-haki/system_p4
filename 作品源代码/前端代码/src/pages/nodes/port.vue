<template>
  <div class="p-4">
    <BorderBox10 :color="['white', 'white']">
      <div class="p-4 w-full h-full flex flex-col">
        <div class="flex items-center p-4 gap-2">
          <Selector :selected="selected" @update:selected="(s) => (selected = s)" />
          <p>流量变化情况</p>
        </div>
        <StaticPortTraffic class="h-full" />
      </div>
    </BorderBox10>
  </div>
</template>

<script setup>
import StaticPortTraffic from "@/components/StaticPortTraffic.vue";
import { BorderBox10 } from "@kjgl77/datav-vue3";
import { ref } from "vue";
import Selector from "@/components/Selector.vue";
const selected = ref("S1");
</script>
