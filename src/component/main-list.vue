<template>
    <md-list lockAxis="y"
             class="main-list"
             :pressDelay="1000"
             helperClass="mu-list mu-list-two-line moveFix"
             :shouldCancelStart="cancelMove"
             @sort-start="moveStart"
             @sort-end="moveEnd"
             v-model="list">
        {{listWatcher}}
        <transition-group :name="moving?'':'flip-list'"
                          tag="div">
            <!--v-bind:css="false"-->
            <!--v-on:before-enter="beforeEnter"-->
            <!--v-on:enter="enter"-->
            <!--v-on:leave="leave"-->
            <template v-for="(item,index) in showList">
                <!--@click="expandTodo(index)"-->
                <md-line :item-index="item.index" :key="item.index"
                         :style="{
                            '--tdRmSpeed': settings.tdlist.delspeed+'ms',
                            '--tdMoveSpeed': settings.tdlist.movespeed+'ms'
                            }"
                         :index="item.index"
                         v-if="(item!=='add')&&(item!=='finish')"
                         @settle="(prop,value) => packChange(prop,value,item.index)"
                         @check="check(item,index)"
                         @delete="itm => deleteTodo(itm, index)"
                         @moveItemStart="changeOrderStart"
                         @moveItemFinish="changeOrderFinish"
                         ref="listItems"
                         @pushNotify="pe => $emit('pushNotify',pe)">
                    <!--{{item.index}}-->
                </md-line>
                <!--@contextmenu.native.prevent.stop="longTap(item,index)"-->
                <mu-list-item :key="item" v-if="item==='add'">
                    <mu-list-item-action>
                        <i class="mdui-icon material-icons">add</i>
                    </mu-list-item-action>
                    <div class="mdui-list-item-content" style="margin-left: 0" @click="createNewTodo">
                        <div class="mdui-list-item-title" v-show="!create">添加新的待做事项</div>
                        <div class="mdui-textfield" v-show="create">
                            <input class="mdui-textfield-input" @keydown.enter="addTodo" @blur="addTodo"
                                   id="newTodoArea"
                                   placeholder="标题"/>
                        </div>
                    </div>
                </mu-list-item>
                <li v-if="item==='finish'" :key="item">
                    <mu-sub-header>{{checkedList.length}}条计划已完成</mu-sub-header>
                </li>
            </template>
        </transition-group>
    </md-list>
</template>

