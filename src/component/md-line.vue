<template>
    <mu-list-item :nested="expand" :open="open" button>
        <mu-list-item-action>
            <mu-checkbox v-model="item.checked" @change="check"></mu-checkbox>
        </mu-list-item-action>
        <mu-list-item-content v-hammer:tap="clickBody"
                              v-hammer:panend="onPanEnd"
                              v-hammer:pan.left="onSwipeLeft">
            <mu-list-item-title>
                <slot/>
                {{item.label}}
            </mu-list-item-title>
            <mu-list-item-sub-title style="color: rgba(0, 0, 0, .87)" v-if="item.prefix">
                <mu-chip class="tag-chip" color="primary">
                    {{item.prefix}}
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
                           @change="$emit('settle','time',time.toJSON())"
                           type="time" label-float full-width></mu-date-input>
        </mu-list-item>
        <mu-list-item slot="nested" button>
            <mu-date-input v-model="date"
                           icon="today"
                           label="添加相关时间"
                           @change="$emit('settle','date',date.toJSON())"
                           label-float full-width no-display></mu-date-input>
        </mu-list-item>
        <mu-list-item slot="nested" button>
            <mu-select label="设置重复"
                       icon="today"
                       v-model="item.repeats"
                       @change="$emit('settle','repeat',item.repeats)"
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
            <mu-text-field icon="note"
                           v-model="item.note"
                           label="添加笔记"
                           @change="$emit('settle','note',item.note)"
                           label-float multi-line :rows="3" full-width></mu-text-field>
        </mu-list-item>
        <mu-button color="secondary"
                   ref="deleteButton"
                   :style="{transform: showDelete}"
                   @click="deleteItem"
                   style="right: -100px;position: absolute;">删除
        </mu-button>
    </mu-list-item>
</template>

<script>
    import mdui from 'mdui/dist/js/mdui';

    export default {
        name: "md-line",
        components: {},
        props: ['item', 'type', 'expand'],
        data() {
            return {
                // date: null,
                // time: null,
                // repeats: null,
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

                open: false,
                deleteShow: false,
                selects: [],
                time: null,
                date: null
            }
        },
        watch: {
            item() {
                this.open = false;
                this.deleteShow = false;
                this.loadInit();
            }
        },
        methods: {
            loadInit() {
                if (this.item.time) this.time = new Date(this.item.time);
                if (this.item.date) this.date = new Date(this.item.date);
            },
            clickBody(e) {
                console.log('click todo line body', e);
                this.open = !this.open;
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
                item.steps.push({
                    label: str,
                    favorite: false,
                    repeats:'无'
                });
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
                this.deleteButton.style.transform = `translateX(${eve.deltaX}px)`;
            },
            onPanEnd(eve) {
                this.deleteShow = eve.deltaX < -50;
                this.$forceUpdate();
            },
            deleteItem() {
                this.$emit('delete', this.item);
            }
        },
        mounted() {
            this.deleteButton = this.$refs.deleteButton.$el;
            this.loadInit();
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
</style>