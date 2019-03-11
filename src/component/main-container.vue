<template>
    <div class="main-body">
        <md-sider ref="drawer"
                  :list="sideList"
                  :st="$refs.settings"
                  @changeCatalog="setCatalog"
                  @createCatalog="setNewCatalog"
                  @refresh="refreshCatalog"
                  @event:focus="e => eKeyBoard(e,$refs.drawer)"
                  @delete="deleteCatalog"
                  :loading="loading.side"/>
        <md-header @settle="saveHeaderChange"
                   @openSide="collapsedSider"/>
        <!--<md-list v-show="$route.path!=='/note'" class="main-list" ref="list"-->
        <!--:list="todoList"-->
        <!--placeholder="添加新的待做事项"/>-->
        <!--<keep-alive>-->
        <transition name="fade">
            <router-view @settle="saveTodoListChange"
                         @createTodo="setNewTodo"
                         @delete="deleteTodo"
                         @pushNotify="pushNotification"
                         @event:focus="e => eKeyBoard(e,$refs.list)"
                         ref="list"/>
        </transition>
        <!--</keep-alive>-->
        <mu-snackbar position="bottom-end" :color="toast.color" :open.sync="toast.open">
            {{toast.message}}
            <mu-button flat slot="action" color="#fff" @click="toast.open = false">关闭</mu-button>
        </mu-snackbar>
    </div>
