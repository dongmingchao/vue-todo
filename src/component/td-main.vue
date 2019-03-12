<template>
    <div style="height: calc(100% - 10rem);">
        {{item}}
        <mu-list :dense="true" textline="two-line" nested-indent style="list-style-type: none;overflow: hidden;">
            <!--<md-list :list="item.steps"-->
            <!--placeholder="添加新的步骤"-->
            <!--@settle="stepSettle"-->
            <!--@createTodo="setNewTodo"/>-->
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
                <mu-chip class="tag-chip"
                         :color="chip.color"
                         @click.stop="tapChip"
                         v-for="chip in chips" :key="chip.label">
                    {{chip.label}}
                </mu-chip>
                <mu-chip>
                    <mu-text-field v-model="create.tag"
                                   @blur="addTag"
                                   class="td-main-add-tag">
                        <slot name="label" v-if="create.tag===''">
                            <div class="add-tag-label">添加标签</div>
                        </slot>
                    </mu-text-field>
                </mu-chip>
            </mu-list-item>
        </mu-list>
        <mu-text-field
                class="note-content"
                v-model="note"
                @change="setValue('note',note)"
                label="添加笔记"
                label-float multi-line :rows="rows" :rows-max="rowsMax" full-width ref="notearea"/>
    </div>
</template>

<script lang="coffee">

    export default {
        name: "td-main"
        props: ['itemIndex']
        computed:
            item: (vm) ->
                @hItem = vm.$store.state.selected.catalog.data.todoList[vm.itemIndex]
                @loadInit(@hItem)
                return;

        data: ->
            hItem: null
            repeats: null
            create:
                tag: ''
            time: null
            date: null
            note: null
            chips: null
            rows: 2
            rowsMax: 7
            repeatTerm: [
                icon: '单',
                label: '单次'
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

        methods:
            setTime: (type) ->
                if type is 'time'
                    @setValue type, @time.toJSON()
                if type is 'date'
                    @setValue type, @date.toJSON()
                if @date && @time
                    datetime = new Date(@date.getFullYear(),
                            @date.getMonth(),
                            @date.getDate(),
                            @time.getHours(),
                            @time.getMinutes(),
                            @time.getSeconds())
                    mtd = Object.assign({}, @hItem)
                    mtd.datetime = datetime;
                    @$emit('pushNotify', mtd)
            setValue: (name, value)->
                @$store.dispatch 'saveTodoListChange',
                    prop: [@itemIndex, name]
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

            loadInit: (e) ->
                console.log 'load item', e
                if e.time?
                    @time = new Date(e.time)
                if e.date?
                    @date = new Date(e.date)
                @note = e.note
                @repeats = e.repeats
                @chips = e.tags

            addTag: () ->
                return if @create.tag is ''
                @chips.push
                    label: @create.tag
                    color: 'primary'
                @create.tag = ''
                @setValue 'tags', @chips

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

    .tag-chip {
        margin: 0 10px;
    }

    .td-main-add-tag{
        margin: 0;
        padding: 0;
        width: 5rem;
        min-height: unset;
    }

    .td-main-add-tag .add-tag-label{
        position: absolute;
        pointer-events: none;
        left: 0.5rem;
    }
</style>