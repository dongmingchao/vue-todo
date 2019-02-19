<template>
    <div>
        <div v-for="td in divs" :style="td"></div>
    </div>
</template>

<script lang="coffee">
    export default
        name: "waterfall"
        data: ->
            generateDiv = []
            for i in [1..10]
                generateDiv.push
                    height: "#{Math.random() * 500 + 50}px"
                    width: "#{Math.random() * 400 + 100}px"
                    backgroundColor: "##{(Math.floor(Math.random() * 16777215) + 1048576).toString(16)}"
                    display: 'inline-block'
            chips: [
                label: 'test'
                color: 'primary'
                size: '2em'
            ,
                label: '中文测试'
                color: 'success'
                size: '5em'
            ,
                label: '颜色测试'
                color: 'error'
                size: '3em'
            ]
            divs: generateDiv
</script>

<style scoped>

</style>