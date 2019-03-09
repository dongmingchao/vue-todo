import catalog from "./catalog.coffee";

export default {
    state: {
        side_list: null
    },
    mutations: {
        setSideList(state, list) {
            state.side_list = list
        }
    },
    actions:{

    },
    modules: {
        catalog
    }
}