<script>
    import MdLine from "@/component/md-line";

    export default {
        name: "main-list",
        components: {MdLine},
        data() {
            let self = this;
            return {
                create: null,
                checkedList: [],
                showList: ['add', 'finish'],
                exclude: ['add', 'finish'],
                canDrag: true,
                moving: false,
                list: [],
                catalog: null
            }
        },
        computed: {
            settings(vm) {
                return vm.$store.state.settings;
            },
            listWatcher(vm) {
                let ret = vm.$store.state.selected.catalog.data.todoList;
                if (typeof ret === 'undefined') return;
                this.list = ret;
                if (this.catalog !== vm.$store.state.selected.catalog.prop) {
                    this.updateList();
                    this.catalog = vm.$store.state.selected.catalog.prop;
                    // this.moving = true;
                    // this.$nextTick(() => {
                    //     this.moving = false;
                    // });
                }
            }
        },
        methods: {
            beforeEnter: function (el) {
                el.style.opacity = 0;
                el.style.transition = 'opacity .5s ease';
            },
            enter: function (el, done) {
                el.style.opacity = 1;
                setTimeout(function () {
                    done();
                }, 500);
            },
            leave: function (el, done) {
                el.style.opacity = 0;
                setTimeout(function () {
                    done();
                }, 500);
            },
            createNewTodo() {
                let self = this;
                this.create = {
                    createdAt: new Date(),
                    favorite: false,
                    repeats: '单次',
                    tags: [{
                        label: '随笔',
                        color: 'primary'
                    }],
                    index: self.list.length
                };
                let todo = document.getElementById('newTodoArea');
                this.$nextTick(() => {
                    todo.focus();
                    this.$emit('event:focus', todo);
                });
            },
            longTap(e, i) {
                this.menuopen = true;
                let ul = this.$refs.listItems;
                this.triggerIndex = i;
                for (let each of ul) {
                    if (each.item === e) {
                        this.trigger = each.$el;
                        break;
                    }
                }
            },
            addTodo(e) {
                console.log('add todo change', e.target.value);
                let value = e.target.value;
                if (value !== '') {
                    this.create.label = value;
                    this.$emit('createTodo', this.create);
                    this.updateList();
                }
                e.target.value = '';
                this.create = null;
            },
            expandTodo(index) {
                this.menuopen = false;
                console.log('md list expand', index);
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
                for (let f = i; f < finlocate; f++) {
                    this.showList[f] = this.showList[f + 1]
                }
                this.showList[finlocate] = t;
                this.checkedList.push(t);
                this.$forceUpdate();
                console.log('check', this.showList, this.checkedList);
                this.saveOrder();
            },
            uncheck(t, i, locate_in_check) {
                this.checkedList.splice(locate_in_check, 1);
                for (let f = i; f > 0; f--) {
                    this.showList[f] = this.showList[f - 1]
                }
                this.showList.shift();
                this.showList.unshift(t);
                console.log('uncheck', this.showList, this.checkedList, locate_in_check);
                this.saveOrder();
            },
            saveOrder() {
                let beSave = [];
                let index = 0;
                for (let i = 0; i < this.showList.length; i++) {
                    if (this.exclude.includes(this.showList[i])) continue;
                    let each = Object.assign({}, this.showList[i]);
                    each.index = index;
                    beSave.push(each);
                    index++;
                }
                console.log('be save order', beSave);
                let poc = {
                    prop: ['todoList'],
                    value: beSave
                };
                setTimeout(() => {
                    this.$store.commit('saveOfCatalog', poc);
                }, 500);
                setTimeout(() => {
                    this.updateList();
                    this.moving = true;
                    poc.prop.unshift(this.$store.state.selected.catalog.prop);
                    this.$store.state.io.saveRing(poc.prop, poc.value);
                    // this.updateList();
                    this.$nextTick(() => {
                        this.moving = false;
                    });
                }, 500);
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
                console.log('update list', this.showList);
                while (this.checkedList.length)
                    this.checkedList.shift();
                let unchecks = [];
                let checks = [];
                for (let each of this.list) {
                    // each.index = this.list.indexOf(each);
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
            deleteTodo(item, index) {
                this.showList.splice(index, 1);
                setTimeout(() => {
                    this.$emit('delete', item);
                }, this.settings.tdlist.delspeed);
                console.log('delete a todo!!', item, this.showList);
            },
            // catalogChange(){
            //     this.checkedList = [[],[]];
            //     if (this.list) {
            //         for (let each of this.list) {
            //             if (each.checked) this.checkedList[1].push(each);
            //             else this.checkedList[0].push(each);
            //         }
            //     }
            // }
            // changeOrder(item, move, lastMove) {
            //     let direct = 1;
            //     if (move < 0) direct = -1;
            //     let index = this.showList.indexOf(item);
            //     let m = move - lastMove;
            //     console.log('改变列表顺序', this.showList, index, move, lastMove);
            //     let beReplace = this.showList[index + m];
            //     console.log('要被替换的元素', beReplace);
            //     if (this.exclude.includes(beReplace)) return;
            //     this.showList[index] = beReplace;
            //     this.showList[index + m] = item;
            //     this.$forceUpdate();
            // },
            changeOrderStart(item) {
                console.log('main list hold', item);
                this.$el.ontouchmove = e => e.preventDefault();
                this.holdItem = item.index;
                this.canDrag = true;
            },
            changeOrderFinish() {
                this.$el.ontouchmove = null;
                this.holdItem = null;
                this.canDrag = false;
            },
            moveStart(event) {
                console.log('move start', event, this.showList);
                this.moving = true;
                // event.node.firstChild.firstChild.classList.add('is-selected');
            },
            moveEnd(val) {
                let tempList = this.list.slice();
                let offset = 0;
                let min, max, shouldOffset;
                if (val.oldIndex < val.newIndex) {
                    min = val.oldIndex;
                    max = val.newIndex;
                    shouldOffset = 1;
                } else if (val.oldIndex > val.newIndex) {
                    min = val.newIndex;
                    max = val.oldIndex;
                    shouldOffset = -1;
                }
                if (val.newIndex === 0) min++;
                if (val.newIndex === this.list.length - 1) max--;
                for (let i = min; i <= max; i++) {
                    tempList[i] = this.list[i + shouldOffset];
                    console.log(i, '->', i + shouldOffset);
                }
                tempList[val.newIndex] = this.list[val.oldIndex];
                for (let i = 0; i < tempList.length; i++) {
                    tempList[i].index = i;
                }
                // let beSave = {
                //     prop: ['todoList'],
                //     value: tempList
                // };
                // this.$store.commit('saveOfCatalog', beSave);
                this.$nextTick(() => {
                    this.updateList();
                });
                let bridge = [this.$store.state.selected.catalog.prop, 'todoList'];
                // this.$store.state.io.saveRing(beSave.prop, beSave.value);
                this.$store.commit('fixBridge', {
                    old: bridge.concat(val.oldIndex),
                    now: bridge.concat(val.newIndex)
                });
                this.$store.dispatch('saveTodoListChange', {
                    value: tempList,
                    prop: [],
                    ext: {
                        props: ['index']
                    }
                });
                this.moving = false;
                console.log('move finish', tempList, val);
            },
            cancelMove(e) {
                if (!this.canDrag) return true;
                const disabledElements = ['input', 'textarea', 'select', 'option', 'button'];
                return disabledElements.indexOf(e.target.tagName.toLowerCase()) !== -1;
            }
            // siderOnResize() {
            //     if (window.innerWidth > 1023) {
            //         this.$el.style.width = 'calc(100% - 256px)';
            //     } else {
            //         this.$el.style.width = '100%';
            //     }
            // }
        },
        mounted() {
            // window.addEventListener('resize', this.siderOnResize);this.siderOnResize();
        }
    }
</script>

<style scoped>
    .moveFix {
        overflow-y: hidden;
        padding: 0;
    }

    .main-list {
        height: calc(100% - 10rem);
        overflow-y: scroll;
        position: absolute;
        /*top: 10rem;*/
        width: calc(100% - 256px);
        transition: width .45s cubic-bezier(.23, 1, .32, 1);
    }

    @media (max-width: 1023px) {
        .main-list {
            width: 100%;
        }
    }

    .flip-list-enter-active, .flip-list-leave-active {
        transition: opacity var(--tdRmSpeed) ease;
    }

    .flip-list-enter {
        opacity: 0;
    }

    .flip-list-leave-to {
        opacity: 0;
    }

    .flip-list-move {
        transition: transform var(--tdMoveSpeed);
    }
</style>