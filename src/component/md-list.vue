<template>
    <ul class="mdui-list" ref="body">
        <template v-for="(item,index) in list">
            <md-line :item.sync="item" @click="expandTodo(index)" :expand="isExpand">
                <a slot="right" href="javascript:;" class="mdui-btn mdui-btn-icon mdui-ripple"
                   @click="markFavorite(item,index)">
                    <i class="mdui-icon material-icons">{{changeStar(item)}}</i>
                </a>
            </md-line>
            <md-line type="separate"/>
        </template>
        <li class="mdui-list-item mdui-ripple">
            <label class="mdui-radio" v-show="create">
                <input type="radio" name="group1"/>
                <i class="mdui-radio-icon"></i>
            </label>
            <label style="width: 36px;height: 36px;line-height: 36px;" v-show="!create">
                <i class="mdui-icon material-icons">add</i>
            </label>
            <div class="mdui-list-item-content" style="margin-left: 0" @click="createNewTodo">
                <div class="mdui-list-item-title" v-show="!create">{{placeholder}}</div>
                <div class="mdui-textfield" v-show="create">
                    <input class="mdui-textfield-input" @blur="addTodo" id="newTodoArea" placeholder="标题"/>
                </div>
            </div>
        </li>
    </ul>
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
                body: null
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
            console.log('md list refs',this.$refs);
            this.body = new mdui.Collapse(this.$refs.body);
        }
    }
</script>

<style scoped>

</style>