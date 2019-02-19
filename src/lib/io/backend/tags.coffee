import io from '../io'
import config from '@/lib/config'

export default (mc,cessor) ->
	@list = ->
		cessor.process
			online: ->
				io.request
					method: 'GET'
					url: config.host + config.tag.list.api
			success: (ret) ->
				ret.tags
	return