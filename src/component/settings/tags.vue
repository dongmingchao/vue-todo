<template>
    <div>
        <mu-chip v-for="c in chips"
                 v-bind="c"
                 class="tags-chip">
            {{c.label}}
        </mu-chip>
    </div>
</template>

<script lang="coffee">
    import { Sync } from '@/lib/io'

    export default
        name: "tags"
        props: ['st']
        data: ->
            chips: []
            sync: null
        mounted: ->
            @sync = new Sync @
            @$emit('setEnv',title: '标签库');
            @chips = await @sync.tags.list();
</script>

<style scoped>
    .tags-chip {
        margin: 8px;
        vertical-align: middle;
    }
</style>