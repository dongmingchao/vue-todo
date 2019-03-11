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
                         ref="chips"
                         v-for="(chip,index) in item.tags" :key="index">
                    {{chip.label}}
                </mu-chip>
                <mu-icon :value="syncStatus" color="success" style="vertical-align: middle;"/>
            </mu-list-item-sub-title>
            <mu-list-item-sub-title v-if="item.note ||item.content">
                {{item.content ? item.content:item.note}}
            </mu-list-item-sub-title>
        </mu-list-item-content>
        <mu-list-item-action>
            <mu-list-item-after-text>
                <div v-if="!datetime"></div>
                <div v-else-if="datetime.valueOf() < Date.now()">{{moment(datetime).fromNow()}}</div>
                <countdown :time="datetime - Date.now()" tag="div" v-else>
                    <template slot-scope="props">
                        {{showRestTime(props)}}
                    </template>
                </countdown>
            </mu-list-item-after-text>
            <mu-checkbox color="yellow700"
                         v-model="item.favorite"
                         @change="tapStar"
                         ref="star"
                         uncheck-icon="star_border"
                         checked-icon="star"/>
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

    import TdNote from "@/component/td-main";
    import propagating from 'propagating-hammerjs';
    import Hammer from 'hammerjs';
    import {ElementMixin} from 'vue-slicksort';
    import countdown from '@chenfengyuan/vue-countdown';
    import moment from 'moment';
    import 'jquery.event.move';

    export default {
        name: "md-line",
        components: {TdNote, countdown},
        mixins: [ElementMixin],
        props: ['itemIndex', 'type'],
        data() {
            let self = this;
            return {
                // date: null,
                // time: null,
                // note: null,
                moment,
                nestedopen: false,
                deleteShow: false,
                star: null,
                datetime: null,
                readyMove: false,
                syncStatus: null
            }
        },
        computed: {
            item(vm) {
                let itm = vm.$store.state.selected.catalog.data.todoList[vm.itemIndex];
                if (itm.date && itm.time) {
                    let date = itm.date.slice(0, 10);
                    let time = itm.time.slice(10);
                    this.datetime = new Date(date + time);
                } else this.datetime = null;
                if (itm.id) this.syncStatus = 'cloud_done';
                else this.syncStatus = null;
                return itm;
            },
            showDelete(vm) {
                return `translateX(${vm.deleteShow ? -120 : 0}px)`
            }
        },
        methods: {
            showRestTime(val) {
                let day = val.days === 0 ? '' : val.days + '天';
                let hour = val.hours === 0 ? '' : val.hours + '小时';
                let minute = val.minutes === 0 ? '' : val.minutes + '分钟';
                let second = val.seconds === 0 ? '' : val.seconds + '秒';
                return day + hour + minute + second;
            },
            clickBody(e) {
                console.log('click todo line body', e);
                this.nestedopen = !this.nestedopen;
                // this.$emit('click', e);
                this.$router.push({
                    path: '/note',
                    query: {
                        itemIndex: this.item.index
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
            tapStar(e) {
                console.log('star change', e);
                this.$store.dispatch('saveTodoListChange', {
                    prop: [this.item.index, 'favorite'],
                    value: e
                });
            },
            gesture() {
                let host = () => {
                    let moveCrossCount = 0;

                    let node = this.$el;
                    node.addEventListener('movestart', (e) => {
                        e.enableMove();
                        if (this.readyMove) {
                        }
                    });
                    // node.addEventListener('moveend', e => {
                    //     e.stopPropagation();
                    //     if (!this.readyMove) return;
                    //     this.readyMove = false;
                    //     this.$el.style.top = '';
                    //     this.$el.style.transition = '';
                    //     moveCrossCount = 0;
                    //     this.$emit('moveItemFinish', true);
                    // });
                    node.addEventListener('move', (e) => {
                        this.onSwipeLeft(e);
                    });
                    node.addEventListener('moveend', e => {
                        this.onPanEnd(e);
                    });
                    // node.addEventListener('move', (e) => {
                    //     e.stopPropagation();
                    //     if (!this.readyMove) return;
                    //     this.$el.style.top = e.distY - moveCrossCount * 72 + 'px';
                    //     if ((e.distY > 72 * moveCrossCount + 72) || (e.distY < 72 * moveCrossCount - 72)) {
                    //         let nowMoveCrossCount = Math.floor(e.distY / 72);
                    //         console.log(this.item, e.distY, moveCrossCount, '->', nowMoveCrossCount);
                    //         if (nowMoveCrossCount < 0) {
                    //             nowMoveCrossCount++;
                    //             if (moveCrossCount < nowMoveCrossCount) nowMoveCrossCount--;
                    //         } else if (moveCrossCount > nowMoveCrossCount) nowMoveCrossCount++;
                    //         this.$emit('moveItem', this.item, nowMoveCrossCount, moveCrossCount);
                    //         moveCrossCount = nowMoveCrossCount;
                    //     }
                    // });
                };
                let edit = () => {
                    let items_gesture = new Hammer.Manager(this.$el, {
                        recognizers: [
                            [Hammer.Press],
                            [Hammer.Tap]
                        ]
                    });
                    items_gesture = propagating(items_gesture);
                    items_gesture.on('press', (ev) => {
                        console.log('长按');
                        // this.$el.style.transition = 'none';
                        this.readyMove = true;
                        this.$emit('moveItemStart', this.item);
                        ev.stopPropagation();
                    });
                    items_gesture.on('pressup', (ev) => {
                        console.log('长按结束');
                        // this.$el.style.transition = '';
                        this.readyMove = false;
                        this.$emit('moveItemFinish');
                        ev.stopPropagation();
                    });
                    items_gesture.on('tap', ev => {
                        this.clickBody();
                        ev.stopPropagation();
                    });
                };
                let check = () => {
                    let check_gesture = propagating(new Hammer(this.$refs.btn_check.$el));
                    check_gesture.on('tap', ev => {
                        ev.stopPropagation();
                    });
                };
                let del = () => {
                    let check_gesture = propagating(new Hammer(this.$refs.deleteButton.$el));
                    check_gesture.on('tap', ev => {
                        ev.stopPropagation();
                    });
                };
                let chips = () => {
                    for (let chip of this.$refs.chips) {
                        let check_gesture = propagating(new Hammer(chip.$el));
                        check_gesture.on('tap', ev => {
                            this.tapChip();
                            ev.stopPropagation();
                        });
                    }
                };
                let star = () => {
                    let check_gesture = propagating(new Hammer(this.$refs.star.$el));
                    check_gesture.on('tap', ev => {
                        ev.stopPropagation();
                    });
                };
                host();
                edit();
                check();
                del();
                chips();
                star();
            }
        },
        mounted() {
            this.gesture();
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
        margin: 0 5px;
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