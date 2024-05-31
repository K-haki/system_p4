import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import { createRouter, createWebHashHistory } from 'vue-router'
import routes from '~pages'
import { autoAnimatePlugin } from '@formkit/auto-animate/vue'
import 'remixicon/fonts/remixicon.css'

const router = createRouter({
    history: createWebHashHistory(),
    routes,
})

createApp(App).use(router).use(autoAnimatePlugin).mount('#app')
