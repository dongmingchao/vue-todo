<template>
    <mu-list-item :nested="expand" :open="nestedopen" button class="td-line">
        <mu-list-item-action>
            <mu-checkbox ref="btn_check" v-model="checked"></mu-checkbox>
        </mu-list-item-action>
        <mu-list-item-content>
            <mu-list-item-title>
                <slot/>
                {{item.label}}
            </mu-list-item-title>
            <mu-list-item-sub-title style="color: rgba(0, 0, 0, .87)" v-if="item.tags">
                <mu-chip class="tag-chip"
                         :color="chip.color"
                         @click.stop="tapChip"
                         v-for="(chip,index) in item.tags" :key="index">
                    {{chip.label}}
                </mu-chip>
            </mu-list-item-sub-title>
            <mu-list-item-sub-title v-if="item.content">
                {{item.content}}
            </mu-list-item-sub-title>
        </mu-list-item-content>
        <mu-list-item-action>
            <mu-list-item-after-text>15 min</mu-list-item-after-text>
            <mu-checkbox color="yellow700" v-model="selects" value="value1" uncheck-icon="star_border"
                         checked-icon="star"></mu-checkbox>
        </mu-list-item-action>
        <md-list :list="item.steps"
                 slot="nested"
                 :is-expand="false"
                 placeholder="添加新的步骤"
                 @settle="stepSettle"
                 @createTodo="setNewTodo"/>
        <mu-list-item slot="nested" button>
            <mu-date-input icon="access_alarm"
                           v-model="time"
                           label="设定闹钟"
                           @change="setTime('time')"
                           type="time" label-float full-width></mu-date-input>
        </mu-list-item>
        <mu-list-item slot="nested" button>
            <mu-date-input v-model="date"
                           icon="today"
                           label="添加相关时间"
                           @change="setTime('date')"
                           label-float full-width no-display></mu-date-input>
        </mu-list-item>
        <mu-list-item slot="nested" button>
            <mu-select label="设置重复"
                       icon="today"
                       v-model="item.repeats"
                       @change="$emit('settle','repeats',item.repeats)"
                       full-width label-float>
                <mu-option v-for="(term,index) in repeatTerm" avatar :key="index" :label="term.label"
                           :value="term.label">
                    <mu-list-item-action avatar>
                        <mu-avatar :size="36" color="primary">
                            {{term.icon}}
                        </mu-avatar>
                    </mu-list-item-action>
                    <mu-list-item-content>
                        <mu-list-item-title>{{term.label}}</mu-list-item-title>
                    </mu-list-item-content>
                </mu-option>
            </mu-select>
        </mu-list-item>
        <mu-list-item slot="nested" button>
            <mu-button color="primary" @click="addNote">添加笔记</mu-button>
        </mu-list-item>
        <mu-button color="secondary"
            ref="deleteButton"
            :style="{transform: showDelete}"
            @click.native.stop="deleteItem"
            style="right: -100px;position: absolute;">
            删除
        </mu-button>
    </mu-list-item>
</template>

