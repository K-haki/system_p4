<template>
  <div class="flex flex-col font-mono h-full gap-8">
    <div class="flex items-center gap-4">
      <div class="flex-none ">过滤日期：</div>
      <n-input v-model:value="filter[0]" placeholder="年"></n-input>
      <n-input v-model:value="filter[1]" placeholder="月"></n-input>
      <n-input v-model:value="filter[2]" placeholder="日"></n-input>
      <n-input v-model:value="filter[3]" placeholder="小时"></n-input>
    </div>
    <n-table :bordered="false" :single-line="false" size="small">
      <thead>
        <tr>
          <th>序列</th>
          <th>设备</th>
          <th>级别</th>
          <th>突发流量最高速率</th>
          <th>最高突发次数</th>
          <th>探测事件时间</th>
        </tr>
      </thead>
      <tbody v-auto-animate>
        <tr v-for="event in displayEvents" :key="event">
          <td v-for="v in event">
            {{ v }}
          </td>
        </tr>
      </tbody>
    </n-table>
    <n-pagination v-model:page="page" :page-count="pageCount" class="mt-auto" />
  </div>
</template>

<script setup>
import { computed, ref } from "vue";
import { NTable, NPagination,NInput } from "naive-ui";
import { useGlobalState } from "@/store";
const { events } = useGlobalState();
const pageSize = 10;
const page = ref(1);
const filter = ref(["", "", "", ""]);
const filterEvents = computed(() => {
  return events.filter((v) => {
    const vecDate = v.date.split(".");
    for (let i = 0; i < filter.value.length; i++) {
      if (filter.value[i] && parseInt(filter.value[i]) !== parseInt(vecDate[i])) {
        return false;
      }
    }
    return true
  });
});
const pageCount = computed(() => {
  return Math.ceil(filterEvents.value.length / pageSize);
});

const displayEvents = computed(() => {
  return filterEvents.value.slice((page.value - 1) * pageSize, page.value * pageSize);
});
</script>
