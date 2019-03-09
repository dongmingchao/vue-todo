import io from './io'
import config from '../config'
import flatland from '../../assets/flatland.jpg'
import b_catalogs from './backend/catalogs.coffee'
import b_tasks from './backend/tasks.coffee'
import b_tags from './backend/tags.coffee'
import b_users from './backend/users.coffee'

class TextProcessor
	constructor: (@self,@processors) ->

	reducer: (existing, processor) ->
		processor.bind(@self) @text, existing

	process: (@text) ->
		@processors.reduce @reducer.bind(@), @text

class Sync
	constructor: (@mc) ->
		@cessor = new TextProcessor @,[@userStatusProcessor, @retStatusProcessor, @updateLocalProcessor]
		@catalogs = new b_catalogs @mc,@cessor
		@tasks = new b_tasks @mc,@cessor
		@tags = new b_tags @mc,@cessor
		@users = new b_users @mc,@cessor

	userStatusProcessor: (des) ->
		switch @mc.$store.state.user.shortStatus
			when '在线' then des.online() if des.online?
			when '离线' then des.offline() if des.offline?

	retStatusProcessor: (des, ret) ->
		ret = await ret
		return if ret is undefined
		switch ret.status
			when 'success' then des.success(ret.data)
			else
				des.finally(ret)

	updateLocalProcessor: (des, ret) ->
		modified = await ret
		console.log 'modified',modified
		bridge = des.bridge
		return ret if bridge is undefined or modified is undefined or modified.status is not 'success'
		await @mc.$store.state.io.saveRing bridge.props, modified.data
		if @mc.$store.state.selected.catalog.prop is bridge.props[0]
			console.log 'now select catalog',bridge.props[0]
			@mc.$store.commit 'saveOfCatalog',
				prop: bridge.props[1..]
				value: modified.data


export default Sync