import {io} from '@/lib/io'

export default {
	state:
		promises: []
		bridge: []

	mutations:
		addReadyTaskWaiter: (state,task) ->
			state.promises.push task.waiter
			state.bridge.push task.index
			io.save new Date().toJSON(),
				bridge: task.index
				promise: task.waiter

	actions:
		addTaskWaiter: ({state, commit, rootState},task) ->
#			commit 'addReadyTaskWaiter',task
			ret = await task.waiter
			found = await rootState.io.find task.index
			task.done(ret,found)

		activateWaiter: () ->

}