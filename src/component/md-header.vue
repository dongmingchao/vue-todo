<template>
    <div class="background">
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
            <div class="mdui-card-menu top-menu-row">
                <a href="javascript:;"
                   style="position: absolute;left: 16px"
                   class="mdui-btn mdui-btn-icon" @click="$emit('openSide')">
                    <i class="mdui-icon material-icons">menu</i>
                </a>
                <a href="javascript:;"
                   style="position: absolute;right: 16px"
                   class="mdui-btn mdui-btn-icon" @click="openSettings">
                    <i class="mdui-icon material-icons">settings</i>
                </a>
            </div>
        </div>
        <div class="loading curtain" :class="{'curtain-show':loading}">
            <div class="mdui-spinner mdui-spinner-colorful" v-if="loading"></div>
        </div>
    </div>
</template>

<script>
    // import mdui from 'mdui/dist/js/mdui';

    export default {
        name: "md-header",
        props: ['title', 'loading'],
        data() {
            return {
            }
        },
        mounted() {
            // mdui.mutation();
        },
        methods: {
        	openSettings(){
		        this.$router.push('/settings/manager');
            },
            doAction(action) {
                console.log('do action', action);
                switch (action.want) {
                    case 'set-background-image': {
                    	this.st.screenDialog.title = '设置背景图片';
                    	this.st.screenDialog.beBind = {
		                    src: this.title.bgimg
	                    };
                        this.st.openFullscreenDialog('/settings/bg-image');
                        this.$nextTick(() => {
                            this.st.$refs.manager.$on('bgImageChange', src => {
                                console.log('bgImageChange', src);
                                this.title.bgimg = src;
                                this.$emit('settle', ['bgimg'], src);
                            })
                        });
                    }

                }
            }
        },
        watch: {
            title() {
                console.log('watch title', this.title);
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

    .top-menu-row {
        width: 100%;
        right: 0;
        margin-top: 20px;
    }
</style>