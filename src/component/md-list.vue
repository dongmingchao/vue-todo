<template>
    <div>
        <mu-list textline="two-line"
                 nested-indent style="list-style-type: none;overflow: hidden;">
            <slot/>
        </mu-list>
        <mu-popover :open.sync="menuopen" :trigger="trigger" placement="bottom-end">
            <mu-list>
                <mu-list-item button>
                    <mu-list-item-title>修改图标</mu-list-item-title>
                </mu-list-item>
                <mu-list-item button>
                    <mu-list-item-title>删除</mu-list-item-title>
                </mu-list-item>
                <mu-list-item button>
                    <mu-list-item-title>标注颜色</mu-list-item-title>
                </mu-list-item>
            </mu-list>
        </mu-popover>
    </div>
</template>

<script>
	// import mdui from 'mdui/dist/js/mdui';
	import MdLine from "./md-line";
    import { ContainerMixin } from 'vue-slicksort';

	export default {
		name: "md-list",
		components: {MdLine},
        mixins: [ContainerMixin],
		props: ['placeholder','list'],
		data() {
			return {
				create: null,
				menuopen: false,
				triggerIndex: 0,
				trigger: null,
				checkedList: [],
				showList: ['add', 'finish'],
				exclude: ['add', 'finish']
				// body: null
			}
		}
		// methods: {
		// 	createNewTodo() {
		// 	    let self = this;
		// 		this.create = {
		// 			createdAt: new Date(),
		// 			favorite: false,
		// 			repeats: '单次',
		// 			tags: [{
		// 				label: '随笔',
		// 				color: 'primary'
		// 			}],
        //             index: self.list.length
        //         };
		// 		let todo = document.getElementById('newTodoArea');
		// 		this.$nextTick(() => {
		// 			todo.focus();
		// 			this.$emit('event:focus', todo);
		// 		});
		// 	},
		// 	longTap(e, i) {
		// 		this.menuopen = true;
		// 		let ul = this.$refs.listItems;
		// 		this.triggerIndex = i;
		// 		for (let each of ul) {
		// 			if (each.item === e) {
		// 				this.trigger = each.$el;
		// 				break;
		// 			}
		// 		}
		// 	},
		// 	addTodo(e) {
		// 		console.log('add todo change', e.target.value);
		// 		let value = e.target.value;
		// 		if (value !== '') {
		// 			this.create.label = value;
		// 			this.$emit('createTodo', this.create);
		// 		}
		// 		e.target.value = '';
		// 		this.create = null;
		// 	},
		// 	expandTodo(index) {
		// 		this.menuopen = false;
		// 		console.log('md list expand', index);
		// 	},
		// 	markFavorite(item) {
		// 		console.log('mark favorite', item);
		// 		item.favorite = !item.favorite;
		// 	},
		// 	changeStar(item) {
		// 		return item.favorite ? 'star' : 'star_border';
		// 	},
		// 	packChange(prop, value, index) {
		// 		let isArray = prop instanceof Array;
		// 		if (!isArray) prop = [prop];
		// 		prop.unshift(index);
		// 		this.$emit('settle', prop, value);
		// 	},
		// 	check(t, i) {
		// 		let checkedLocate = this.checkedList.indexOf(t);
		// 		if (-1 !== checkedLocate) return this.uncheck(t, i, checkedLocate);
		// 		let finlocate = this.showList.indexOf('finish');
		// 		for (let f = i; f <= finlocate; f++) {
		// 			this.showList[f] = this.showList[f + 1]
		// 		}
		// 		this.showList[finlocate] = t;
		// 		this.checkedList.push(t);
		// 		this.$forceUpdate();
		// 		console.log('check', this.showList, this.checkedList);
		// 	},
		// 	uncheck(t, i, locate_in_check) {
		// 		this.checkedList.splice(locate_in_check, 1);
		// 		for (let f = i; f > 0; f--) {
		// 			this.showList[f] = this.showList[f - 1]
		// 		}
		// 		this.showList.shift();
		// 		this.showList.unshift(t);
		// 		console.log('uncheck', this.showList, this.checkedList, locate_in_check);
		// 	},
		// 	updateList() {
		// 		while (this.showList.length > this.exclude.length) {
		// 			let top = this.showList.shift();
		// 			if (this.exclude.includes(top))
		// 				this.showList.push(top);
		// 		}
		// 		if (this.showList.length === 0) {
		// 			this.showList.push('add');
		// 			this.showList.push('finish');
		// 		}
		// 		console.log('list', this.showList);
		// 		while (this.checkedList.length)
		// 			this.checkedList.shift();
		// 		let unchecks = [];
		// 		let checks = [];
		// 		for (let each of this.list) {
		// 			// each.index = this.list.indexOf(each);
		// 			if (each.checked) {
		// 				checks.push(each);
		// 				this.checkedList.push(each);
		// 			} else unchecks.push(each);
		// 		}
		// 		for (let each of unchecks.reverse()) {
		// 			this.showList.unshift(each);
		// 		}
		// 		for (let each of checks) {
		// 			this.showList.push(each);
		// 		}
		// 	},
		// 	deleteTodo(item) {
		// 		let index = this.showList.indexOf(item);
		// 		this.showList.splice(index, 1);
		// 		this.$emit('delete', item);
		// 		console.log('delete a todo!!', item);
		// 	},
		// 	// catalogChange(){
		// 	//     this.checkedList = [[],[]];
		// 	//     if (this.list) {
		// 	//         for (let each of this.list) {
		// 	//             if (each.checked) this.checkedList[1].push(each);
		// 	//             else this.checkedList[0].push(each);
		// 	//         }
		// 	//     }
		// 	// }
		// },
		// watch: {
		// 	list() {
		// 		if (!this.list) return;
		// 		this.updateList();
		// 	}
		// },
		// mounted() {
		// 	if (this.list) this.updateList();
		// }
	}
</script>

<style scoped>
    .mu-list .mu-list {
        padding-left: 34px;
    }
</style>