export default {
	state:
		prop: null
		data:
			title: '加载中'
		index: null
	mutations:
		selectCatalog: (state, catalog) ->
			state.prop = catalog.prop
			state.data = catalog.data
			state.index = catalog.index
		setMHeaderBGIMG: (state, bgimg) ->
			state.data.title.bgimg = bgimg
#		setCatalogData: (state, data) ->
#			state.data = data
		saveOfCatalog: (state, {prop, value}) ->
			res = state.data
			key = prop[0]
			for each,k in prop[1..]
				if (typeof res[key] == 'undefined')
					res[key] = {}
				res = res[key]
				key = prop[k + 1]
			res[key] = value

	actions:
		addTodoItem: ({state, commit, rootState}, item) ->
			state.data.todoList.push item
			index = item.index
			waiter = rootState.io.sync.tasks.add state.prop, item
			done = (ret,found) ->
				found.id = ret.id
			rootState.io.saveRing [state.prop],state.data


		saveTodoListChange: ({state, commit, rootState}, pv) ->
			pv.prop.unshift 'todoList'
			commit 'saveOfCatalog', pv

			item = rootState.selected.catalog.data.todoList[pv.prop[1]]
			if item.id?
				id = item.id
				item = Object.assign({}, item)
				delete item.id
				rootState.io.sync.tasks.update id, item

			pv.prop.unshift(state.prop)
			rootState.io.saveRing pv.prop, pv.value
}