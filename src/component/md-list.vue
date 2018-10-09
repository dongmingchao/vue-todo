<template>
    <ul class="mdui-list">
        <template v-for="(item,index) in list">
            <li class="mdui-divider-inset mdui-m-y-0" v-if="index%2"></li>
            <li class="mdui-list-item mdui-ripple">
                <label class="mdui-radio">
                    <input type="radio" name="group1"/>
                    <i class="mdui-radio-icon"></i>
                </label>
                <div class="mdui-list-item-content" style="margin-left: 0">
                    <div class="mdui-list-item-title">{{item.label}}</div>
                    <div class="mdui-list-item-text mdui-list-item-one-line" v-if="item.content">
                        <span class="mdui-text-color-theme-text">{{item.prefix}}</span>
                        {{item.content}}
                    </div>
                </div>
                <a href="javascript:;" class="mdui-btn mdui-btn-icon">
                    <i class="mdui-icon material-icons">star_border</i>
                </a>
            </li>
        </template>
        <li class="mdui-divider-inset mdui-m-y-0" style="margin-left: 53px" v-if="list.length!==0"></li>
        <li class="mdui-list-item mdui-ripple">
            <label style="width: 36px;height: 36px;line-height: 36px;">
                <i class="mdui-icon material-icons">add</i>
            </label>
            <div class="mdui-list-item-content" style="margin-left: 0">
                <div class="mdui-list-item-title">添加新的待做事项</div>
            </div>
        </li>
    </ul>
</template>

<script>
    export default {
        name: "md-list",
        props: ['list']
    }
</script>

<style scoped>

</style>