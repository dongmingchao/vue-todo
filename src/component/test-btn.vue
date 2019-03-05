<template>
    <div class="root">
        <SlickList lockAxis="y" v-model="items">
            <SlickItem v-for="(item, index) in items" :index="index" :key="index">
                {{ item }}
            </SlickItem>
        </SlickList>
    </div>
</template>

<script>
    import { SlickList, SlickItem } from 'vue-slicksort';

    export default {
        name: 'Toolbar',
        components: {
            SlickItem,
            SlickList
        },
        data() {
            return {
                items: ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5', 'Item 6', 'Item 7', 'Item 8']
            };
        }
    }
</script>

<style scoped>

</style>