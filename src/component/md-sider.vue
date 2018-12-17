<template>
    <div class="mdui-drawer mdui-drawer-full-height" id="drawer">
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
                    <mu-badge :content="user.shortStatus" :color="user.color"></mu-badge>
                    <mu-button icon>
                        <mu-icon value="refresh"></mu-icon>
                    </mu-button>
                </mu-list-item-action>
            </mu-list-item>
        </mu-list>
        <div class="loading curtain" :style="{opacity:loading?1:0}" style="transition: opacity 0.5s ease-in-out">
            <mu-linear-progress></mu-linear-progress>
        </div>
        <ul class="mdui-list" ref="list">
            <template v-for="(item,index) in list">
                <li class="mdui-subheader" v-if="item.type==='title'">{{item.label}}</li>
                <li class="mdui-list-item mdui-ripple" v-else-if="item.type==='add'" @click="addCatalog">
                    <i class="mdui-list-item-icon mdui-icon material-icons">playlist_add</i>
                    <div class="mdui-list-item-content">添加清单</div>
                </li>
                <li class="mdui-list-item mdui-ripple" v-else-if="item.type==='manage'">
                    <i class="mdui-list-item-icon mdui-icon material-icons">playlist_add_check</i>
                    <div class="mdui-list-item-content">管理清单和标签</div>
                </li>
                <li class="mdui-list-item mdui-ripple" v-else
                    @contextmenu.prevent="longTap(index)"
                    @click="changeCatalog(item)">
                    <i class="mdui-list-item-icon mdui-icon material-icons">{{item.icon}}</i>
                    <div class="mdui-list-item-content">
                        {{item.edit?null:item.label}}
                        <div class="mdui-textfield" style="padding: 0" v-show="item.edit">
                            <input class="mdui-textfield-input" @keydown.enter="addCatalogFinish"
                                   @blur="addCatalogFinish"
                                   ref="input"
                                   placeholder="标题"/>
                        </div>
                    </div>
                </li>
            </template>
        </ul>
        <mu-popover :open.sync="open" :trigger="trigger" placement="bottom-end">
            <mu-list>
                <mu-list-item button>
                    <mu-list-item-title>修改图标</mu-list-item-title>
                </mu-list-item>
                <mu-list-item button @click="delete_catalog">
                    <mu-list-item-title>删除</mu-list-item-title>
                </mu-list-item>
                <mu-list-item button>
                    <mu-list-item-title>标注颜色</mu-list-item-title>
                </mu-list-item>
            </mu-list>
        </mu-popover>
    </div>
</template>

<script>
    import mdui from 'mdui/dist/js/mdui';
    import localforge from 'localforage';
    import io from "../lib/io";

    export default {
        name: "md-sider",
        props: ['drawer', 'list', 'loading', 'st'],
        data() {
            return {
                user: {},
                menuopen: false,
                trigger: null,
                triggerIndex: 0,
                create: null
            }
        },
        watch: {
            st(n){
                this.user = n.user;
                this.user.color = n.statusLED;
            }
        },
        mounted() {
            let drawer = new mdui.Drawer('#drawer', {swipe: true});
            this.$emit('update:drawer', drawer);
        },
        methods: {
            changeCatalog(item) {
                if (window.innerWidth < 1024) this.drawer.close();
                this.$emit('changeCatalog', item);
            },
            longTap(e) {
                this.open = true;
                let ul = this.$refs.list;
                console.log('长按', ul);
                this.trigger = ul.children[e];
                this.triggerIndex = e;
            },
            addCatalog() {
                let len = this.list.length;
                this.create = {
                    index: len - 3,
                    body: {
                        icon: 'format_list_bulleted',
                        edit: true
                    }
                };
                for (let i = 0; i < 3; i++) {
                    this.list[len - i] = this.list[len - i - 1];
                }
                this.$set(this.list, len - 3, this.create.body);
                this.$nextTick(() => {
                    let input = this.$refs.input[this.$refs.input.length - 1];
                    setTimeout(() => input.scrollIntoView(), 300);
                    input.focus();
                    this.$emit('event:focus',input);
                });
            },
            addCatalogFinish(e) {
                let value = e.target.value;
                if (value !== '') {
                    delete this.create.body.edit;
                    this.create.body.label = value;
                    this.create.body.prop = value;
                    this.$forceUpdate();
                    this.$emit('createCatalog', this.create.body);
                } else this.list.splice(this.create.index, 1);
            },
            delete_catalog() {
                let prop = '';
                prop += this.list[this.triggerIndex].prop;
                this.list.splice(this.triggerIndex, 1);
                this.open = false;
                this.$emit('delete', prop);
            }
        }
    }
</script>

<style scoped>

</style>