<template>
  <div class="flex flex-col font-mono h-full gap-8">
    <n-table :bordered="false" :single-line="false" size="small">
      <thead>
        <tr>
          <th>序列</th>
          <th>设备</th>
          <th>级别</th>
          <th>突发流量最高速率</th>
          <th>最高突发次数</th>
        </tr>
      </thead>
      <tbody v-auto-animate>
        <tr v-for="event in displayEvents" :key="event.id">
          <td v-if="k != 'date'" v-for="(v, k) in event">
            {{ v }}
          </td>
        </tr>
      </tbody>
    </n-table>
  </div>
</template>

<script setup>
import { computed } from "vue";
import { NTable } from "naive-ui";
import { useGlobalState } from "@/store";
import { omit } from "lodash-es";
const { events } = useGlobalState();

const displayEvents = computed(() => {
  return events
    .slice(events.length - 3, events.length)
    .map((v) => omit(v, "date"));
});
</script>
