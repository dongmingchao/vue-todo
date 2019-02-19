<template>
    <mu-container>
        <mu-button @click="test">测试按钮</mu-button>
    </mu-container>
</template>

<script>
	export default {
		name: "test-btn",
        methods:{
			test(){
				this.$router.push('/note');
            }
        }
	}
</script>

<style scoped>

</style>