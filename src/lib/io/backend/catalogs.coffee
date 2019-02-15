import io from '../io'
import config from '@/lib/config'

export default (mc,cessor) ->
	@list = ->
		cessor.process
			online: ->
				mc.postToast(message: '正在获取分类')
				io.request
					method: 'GET'
					url: config.host + config.catalog.list.api
			success: (ret) ->
				ret.catalogs

	@add = (item) ->
		cessor.process
			online: ->
				mc.postToast(message: '同步保存中')
				io.request
					method: 'POST',
					url: config.host + config.catalog.add.api,
					data:
						icon: item.icon
						bgimg: flatland
						label: item.label
						date: item.date
			success: (ret) ->
				mc.postToast
					message: '已保存'
					color: 'success'
			finally: (ret) ->
				mc.postToast
					message: '保存失败'
					color: 'error'
	return
