import io from '../io'
import config from '@/lib/config'

export default (mc,cessor) ->
	@done =
		add: (ret,found) ->
			found.id = ret.id
	@list = (id) ->
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
	@add = (id,item) ->
		cessor.process
			online: ->
				mc.postToast(message: '正在获取清单')
				io.request
					method: 'POST'
					url: config.host + config.task.add.api
					data:
						catalogId: id
						item: item
			offline: ->
				mc.$store.commit 'addReadyTaskWaiter',
					waiter: 'tasks/add'

			success: (ret) ->
				mc.postToast
					message: '已保存'
					color: 'success'
				id: ret.id
			finally: (ret) ->
				mc.postToast
					message: '保存失败'
					color: 'error'
	@remove = (td) ->
		cessor.process
			online: ->
				io.request
					method: 'POST'
					url: config.host + config.task.remove.api
					data:
						id: td.id
			success: (ret) ->
				mc.postToast
					message: '已删除'
					color: 'success'
			finally: (ret) ->
				mc.postToast
					message: '删除失败'
					color: 'error'
	@update = (id,item) ->
		for k,v of item
			if v is null then delete item[k]
		cessor.process
			online: ->
				io.request
					method: 'POST'
					url: config.host + config.task.update.api
					data:
						id: id
						item: item
			success: (ret) ->
				mc.postToast
					message: '已保存'
					color: 'success'
			finally: (ret) ->
				mc.postToast
					message: '保存失败'
					color: 'error'

	return