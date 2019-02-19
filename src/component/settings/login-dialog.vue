<template>
    <mu-container>
        <mu-form ref="form" :model="validateForm">
            <mu-form-item label="邮箱" prop="username" :rules="usernameRules">
                <mu-text-field v-model="validateForm.username" prop="username"></mu-text-field>
            </mu-form-item>
            <mu-form-item label="密码" help-text="密码长度在6到20位，至少包含两种类型" prop="password" :rules="passwordRules">
                <mu-text-field type="password" v-model="validateForm.password" prop="password"></mu-text-field>
            </mu-form-item>
            <mu-form-item prop="isAgree" :rules="argeeRules">
                <mu-checkbox label="同意用户协议" v-model="validateForm.isAgree"></mu-checkbox>
            </mu-form-item>
            <mu-form-item>
                <mu-button color="primary" @click="submit">
                    <label style="margin-left: 15px">登陆</label>
                    <mu-circular-progress :style="{opacity: loading.login?1:0}" style="display: flex;" color="#fff"
                                          class="loading-circle"
                                          :size="18"/>
                </mu-button>
                <mu-button color="success" @click="signup">
                    <label style="margin-left: 15px">注册</label>
                    <mu-circular-progress :style="{opacity: loading.sign?1:0}" style="display: flex;" color="#fff"
                                          class="loading-circle"
                                          :size="18"/>
                </mu-button>
                <mu-button @click="cancel">取消</mu-button>
            </mu-form-item>
        </mu-form>
    </mu-container>
</template>
<script>
	import { io } from '@/lib/io/';
	import config from '@/lib/config';

	export default {
		name: "login-dialog",
		props: ['host'],
		data() {
			return {
				loading: {
					login: false,
					sign: false
				},
				usernameRules: [
					{validate: (val) => !!val, message: '必须填写登陆邮箱'},
					{validate: emailValidate, message: '邮箱格式不合法'}
				],
				passwordRules: [
					{validate: (val) => !!val, message: '必须填写密码'},
					{validate: (val) => val.length >= 6 && val.length <= 20, message: '密码长度大于6小于20'}
				],
				argeeRules: [{validate: (val) => !!val, message: '必须同意用户协议'}],
				validateForm: {
					username: '',
					password: '',
					isAgree: false
				}
			}
		},
		methods: {
			async submit() {
				let pass = await this.$refs.form.validate();
				if (pass) {
					this.loading.login = true;
					let ret = await io.request({
						method: 'POST',
						url: config.host + config.user.login.api,
						data: this.validateForm
					});
					if (ret.status === 'success') {
						this.host.postToast({message: '登陆成功', color: 'success'});
						this.$store.commit('login',Object.assign(config.online.user, ret.user));
						this.host.closeDialog();
					} else if (ret.status === 'error') {
						switch (ret.msg) {
							case 'not found':
								this.host.postToast({message: '请检查您的用户名和密码'});
								break;
							case 'wrong password':
								this.host.postToast({message: '密码错误，请重新输入'});
								break;
						}
					}
					this.loading.login = false;
				}
			},
			async signup() {
				let pass = await this.$refs.form.validate();
				if (pass) {
					this.loading.sign = true;
					let ret = await io.request({
						method: 'POST',
						url: config.host + config.user.signUp.api,
						data: this.validateForm
					});
					console.log('resp', ret);
					if (ret.status === 'success') {
						this.host.postToast({message: '注册成功', color: 'success'});
						this.$store.commit('login',Object.assign(config.online.user, ret.user));
						this.host.closeDialog();
					}
					this.loading.sign = false;
				}
			},
			clear() {
				this.$refs.form.clear();
				this.validateForm = {
					username: '',
					password: '',
					isAgree: false
				};
			},
			cancel() {
				this.host.closeDialog();
			}
		}
	};

	function emailValidate(val) {
		return val.match(/\w[-\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\.)+[A-Za-z]{2,14}/g);
	}

	function passwdValidate(val) {
		return val.match(/^[a-zA-Z0-9]+$/g);
	}
</script>
<style>

    .loading-circle {
        justify-content: center;
        align-items: center;
        left: 7px;
        transition: opacity 300ms ease-in-out;
    }
</style>