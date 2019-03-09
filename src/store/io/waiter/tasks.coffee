import {io} from '@/lib/io'
import localconfig from '@/lib/config/local'

arrayEqual = (a1,a2) ->
	for each,i in a1
		return false if each isnt a2[i]
	true

export default {
	state:
		dataset:
			promises: []
			bridge: []
		findWaiterIndexByProp: (bridge) ->
			console.log('find waiter index',@dataset)
			for each,i in @dataset.bridge
				if arrayEqual each.props,bridge.props
					return i

	mutations:
		addReadyTaskWaiter: (state, task) ->
			console.log 'task waiter is ready', task, Array.isArray task.waiter
			if Array.isArray task.waiter
				state.dataset.promises = state.dataset.promises.concat task.waiter
			else state.dataset.promises.push task.waiter
			if Array.isArray task.bridge
				state.dataset.bridge = state.dataset.bridge.concat task.bridge
			else state.dataset.bridge.push task.bridge
			console.log 'waiter init', state.dataset

		fixBridge: (state, {old,now}) ->
			got = state.findWaiterIndexByProp props:old
			if got is undefined then return
			state.dataset.bridge[got] = props:now

		setReadyTaskWaiter: (state, task) ->
			got = state.findWaiterIndexByProp task.bridge
			done = task.change
				waiter: state.dataset.promises[got]
				bridge: state.dataset.bridge[got]
			state.dataset.promises[got] = done.waiter
			state.dataset.bridge[got] = done.bridge

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
			waiters = await io.fetchObj localconfig.dbname.waiters
			return if waiters is null
			res = waiters.data
			commit 'addReadyTaskWaiter',
				waiter: res.promises
				bridge: res.bridge

		releaseWaiters: ({state, commit, rootState}) ->
			while state.dataset.promises.length != 0
				each = state.dataset.promises.shift()
				bridge = state.dataset.bridge.shift()
				console.log 'Waiters is releasing', each, bridge
				found = await rootState.io.find bridge.props
				cb = rootState.io.sync
				for funKey in each.sync
					cb = cb[funKey]
				for arg,i in each.args
					if arg is 'bridge'
						each.args[i] = found
				await cb[each.method](...each.args)
				console.log 'after remove waiter', state.dataset
				await io.save localconfig.dbname.waiters, state.dataset

}