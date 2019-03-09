import io from '../io'
import config from '@/lib/config'
import localconfig from '@/lib/config/local'

export default (mc, cessor) ->
	@list = (id) ->
		console.log 'task list',config.host + config.task.list.api
		cessor.process
			online: ->
				mc.postToast(message: '正在获取清单')
				io.request
					method: 'POST'
					url: config.host + config.task.list.api
					data:
						catalogId: id
			success: (ret) ->
				retList = []
				retList[each.index] = each for each in ret.items
				retList
	@add = (id, item) ->
		props = [id, 'todoList', item.index]
		cessor.process
			bridge:
				props: props
			online: ->
				mc.postToast(message: '正在保存')
				io.request
					method: 'POST'
					url: config.host + config.task.add.api
					data:
						catalogId: id
						item: item
			offline: ->
				mc.$store.commit 'addReadyTaskWaiter',
					waiter:
						sync: ['tasks']
						method: 'add'
						args: [id, 'bridge']
					bridge:
						props: props
				io.save localconfig.dbname.waiters, mc.$store.state.io.waiter.tasks.dataset
			success: (ret) ->
				found = await mc.$store.state.io.find props
				found.id = ret.id
				mc.postToast
					message: '已保存'
					color: 'success'
				status: 'success'
				data: found
			finally: (ret) ->
				mc.postToast
					message: '保存失败'
					color: 'error'
	@remove = (td) ->
		console.log 'task remove',td
		cessor.process
			online: ->
				io.request
					method: 'POST'
					url: config.host + config.task.remove.api
					data:
						id: td.id
			offline: ->
				mc.$store.commit 'addReadyTaskWaiter',
					waiter:
						sync: ['tasks']
						method: 'remove'
						args: [{id: td.id}]
					bridge:
						props: [mc.$store.state.selected.catalog.prop, 'todoList', td.index]
				io.save localconfig.dbname.waiters, mc.$store.state.io.waiter.tasks.dataset
			success: ->
				mc.postToast
					message: '已删除'
					color: 'success'
			finally: ->
				mc.postToast
					message: '删除失败'
					color: 'error'
	@update = (item, prop) ->
		ntd = {}
		for ep in prop
			ntd[ep] = item[ep]
		props = [mc.$store.state.selected.catalog.prop, 'todoList', item.index]
		cessor.process
			online: ->
				io.request
					method: 'POST'
					url: config.host + config.task.update.api
					data:
						id: item.id
						item: ntd
			offline: ->
#				if item._cloud is 'wait'
#					mc.$store.commit 'setReadyTaskWaiter',
#						bridge:
#							props: props
#						change: (e) ->
#							for ep in prop
#								if not e.waiter.args[1].includes ep
#									e.waiter.args[1].push ep
#							e
#				else
#					waitProp = props.slice()
#					waitProp.shift()
#					waitProp.push '_cloud'
#					#TODO 同时触发两个save ring，导致没有_cloud被保存
#					#TODO 或许使用一下updateLocalProcessor ？
#					mc.$store.dispatch 'saveAll',
#						prop: waitProp
#						value: 'wait'
				mc.$store.commit 'addReadyTaskWaiter',
					waiter:
						sync: ['tasks']
						method: 'update'
						args: [item, prop]
					bridge:
						props: props
				io.save localconfig.dbname.waiters, mc.$store.state.io.waiter.tasks.dataset
			success: (ret) ->
				mc.postToast
					message: '已保存'
					color: 'success'
			finally: (ret) ->
				mc.postToast
					message: '保存失败'
					color: 'error'

	return