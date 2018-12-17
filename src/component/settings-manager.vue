<template>
    <mu-paper :z-depth="1" class="demo-list-wrap">
        <mu-list textline="two-line">
            <mu-sub-header inset>用户</mu-sub-header>
            <mu-list-item avatar>
                <mu-list-item-action>
                    <mu-badge circle :color="st.statusLED" badge-class="login-status">
                        <mu-avatar>
                            <img src="../assets/logo.png" alt="">
                        </mu-avatar>
                    </mu-badge>
                </mu-list-item-action>
                <mu-list-item-content>
                    <mu-list-item-title>{{user.name}}</mu-list-item-title>
                    <mu-list-item-sub-title>{{user.status}}</mu-list-item-sub-title>
                </mu-list-item-content>
                <mu-list-item-action>
                    <mu-button @click="openDialog(login)">
                        登陆
                    </mu-button>
                </mu-list-item-action>
            </mu-list-item>
            <mu-list-item avatar button>
                <mu-list-item-action>
                    <mu-avatar>
                        <mu-icon value="lock"></mu-icon>
                    </mu-avatar>
                </mu-list-item-action>
                <mu-list-item-content>
                    <mu-list-item-title>设置数据隐私保护</mu-list-item-title>
                </mu-list-item-content>
                <mu-list-item-action>
                    <mu-button icon>
                        <mu-icon value="info"></mu-icon>
                    </mu-button>
                </mu-list-item-action>
            </mu-list-item>
        </mu-list>
        <mu-divider inset></mu-divider>
        <mu-list textline="two-line">
            <mu-sub-header inset>管理</mu-sub-header>
            <mu-list-item avatar button>
                <mu-list-item-action>
                    <mu-avatar color="blue">
                        <mu-icon value="assignment"></mu-icon>
                    </mu-avatar>
                </mu-list-item-action>
                <mu-list-item-content>
                    <mu-list-item-title>标签库</mu-list-item-title>
                </mu-list-item-content>
                <mu-list-item-action>
                    <mu-button icon>
                        <mu-icon value="info"></mu-icon>
                    </mu-button>
                </mu-list-item-action>
            </mu-list-item>
            <mu-list-item avatar button>
                <mu-list-item-action>
                    <mu-avatar color="yellow600">
                        <mu-icon value="insert_chart"></mu-icon>
                    </mu-avatar>
                </mu-list-item-action>
                <mu-list-item-content>
                    <mu-list-item-title>关于</mu-list-item-title>
                </mu-list-item-content>
                <mu-list-item-action>
                    <mu-button icon>
                        <mu-icon value="info"></mu-icon>
                    </mu-button>
                </mu-list-item-action>
            </mu-list-item>
        </mu-list>
        <mu-dialog :open.sync="dialog" v-bind="dialog">
            <component :is="dialog.component" :host="_self" v-if="dialog"/>
        </mu-dialog>
    </mu-paper>
</template>

<script>
    import LoginDialog from "./login-dialog";

    export default {
        name: "settings-manager",
        components: {LoginDialog},
        props: ['st','beBind'],
        beforeMount() {
            this.user = this.st.user;
        },
        data() {
            return {
                dialog: null,
                login: {
                    'title': '使用网络同步',
                    width: "600",
                    'max-width': '80%',
                    'esc-press-close': false,
                    'overlay-close': false,
                    component: LoginDialog
                }
            }
        },
        methods: {
            openDialog(config) {
                this.dialog = config;
            },
            closeDialog() {
                this.dialog = null;
            }
        }
    }
</script>

<style>
    @media (max-width: 680px) {
        .demo-list-wrap {
            margin: 0;
        }
    }

    .demo-list-wrap {
        max-width: 680px;
        margin: 0 auto;
        overflow: hidden;
    }

    .login-status {
        height: 10px !important;
        width: 10px !important;
        margin: 43px 13px;
    }
</style>