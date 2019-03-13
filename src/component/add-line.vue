<template>
    <mu-text-field v-model="text"
                   class="edit-add-line"
                   placeholder="Please input......"
                   full-width>
        <slot name="append">
            <mu-button icon color="primary">
                <mu-icon value="add"/>
            </mu-button>
        </slot>
    </mu-text-field>
</template>

<script>

    export default {
        name: "add-line",
        data() {
            return {
                text: null,
                marginBottom: 0
            }
        }
    }
</script>

<style scoped>
    .edit-add-line {
        width: 100%;
        position: fixed;
        bottom: 0;
        left: 0;
        z-index: 200;
        background-color: #eeeeee;
        margin: 0;
        padding-left: 10px;
        padding-right: 10px;
    }
</style>