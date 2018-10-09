import Vue from 'vue';
import VueRouter from 'vue-router';
import App from './App';
import Routers from './router.js';
import 'mdui/dist/css/mdui.css';

Vue.use(VueRouter);

// The routing configuration
const RouterConfig = {
    routes: Routers
};
const router = new VueRouter(RouterConfig);

new Vue({
    el: '#app',
    router: router,
    render: h => h(App)
});