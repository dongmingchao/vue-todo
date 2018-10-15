import Vue from 'vue';
import VueRouter from 'vue-router';
import App from './App';
import Routers from './router.js';
import 'mdui/dist/css/mdui.css';

import MuseUI from 'muse-ui';
import 'muse-ui/dist/muse-ui.css';

Vue.use(MuseUI);

//解决循环引用组件报错
import MdList from "./component/md-list";
Vue.component('md-list', MdList);


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