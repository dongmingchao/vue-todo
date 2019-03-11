import io from '../io'
import backend from '@/lib/config/backend'

export default (mc,cessor) ->
	@list = ->
		cessor.process
			online: ->
				io.request
					method: 'GET'
					url: backend.host + backend.prefix + backend.tag.list.api
			success: (ret) ->
				ret.tags
	return