export default {
    host: '',
    login: {
        api: '/api/user/login'
    },
    signUp: {
        api: '/api/user/register'
    },
    logout: {
        api: '/api/user/logout'
    },
    catalog: {
        remove: {
            api: '/api/catalog/delete'
        },
        add: {
            api: '/api/catalog/add'
        },
        list: {
            api: '/api/catalog/list'
        }
    },
    todo: {
        add: {
            api: '/api/item/add'
        },
        addStep: {
            api: '/api/item/step/add'
        }
    }
}