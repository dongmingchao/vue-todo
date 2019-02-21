export default {
	state:
		prop: null
		data: null
		index: null
	mutations:
		selectCatalog: (state, catalog) ->
			state.prop = catalog.prop
			state.data = catalog.data
			state.index = catalog.index
	modules:
		header: mHeader
}