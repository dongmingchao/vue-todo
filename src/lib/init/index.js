import document from './document';
import cloud from './cloud';
import draft from './draft';

export default {
	"api": "./apis/sidelist.json",
	"checkExpire": "./apis/expire.json",
	"body": [
		{
			"label": "普通分类",
			children: [
				{
					"icon": "move_to_inbox",
					"label": "归档",
					"path": document,
					"prop": "local|document"
				},
				// {
				// 	"icon": "star",
				// 	"label": "收藏",
				// 	"path": "./apis/marked.json",
				// 	"prop": "marked"
				// },
				// {
				// 	"icon": "email",
				// 	"label": "日记",
				// 	"path": "./apis/diary.json",
				// 	"prop": "diary"
				// },
				// {
				// 	"icon": "backup",
				// 	"label": "云端",
				// 	"path": cloud,
				// 	"prop": "cloud"
				// }
				]
		},
		{
			"label": "自定义清单",
			children: [
				{
					"icon": "book",
					"label": "草稿",
					"path": draft,
					"prop": "local|draft"
				}
			]
		},
		{
			"label": "清单管理",
			children: [
				{
					"type": "add"
				},
				{
					"type": "manage"
				}
			]
		}
	]
}