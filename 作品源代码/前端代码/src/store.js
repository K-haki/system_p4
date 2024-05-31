// store.js
import { ref, reactive } from 'vue'
import { createGlobalState, rand } from '@vueuse/core'
import dayjs from 'dayjs';

export const useGlobalState = createGlobalState(
  () => {
    const isEase = ref(false);
    const events = reactive([])
    let cnt = 0
    setInterval(() => {
      const device = rand(1, 4)
      let port = -1
      if (device === 1) {
        port = rand(0, 4)
      }
      else if (device === 4) {
        port = rand(0, 3)
      }
      else {
        port = rand(0, 1)
      }
      events.push({
        id: cnt++,
        device: `S${device}`,
        port: `eth${port}`,
        rate: `${rand(1, 250)}Gbps`,
        duration: `${rand(1, 1000)}`,
        date: dayjs().format('YYYY.MM.DD.HH')
      })
    }, 1000);
    return { isEase, events }
  }
)