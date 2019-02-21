import flatland from '@/assets/flatland.jpg';

export default {
	"api": "./apis/cloud.json",
	"checkExpire":"./apis/expire.json",
	"title": {
		"title": "云端",
		"date": "10月2日 星期五",
		"bgimg": flatland,
		"actions": [
			{
				"name": "排序"
			},
			{
				"name": "设置背景图",
				"want": "set-background-image"
			}
		]
	},
	"todoList": [
		{
			"index": 0,
			"label": "云端里的一条",
			"tags": [{
				"label": '随笔',
				"color": 'primary'
			}],
			"content": "随便写的一条，传到云端测试",
			"checked": true,
			"steps": [
				{
					"label": "第一步",
					"tags": [{
						"label": '随笔',
						"color": 'primary'
					}],
					"content": "第一步，简单却重要"
				}
			]
		},
		{
			"index": 1,
			"date": "2018-11-27T06:09:42.635Z",
			"favorite": false,
			"label": "123",
			"note": "454",
			"repeats": "每年",
			"time": "2018-11-27T06:09:42.635Z"
		}
	]
}