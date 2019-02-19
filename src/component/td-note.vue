<template>
        <!--@change="$emit('settle','note',item.note)"-->
    <mu-text-field
            class="main-list"
            v-model="item.note"
            label="添加笔记"
            label-float multi-line :rows="rows" full-width ref="notearea"/>
</template>

<script lang="coffee">

    export default
        name: "td-note"
        data: ->
            item:
                note: null
            rows: 1
        mounted: ->
            @resizeNoteArea()
    #            window.addEventListener('resize',@resizeNoteArea)

        methods:
            resizeNoteArea: ->
                notetext = @$refs.notearea.$el
                lineHeight = window.getComputedStyle(notetext, null).getPropertyValue('line-height')
                lineHeight = Number(lineHeight.substring(0, lineHeight.indexOf('px')))
                @rows = Math.floor((@$el.scrollHeight - 58) / lineHeight)
                console.log 'note resize area', @rows, lineHeight, @$el.scrollHeight
                notediv = @$refs.notearea.$children[0]
                @item.note = '描述一下详细情况～'
                @$nextTick ->
                    notediv.$refs.textarea.focus()
                    @item.note = ''
                return

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
</style>