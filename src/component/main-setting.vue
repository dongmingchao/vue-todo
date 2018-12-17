<template>
    <mu-dialog width="360" transition="slide-bottom" fullscreen :open.sync="openFullscreen">
        <div style="background-color:#2196f3;width: 100%;height: 20px;"></div>
        <mu-appbar
                style="box-shadow: 0 2px 4px -1px rgba(0,0,0,.2), 0 4px 5px 0 rgba(0,0,0,.14), 0 0 0 0 rgba(0,0,0,.12);"
                color="primary" :title="screenDialog.title">
            <mu-button slot="left" icon @click="closeFullscreenDialog">
                <mu-icon value="close"></mu-icon>
            </mu-button>
            <mu-button slot="right" icon @click="closeFullscreenDialog">
                <mu-icon value="check"></mu-icon>
            </mu-button>
        </mu-appbar>
        <component :is="screenDialog.component"
                   :st="_self"
                   :beBind="screenDialog.beBind" ref="manager"/>
    </mu-dialog>
</template>

<script>
    import BgImageManager from "./bg-image-manager";
    import SettingsManager from "./settings-manager";

    export default {
        name: "main-setting",
        components: {SettingsManager, BgImageManager},
        data() {
            return {
                user: {
                    name: '本地用户',
                    shortStatus: '离线',
                    status: '使用本地数据'
                },
                openFullscreen: false,
                screenDialog: {}
            }
        },
        methods:{
            openFullscreenDialog(config) {
                this.openFullscreen = true;
                this.screenDialog = config;
            },
            closeFullscreenDialog() {
                this.openFullscreen = false;
                this.screenDialog = {};
            }
        },
        computed:{
            statusLED(vm){
                let color = null;
                switch (vm.user.shortStatus) {
                    case '离线':{
                        color = null;
                        break;
                    }
                    case '在线':{
                        color = 'primary';
                        break;
                    }
                    case '同步中':{
                        color = 'success';
                        break;
                    }
                    case '错误':{
                        color = 'error';
                    }
                }
                return color;
            }
        }
    }
</script>

<style scoped>

</style>