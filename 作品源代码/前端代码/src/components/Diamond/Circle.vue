<template>
    <div class="rounded-full shadow-lg shadow-white/50 flex items-center justify-center relative">
        <div
            class=" w-5/6 aspect-square border-[rgb(92,251,230)] shadow-lg shadow-[rgb(92,251,230)]/50 rounded-full border-r animate-spin-6 flex items-center justify-center absolute">
            <div
                class=" w-5/6 aspect-square border-[rgb(246,163,254)] shadow-lg shadow-[rgb(246,163,254)]/50 rounded-full border-r animate-spin-9">
            </div>
        </div>
        <slot class=" absolute top-1/2 left-1/2"></slot>
    </div>
</template>