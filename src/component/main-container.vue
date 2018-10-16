<template>
    <div style="height: 100%;">
        <md-sider v-bind:drawer.sync="drawer" :list="sideList" @changeCatalog="setCatalog"/>
        <md-header :title="title" @openSide="collapsedSider" :loading="loading.header"/>
        <md-list class="main-list" :list="todoList" @createTodo="setNewTodo" :is-expand="true" placeholder="添加新的待做事项"/>
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
                loading: {
                    header: true
                },
                title: null,
                todoList: null,
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
            }
        },
        methods: {
            collapsedSider() {
                console.log('click open side menu');
                this.drawer.toggle();
            },
            setNewTodo(str) {
                console.log('set new todo list event', str);
                this.todoList.push({
                    label: str,
                    favorite: false
                })
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
            }
        },
        mounted() {
            // this.setCatalog('/apis/draft.json');
        }
    }
</script>
<style scoped>
    .main-list {
        height: calc(100% - 10rem);
        position: absolute;
    }

    @media (min-width: 1023px) {
        .main-list {
            width: calc(100% - 240px);
        }
    }
</style>