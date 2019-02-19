export default
	state:
		name: '本地用户'
		shortStatus: '离线'
		status: '使用本地数据'
		statusLED: null

	mutations:
		login: (state,user) ->
			state.name = user.name
			state.shortStatus = user.shortStatus
			state.status = user.status
			state.statusLED = user.statusLED

#	actions:
#	getters: