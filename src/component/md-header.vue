<template>
    <div class="mdui-appbar background">
        <div v-if="title" class="mdui-card">
            <div class="mdui-card-media">
                <img src="../assets/card.jpg" class="background"/>
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
        <div class="loading mdui-overlay mdui-overlay-show" v-show="loading">
            <div class="mdui-spinner mdui-spinner-colorful"></div>
        </div>
    </div>
</template>

<script>
    import mdui from 'mdui/dist/js/mdui';

    export default {
        name: "md-header",
        props: ['title','loading'],
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
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
    }
</style>