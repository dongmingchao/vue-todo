<template>
    <div class="mdui-appbar background">
        <div class="mdui-card" style="height: 100%;">
            <div class="mdui-card-media" v-if="title">
                <img src="../assets/dusk.jpg" class="background"/>
                <div class="mdui-card-media-covered mdui-card-media-covered-transparent">
                    <div class="mdui-card-primary">
                        <div class="mdui-card-primary-title">{{title.title}}</div>
                        <div class="mdui-card-primary-subtitle">{{title.date}}</div>
                    </div>
                    <div class="mdui-card-actions actions">
                        <button class="mdui-btn mdui-ripple mdui-ripple-white" v-for="(ac,index) in title.actions"
                                :key="index">{{ac.name}}
                        </button>
                    </div>
                </div>
            </div>
            <div class="mdui-card-menu sidebarAct">
                <a href="javascript:;" class="mdui-btn mdui-btn-icon" @click="$emit('openSide')">
                    <i class="mdui-icon material-icons">menu</i>
                </a>
            </div>
        </div>
        <div class="loading curtain" :class="{'curtain-show':loading}">
            <div class="mdui-spinner mdui-spinner-colorful"></div>
        </div>
    </div>
</template>

<script>
    import mdui from 'mdui/dist/js/mdui';

    export default {
        name: "md-header",
        props: ['title', 'loading'],
        mounted() {
            mdui.mutation();
        }
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

    .sidebarAct {
        left: 16px;
    }

    .background {
        height: 10rem;
        position: relative;
    }

    .loading {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 100%;
        pointer-events: none;
    }

    .curtain-show {
        visibility: visible !important;
        opacity: 1 !important;
    }

    .curtain {
        position: absolute;
        top: 0;
        left: 0;
        z-index: 2000;
        visibility: hidden;
        background: rgba(0, 0, 0, .4);
        opacity: 0;
        -webkit-transition-duration: .3s;
        transition-duration: .3s;
        -webkit-transition-property: opacity, visibility;
        transition-property: opacity, visibility;
        -webkit-backface-visibility: hidden;
        backface-visibility: hidden;
        will-change: opacity;
    }
</style>