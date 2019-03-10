import io from '../io'
import config from '@/lib/config'

export default (mc, cessor) ->
	@login = (form) ->
		cessor.process
			offline: ->
				io.request
					method: 'POST'
					url: config.host + config.user.login.api
					data: form
			success: (ret) ->
				ret
			finally: (ret) ->
				ret

	@signUp = (form) ->
		cessor.process
			offline: ->
				io.request
					method: 'POST'
					url: config.host + config.user.signUp.api
					data: form
			success: (ret) ->
				status: 'success'
			finally: (ret) ->
				ret


	@logout = ->
		cessor.process
			online: ->
				io.request
					method: 'GET'
					url: config.host + config.user.logout.api
			success: (ret) ->
				mc.postToast
					message: '已注销',
					color: 'success'
				status: 'success'
			finally: (ret) ->
				mc.postToast
					message: '注销失败',
					color: 'success'
	return