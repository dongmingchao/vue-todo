<template>
    <div style="height: 100%;">
        <md-sider v-bind:drawer.sync="drawer"
                  ref="drawer"
                  :list="sideList"
                  :st="$refs.settings"
                  @changeCatalog="setCatalog"
                  @createCatalog="setNewCatalog"
                  @event:focus="e => eKeyBoard(e,$refs.drawer)"
                  @delete="deleteCatalog"
                  :loading="loading.side"/>
        <md-header :title="title"
                   :st="$refs.settings"
                   @settle="saveHeaderChange"
                   @openSide="collapsedSider"
                   :loading="loading.header"/>
        <md-list class="main-list" ref="list"
                 :list="todoList"
                 @settle="saveTodoListChange"
                 @createTodo="setNewTodo"
                 @delete="deleteTodo"
                 @pushNotify="pushNotification"
                 @event:focus="e => eKeyBoard(e,$refs.list)"
                 :is-expand="true"
                 placeholder="添加新的待做事项"/>
        <main-setting ref="settings"/>
    </div>
</template>
<script>

    import MdHeader from "./md-header";
    import MdSider from "./md-sider";
    import MdList from "./md-list";
    import io from '../lib/io';
    import moment from 'moment';
    import media from '../lib/media';
    import MainSetting from "./main-setting";

    export default {
        name: 'main-container',
        components: {MainSetting, MdList, MdSider, MdHeader},
        data() {
            return {
                items: [1, 2, 3, 4, 5, 6, 7, 8, 9],
                loading: {
                    header: true,
                    side: true
                },
                title: null,
                todoList: null,
                selectedCatalog: null,
                drawer: null,
                sideList: null,
                device: null,
                mat: null
            };
        },
        computed: {
            rotateIcon() {
                return [
                    'menu-icon',
                    this.isCollapsed ? '' : 'rotate-icon'
                ];
            },
            menuitemClasses: function () {
                return [
                    'menu-item',
                    this.isCollapsed ? 'collapsed-menu' : ''
                ]
            },
            daemon(vm) {
                console.log('todo list', vm.todoList);
                if (!vm.todoList) return;
                this.selectedCatalog.data.todoList = vm.todoList;
                io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
            }
        },
        methods: {
            /**
             *
             * @param prop{Array} 可以定位改变位置的属性链keys
             * @param value
             */
            saveTodoListChange(prop, value) {
                // prop.unshift('todoList');
                // prop.unshift(this.selectedCatalog.prop);
                console.log('save change', 'todoList', prop, value);
                let todo = this.todoList;
                let res = todo[prop[0]];
                for (let k = 1; k < prop.length; k++) {
                    if (typeof res[prop[k]] === 'undefined') {
                        res[prop[k]] = {};
                    }
                    res = res[prop[k]];
                    console.log('in prop', res);
                }
                res = value;
                this.selectedCatalog.data.todoList = todo;
                io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
            },
            saveHeaderChange(prop, value) {
                console.log('save change', 'title', prop, value);
                let todo = this.title;
                let res = todo[prop[0]];
                for (let k = 1; k < prop.length; k++) {
                    if (typeof res[prop[k]] === 'undefined') {
                        res[prop[k]] = {};
                    }
                    res = res[prop[k]];
                    console.log('in prop', res);
                }
                res = value;
                this.selectedCatalog.data.title = todo;
                io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
            },
            collapsedSider() {
                console.log('click open side menu');
                this.drawer.toggle();
            },
            setNewTodo(str) {
                console.log('set new todo list event', str);
                this.todoList.push(str);
                this.selectedCatalog.data.todoList = this.todoList;
                io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
            },
            async setCatalog(item) {
                if (typeof item.prop === 'undefined') return;
                this.loading.header = true;
                let local = await io.fetchObj(item.prop);
                //第一次安装app的默认清单
                if (local === null) {
                    local = await io.fetch(item.path);
                    io.save(item.prop, local.data);
                }
                this.title = local.data.title;
                this.todoList = local.data.todoList;
                this.loading.header = false;
                this.selectedCatalog = {prop: item.prop, data: local.data, index: this.todoList.indexOf(item)};
            },
            deleteTodo(todo) {
                this.todoList.splice(this.todoList.indexOf(todo), 1);
                this.selectedCatalog.data.todoList = this.todoList;
                io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
            },
            async getSideList() {
                return await io.autofetch('side_list', './apis/sidelist.json');
            },
            setNewCatalog(item) {
                let local = {};
                let date = moment().format('MMMDo dddd');
                local = {
                    "title": {
                        "title": item.label,
                        "date": date,
                        "bgimg": "dist/flatland.jpg",
                        "actions": [
                            {
                                "name": "排序"
                            },
                            {
                                "name": "设置背景图"
                            }
                        ]
                    },
                    "todoList": []
                };
                io.save(item.prop, local);
                io.save('side_list', {body: this.sideList});
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
                io.remove(prop);
                this.setCatalog(this.sideList[1]);
                io.save('side_list', {body: this.sideList});
            },
            pushNotification(target) {
                let id = '' + this.selectedCatalog.index + target.index;
                if (this.device) {
                    this.device.notification.post({
                        id: parseInt(id),
                        title: target.label,
                        text: target.content,
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
            eKeyBoard(elm,body) {
                body = body.$el;
                console.log('capture focus', elm);
                if (this.device) this.device.onKeyboardShow = height => {
                    this.mat.style.height = height + 'px';
                    if (body.lastChild !== this.mat) body.appendChild(this.mat);
                    window.scrollTo(body.scrollWidth, body.scrollHeight);
                }
            }
        },
        mounted() {
            this.mat = document.createElement('div');
            this.mat.style.width = '100%';
            this.getSideList().then(li => {
                this.loading.side = false;
                this.sideList = li;
                this.setCatalog(li[1]);
            });
            document.addEventListener('deviceready', this.ready);
            window.addEventListener('native.keyboardshow', this.keyboardShow);
            window.addEventListener('native.keyboardhide', this.keyboardHide);
        }
    }
</script>
<style scoped>

    .flip-list-move {
        transition: transform 1s;
    }

    .main-list {
        height: calc(100% - 10rem);
    }

    @media (min-width: 1023px) {
        .main-list {
            width: calc(100% - 240px);
            position: absolute;
        }
    }
</style>