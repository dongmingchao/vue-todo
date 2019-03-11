import '@babel/polyfill';
import Vue from 'vue';
import VueRouter from 'vue-router';
import App from './App';
import Routers from './router.js';
import 'mdui/dist/css/mdui.css';
import './assets/iconfont/material-icons.css'
import 'animate.css/animate.min.css';
import MuseUI from 'muse-ui';
import 'muse-ui/dist/muse-ui.css';
import moment from 'moment';
import Vuex from 'vuex'
import Store from './store';

moment.locale('zh-CN');

Vue.use(MuseUI);

//解决循环引用组件报错
import MdList from "./component/md-list";
Vue.component('md-list', MdList);

Vue.use(VueRouter);
Vue.use(Vuex);

// The routing configuration
const RouterConfig = {
    routes: Routers
};
const router = new VueRouter(RouterConfig);
const store = new Vuex.Store(Store);

new Vue({
    el: '#app',
    router,
	store,
    render: h => h(App)
});