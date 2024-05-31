<template>
  <div class="relative p-4" ref="board">
    <BorderBox7 :color="['white', 'white']" :key="width">
      <div class="h-full w-full" ref="panel"></div>
      <div class="border border-white w-60 h-32 top-8 left-8 absolute p-4">
        <p class="mb-2">微突发次数</p>
        <div class="flex items-center justify-between">
          <span class="bg-green-500 rounded-full aspect-square w-4"></span> &lt;
          100
        </div>
        <div class="flex items-center justify-between">
          <div class="bg-yellow-500 rounded-full aspect-square w-4"></div>
          100~500
        </div>
        <div class="flex items-center justify-between">
          <div class="bg-red-500 rounded-full aspect-square w-4"></div>
          &gt; 500
        </div>
      </div>
    </BorderBox7>
  </div>
</template>

<script setup>
import { Network } from "vis-network";
import { nextTick, onMounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import switchImageUrl from "../assets/Switch.png";
import clientImageUrl from "../assets/Laptop1.png";
import { BorderBox7 } from "@kjgl77/datav-vue3";
import { useElementSize } from "@vueuse/core";
import { useGlobalState } from "@/store";
const board = ref();
const { width } = useElementSize(board);
const panel = ref();
const { isEase } = useGlobalState();
const options = {
  nodes: {
    font: {
      color: "#fff",
    },
    color: "#fff",
  },
  edges: {
    color: "rgba(255,255,255,0.2)",
  },
  layout: {
    hierarchical: {
      direction: "LR",
    },
  },
};
const nodes = [
  {
    id: 1,
    label: "pc1",
    level: 0,
    image: clientImageUrl,
    shape: "image",
  },
  {
    id: 2,
    label: "pc2",
    level: 0,
    image: clientImageUrl,
    shape: "image",
  },
  {
    id: 3,
    label: "S1",
    level: 1,
    image: switchImageUrl,
    shape: "image",
  },
  {
    id: 4,
    label: "S2",
    level: 2,
    image: switchImageUrl,
    shape: "image",
  },
  {
    id: 5,
    label: "S3",
    level: 2,
    image: switchImageUrl,
    shape: "image",
  },
  {
    id: 6,
    label: "S4",
    level: 3,
    image: switchImageUrl,
    shape: "image",
  },
  {
    id: 7,
    label: "pc3",
    level: 4,
    image: clientImageUrl,
    shape: "image",
  },
];
function createDot(hexColor) {
  return {
    enabled: true,
    type: "image",
    imageWidth: 12,
    imageHeight: 12,
    src: `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' style='width:24px;height:24px' viewBox='0 0 24 24'%3E%3Ccircle cx='12' cy='12' r='10' fill='%23${hexColor.slice(
      1
    )}' /%3E%3C/svg%3E`,
  };
}
const redDot = createDot("#ff0000");
const greenDot = createDot("#00ff00");
const yellowDot = createDot("#EAB308");
const edges = [
  {
    from: 1,
    to: 3,
    arrows: {
      to: greenDot,
      from: greenDot,
    },
  },
  {
    from: 2,
    to: 3,
    arrows: {
      to: isEase.value ? yellowDot : redDot,
      from: isEase.value ? yellowDot : redDot,
    },
  },
  {
    from: 3,
    to: 4,
    arrows: {
      to: greenDot,
      from: greenDot,
    },
  },
  {
    from: 3,
    to: 5,
    arrows: {
      to: isEase.value ? yellowDot : redDot,
      from: isEase.value ? yellowDot : redDot,
    },
  },
  {
    from: 3,
    to: 6,
    arrows: {
      to: isEase.value ? yellowDot : redDot,
      from: isEase.value ? yellowDot : redDot,
    },
  },
  {
    from: 4,
    to: 6,
    arrows: {
      to: isEase.value ? greenDot : redDot,
      from: isEase.value ? greenDot : redDot,
    },
  },
  {
    from: 5,
    to: 6,
    arrows: {
      to: isEase.value ? greenDot : redDot,
      from: isEase.value ? greenDot : redDot,
    },
  },
  {
    from: 6,
    to: 7,
    arrows: {
      to: greenDot,
      from: greenDot,
    },
  },
];
const router = useRouter();
function renderNets() {
  new Network(panel.value, { nodes, edges }, options).on(
    "doubleClick",
    function (params) {
      const label = nodes.find((v) => v.id === params.nodes[0]).label;
      if (label.startsWith("S")) router.push(`/flow?label=${label}`);
      // alert(JSON.stringify(params, null, 4))
    }
  );
}
onMounted(() => {
  renderNets();
});

watch(width, () => {
  nextTick(() => renderNets());
});
</script>
