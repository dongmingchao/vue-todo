export default {
	state:
		indexes: []
		promises: []
		bridge: []

	mutations:
		addReadyTaskWaiter: (state,task) ->
			bridge = {}
			bridge.index = state.indexes.length
			bridge.depIndex = task.index
			state.indexes.push task.index
			state.promises.push task.waiter

	actions:
		addTaskWaiter: ({state, commit, rootState},task) ->
#			commit 'addReadyTaskWaiter',task
			ret = await task.waiter
			found = await rootState.io.find task.index
			task.done(ret,found)

}