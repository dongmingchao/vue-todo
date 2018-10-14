<template>
    <li class="mdui-divider-inset mdui-m-y-0" style="margin-left: 53px" v-if="type==='separate'"></li>
    <li class="mdui-collapse-item" v-else>
        <div class="mdui-collapse-item-header mdui-list-item mdui-ripple" style="width: 100%">
            <label class="mdui-checkbox">
                <input type="checkbox" @change="check"/>
                <i class="mdui-checkbox-icon"></i>
            </label>
            <div class="mdui-list-item-content" @click="clickBody">
                <div class="mdui-list-item-title" style="text-overflow: ellipsis;overflow: hidden">{{item.label}}</div>
                <div class="mdui-list-item-text mdui-list-item-one-line" style="display: block;"
                     v-if="item.content||item.prefix">
                    <span class="mdui-text-color-theme-text" v-if="item.prefix">{{item.prefix}}</span>
                    {{item.content?item.content:null}}
                </div>
            </div>
            <slot name="right"/>
        </div>
        <div class="mdui-collapse-item-body">
            <div v-if="expand">
                <md-list :list="item.steps"
                         :is-expand="false"
                         placeholder="添加新的步骤"
                         @createTodo="setNewTodo"/>
                <div class="mdui-list-item detail-setting">
                    <div class="mdui-textfield mdui-textfield-floating-label">
                        <label class="mdui-textfield-label">设定闹钟</label>
                        <input class="mdui-textfield-input"/>
                    </div>
                    <!--<div style="display: inline-block">-->
                    <div class="mdui-textfield mdui-textfield-floating-label">
                        <label class="mdui-textfield-label">添加相关时间</label>
                        <input class="mdui-textfield-input"/>
                    </div>
                    <!--</div>-->
                    <!--<div style="display: inline-block">-->
                    <div class="mdui-textfield mdui-textfield-floating-label">
                        <label class="mdui-textfield-label">设置重复</label>
                        <input class="mdui-textfield-input"/>
                    </div>
                </div>
                <!--</div>-->
                <div class="mdui-list-item">
                    <div class="mdui-textfield mdui-textfield-floating-label">
                        <label class="mdui-textfield-label">添加笔记</label>
                        <textarea class="mdui-textfield-input"></textarea>
                    </div>
                </div>
            </div>
        </div>
    </li>
</template>

<script>
    import mdui from 'mdui/dist/js/mdui';

    export default {
        name: "md-line",
        components: {},
        props: ['item', 'type', 'expand'],
        data() {
            return {}
        },
        methods: {
            clickBody(e) {
                console.log('click todo line body', e);
                this.$emit('click', e);
            },
            check(e) {
                console.log('you check a todo', e);
                this.$emit('check', e);
            },
            setNewTodo(str) {
                let item = this.item;
                console.log('set new todo list event', str);
                if (typeof item.steps === 'undefined') {
                    item.steps = [];
                    this.$emit('update:item', item);
                }
                item.steps.push({
                    label: str,
                    favorite: false
                })
            }
        },
        mounted() {

        }
    }
</script>

<style scoped>
    .item-header {
        padding: 0;
    }

    .item-header-center {
        margin-left: 0;
        width: 0;
    }

    .detail-setting > div {
        display: inline-block;
    }
</style>