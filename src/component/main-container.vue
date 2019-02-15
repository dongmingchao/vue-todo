<template>
    <div style="height: 100%;">
        <md-sider v-bind:drawer.sync="drawer"
                  ref="drawer"
                  :list="sideList"
                  :st="$refs.settings"
                  @changeCatalog="setCatalog"
                  @createCatalog="setNewCatalog"
                  @refresh="refreshCatalog"
                  @event:focus="e => eKeyBoard(e,$refs.drawer)"
                  @delete="deleteCatalog"
                  :loading="loading.side"/>
        <md-header :title="title"
                   :st="$refs.settings"
                   @settle="saveHeaderChange"
                   @openSide="collapsedSider"
                   :loading="loading.header"/>
        <md-list class="main-list" ref="list"
                 :list="todoList"
                 @settle="saveTodoListChange"
                 @createTodo="setNewTodo"
                 @delete="deleteTodo"
                 @pushNotify="pushNotification"
                 @event:focus="e => eKeyBoard(e,$refs.list)"
                 :is-expand="true"
                 placeholder="添加新的待做事项"/>
        <main-setting ref="settings"/>
        <mu-snackbar position="bottom-end" :color="toast.color" :open.sync="toast.open">
            {{toast.message}}
            <mu-button flat slot="action" color="#fff" @click="toast.open = false">关闭</mu-button>
        </mu-snackbar>
    </div>
