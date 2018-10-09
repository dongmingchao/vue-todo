<template>
    <main-container/>
</template>

<script>
    import MainContainer from "./component/main-container";

    export default {
        name: 'app',
        components: {MainContainer},
        data() {
            return {
                msg: 'Welcome to Your Vue.js App'
            }
        }
    }
</script>

<style>
    /*body{*/
        /*position: absolute;*/
        /*height: 100%;*/
        /*width: 100%;*/
    /*}*/
</style>
