<template>
    <mu-list-item :open="nestedopen" button class="td-line" :value="item.index">
        <mu-list-item-action>
            <mu-checkbox ref="btn_check" v-model="item.checked" @change="check"></mu-checkbox>
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
		props: ['item', 'type'],
		data() {
			let self = this;
			return {
				// date: null,
				// time: null,
				// note: null,

				nestedopen: false,
				deleteShow: false,
				selects: [],
				time: null,
				date: null,
				readyMove: false
			}
		},
		watch: {
			// checked(val) {
			// 	this.check(val);
			// }
		},
		methods: {
			clickBody(e) {
				console.log('click todo line body', e);
				this.nestedopen = !this.nestedopen;
				// this.$emit('click', e);
				this.$router.push({
                    path: '/note',
					query: {
                    	item: this.item
                    }
				});
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
			tapChip() {
				console.log('tap chip');
			},
			addNote() {
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
				this.$el.style.top = '';
				this.$el.style.transition = '';
				moveCrossCount = 0;
				this.$emit('moveItemFinish', true);
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
			let items_gesture = new Hammer.Manager(this.$el, {
				recognizers: [
					[Hammer.Press],
					[Hammer.Tap]
				]
			});
			items_gesture = propagating(items_gesture);
			items_gesture.on('press', (ev) => {
				console.log('长按');
				this.$el.style.transition = 'none';
				this.readyMove = true;
				this.$emit('moveItemStart',this.item);
				ev.stopPropagation();
			});
			items_gesture.on('pressup', (ev) => {
				console.log('长按结束');
				this.$el.style.transition = '';
				this.readyMove = false;
				this.$emit('moveItemFinish', false);
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