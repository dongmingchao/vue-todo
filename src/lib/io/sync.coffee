import io from './io'
import config from '../config'
import flatland from '../../assets/flatland.jpg'
import b_catalogs from './backend/catalogs.coffee'
import b_tasks from './backend/tasks.coffee'
import b_tags from './backend/tags.coffee'

class TextProcessor
	constructor: (@self,@processors) ->

	reducer: (existing, processor) ->
		processor.bind(@self) @text, existing

	process: (@text) ->
		@processors.reduce @reducer.bind(@), @text

class Sync
	constructor: (@mc) ->
		@cessor = new TextProcessor @,[@userStatusProcessor, @retStatusProcessor]
		@catalogs = new b_catalogs @mc,@cessor
		@tasks = new b_tasks @mc,@cessor
		@tags = new b_tags @mc,@cessor

	userStatusProcessor: (des) ->
		switch @mc.$store.state.user.shortStatus
			when '在线' then des.online()

	retStatusProcessor: (des, ret) ->
		ret = await ret
		return if ret is undefined
		switch ret.status
			when 'success' then des.success(ret)
			else
				des.finally(ret)


export default Sync