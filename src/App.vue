<template>
    <transition name="mu-slide-bottom-transition">
        <keep-alive>
            <router-view/>
        </keep-alive>
    </transition>
</template>

<script>
	export default {
		name: 'app',
		data() {
			return {}
		}
	}
</script>

<style>
    .mu-ripple-wrapper {
        pointer-events: none;
    }

    /*
    .touchPoint{
        max-height:${document.documentElement.clientHeight}px;
        overflow:hidden;
        animation-name:touchPoint;
        position: relative;
    }
    @keyframes touchPoint {
        0% {
            -webkit-clip-path: circle(0% at ${coord.x}px ${coord.y}px);
        }
        100% {
            -webkit-clip-path: circle(120% at ${coord.x}px ${coord.y}px);
        }
    }
    */
</style>
