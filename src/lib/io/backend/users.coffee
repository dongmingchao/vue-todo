import io from '../io'
import backend from '@/lib/config/backend'

export default (mc, cessor) ->
	@login = (form) ->
		cessor.process
			offline: ->
				io.request
					method: 'POST'
					url: backend.host + backend.prefix + backend.user.login.api
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
					url: backend.host + backend.prefix + backend.user.signUp.api
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
					url: backend.host + backend.prefix + backend.user.logout.api
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