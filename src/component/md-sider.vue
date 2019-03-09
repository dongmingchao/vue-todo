<template>
    <mu-drawer :open.sync="sider_open" :docked="docked">
        <mu-list style="margin-top: 20px" textline="two-line">
            <mu-list-item avatar>
                <mu-list-item-action>
                    <mu-avatar>
                        <img src="../assets/logo.png" alt="">
                    </mu-avatar>
                </mu-list-item-action>
                <mu-list-item-content>
                    <mu-list-item-title>{{user.name}}</mu-list-item-title>
                    <mu-list-item-sub-title>{{user.status}}</mu-list-item-sub-title>
                </mu-list-item-content>
                <mu-list-item-action>
                    <mu-badge :content="user.shortStatus" :color="user.statusLED"></mu-badge>
                    <mu-button icon @click="$emit('refresh')" v-show="user.shortStatus==='在线'">
                        <mu-icon value="refresh"></mu-icon>
                    </mu-button>
                </mu-list-item-action>
            </mu-list-item>
        </mu-list>
        <div class="loading curtain" :style="{opacity:loading?1:0}" style="transition: opacity 0.5s ease-in-out">
            <mu-linear-progress></mu-linear-progress>
        </div>
        <ul class="mdui-list" ref="list">
            <template v-for="(each,oi) in list">
                <li class="mdui-subheader">{{each.label}}</li>
                <template v-for="(item,ei) in each.children">
                    <li class="mdui-list-item mdui-ripple" v-if="item.type==='add'" @click="addCatalog">
                        <i class="mdui-list-item-icon mdui-icon material-icons">playlist_add</i>
                        <div class="mdui-list-item-content">添加清单</div>
                    </li>
                    <li class="mdui-list-item mdui-ripple" v-else-if="item.type==='manage'">
                        <i class="mdui-list-item-icon mdui-icon material-icons">playlist_add_check</i>
                        <div class="mdui-list-item-content">管理清单和标签</div>
                    </li>
                    <li class="mdui-list-item mdui-ripple" v-else
                        @contextmenu.prevent="longTap(oi,ei)"
                        data-header=""
                        @click="changeCatalog(item,[oi,ei])">
                        <i class="mdui-list-item-icon mdui-icon material-icons">{{item.icon}}</i>
                        <div class="mdui-list-item-content">
                            {{item.edit?null:item.label}}
                            <div class="mdui-textfield" style="padding: 0" v-show="item.edit">
                                <input class="mdui-textfield-input"
                                       @keydown.stop.enter="addCatalogFinish"
                                       @blur.stop="addCatalogFinish"
                                       ref="input"
                                       placeholder="标题"/>
                            </div>
                        </div>
                    </li>
                </template>
            </template>
        </ul>
        <mu-popover :open.sync="open" :trigger="trigger" placement="bottom-end">
            <mu-list>
                <!--<mu-list-item button>-->
                    <!--<mu-list-item-title>修改图标</mu-list-item-title>-->
                <!--</mu-list-item>-->
                <mu-list-item button @click="delete_catalog">
                    <mu-list-item-title>删除</mu-list-item-title>
                </mu-list-item>
                <mu-list-item button @click="open = false">
                    <mu-list-item-title>关闭</mu-list-item-title>
                </mu-list-item>
                <!--<mu-list-item button>-->
                    <!--<mu-list-item-title>标注颜色</mu-list-item-title>-->
                <!--</mu-list-item>-->
            </mu-list>
        </mu-popover>
    </mu-drawer>
</template>

<script>
    import localforge from 'localforage';
    import io from "../lib/io";
    import {mapState} from "vuex";

    export default {
        name: "md-sider",
        props: ['list', 'loading'],
        data() {
            return {
                menuopen: false,
                trigger: null,
                trigger_: {
                    index: 0,
                    parentIndex: 0
                },
                create: null,
                open: false,
                sider_open: null,
                docked: null
            }
        },
        computed: {
            ...mapState({
                user: 'user'
            })
        },
        watch: {
            // st(n) {
            // 	this.user = n.user;
            // 	this.user.color = n.statusLED;
            // }
        },
        mounted() {
            // let drawer = new mdui.Drawer('#drawer', {swipe: true});
            // this.$emit('update:drawer', drawer);
            this.toggleDrawer();
            window.addEventListener('resize', this.toggleDrawer);
        },
        methods: {
            toggleDrawer() {
                if (window.innerWidth > 1023) {
                    this.docked = true;
                    this.sider_open = true;
                } else {
                    this.docked = false;
                    this.sider_open = false;
                }
            },
            changeCatalog(item, locate) {
                if (window.innerWidth < 1024) this.sider_open = false;
                this.$emit('changeCatalog', item, locate);
            },
            longTap(parentIndex, index) {
                this.open = true;
                let ul = this.$refs.list;
                console.log('长按', ul, parentIndex, index);
                let sum = 0;
                for (let i = 0; i < parentIndex; i++) {
                    sum += this.list[i].children.length;
                }
                sum += parentIndex + index + 1;
                this.trigger = ul.children[sum];
                this.trigger_.index = index;
                this.trigger_.parentIndex = parentIndex;
            },
            addCatalog() {
                let defaultCatalog = this.list[1];
                this.create = {
                    body: {
                        icon: 'format_list_bulleted',
                        edit: true
                    }
                };
                console.log('default catalog', defaultCatalog);
                defaultCatalog.children.push(this.create.body);
                this.$set(this.list, 1, defaultCatalog);
                this.$nextTick(() => {
                    let input = this.$refs.input[this.$refs.input.length - 1];
                    setTimeout(() => input.scrollIntoView(), 300);
                    input.focus();
                    this.$emit('event:focus', input);
                });
            },
            addCatalogFinish(e) {
                let value = e.target.value;
                if (value === 'undefined') return;
                if (value === '') {
                    this.list[1].children.pop();
                    return;
                }
                delete this.create.body.edit;
                this.create.body.label = value;
                this.create.body.date = new Date().toJSON();
                this.create.body.prop = value + '|' + this.create.body.date;
                e.target.value = undefined;
                this.$forceUpdate();
                this.$emit('createCatalog', this.create.body);
            },
            delete_catalog() {
                let li = this.list[this.trigger_.parentIndex].children;
                let prop = li[this.trigger_.index].prop;
                li.splice(this.trigger_.index, 1);
                this.open = false;
                this.$emit('delete', prop);
            }
        }
    }
</script>

<style scoped>

</style>