<template>
    <div class="mdui-appbar">
        <div v-if="title" class="mdui-card">
            <div class="mdui-card-media">
                <img src="../assets/card.jpg" style="max-height: 200px"/>
                <div class="mdui-card-media-covered mdui-card-media-covered-transparent">
                    <div class="mdui-card-primary">
                        <div class="mdui-card-primary-title">{{title.title}}</div>
                        <div class="mdui-card-primary-subtitle">{{title.date}}</div>
                    </div>
                    <div class="mdui-card-actions actions">
                        <button class="mdui-btn mdui-ripple mdui-ripple-white" v-for="(ac,index) in title.actions" :key="index">{{ac.name}}</button>
                    </div>
                </div>
            </div>
            <div class="mdui-card-menu sidebarAct">
                <a href="javascript:;" class="mdui-btn mdui-btn-icon" @click="$emit('openSide')">
                    <i class="mdui-icon material-icons">menu</i>
                </a>
            </div>
        </div>
        <div v-else class="mdui-spinner mdui-spinner-colorful"></div>
    </div>
</template>

<script>

    export default {
        name: "md-header",
        props:['title']
    }
</script>

<style scoped>
    .actions {
        position: absolute;
        right: 0;
        bottom: 0;
    }

    .todo-title-background {
        width: 100%;
        height: 100%;
        background-color: #acd;
    }

    .header {
        height: 150px;
    }

    .header > .mdui-card > .mdui-card-media {
        height: 100%;
        width: 100%;
    }

    .header > .mdui-card {
        margin: 0;
        height: 100%;
        width: 100%;
    }

    .sidebarAct{
        left: 16px;
    }
</style>