import io from '../io'
import config from '@/lib/config'
import flatland from '@/assets/flatland.jpg'
import moment from 'moment'

export default (mc,cessor) ->
	@list = ->
		cessor.process
			online: ->
				mc.postToast(message: '正在获取分类')
				io.request
					method: 'GET'
					url: config.host + config.catalog.list.api
			success: (ret) ->
				netCatalog = ret.catalogs
				console.log 'net catalog', netCatalog
				for each in netCatalog
					if each.type is null
						sideL = mc.sideList[1].children
					else
						for eside in this.sideList
							if eside.label == each.type
								sideL = eside.children
					hasCatalogs = [];
					hasCatalogs.push sideSon.prop for sideSon in sideL
					if !hasCatalogs.includes(each.id)
						sideL.push
							icon: each.icon
							label: each.label
							prop: each.id
						io.save(each.id,
							title:
								title: each.label
								datetime: each.date
								date: moment(each.date).format('MMMDo dddd')
								bgimg: each.bgimg
								actions: each.actions
							todoList: null
						)
				io.save('side_list', body: mc.sideList)

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
	@remove = (id) ->
		cessor.process
			online: ->
				io.request
					method: 'POST'
					url: config.host + config.catalog.remove.api
					data:
						id: id
			success: (ret) ->
				mc.postToast
					message: '已删除'
					color: 'success'
			finally: (ret) ->
				mc.postToast
					message: '删除失败'
					color: 'error'
	return