</template>
<script>

	import MdHeader from "./md-header";
	import MdSider from "./md-sider";
	import MdList from "./md-list";
	import {io, Sync} from '../lib/io/index';
	import config from '../lib/config';
	import moment from 'moment';
	import media from '../lib/media';
	import MainSetting from "./main-setting";
	import flatland from '../assets/flatland.jpg';
	import init from '../lib/init';

	export default {
		name: 'main-container',
		components: {MainSetting, MdList, MdSider, MdHeader},
		data() {
			return {
				items: [1, 2, 3, 4, 5, 6, 7, 8, 9],
				loading: {
					header: true,
					side: true
				},
				title: null,
				todoList: null,
				selectedCatalog: null,
				drawer: null,
				sideList: null,
				device: null,
				mat: null,
				toast: {
					open: false,
					color: 'secondary',
					message: ''
				},
				sync: null
			};
		},
		computed: {
			rotateIcon() {
				return [
					'menu-icon',
					this.isCollapsed ? '' : 'rotate-icon'
				];
			},
			menuitemClasses: function () {
				return [
					'menu-item',
					this.isCollapsed ? 'collapsed-menu' : ''
				]
			},
			daemon(vm) {
				console.log('todo list', vm.todoList);
				if (!vm.todoList) return;
				this.selectedCatalog.data.todoList = vm.todoList;
				io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
			}
		},
		methods: {
			postToast(opts) {
				this.toast = Object.assign(this.toast, opts);
				this.toast.open = true;
				setTimeout(() => {
					this.toast.open = false;
				}, 3000);
			},
			/**
			 *
			 * @param prop{Array} 可以定位改变位置的属性链keys
			 * @param value
			 */
			async saveRing(prop, value) {
				let storgae = await io.fetchObj(prop[0]);
				if (storgae === null) return;
				let res = storgae.data;
				let key = prop[1];
				for (let k = 1; k < prop.length - 1; k++) {
					if (typeof res[key] === 'undefined') {
						res[key] = {};
					}
					res = res[key];
					key = prop[k + 1];
				}
				res[key] = value;
				console.log('save ring', res, key, value);
				io.save(prop[0], storgae.data);
			},

			saveTodoListChange(prop, value) {
				prop.unshift('todoList');
				prop.unshift(this.selectedCatalog.prop);
				console.log('save change', 'todoList', prop, value);
				this.saveRing(prop, value);
			},
			saveHeaderChange(prop, value) {
				console.log('save change', 'title', prop, value);
				let todo = this.title;
				let res = todo[prop[0]];
				for (let k = 1; k < prop.length; k++) {
					if (typeof res[prop[k]] === 'undefined') {
						res[prop[k]] = {};
					}
					res = res[prop[k]];
					console.log('in prop', res);
				}
				res = value;
				this.selectedCatalog.data.title = todo;
				io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
			},
			collapsedSider() {
				console.log('click open side menu');
				this.drawer.toggle();
			},
			setNewTodo(ntd) {
				console.log('set new todo list event', ntd);
				this.sync.tasks.add(this.selectedCatalog.prop, ntd);
				this.todoList.push(ntd);
				this.selectedCatalog.data.todoList = this.todoList;
				io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
			},
			async refreshCatalog() {
				let netCatalog = await this.sync.catalogs.list();
				console.log('net catalog', netCatalog);
				for (let each of netCatalog) {
					let sideL;
					if (each.type === null) sideL = this.sideList[1].children;
					else for (let eside of this.sideList) {
						if (eside.label === each.type)
							sideL = eside.children;
					}
					let hasCatalogs = [];
					for (let sideSon of sideL)
						hasCatalogs.push(sideSon.prop);
					if (!hasCatalogs.includes(each.id))
						sideL.push({
							icon: each.icon,
							label: each.label,
							prop: each.id
						});
					io.save(each.id, {
						title: {
							title: each.label,
							datetime: each.date,
							date: moment(each.date).format('MMMDo dddd'),
							bgimg: each.bgimg,
							actions: each.actions
						},
						todoList: null
					});
				}
				io.save('side_list', {body: this.sideList});
			},
			async setCatalog(item) {
				console.log('set catalog', item);
				if (typeof item.prop === 'undefined') return;
				this.loading.header = true;
				let local = await io.fetchObj(item.prop);
				//第一次安装app的默认清单
				if (local === null) {
					if (item.path instanceof Object)
						local = {data: item.path};
					else local = await io.fetch(item.path);
					io.save(item.prop, local.data);
				}
				this.title = local.data.title;
				let list = local.data.todoList;
				if (list === null) {
					list = await this.sync.tasks.list(item.prop);
					this.saveRing([item.prop, 'todoList'], list);
				}
				this.todoList = list;
				this.loading.header = false;
				this.selectedCatalog = {prop: item.prop, data: local.data, index: this.sideList.indexOf(item)};
			},
			deleteTodo(todo) {
				this.todoList.splice(this.todoList.indexOf(todo), 1);
				this.sync.tasks.remove(todo);
				this.selectedCatalog.data.todoList = this.todoList;
				io.save(this.selectedCatalog.prop, this.selectedCatalog.data);
			},
			// async getSideList() {
			// 	return await io.autofetch('side_list', './apis/sidelist.json');
			// },
			setNewCatalog(item) {
				let local = {};
				let datetime = moment().toJSON();
				let date = moment(datetime).format('MMMDo dddd');
				local = {
					"title": {
						"title": item.label,
						"date": date,
						"datetime": datetime,
						"bgimg": flatland,
						"actions": [
							// {
							// 	"name": "排序"
							// },
							{
								"name": "设置背景图"
							}
						]
					},
					"todoList": []
				};
				io.save(item.prop + '|' + datetime, local);
				io.save('side_list', {body: this.sideList});
				item.date = datetime;
				this.sync.catalogs.add(item);
			},
			ready(e) {
				console.log('Vue中 设备已就绪', e);
				this.device = new media(window);
				console.log('can be set', this.device.notification.defaultSet());
				console.log('是否是安卓环境运行？', window.cordova);
				console.log('window', window);
			},
			deleteCatalog(prop) {
				console.log('delete catalog', prop);
				io.remove(prop);
				this.setCatalog(this.sideList[1]);
				io.save('side_list', {body: this.sideList});
			},
			pushNotification(target) {
				let id = '' + this.selectedCatalog.index + target.index;
				if (this.device) {
					this.device.notification.post({
						id: parseInt(id),
						title: target.label,
						text: target.content,
						trigger: {at: target.datetime}
					});
				}
			},
			keyboardShow(e) {
				console.log('Keyboard height is: ', e.keyboardHeight);
				this.device.onKeyboardShow(e.keyboardHeight);
			},
			keyboardHide(e) {
				this.mat.style.height = '0';
			},
			eKeyBoard(elm, body) {
				body = body.$el;
				console.log('capture focus', elm);
				if (this.device) this.device.onKeyboardShow = height => {
					this.mat.style.height = height + 'px';
					if (body.lastChild !== this.mat) body.appendChild(this.mat);
					window.scrollTo(body.scrollWidth, body.scrollHeight);
				}
			}
		},
		mounted() {
			this.sync = new Sync(this);
			this.mat = document.createElement('div');
			this.mat.style.width = '100%';
			io.fetchObj('side_list').then(ret => {
				let li;
				if (ret === null)
					li = init.body;
				else li = ret.data.body;
				this.loading.side = false;
				this.sideList = li;
				this.setCatalog(li[0].children[0]);
				io.save('side_list', {body: this.sideList});
			});
			document.addEventListener('deviceready', this.ready);
			window.addEventListener('native.keyboardshow', this.keyboardShow);
			window.addEventListener('native.keyboardhide', this.keyboardHide);
		}
	}
</script>
<style scoped>

    .flip-list-move {
        transition: transform 1s;
    }

    .main-list {
        height: calc(100% - 10rem);
        overflow-y: scroll;
    }

    @media (min-width: 1023px) {
        .main-list {
            width: calc(100% - 240px);
            position: absolute;
        }
    }
</style>