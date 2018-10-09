<template>
    <div class="mdui-toolbar">
        <a href="javascript:;" class="mdui-btn mdui-btn-icon" @click="$emit('openSide')">
            <i class="mdui-icon material-icons">menu</i>
        </a>
        <span class="mdui-typo-title">标题</span>
        <div class="mdui-toolbar-spacer"></div>
        <a href="javascript:;" class="mdui-btn mdui-btn-icon"><i class="mdui-icon material-icons">search</i></a>
        <a href="javascript:;" class="mdui-btn mdui-btn-icon"><i class="mdui-icon material-icons">refresh</i></a>
        <a href="javascript:;" class="mdui-btn mdui-btn-icon"><i class="mdui-icon material-icons">more_vert</i></a>
    </div>
</template>

<script>

    export default {
        name: "md-header"
    }
</script>

<style scoped>

</style>