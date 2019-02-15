<template>
    <main-container/>
</template>

<script>

    import MainContainer from "@/component/main-container";
    export default {
        name: 'app',
	    components: {MainContainer},
	    data() {
            return {
            }
        }
    }
</script>

<style>
    .mu-ripple-wrapper {
        pointer-events: none;
    }
</style>
