<template>
  <div class="p-8 overflow-y-auto font-mono">
    <Selector :selected="selected" @update:selected="(s) => (selected = s)" />
    <NDataTable :columns="columns" :data="data" :pagination="pagination" />
    <!-- <pre>{{ JSON.stringify(data, null, 2) }}</pre> -->
  </div>
</template>

<script setup>
import { h, ref } from "vue";
import { NInput, NDataTable, NButton } from "naive-ui";
import { useRoute } from "vue-router";
import Selector from "@/components/Selector.vue";

const route = useRoute();
const selected = ref(route.query.label || "S1");

const createData = () => [
  {
    id: 1,
    device: "S1",
    match: "10.0.0.1/32",
    action: "set _designate _nhop",
    port: 1,
    prob: 1,
  },
  {
    id: 2,
    device: "S1",
    match: "10.0.0.1/32",
    action: "set _designate _nhop",
    port: 2,
    prob: 0.3,
  },
  {
    id: 3,
    device: "S1",
    match: "10.0.0.2",
    action: "ipv4_ select _forward",
    port: 3,
    prob: 0,
  },
];

const data = ref(createData());
const columns = [
  {
    title: "ID",
    key: "id",
    width: 64,
    render: custom_render("id"),
  },
  {
    title: "设备",
    key: "device",
    width: 128,
    render: custom_render("device"),
  },
  {
    title: "匹配参数",
    key: "match",
    width: 256,
    render: custom_render("match"),
  },
  {
    title: "Action entry(动作表项)",
    key: "action",
    render: custom_render("action"),
  },
  {
    title: "输出端口",
    key: "port",
    width: 96,
    render: custom_render("port"),
  },
  {
    title: "概率",
    key: "prob",
    width: 96,
    render: custom_render("prob"),
  },
  {
    title: "操作",
    key: "op",
    width: 96,
    render() {
      return h(
        NButton,
        {
          onClick(v) {
            alert("修改成功");
          },
          type: "primary",
          class: "text-white",
        },
        "修改"
      );
    },
  },
];

function custom_render(col) {
  return (row, index) => {
    return h(NInput, {
      value: row[col],
      onUpdateValue(v) {
        data.value[index][col] = v;
      },
    });
  };
}
</script>
