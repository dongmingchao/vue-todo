import {io} from '@/lib/io';

let config = {
	user: {
		login: {
			api: '/user/login'
		},
		signUp: {
			api: '/user/register'
		},
		logout: {
			api: '/user/logout'
		},
		checkStatus: {
			api: '/user/status'
		}
	},
	catalog: {
		remove: {
			api: '/catalog/remove'
		},
		add: {
			api: '/catalog/add'
		},
		list: {
			api: '/catalog/list'
		}
	},
	task: {
		list:{
			api:'/catalog/item/list'
		},
		add: {
			api: '/catalog/item/add'
		},
		remove:{
			api: '/catalog/item/remove'
		},
		addStep: {
			api: '/item/step/add'
		},
		update: {
			api: '/catalog/item/update'
		}
	},
	tag: {
		list: {
			api: '/tag/list'
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
};
async function getConfig() {
	let backend = await io.fetch('dist/backend.json');
	backend = backend.data;
	config.host = backend.host;
	config.prefix = backend.prefix;
}

getConfig();

export default config