<template>
    <div>
        <div class="mdui-card" style="margin: 15px" v-for="each in localImages">
            <div class="mdui-card-media">
                <img :src="each.src" style="min-height: 150px;"/>
                <div class="mdui-card-media-covered">
                    <div class="mdui-card-primary">
                        <div class="mdui-card-primary-subtitle">{{each.name}}</div>
                    </div>
                    <div class="mdui-card-actions actions">
                        <mu-radio :value="each.src" v-model="nowSrc" @change="imgChange"></mu-radio>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: "bg-image-manager",
        props: ['beBind'],
        data() {
            return {
                localImages: [{
                    name: '血色黎明',
                    src: 'dist/dusk.jpg'
                }, {
                    name: '原谅色平原',
                    src: 'dist/flatland.jpg'
                }],
                nowSrc: null
            }
        },
        methods:{
            imgChange(n){
                this.$emit('bgImageChange',n);
                console.log('manager bgImageChange',n, this.nowSrc);
            }
        },
        mounted(){
            this.nowSrc = this.beBind.src;
        }
    }
</script>

<style scoped>
    .actions {
        position: absolute;
        right: 0;
        bottom: 0;
    }
</style>