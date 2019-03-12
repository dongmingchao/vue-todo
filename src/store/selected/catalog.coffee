import Vue from 'vue'

export default {
	state:
		prop: null
		data:
			title: '加载中'
		index: null
	mutations:
		selectCatalog: (state, catalog) ->
			console.log('set catalog index', catalog.index)
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
			Vue.set(res, key, value);
		addTodoItem: (state, item) ->
			state.data.todoList.push item


	actions:
		addTodoItem: ({state, commit, rootState}, item) ->
			commit 'addTodoItem', item
			rootState.io.sync.tasks.add state.prop, item
			rootState.io.saveRing [state.prop], state.data


		saveTodoListChange: ({state, commit, rootState}, pv) ->
			pv.prop.unshift 'todoList'
			commit 'saveOfCatalog', pv
			pv.prop.unshift(state.prop)
			rootState.io.saveRing pv.prop, pv.value

		saveAll: ({state, commit, rootState}, pv) ->
			commit 'saveOfCatalog', pv
			pv.prop.unshift(state.prop)
			rootState.io.saveRing pv.prop, pv.value
}