import {io} from '@/lib/io'

export default {
	state:
		promises: []
		bridge: []

	mutations:
		addReadyTaskWaiter: (state, task) ->
			console.log 'task waiter is ready', task, Array.isArray task.waiter
			if Array.isArray task.waiter
				state.promises = state.promises.concat task.waiter
			else state.promises.push task.waiter
			if Array.isArray task.bridge
				state.bridge = state.bridge.concat task.bridge
			else state.bridge.push task.bridge
			console.log 'waiter init', state

		setReadyTaskWaiter: (state, task) ->
			state.promises = task.waiter
			state.bridge = task.bridge
			io.save 'waiters', state

		removeReadyTaskWaiter: (state, index) ->
			state.promises.splice(index, 1)
			state.bridge.splice(index, 1)
			console.log 'waiter be remove', index, state

	actions:
#		addTaskWaiter: ({state, commit, rootState},task) ->
##			commit 'addReadyTaskWaiter',task
#			ret = await task.waiter
#			found = await rootState.io.find task.index
#			task.done(ret,found)

		activateWaiter: ({state, commit, rootState}) ->
			waiters = await io.fetchObj 'waiters'
			return if waiters is null
			res = waiters.data
			commit 'addReadyTaskWaiter',
				waiter: res.promises
				bridge: res.bridge

		releaseWaiters: ({state, commit, rootState}) ->
			while state.promises.length != 0
				each = state.promises.shift()
				bridge = state.bridge.shift()
				console.log 'Waiters is releasing', each, bridge
				found = await rootState.io.find bridge.props
				cb = rootState.io.sync
				for funKey in each.sync
					cb = cb[funKey]
				for arg,i in each.args
					if arg is 'bridge'
						each.args[i] = found
				await cb[each.method](...each.args)
				console.log 'after remove waiter', state
				await io.save 'waiters', state

}