export default {
	host: '',
	user: {
		login: {
			api: '/api/user/login'
		},
		signUp: {
			api: '/api/user/register'
		},
		logout: {
			api: '/api/user/logout'
		},
		checkStatus: {
			api: '/api/user/status'
		}
	},
	catalog: {
		remove: {
			api: '/api/catalog/remove'
		},
		add: {
			api: '/api/catalog/add'
		},
		list: {
			api: '/api/catalog/list'
		}
	},
	task: {
		list:{
			api:'/api/catalog/item/list'
		},
		add: {
			api: '/api/catalog/item/add'
		},
		remove:{
			api: '/api/catalog/item/remove'
		},
		addStep: {
			api: '/api/item/step/add'
		}
	},
	tag: {
		list: {
			api: '/api/tag/list'
		}
	},
	online:{
		user: {
			shortStatus: '在线',
			status: '使用网络同步',
			statusLED: 'primary'
		}
	},
	offline:{
		user: {
			name: '本地用户',
			shortStatus: '离线',
			status: '使用本地数据',
			statusLED: null
		}
	}
}