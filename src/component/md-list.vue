<template>
    <ul class="mdui-list">
            <template v-for="(item,index) in list">
                <md-line :item="item" @click="expandTodo(index)">
                    <a slot="right" href="javascript:;" class="mdui-btn mdui-btn-icon mdui-ripple" @click="markFavorite(item,index)">
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
                <div class="mdui-list-item-title" v-show="!create">添加新的待做事项</div>
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
        props: ['list'],
        data() {
            return {
                create: null
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
                // let li = document.getElementById('todoList');
                // let target = {};
                // target.elm = li.children[index];
                // target.classList = target.elm.classList;
                // target.body = target.elm.getElementsByClassName('mdui-panel-item-body')[0];
                // if (target.classList.contains('mdui-panel-item-open')) {
                //     target.classList.remove('mdui-panel-item-open');
                // }
                // else {
                //     target.classList.add('mdui-panel-item-open');
                // }
            },
            markFavorite(item){
                console.log('mark favorite',item);
                item.favorite = !item.favorite;
            },
            changeStar(item){
                return item.favorite?'star':'star_border';
            }
        },
        computed:{

        }
    }
</script>

<style scoped>

</style>