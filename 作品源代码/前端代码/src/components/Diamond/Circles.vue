<template>
    <div class="grid grid-cols-6 gap-4 w-5/6 m-auto mt-8">
        <Circle2 class="col-span-2 aspect-square">

        </Circle2>
        <Circle class="col-span-2 aspect-square">
            66%
        </Circle>
        <Circle class="col-span-2 aspect-square">
            <p class="text-lg font-bold">
                66 %
            </p>
        </Circle>
        <div class="col-span-1">
        </div>
        <Circle class="col-span-2 aspect-square">
            <p class="text-2xl font-bold">
                66 %
            </p>
        </Circle>
        <Circle class="col-span-2 aspect-square">
            <p class="text-2xl font-bold">
                66 %
            </p>
        </Circle>
    </div>
</template>

<script setup>
import Circle from './Circle.vue'
import Circle2 from './Circle2.vue';
</script>