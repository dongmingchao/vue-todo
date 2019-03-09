<template>
    <div>test</div>
</template>

<script>
    export default {
        name: "test",
        mounted() {
            this.$emit('setEnv', {title: '测试'});
        }
    }
</script>

<style scoped>

</style>