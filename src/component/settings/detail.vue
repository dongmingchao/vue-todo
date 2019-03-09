<template>
    <mu-list textline="two-line">
        <mu-sub-header>任务列表动画速度</mu-sub-header>
        <mu-list-item>
            <mu-list-item-content>
                <mu-list-item-title>删除一条、展现新列表</mu-list-item-title>
                <mu-list-item-sub-title>
                    <mu-row gutter>
                        <mu-col span="1" style="text-align: center">快</mu-col>
                        <mu-col span="10">
                            <mu-slider :step="10" :max="700" :min="100" v-model="tdlist.rmSpeed" :display-value="false"/>
                        </mu-col>
                        <mu-col span="1" style="text-align: center">慢</mu-col>
                    </mu-row>
                </mu-list-item-sub-title>
            </mu-list-item-content>
        </mu-list-item>
        <mu-list-item>
            <mu-list-item-content>
                <mu-list-item-title>移动</mu-list-item-title>
                <mu-list-item-sub-title>
                    <mu-row gutter>
                        <mu-col span="1" style="text-align: center">快</mu-col>
                        <mu-col span="10">
                            <mu-slider :step="10" :max="700" :min="100" v-model="tdlist.moveSpeed" :display-value="false"/>
                        </mu-col>
                        <mu-col span="1" style="text-align: center">慢</mu-col>
                    </mu-row>
                </mu-list-item-sub-title>
            </mu-list-item-content>
        </mu-list-item>
        <mu-divider/>
        <!--<mu-list-item>-->
            <!--<mu-list-item-content>-->
                <!--<mu-list-item-title>字体大小</mu-list-item-title>-->
                <!--<mu-list-item-sub-title>-->
                    <!--<mu-slider :step="1" :max="40" :min="10" v-model="font.size" :display-value="false"/>-->
                <!--</mu-list-item-sub-title>-->
            <!--</mu-list-item-content>-->
        <!--</mu-list-item>-->
    </mu-list>
</template>

<script lang="coffee">
    import {Sync, io} from '@/lib/io'
    import localconfig from '@/lib/config/local'

    export default
        name: "animation-speed"
        data: ->
            tdlist:
                rmSpeed: 200
                moveSpeed: 500
            font:
                size: 18
        watch:
            'tdlist.rmSpeed': (val) ->
                @setValue(['tdlist', 'delspeed'], val);
            'tdlist.moveSpeed': (val) ->
                @setValue(['tdlist', 'movespeed'], val);
        methods:
            setValue: (type, val) ->
                @$store.commit 'saveOfSettings',
                    prop:type
                    value: val
                await io.save localconfig.dbname.settings, @$store.state.settings

        mounted: ->
#            @sync = new Sync @
            @$emit('setEnv', title: '细节设定');
            console.log 'tdlist speed',@$store.state.settings.tdlist
            @tdlist.rmSpeed = @$store.state.settings.tdlist.delspeed
            @tdlist.moveSpeed = @$store.state.settings.tdlist.movespeed
</script>
<style scoped>

</style>