<template>
    <div>
        <md-header @openSide="collapsedSider"/>
        <md-sider v-bind:drawer.sync="drawer" :list="sideList"/>
        <md-list :list="todoList"/>
    </div>
</template>
<script>

    import MdHeader from "./md-header";
    import MdSider from "./md-sider";
    import MdList from "./md-list";

    export default {
        name: 'main-container',
        components: {MdList, MdSider, MdHeader},
        data() {
            return {
                drawer: null,
                sideList: [{
                    type:'title',
                    label:'普通分类'
                },{
                    icon: 'move_to_inbox',
                    label: '归档'
                },{
                    icon: 'star',
                    label: '收藏'
                },{
                    icon: 'email',
                    label: '日记'
                },{
                    icon: 'backup',
                    label: '云端'
                },{
                    type:'title',
                    label:'自定义列表'
                },{
                    icon:'book',
                    label:'草稿'
                },{
                    icon:'format_list_bulleted',
                    label:'自定义列表1'
                }],
                todoList:[{
                    label:'第一条',
                    prefix:'今日',
                    content:'哦吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼'
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
            }
        }
    }
</script>
<style scoped>

</style>