import {io} from '@/lib/io'
import localforge from 'localforage'

export default
	state:
		name: '本地用户'
		shortStatus: '离线'
		status: '使用本地数据'
		statusLED: null

	mutations:
		login: (state, user) ->
			state.name = user.name
			state.shortStatus = user.shortStatus
			state.status = user.status
			state.statusLED = user.statusLED

	actions:
		login: ({state, commit, rootState}, form) ->
			user = await rootState.io.sync.users.login form
			if user.user?
				user.shortStatus = '在线'
				user.status = '使用网络数据'
				user.statusLED = 'primary'
				user.name = user.user.name
				delete user.user
				console.log('final user', user);
				commit 'login', user
				return status: 'success'
			else return user

		signUp: ({state, commit, rootState}, form) ->
			await rootState.io.sync.users.signUp form

		logout: ({state, commit, rootState}) ->
			ret = await await rootState.io.sync.users.logout()
			if ret.status is 'success'
				commit 'login',
					name: '本地用户'
					shortStatus: '离线'
					status: '使用本地数据'
					statusLED: null
				keys = await localforge.keys()
				for key in keys
					if not key.startsWith 'local|'
						io.remove(key)
				return status: 'success'

#	getters: