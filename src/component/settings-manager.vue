<template>
    <mu-paper :z-depth="1" class="demo-list-wrap">
        <mu-list textline="two-line">
            <mu-sub-header inset>用户</mu-sub-header>
            <mu-list-item avatar>
                <mu-list-item-action>
                    <mu-badge circle color="error" badge-class="login-status">
                        <mu-avatar>
                            <img src="../assets/logo.png" alt="">
                        </mu-avatar>
                    </mu-badge>
                </mu-list-item-action>
                <mu-list-item-content>
                    <mu-list-item-title>用户名</mu-list-item-title>
                    <mu-list-item-sub-title>使用本地数据</mu-list-item-sub-title>
                </mu-list-item-content>
                <mu-list-item-action>
                    <mu-button>
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
    </mu-paper>
</template>

<script>
    export default {
        name: "settings-manager"
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

    .login-status{
        height: 10px !important;
        width: 10px !important;
        margin: 43px 13px;
    }
</style>