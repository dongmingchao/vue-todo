<template>
    <div class="mdui-appbar background">
        <div class="mdui-card" style="height: 100%;color: #fff">
            <div class="mdui-card-media" v-if="title">
                <img :src="title.bgimg" class="background"/>
                <div class="mdui-card-media-covered mdui-card-media-covered-transparent">
                    <div class="mdui-card-primary">
                        <div class="mdui-card-primary-title">{{title.title}}</div>
                        <div class="mdui-card-primary-subtitle">{{title.date}}</div>
                    </div>
                    <div class="mdui-card-actions actions">
                        <button class="mdui-btn mdui-ripple mdui-ripple-white" v-for="(ac,index) in title.actions"
                                :key="index" @click="doAction(ac)">{{ac.name}}
                        </button>
                        <a href="javascript:;" class="mdui-btn mdui-btn-icon">
                            <i class="mdui-icon material-icons">more_horiz</i>
                        </a>
                    </div>
                </div>
            </div>
            <div class="mdui-card-menu sidebarAct">
                <a href="javascript:;" class="mdui-btn mdui-btn-icon" @click="$emit('openSide')">
                    <i class="mdui-icon material-icons">menu</i>
                </a>
            </div>
            <div class="mdui-card-menu">
                <a href="javascript:;" class="mdui-btn mdui-btn-icon" @click="openFullscreenDialog(settings)">
                    <i class="mdui-icon material-icons">settings</i>
                </a>
            </div>
        </div>
        <div class="loading curtain" :class="{'curtain-show':loading}">
            <div class="mdui-spinner mdui-spinner-colorful"></div>
        </div>
        <mu-dialog width="360" transition="slide-bottom" fullscreen :open.sync="openFullscreen">
            <mu-appbar color="primary" :title="screenDialog.title">
                <mu-button slot="left" icon @click="closeFullscreenDialog">
                    <mu-icon value="close"></mu-icon>
                </mu-button>
                <mu-button slot="right" icon @click="closeFullscreenDialog">
                    <mu-icon value="check"></mu-icon>
                </mu-button>
            </mu-appbar>
            <component :is="screenDialog.component" v-bind="screenDialog.beBind" ref="manager"/>
        </mu-dialog>
    </div>
</template>

<script>
    import mdui from 'mdui/dist/js/mdui';
    import BgImageManager from "./bg-image-manager";
    import SettingsManager from "./settings-manager";

    export default {
        name: "md-header",
        components: {SettingsManager, BgImageManager},
        props: ['title', 'loading'],
        data() {
            return {
                openFullscreen: false,
                screenDialog: {},
                settings: {
                    title: '设置',
                    component: SettingsManager
                }
            }
        },
        mounted() {
            mdui.mutation();
        },
        methods: {
            openFullscreenDialog(config) {
                this.openFullscreen = true;
                this.screenDialog = config;
            },
            closeFullscreenDialog() {
                this.openFullscreen = false;
                this.screenDialog = {};
            },
            doAction(action) {
                console.log('do action', action);
                switch (action.want) {
                    case 'set-background-image': {
                        this.openFullscreenDialog({
                            title: '设置背景图片',
                            beBind: {
                                src:this.title.bgimg
                            },
                            component: BgImageManager
                        });
                        this.$nextTick(() => {
                            this.$refs.manager.$on('bgImageChange',src => {
                                console.log('bgImageChange',src);
                                this.title.bgimg = src;
                                this.$emit('settle', ['bgimg'], src);
                            })
                        });
                    }

                }
            }
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