<script>
	// import mdui from 'mdui/dist/js/mdui';

	import TdNote from "@/component/td-note";
	import propagating from 'propagating-hammerjs';
	import Hammer from 'hammerjs';
	import 'jquery.event.move';

	export default {
		name: "md-line",
		components: {TdNote},
		props: ['item', 'type', 'expand'],
		data() {
			let self = this;
			return {
				// date: null,
				// time: null,
				repeatTerm: [
					{
						icon: '无',
						label: '无'
					}, {
						icon: '天',
						label: '每天'
					}, {
						icon: '周',
						label: '每周'
					}, {
						icon: '月',
						label: '每月'
					}, {
						icon: '年',
						label: '每年'
					}, {
						icon: '自',
						label: '自定义'
					}],
				// note: null,

				nestedopen: false,
				deleteShow: false,
				selects: [],
				time: null,
				date: null,
				checked: self.item.checked ? self.item.checked : false,
				readyMove: false
			}
		},
		watch: {
			item() {
				this.nestedopen = false;
				this.deleteShow = false;
				this.loadInit();
			},
			checked(val) {
				this.check(val);
			}
		},
		methods: {
			loadInit() {
				if (this.item.time) this.time = new Date(this.item.time);
				if (this.item.date) {
					console.log('read date', this.item.date);
					this.date = new Date(this.item.date);
				}
			},
			clickBody(e) {
				console.log('click todo line body', e);
				this.nestedopen = !this.nestedopen;
				this.$emit('click', e);
			},
			check(e) {
				console.log('you check a todo', e);
				this.$emit('check', e);
				this.$emit('settle', 'checked', e);
			},
			setNewTodo(str) {
				let item = this.item;
				console.log('set new todo step event', str);
				if (typeof item.steps === 'undefined') {
					item.steps = [];
					this.$emit('update:item', item);
					this.$forceUpdate();
				}
				item.steps.push(str);
				this.$emit('settle', 'steps', item.steps);
			},
			toggle(val) {
				console.log('list item toggle', val);
				// this.open = false;
			},
			stepSettle(prop, value) {
				prop.unshift('steps');
				this.$emit('settle', prop, value);
			},
			onSwipeLeft(eve) {
				this.$refs.deleteButton.$el.style.transform = `translateX(${eve.distX}px)`;
			},
			onPanEnd(eve) {
				this.deleteShow = eve.distX < -50;
				this.$forceUpdate();
			},
			deleteItem() {
				this.$emit('delete', this.item);
			},
			setTime(type, value) {
				if (type === 'time') {
					this.$emit('settle', type, this.time.toJSON());
				}
				if (type === 'date')
					this.$emit('settle', type, this.date.toJSON());
				if (this.date && this.time) {
					let datetime = new Date(this.date.getFullYear(),
						this.date.getMonth(),
						this.date.getDate(),
						this.time.getHours(),
						this.time.getMinutes(),
						this.time.getSeconds());
					console.log('date', this.date, 'time', this.time);
					console.log('date time', datetime);
					this.item.datetime = datetime;
					this.$emit('pushNotify', this.item);
				}
			},
			tapChip() {
				console.log('tap chip');
			},
			addNote() {
				this.$router.push('/note');
			}
		},
		mounted() {
			let moveCrossCount = 0;

			let node = this.$el;
			node.addEventListener('movestart', (e) => {
				e.enableMove();
				if (this.readyMove) {
				}
			});
			node.addEventListener('moveend', e => {
				e.stopPropagation();
				if (!this.readyMove) return;
				this.readyMove = false;
				this.$el.style.border = '';
				this.$el.style.top = '';
				this.$el.style.transition = '';
				moveCrossCount = 0;
				this.$emit('moveItemFinish');
			});
			node.addEventListener('move', (e) => {
				this.onSwipeLeft(e);
			});
			node.addEventListener('moveend', e => {
				this.onPanEnd(e);
			});
			node.addEventListener('move', (e) => {
				e.stopPropagation();
				if (!this.readyMove) return;
				this.$el.style.top = e.distY - moveCrossCount * 72 + 'px';
				if ((e.distY > 72 * moveCrossCount + 72) || (e.distY < 72 * moveCrossCount - 72)) {
					let nowMoveCrossCount = Math.floor(e.distY / 72);
					console.log(this.item, e.distY, moveCrossCount, '->', nowMoveCrossCount);
					if (nowMoveCrossCount < 0) {
						nowMoveCrossCount++;
						if (moveCrossCount < nowMoveCrossCount) nowMoveCrossCount--;
					} else if (moveCrossCount > nowMoveCrossCount) nowMoveCrossCount++;
					this.$emit('moveItem', this.item, nowMoveCrossCount, moveCrossCount);
					moveCrossCount = nowMoveCrossCount;
				}
			});
			this.loadInit();
			let items_gesture = new Hammer.Manager(this.$el, {
				recognizers: [
					[Hammer.Press],
					[Hammer.Tap]
				]
			});
			items_gesture = propagating(items_gesture);
			items_gesture.on('press', (ev) => {
				console.log('长按');
				this.$el.style.border = 'inset';
				this.$el.style.transition = 'none';
				this.readyMove = true;
				this.$emit('moveItemStart');
				ev.stopPropagation();
			});
			items_gesture.on('pressup', (ev) => {
				console.log('长按结束');
				this.$el.style.border = '';
				this.$el.style.transition = '';
				this.readyMove = false;
				ev.stopPropagation();
			});
			items_gesture.on('tap', ev => {
				this.clickBody();
				ev.stopPropagation();
            });
			let check_gesture = propagating(new Hammer(this.$refs.btn_check.$el));
			check_gesture.on('tap', ev => {
				ev.stopPropagation();
			});
		},
		computed: {
			showDelete(vm) {
				return `translateX(${vm.deleteShow ? -120 : 0}px)`
			}
		}
	}
</script>

<style scoped>
    .item-header {
        padding: 0;
    }

    .item-header-center {
        margin-left: 0;
        width: 0;
    }

    .tag-chip {
        font-size: smaller;
        line-height: 20px;
    }

    .td-line {
        position: relative;
        /*-webkit-transition: top .5 ease;*/
        /*-moz-transition: top .5 ease ;*/
        /*-ms-transition: top .5 ease ;*/
        /*-o-transition: top .5 ease ;*/
        /*transition: top .5 ease;*/
    }
</style>