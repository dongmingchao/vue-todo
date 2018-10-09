<template>
    <div class="mdui-drawer mdui-drawer-full-height" id="drawer">
        <ul class="mdui-list">
            <template v-for="(item,index) in list">
                <li class="mdui-subheader" v-if="item.type==='title'">{{item.label}}</li>
                <li class="mdui-list-item mdui-ripple" v-else>
                    <i class="mdui-list-item-icon mdui-icon material-icons">{{item.icon}}</i>
                    <div class="mdui-list-item-content">{{item.label}}</div>
                </li>
            </template>
        </ul>
    </div>
</template>

<script>
    import mdui from 'mdui/dist/js/mdui';

    export default {
        name: "md-sider",
        props:['drawer','list'],
        data(){
            return {

            }
        },
        mounted() {
            let drawer = new mdui.Drawer('#drawer',{swipe: true});
            this.$emit('update:drawer', drawer);
        }
    }
</script>

<style scoped>

</style>