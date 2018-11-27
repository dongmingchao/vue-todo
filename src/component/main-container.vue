<template>
    <div style="height: 100%;">
        <md-sider v-bind:drawer.sync="drawer" :list="sideList" @changeCatalog="setCatalog"/>
        <md-header :title="title" @openSide="collapsedSider" :loading="loading.header"/>
        <md-list class="main-list" ref="list"
                 :list="todoList"
                 @settle="saveTodoListChange"
                 @createTodo="setNewTodo"
                 :is-expand="true"
                 placeholder="添加新的待做事项"/>
    </div>
</template>
<script>

    import MdHeader from "./md-header";
    import MdSider from "./md-sider";
    import MdList from "./md-list";
    import io from '../lib/io';

    export default {
        name: 'main-container',
        components: {MdList, MdSider, MdHeader},
        data() {
            return {
                items: [1,2,3,4,5,6,7,8,9],
                loading: {
                    header: true
                },
                title: null,
                todoList: null,
                selectedCatalog: null,
                drawer: null,
                sideList: [{
                    type: 'title',
                    label: '普通分类'
                }, {
                    icon: 'move_to_inbox',
                    label: '归档',
                    path: './apis/document.json',
                    prop: 'document'
                }, {
                    icon: 'star',
                    label: '收藏',
                    path: './apis/marked.json',
                    prop: 'marked'
                }, {
                    icon: 'email',
                    label: '日记',
                    path: './apis/diary.json',
                    prop: 'diary'
                }, {
                    icon: 'backup',
                    label: '云端',
                    path: './apis/cloud.json',
                    prop: 'cloud'
                }, {
                    type: 'title',
                    label: '自定义列表'
                }, {
                    icon: 'book',
                    label: '草稿',
                    path: './apis/draft.json',
                    prop: 'draft'
                }, {
                    icon: 'format_list_bulleted',
                    label: '自定义列表1'
                }, {
                    icon: 'format_list_bulleted',
                    label: '自定义列表1'
                }, {
                    icon: 'format_list_bulleted',
                    label: '自定义列表1'
                }, {
                    icon: 'format_list_bulleted',
                    label: '自定义列表1'
                }, {
                    icon: 'format_list_bulleted',
                    label: '自定义列表1'
                }, {
                    icon: 'format_list_bulleted',
                    label: '自定义列表1'
                }, {
                    icon: 'format_list_bulleted',
                    label: '自定义列表1'
                }, {
                    icon: 'format_list_bulleted',
                    label: '自定义列表1'
                }, {
                    icon: 'format_list_bulleted',
                    label: '自定义列表1'
                }]
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
                let res;
                for (let key of prop) {
                    res = todo[key];
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
                this.todoList.push({
                    label: str,
                    favorite: false
                });
                this.selectedCatalog.data.todoList = this.todoList;
                io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
            },
            async setCatalog(item) {
                this.loading.header = true;
                let local = await io.fetchObj(item.prop);
                if (local === null) {
                    local = await io.fetch(item.path);
                    console.log('request new value', local);
                    if (typeof item.prop !== 'undefined') io.save(item.prop, local.data);
                }
                this.title = local.data.title;
                this.todoList = local.data.todoList;
                this.loading.header = false;
                this.selectedCatalog = {prop: item.prop, data: local.data};
                // this.$refs.list.catalogChange(local.data.todoList);
            },
            shuffle() {
                let e = this.items.shift();
                this.items.push(e);
            }
        },
        mounted() {
            this.setCatalog(this.sideList[1]);
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