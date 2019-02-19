<template>
    <div>
        <div style="background-color:#2196f3;width: 100%;height: 20px;"></div>
        <mu-appbar class="header-bar"
                   color="primary" :title="screenDialog.title">
            <mu-button slot="left" icon @click="closeFullscreenDialog">
                <mu-icon value="close"></mu-icon>
            </mu-button>
            <mu-button slot="right" icon @click="closeFullscreenDialog">
                <mu-icon value="check"></mu-icon>
            </mu-button>
        </mu-appbar>
        <router-view class="list-wrap"
                     :st="_self"
                     @change-user="setUser"
                     :beBind="screenDialog.beBind" ref="manager"/>
    </div>
</template>

<script>
	export default {
		name: "header"
	}
</script>

<style scoped>

</style>