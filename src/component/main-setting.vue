<template>
    <div style="position:absolute;height: 100%;width: 100%">
        <div style="background-color:#2196f3;width: 100%;height: 20px;"></div>
        <mu-appbar class="header-bar"
                   color="primary" :title="screenDialog.title">
            <mu-button slot="left" icon @click="closeFullscreenDialog">
                <mu-icon value="close"></mu-icon>
            </mu-button>
            <mu-button slot="right" icon @click="closeFullscreenDialog">
                <mu-icon value="check"></mu-icon>
            </mu-button>
        </mu-appbar>
        <router-view class="list-wrap"
                     @setEnv="setEnv"
                     :st="_self"
                     :beBind="screenDialog.beBind" ref="manager"/>
    </div>
</template>

<script>
	import backend from '../lib/config/backend';
	import {io} from '../lib/io/';

	export default {
		name: "main-setting",
		data() {
			return {
				openFullscreen: false,
				screenDialog: {
					transition: 'slide-bottom'
				}
			}
		},
		methods: {
			setEnv(env){
				this.screenDialog = env;
            },
			openFullscreenDialog(to) {
				this.openFullscreen = true;
				this.$router.push(to);
			},
			closeFullscreenDialog() {
				this.openFullscreen = false;
				this.$nextTick(() => {
					this.$router.replace('/')
				});
			},
			checkLogin() {
				io.request({
					method: 'GET',
					url: backend.host + backend.prefix + backend.user.checkStatus.api,
				}).then(ret => {
					if (ret.status === 'success') {
						this.$store.commit('login',Object.assign(backend.online.user, ret.user));
					}
				}).catch(err => {
					if (err.status === 'net error') {
						console.log('网络错误', err.code);
						this.$store.commit('login',backend.offline.user);
					} else console.log(err);
				});
			}
		},
		computed: {
			// statusLED(vm) {
			// 	let color = null;
			// 	switch (vm.user.shortStatus) {
			// 		case '离线': {
			// 			color = null;
			// 			break;
			// 		}
			// 		case '在线': {
			// 			color = 'primary';
			// 			break;
			// 		}
			// 		case '同步中': {
			// 			color = 'success';
			// 			break;
			// 		}
			// 		case '错误': {
			// 			color = 'error';
			// 		}
			// 	}
			// 	return color;
			// }
		},
		mounted() {
			this.checkLogin();
		}
	}
</script>

<style scoped>
    .list-wrap {
        background-color: transparent;
        overflow-x: hidden;
        height: calc(100% - 84px);
        position: absolute;
        width: 100%;
    }

    @media (max-width: 600px) {
        .list-wrap {
            height: calc(100% - 76px);
        }
    }

    .header-bar {
        box-shadow: 0 2px 4px -1px rgba(0, 0, 0, .2), 0 4px 5px 0 rgba(0, 0, 0, .14), 0 0 0 0 rgba(0, 0, 0, .12);
    }
</style>