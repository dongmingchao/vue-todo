<template>
    <li class="mdui-divider-inset mdui-m-y-0" style="margin-left: 53px" v-if="type==='separate'"></li>
    <li class="mdui-list-item" style="width: 100%" v-else>
        <label class="mdui-radio">
            <input type="radio" name="group1" @change="check"/>
            <i class="mdui-radio-icon"></i>
        </label>
        <div class="mdui-list-item-content mdui-ripple" @click="clickBody">
            <div class="mdui-list-item-title" style="text-overflow: ellipsis;overflow: hidden">{{item.label}}</div>
            <div class="mdui-list-item-text mdui-list-item-one-line" style="display: block;"
                 v-if="item.content||item.prefix">
                <span class="mdui-text-color-theme-text" v-if="item.prefix">{{item.prefix}}</span>
                {{item.content?item.content:null}}
            </div>
        </div>
        <slot name="right"/>
    </li>
</template>

<script>
    export default {
        name: "md-line",
        props: ['item', 'type'],
        methods: {
            clickBody(e) {
                console.log('click todo line body', e);
                this.$emit('click', e);
            },
            check(e) {
                console.log('you check a todo', e);
                this.$emit('check', e);
            }
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
</style>