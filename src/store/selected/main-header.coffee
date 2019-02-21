export default
	state:
		loading: true
		title: null
		actions: []
		date: null
		bgimg: null

	mutations:
		selectedCatalogTitle: (state,title) ->
			state.title = title.title
			state.actions = title.actions
			state.date = title.date
			state.bgimg = title.bgimg
			state.loading = false
