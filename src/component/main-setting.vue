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
        <router-view class="list-wrap"
                   :st="_self"
                   @change-user="setUser"
                   :beBind="screenDialog.beBind" ref="manager"/>
    </mu-dialog>
</template>

<script>
	import BgImageManager from "./bg-image-manager";
	import SettingsManager from "./settings-manager";
	import config from '../lib/config';
	import { io } from '../lib/io/';

	export default {
		name: "main-setting",
		components: {SettingsManager, BgImageManager},
		data() {
			return {
				user: {
					name: '本地用户',
					shortStatus: '离线',
					status: '使用本地数据',
					statusLED: null
				},
				openFullscreen: false,
				screenDialog: {}
			}
		},
		methods: {
			setUser(user) {
				this.user = Object.assign(this.user, user);
			},
			openFullscreenDialog(config) {
				this.openFullscreen = true;
				this.screenDialog = config;
			},
			closeFullscreenDialog() {
				this.openFullscreen = false;
				this.screenDialog = {};
				this.$router.back();
			},
            checkLogin(){
	            io.request({
		            method: 'GET',
		            url: config.host + config.user.checkStatus.api,
	            }).then(ret => {
		            if (ret.status === 'success') {
			            this.setUser(config.loginSuccess(ret.user));
		            }
	            }).catch(err => {
	            	if (err.status === 'net error')
	            		console.log('网络错误',err.code);
	            	else console.log(err);
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
        mounted(){
	        this.checkLogin();
        },
        updated(){
            this.checkLogin();
        }
	}
</script>

<style scoped>
    .list-wrap {
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
</style>