</template>
<script>

    import MdHeader from "./main-header";
    import MdSider from "./md-sider";
    import {io, Sync} from '../lib/io/index';
    import localconfig from '@/lib/config/local';
    import moment from 'moment';
    import media from '../lib/media';
    import MainSetting from "./main-setting";
    import flatland from '../assets/flatland.jpg';
    import init from '../lib/init';
    import {mapState} from 'vuex';
    import MainList from "@/component/main-list";

    export default {
        name: 'main-container',
        components: {MainList, MainSetting, MdSider, MdHeader},
        data() {
            return {
                items: [1, 2, 3, 4, 5, 6, 7, 8, 9],
                loading: {
                    side: true
                },
                selectedCatalog: null,
                drawer: null,
                device: null,
                mat: null,
                toast: {
                    open: false,
                    color: 'secondary',
                    message: ''
                },
                sync: null
            };
        },
        computed: {
            ...mapState({
                todoList: state => state.selected.catalog.data.todoList,
                sideList: state => state.selected.side_list
            })
        },
        methods: {
            postToast(opts) {
                this.toast = Object.assign(this.toast, opts);
                this.toast.open = true;
                setTimeout(() => {
                    this.toast.open = false;
                }, 3000);
            },
            /**
             *
             * @param prop{Array} 可以定位改变位置的属性链keys
             * @param value
             */
            async saveRing(prop, value) {
                let storgae = await io.fetchObj(prop[0]);
                if (storgae === null) return;
                let res = storgae.data;
                let key = prop[1];
                for (let k = 1; k < prop.length - 1; k++) {
                    if (typeof res[key] === 'undefined') {
                        res[key] = {};
                    }
                    res = res[key];
                    key = prop[k + 1];
                }
                res[key] = value;
                console.log('save ring', res, key, value);
                io.save(prop[0], storgae.data);
            },

            saveTodoListChange(prop, value) {
                prop.unshift('todoList');
                prop.unshift(this.selectedCatalog.prop);
                console.log('save change', 'todoList', prop, value);
                this.saveRing(prop, value);
            },
            saveHeaderChange(prop, value) {
                prop.unshift('title');
                prop.unshift(this.selectedCatalog.prop);
                console.log('save change', 'title', prop, value);
                this.saveRing(prop, value);
            },
            setNewTodo(ntd) {
                console.log('set new todo list event', ntd.index);
                this.$store.dispatch('addTodoItem', ntd);
            },
            refreshCatalog() {
                this.sync.catalogs.list();
                this.$store.dispatch('releaseWaiters');
            },
            async setCatalog(item, locate) {
                if (typeof item.prop === 'undefined') return;
                let local = await io.fetchObj(item.prop);
                //第一次安装app的默认清单
                if (local === null) {
                    if (item.path instanceof Object)
                        local = {data: item.path};
                    else local = await io.fetch(item.path);
                    io.save(item.prop, local.data);
                }
                // this.title = local.data.title;
                // this.$store.commit('selectedCatalogTitle', local.data.title);
                let list = local.data.todoList;
                if (list === null) {
                    list = await this.sync.tasks.list(item.prop);
                    this.saveRing([item.prop, 'todoList'], list);
                    local.data.todoList = list;
                }
                let [x, y] = locate;
                let index = 0;
                for (let i = 0; i < x; i++) {
                    index += this.sideList[i].children.length;
                }
                index += y;
                this.selectedCatalog = {prop: item.prop, data: local.data, index: index};
                this.$store.commit('selectCatalog', this.selectedCatalog);
            },
            deleteTodo(todo) {
                this.todoList.splice(this.todoList.indexOf(todo), 1);
                this.sync.tasks.remove(todo);
                this.selectedCatalog.data.todoList = this.todoList;
                io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
            },
            // async getSideList() {
            // 	return await io.autofetch('side_list', './apis/sidelist.json');
            // },
            setNewCatalog(item) {
                let local = {};
                let date = moment(item.date).format('MMMDo dddd');
                local = {
                    "title": {
                        "title": item.label,
                        "date": date,
                        "datetime": item.date,
                        "bgimg": flatland,
                        "actions": [
                            // {
                            // 	"name": "排序"
                            // },
                            {
                                "name": "设置背景图"
                            }
                        ]
                    },
                    "todoList": []
                };
                io.save(item.prop, local);
                io.save(localconfig.dbname.side_list, {body: this.sideList});
                this.sync.catalogs.add(item);
            },
            ready(e) {
                console.log('Vue中 设备已就绪', e);
                this.device = new media(window);
                console.log('can be set', this.device.notification.defaultSet());
                console.log('是否是安卓环境运行？', window.cordova);
                console.log('window', window);
            },
            deleteCatalog(prop) {
                console.log('delete catalog', prop);
                this.sync.catalogs.remove(prop);
                io.remove(prop);
                this.setCatalog(this.sideList[0].children[0], [0, 0]);
                io.save(localconfig.dbname.side_list, {body: this.sideList});
            },
            pushNotification(target) {
                console.log('post notify', target);
                let id = this.selectedCatalog.index;
                if (this.device) {
                    this.device.notification.post({
                        id: id,
                        title: target.label,
                        text: target.content ? target.content : target.note,
                        trigger: {at: target.datetime}
                    });
                }
            },
            keyboardShow(e) {
                console.log('Keyboard height is: ', e.keyboardHeight);
                this.device.onKeyboardShow(e.keyboardHeight);
            },
            keyboardHide(e) {
                this.mat.style.height = '0';
            },
            eKeyBoard(elm, body) {
                body = body.$el;
                console.log('capture focus', elm);
                if (this.device) this.device.onKeyboardShow = height => {
                    this.mat.style.height = height + 'px';
                    if (body.lastChild !== this.mat) body.appendChild(this.mat);
                    window.scrollTo(body.scrollWidth, body.scrollHeight);
                }
            },
            collapsedSider() {
                console.log('click open side menu');
                let now = this.$refs.drawer.sider_open;
                let isPad = window.innerWidth > 1023;
                this.$refs.drawer.sider_open = !now;
                if (isPad) {
                    if (now) {
                        this.$el.style.paddingLeft = '0';
                        this.$refs.list.$el.style.width = '100%';
                    } else {
                        this.$el.style.paddingLeft = '256px';
                        this.$refs.list.$el.style.width = 'calc(100% - 256px)';
                    }
                }
            }
        },
        mounted() {
            this.$store.commit('setSync', this);
            this.sync = new Sync(this);
            this.mat = document.createElement('div');
            this.mat.style.width = '100%';
            io.fetchObj(localconfig.dbname.side_list).then(ret => {
                let li;
                if (ret === null)
                    li = JSON.parse(JSON.stringify(init.body));
                else li = ret.data.body;
                this.loading.side = false;
                this.$store.commit('setSideList', li);
                this.setCatalog(li[0].children[0], [0, 0]);
                io.save(localconfig.dbname.side_list, {body: li});
            });
            document.addEventListener('deviceready', this.ready);
            window.addEventListener('native.keyboardshow', this.keyboardShow);
            window.addEventListener('native.keyboardhide', this.keyboardHide);
        }
    }
</script>
<style scoped>

    .main-body {
        /*width: calc(100% - 256px);*/
        /*left: 256px;*/
        height: 100%;
        position: absolute;
        transition: padding-left .45s cubic-bezier(.23, 1, .32, 1);
        padding-left: 256px;
    }

    @media (max-width: 1023px) {
        .main-body {
            padding-left: 0;
        }
    }

    .fade-enter-active {
        transition: opacity .3s ease;
    }
    .fade-leave-active {
        transition: opacity .15s ease;
    }
    .fade-enter, .fade-leave-to{
        pointer-events: none;
        opacity: 0;
    }
</style>