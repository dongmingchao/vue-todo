<template>
    <mu-paper>
        <mu-list textline="two-line">
            <mu-sub-header inset>用户</mu-sub-header>
            <mu-list-item avatar>
                <mu-list-item-action>
                    <mu-badge circle :color="user.statusLED" badge-class="login-status">
                        <mu-avatar>
                            <img src="@/assets/logo.png" alt="">
                        </mu-avatar>
                    </mu-badge>
                </mu-list-item-action>
                <mu-list-item-content>
                    <mu-list-item-title>{{user.name}}</mu-list-item-title>
                    <mu-list-item-sub-title>{{user.status}}</mu-list-item-sub-title>
                </mu-list-item-content>
                <mu-list-item-action>
                    <mu-button v-if="user.shortStatus === '在线'">
                        注销
                    </mu-button>
                    <mu-button v-else @click="openDialog(login)">
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
            <mu-list-item avatar button @click="openPaper">
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
            <mu-list-item avatar button @click="$router.push('/settings/test')">
                <mu-list-item-action>
                    <mu-avatar color="blue">
                        <mu-icon value="assignment"></mu-icon>
                    </mu-avatar>
                </mu-list-item-action>
                <mu-list-item-content>
                    <mu-list-item-title>测试</mu-list-item-title>
                </mu-list-item-content>
                <mu-list-item-action>
                    <mu-button icon>
                        <mu-icon value="info"></mu-icon>
                    </mu-button>
                </mu-list-item-action>
            </mu-list-item>
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
        <mu-snackbar position="bottom-end" :color="toast.color" :open.sync="toast.open">
            {{toast.message}}
            <mu-button flat slot="action" color="#fff" @click="toast.open = false">关闭</mu-button>
        </mu-snackbar>
    </mu-paper>
</template>

<script>
	import LoginDialog from "./login-dialog";
	import {mapState} from "vuex";

	export default {
		name: "settings-manager",
		components: {LoginDialog},
		props: ['st', 'beBind'],
		computed: {
			...mapState({
				user: 'user'
			})
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
				},
				toast: {
					open: false,
					color: 'secondary',
					message: ''
				}
			}
		},
		methods: {
			openPaper(config) {
				this.st.openFullscreenDialog('/settings/tags');
			},
			postToast(opts) {
				this.toast = Object.assign(this.toast, opts);
				this.toast.open = true;
				setTimeout(() => {
					this.toast.open = false;
				}, 3000);
			},
			openDialog(config) {
				this.dialog = config;
			},
			closeDialog() {
				this.dialog = null;
			}
		},
		mounted() {
			this.$emit('setEnv', {title: '设置'});
		},
		beforeRouteLeave(to, from, next) {
			console.log('before route leave', to, this.$route);
			if (to.path === '/')
				this.st.closeFullscreenDialog();
			// 导航离开该组件的对应路由时调用
			// 可以访问组件实例 `this`
			next();
		}
	}
</script>

<style>
    .login-status {
        height: 10px !important;
        width: 10px !important;
        margin: 43px 13px;
    }
</style>