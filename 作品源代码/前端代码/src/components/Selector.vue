<template>
  <NSelect :options="options" v-model:value="selected" class="w-32 font-mono" />
</template>

<script setup>
import { NSelect } from "naive-ui";
import { useVModels } from "@vueuse/core";
const props = defineProps({
  selected: String,
});
const emit = defineEmits();
const { selected } = useVModels(props, emit);
const options = [
  {
    label: "S1",
    value: "S1",
  },
  {
    label: "S2",
    value: "S2",
  },
  {
    label: "S3",
    value: "S3",
  },
  {
    label: "S4",
    value: "S4",
  },
];
</script>
