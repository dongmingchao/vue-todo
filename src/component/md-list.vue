<template>
    <mu-list textline="two-line" nested-indent>
        <template v-for="(item,index) in list">
            <md-line :item.sync="item" @click="expandTodo(index)" :expand="isExpand"/>
            <mu-divider></mu-divider>
        </template>
        <mu-list-item>
            <mu-list-item-action>
                <i class="mdui-icon material-icons">add</i>
            </mu-list-item-action>
            <div class="mdui-list-item-content" style="margin-left: 0" @click="createNewTodo">
                <div class="mdui-list-item-title" v-show="!create">{{placeholder}}</div>
                <div class="mdui-textfield" v-show="create">
                    <input class="mdui-textfield-input" @blur="addTodo" id="newTodoArea" placeholder="标题"/>
                </div>
            </div>
        </mu-list-item>
    </mu-list>
</template>

<script>
    import mdui from 'mdui/dist/js/mdui';
    import MdLine from "./md-line";

    export default {
        name: "md-list",
        components: {MdLine},
        props: ['list','isExpand','placeholder'],
        data() {
            return {
                create: null,
                open:'send'
                // body: null
            }
        },
        methods: {
            createNewTodo() {
                this.create = {};
                let todo = document.getElementById('newTodoArea');
                console.log(todo);
                this.$nextTick(() => {
                    todo.focus();
                });
            },
            addTodo(e) {
                console.log('add todo change', e.target.value);
                let value = e.target.value;
                if (value !== '') this.$emit('createTodo', value);
                e.target.value = '';
                this.create = null;
            },
            expandTodo(index) {
                console.log('md list expand', index);
                // setTimeout(() => {
                //     this.body.toggle(index);
                // },10000);
            },
            markFavorite(item) {
                console.log('mark favorite', item);
                item.favorite = !item.favorite;
            },
            changeStar(item) {
                return item.favorite ? 'star' : 'star_border';
            }
        },
        computed: {},
        mounted() {
            // console.log('md list refs',this.$refs);
            // this.body = new mdui.Collapse(this.$refs.body);
        }
    }
</script>

<style scoped>
    .mu-list .mu-list{
        margin-left: 34px;
    }
</style>