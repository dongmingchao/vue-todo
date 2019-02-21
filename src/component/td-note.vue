<template>
    <div>
        <mu-list :dense="true" textline="two-line" nested-indent style="list-style-type: none;overflow: hidden;">
            <md-list :list="item.steps"
                     placeholder="添加新的步骤"
                     @settle="stepSettle"
                     @createTodo="setNewTodo"/>
            <mu-list-item button>
                <mu-list-item-content>
                    <mu-date-input icon="access_alarm"
                                   v-model="time"
                                   label="设定闹钟"
                                   @change="setTime('time')"
                                   type="time" label-float full-width></mu-date-input>
                </mu-list-item-content>
            </mu-list-item>
            <mu-list-item button>
                <mu-date-input v-model="date"
                               icon="today"
                               label="添加相关时间"
                               @change="setTime('date')"
                               label-float full-width no-display></mu-date-input>
            </mu-list-item>
            <mu-list-item>
                <mu-list-item-content>
                    <mu-select label="设置重复"
                               icon="today"
                               v-model="repeats"
                               @change="setValue('repeats',repeats)"
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
                </mu-list-item-content>
            </mu-list-item>
            <mu-list-item button>
                <mu-button color="primary" @click="addNote">添加标签</mu-button>
            </mu-list-item>
        </mu-list>
        <mu-text-field
                class="note-content"
                v-model="note"
                @change="setValue('note',note)"
                label="添加笔记"
                label-float multi-line :rows="rows" full-width ref="notearea"/>
    </div>
</template>

<script lang="coffee">

    export default {
        name: "td-note"
        props: ['item']
        data: ->
            repeats: null
            time: null
            date: null
            note: null
            rows: 2
            repeatTerm: [
                icon: '无',
                label: '无'
            ,
                icon: '天',
                label: '每天'
            ,
                icon: '周',
                label: '每周'
            ,
                icon: '月',
                label: '每月'
            ,
                icon: '年',
                label: '每年'
            ,
                icon: '自',
                label: '自定义'
            ]
        mounted: ->
            console.log 'td note item', @item
            @loadInit()

        methods:
            setTime: (type) ->
                if (type == 'time')
                    @setValue type,@time.toJSON()
                if (type == 'date')
                    @setValue type,@date.toJSON()
                if (@date && @time)
                    datetime = new Date(@date.getFullYear(),
                    this.date.getMonth(),
                    this.date.getDate(),
                    this.time.getHours(),
                    this.time.getMinutes(),
                    this.time.getSeconds())
#    this.item.datetime = datetime;
#    this.$emit('pushNotify', this.item)
            setValue: (name, value)->
                @$store.dispatch 'saveTodoListChange',
                    prop: [@item.index, name]
                    value: value

            resizeNoteArea: ->
                notetext = @$refs.notearea.$el
                lineHeight = window.getComputedStyle(notetext, null).getPropertyValue('line-height')
                lineHeight = Number(lineHeight.substring(0, lineHeight.indexOf('px')))
                @rows = Math.floor((@$el.scrollHeight - 58) / lineHeight)
                console.log 'note resize area', @rows, lineHeight, @$el.scrollHeight
                notediv = @$refs.notearea.$children[0]
                @item.note = '描述一下详细情况～'
                return

            loadInit: ->
                if @item.time?
                    @time = new Date(@item.time)
                if @item.date?
                    @date = new Date(@item.date)
                @note = @item.note
                @repeats = @item.repeats

    }
</script>

<style scoped>
    .main-list {
        height: calc(100% - 10rem);
        /*overflow-y: scroll;*/
        /*position: absolute;*/
        /*top: 10rem;*/
        /*left: 256px;*/
        /*width: 100%;*/
    }

    .note-content {
        padding: 3rem;
    }
</style>