<template>
    <div class="wrap1">
        <div class="wrap2">
            <div class="diamond w-full aspect-square flex items-center justify-center relative overflow-visible">
                <div class="absolute aspect-square circle-three w-full" v-for="_ in 5">
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.diamond {
    clip-path: polygon(72% 0, 100% 40%, 50% 78%, 0 40%, 28% 0);
    background: rgba(255, 255, 255, 0.2);
}

.diamond::before{
    content: '';
    clip-path: polygon(72% 0, 100% 40%, 50% 78%, 0 40%, 28% 0);
    position: absolute;
    width: 98%;
    aspect-ratio: 1/1;
    background: #000;
    z-index: 10;
}
.wrap1 {
    filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.1));
}

.wrap2 {
    filter: drop-shadow(0 0 20px rgba(255, 255, 255, 0.1));
}

.diamond :nth-child(1){
    background: conic-gradient(#00000000 21deg,#ffffff 21deg, #ffffff 26deg, #00000000 26deg);
    filter: drop-shadow(0 0 80px rgba(255, 255, 255));
}
.diamond :nth-child(2){
    background: conic-gradient(#00000000 334deg,#ffffff 334deg, #ffffff 339deg, #00000000 339deg);
    filter: drop-shadow(0 0 80px rgba(255, 255, 255));
}
.diamond :nth-child(3){
    background: conic-gradient(#00000000 75deg,#ffffff 75deg, #ffffff 80deg, #00000000 80deg);
    filter: drop-shadow(0 0 80px rgba(255, 255, 255));
}
.diamond :nth-child(4){
    background: conic-gradient(#00000000 177deg,#ffffff 177deg, #ffffff 183deg, #00000000 183deg);
    filter: drop-shadow(0 0 80px rgba(255, 255, 255));
}
.diamond :nth-child(5){
    background: conic-gradient(#00000000 280deg,#ffffff 280deg, #ffffff 285deg, #00000000 285deg);
    filter: drop-shadow(0 0 80px rgba(255, 255, 255));
}
</style>