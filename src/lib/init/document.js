import dusk from '@/assets/dusk.jpg';

export default {
	"api": "./apis/document.json",
	"checkExpire":"./apis/expire.json",
	"title": {
		"title": "归档",
		"date": "10月2日 星期五",
		"bgimg": dusk,
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
	"todoList": []
}