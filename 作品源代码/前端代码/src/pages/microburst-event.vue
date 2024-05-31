<template>
	<div class="p-4" ref="panel">
		<BorderBox6 class="p-8" :key="width">
			<EventTable class="w-full"/>
		</BorderBox6>
	</div>
</template>


<script setup>
import EventTable from '@/components/EventTable.vue';
import { BorderBox6 } from '@kjgl77/datav-vue3';
import { ref } from 'vue';
import { useElementSize } from '@vueuse/core';
const panel = ref();
const { width } = useElementSize(panel);
</script>