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
	import dusk from '@/assets/dusk.jpg';
	import flatland from '@/assets/flatland.jpg';
	import {mapState} from 'vuex';

	export default {
		name: "bg-image-manager",
		computed: {
			...mapState({
				header: state => state.selected.catalog.data.title
			})
		},
		data() {
			return {
				localImages: [{
					name: '血色黎明',
					src: dusk
				}, {
					name: '原谅色平原',
					src: flatland
				}],
				nowSrc: null
			}
		},
		methods: {
			imgChange(n) {
				this.$store.commit('setMHeaderBGIMG', this.nowSrc);
				let prop = ['title', 'bgimg'];
				prop.unshift(this.$store.state.selected.catalog.prop);
				this.$store.state.io.saveRing(prop, this.nowSrc);
			}
		},
		mounted() {
			this.$emit('setEnv', {title: '设置背景图片'});
		},
		activated() {
			this.nowSrc = this.header.bgimg;
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