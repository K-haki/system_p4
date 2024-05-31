<template>
  <div class="flex flex-col p-16 gap-8">
    <div class="flex items-center gap-4">
      <p>启动缓解</p>
      <NSwitch v-model:value="isEase" />
    </div>
    <div class="flex items-center gap-4">
      <p class="flex-none">微突发队列长度判定阈值</p>
      <NInput v-model:value="threshold" class="font-mono" />
    </div>
    <NButton class="self-end">保存</NButton>
  </div>
</template>

<script setup>
import { useGlobalState } from "@/store";
import { NInput, NSwitch,NButton } from "naive-ui";
import { ref } from "vue";
const threshold = ref("");
const { isEase } = useGlobalState();
</script>
