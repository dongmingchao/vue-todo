<template>
    <div style="height: 100%;">
        <md-sider v-bind:drawer.sync="drawer"
                  :list="sideList"
                  @changeCatalog="setCatalog"
                  @createCatalog="setNewCatalog"
                  @delete="deleteCatalog"
                  :loading="loading.side"/>
        <md-header :title="title" @openSide="collapsedSider" :loading="loading.header"/>
        <md-list class="main-list" ref="list"
                 :list="todoList"
                 @settle="saveTodoListChange"
                 @createTodo="setNewTodo"
                 @delete="deleteTodo"
                 @pushNotify="pushNotification"
                 :is-expand="true"
                 placeholder="添加新的待做事项"/>
    </div>
</template>
<script>

    import MdHeader from "./md-header";
    import MdSider from "./md-sider";
    import MdList from "./md-list";
    import io from '../lib/io';
    import moment from 'moment';
    import media from '../lib/media';

    export default {
        name: 'main-container',
        components: {MdList, MdSider, MdHeader},
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
                device: null
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
                console.log('save change', prop, value);
                let todo = this.todoList;
                let res = todo[prop[0]];
                for (let k = 1; k < prop.length; k++) {
                    if (typeof res[prop[k]] === 'undefined') {
                        res[prop[k]] = value;
                        break;
                    } else res = res[prop[k]];
                    console.log('in prop', res);
                }
                res = value;
                this.selectedCatalog.data.todoList = todo;
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
                this.selectedCatalog = {prop: item.prop, data: local.data};
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
                this.device.notification.post({
                    title: '计划任务',
                    text: '计划任务正在后台运行',
                    foreground: true,
                    ongoing: true
                });
                this.device.notification.post({
                    title: '计划任务',
                    text: '计划任务展示一个任务',
                    trigger: {in: 10, unit: 'second'}
                });
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
                console.log('push notification', target, this.selectedCatalog);
                this.device.notification.post({
                    id: this.selectedCatalog.prop + target.index + target.label,
                    title: target.label,
                    text: target.content,
                    trigger: {at: target.datetime}
                });
            }
        },
        mounted() {
            this.getSideList().then(li => {
                this.loading.side = false;
                this.sideList = li;
                this.setCatalog(li[1]);
            });
            document.addEventListener('deviceready', this.ready);
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