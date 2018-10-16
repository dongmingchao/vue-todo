<template>
    <mu-list-item :nested="expand" :open="open" button>
        <mu-list-item-action>
            <mu-checkbox v-model="item.checked" @change="check"></mu-checkbox>
        </mu-list-item-action>
        <mu-list-item-content @click="clickBody">
            <mu-list-item-title>
                {{item.label}}
            </mu-list-item-title>
            <mu-list-item-sub-title style="color: rgba(0, 0, 0, .87)" v-if="item.prefix">
                {{item.prefix}}
            </mu-list-item-sub-title>
            <mu-list-item-sub-title v-if="item.content">
                {{item.content?item.content:null}}
            </mu-list-item-sub-title>
        </mu-list-item-content>
        <mu-list-item-action>
            <mu-list-item-after-text>15 min</mu-list-item-after-text>
            <mu-checkbox color="yellow700" v-model="selects" value="value1" uncheck-icon="star_border"
                         checked-icon="star"></mu-checkbox>
        </mu-list-item-action>
        <!--<slot name="right"/>-->
        <md-list :list="item.steps"
                 slot="nested"
                 :is-expand="false"
                 placeholder="添加新的步骤"
                 @createTodo="setNewTodo"/>
        <mu-list-item slot="nested" button>
            <mu-date-input icon="access_alarm"
                           v-model="time"
                           label="设定闹钟"
                           type="time" label-float full-width></mu-date-input>
        </mu-list-item>
        <mu-list-item slot="nested" button>
            <mu-date-input v-model="date"
                           icon="today"
                           label="添加相关时间"
                           label-float full-width no-display></mu-date-input>
        </mu-list-item>
        <mu-list-item slot="nested" button>
            <mu-select label="设置重复" icon="today" v-model="repeats" full-width label-float>
                <mu-option v-for="language,index in languages" avatar :key="language" :label="language"
                           :value="language">
                    <mu-list-item-action avatar>
                        <mu-avatar :size="36" color="primary">
                            {{language.substring(0, 1)}}
                        </mu-avatar>
                    </mu-list-item-action>
                    <mu-list-item-content>
                        <mu-list-item-title>{{language}}</mu-list-item-title>
                    </mu-list-item-content>
                </mu-option>
            </mu-select>
        </mu-list-item>
        <mu-list-item slot="nested" button>
            <mu-text-field icon="note" v-model="note" label="添加笔记" label-float multi-line :rows="3"></mu-text-field>
        </mu-list-item>
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
                date: null,
                time: null,
                repeats: null,
                languages: ['C', 'Java'],
                note: null,

                open: false,
                selects: []
            }
        },
        methods: {
            clickBody(e) {
                console.log('click todo line body', e);
                this.open = !this.open;
                this.$emit('click', e);
            },
            check(e) {
                console.log('you check a todo', e);
                this.$emit('check', e);
            },
            setNewTodo(str) {
                let item = this.item;
                console.log('set new todo list event', str);
                if (typeof item.steps === 'undefined') {
                    item.steps = [];
                    this.$emit('update:item', item);
                }
                item.steps.push({
                    label: str,
                    favorite: false
                })
            },
            toggle(val) {
                console.log('list item toggle', val);
                // this.open = false;
            }
        },
        mounted() {

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

    /*.detail-setting > div {*/
    /*display: inline-block;*/
    /*}*/
</style>