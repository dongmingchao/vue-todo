<template>
    <mu-list textline="two-line" nested-indent style="list-style-type: none;overflow: hidden;">
        <transition-group name="flip-list" tag="div" mode="in-out">
            <template v-for="(item,index) in showList">
                <md-line :item.sync="item" :key="item.index"
                         v-if="(item!=='add')&&(item!=='finish')"
                         @settle="(prop,value) => packChange(prop,value,item.index)"
                         @click="expandTodo(index)"
                         @check="check(item,index)"
                         @delete="deleteTodo"
                         @pushNotify="pe => $emit('pushNotify',pe)"
                         :expand="isExpand">{{item.index}}
                </md-line>
                <mu-list-item :key="item" v-if="item==='add'">
                    <mu-list-item-action>
                        <i class="mdui-icon material-icons">add</i>
                    </mu-list-item-action>
                    <div class="mdui-list-item-content" style="margin-left: 0" @click="createNewTodo">
                        <div class="mdui-list-item-title" v-show="!create">{{placeholder}}</div>
                        <div class="mdui-textfield" v-show="create">
                            <input class="mdui-textfield-input" @keydown.enter="addTodo" @blur="addTodo"
                                   id="newTodoArea"
                                   placeholder="标题"/>
                        </div>
                    </div>
                </mu-list-item>
                <li v-if="item==='finish'&&checkedList.length" :key="item">
                    <mu-sub-header>已完成</mu-sub-header>
                </li>
            </template>
        </transition-group>
    </mu-list>
</template>

<script>
    import mdui from 'mdui/dist/js/mdui';
    import MdLine from "./md-line";

    export default {
        name: "md-list",
        components: {MdLine},
        props: ['list', 'isExpand', 'placeholder'],
        data() {
            return {
                create: null,
                open: 'send',
                checkedList: [],
                showList: [],
                exclude: ['add', 'finish']
                // body: null
            }
        },
        methods: {
            createNewTodo() {
                this.create = {
                    favorite: false,
                    repeats: '无',
                    prefix: '随笔'
                };
                let todo = document.getElementById('newTodoArea');
                console.log(todo);
                this.$nextTick(() => {
                    todo.focus();
                });
            },
            addTodo(e) {
                console.log('add todo change', e.target.value);
                let value = e.target.value;
                if (value !== '') {
                    this.create.label = value;
                    this.$emit('createTodo', this.create);
                }
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
            },
            packChange(prop, value, index) {
                let isArray = prop instanceof Array;
                if (!isArray) prop = [prop];
                prop.unshift(index);
                this.$emit('settle', prop, value);
            },
            check(t, i) {
                let checkedLocate = this.checkedList.indexOf(t);
                if (-1 !== checkedLocate) return this.uncheck(t, i, checkedLocate);
                let finlocate = this.showList.indexOf('finish');
                for (let f = i; f <= finlocate; f++) {
                    this.showList[f] = this.showList[f + 1]
                }
                this.showList[finlocate] = t;
                this.checkedList.push(t);
                this.$forceUpdate();
                console.log('check', this.showList);
            },
            uncheck(t, i, locate_in_check) {
                this.checkedList.splice(locate_in_check, 1);
                for (let f = i; f > 0; f--) {
                    this.showList[f] = this.showList[f - 1]
                }
                this.showList.shift();
                this.showList.unshift(t);
                console.log('uncheck', this.showList, this.checkedList, locate_in_check);
            },
            updateList() {
                while (this.showList.length > this.exclude.length) {
                    let top = this.showList.shift();
                    if (this.exclude.includes(top))
                        this.showList.push(top);
                }
                if (this.showList.length === 0) {
                    this.showList.push('add');
                    this.showList.push('finish');
                }
                console.log('list', this.showList);
                while (this.checkedList.length)
                    this.checkedList.shift();
                let unchecks = [];
                let checks = [];
                for (let each of this.list) {
                    each.index = this.list.indexOf(each);
                    if (each.checked) {
                        checks.push(each);
                        this.checkedList.push(each);
                    } else unchecks.push(each);
                }
                for (let each of unchecks.reverse()) {
                    this.showList.unshift(each);
                }
                for (let each of checks) {
                    this.showList.push(each);
                }
            },
            deleteTodo(item) {
                this.showList.splice(this.showList.indexOf(item), 1);
                this.$emit('delete', item);
                console.log('delete a todo!!', item);
            }
            // catalogChange(){
            //     this.checkedList = [[],[]];
            //     if (this.list) {
            //         for (let each of this.list) {
            //             if (each.checked) this.checkedList[1].push(each);
            //             else this.checkedList[0].push(each);
            //         }
            //     }
            // }
        },
        watch: {
            list() {
                if (!this.list) return;
                this.updateList();
            }
        },
        mounted() {
            if (this.list) this.updateList();
        }
    }
</script>

<style scoped>
    .mu-list .mu-list {
        padding-left: 34px;
    }

    .flip-list-enter-active, .flip-list-leave-active {
        transition: opacity .5s ease;
    }

    .flip-list-enter, .flip-list-leave-to {
        opacity: 0;
    }

    .flip-list-move {
        transition: transform .5s;
    }
</style>