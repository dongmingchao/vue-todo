import io from '../io'
import config from '@/lib/config'

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
				ret.items
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
				io.save 'waiters', mc.$store.state.io.waiter.tasks
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
				io.save 'waiters', mc.$store.state.io.waiter.tasks
			success: ->
				mc.postToast
					message: '已删除'
					color: 'success'
			finally: ->
				mc.postToast
					message: '删除失败'
					color: 'error'
	@update = (id, item) ->
		props = [mc.$store.state.selected.catalog.prop, 'todoList', item.index]
		cessor.process
			online: ->
				io.request
					method: 'POST'
					url: config.host + config.task.update.api
					data:
						id: id
						item: item
			offline: ->
				mc.$store.commit 'addReadyTaskWaiter',
					waiter:
						sync: ['tasks']
						method: 'update'
						args: [id, item]
					bridge:
						props: props
				io.save 'waiters', mc.$store.state.io.waiter.tasks
			success: (ret) ->
				mc.postToast
					message: '已保存'
					color: 'success'
			finally: (ret) ->
				mc.postToast
					message: '保存失败'
					color: 'error'

	return