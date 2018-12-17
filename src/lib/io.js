import localforge from 'localforage';

export default {
    delay() {
        return new Promise((s, j) => {
            setTimeout(s, 1000);
        })
    },

    /**
     * 按照key获取值，获取最新的值，并通过[api]更新本地存储
     * @param key 对象键名
     * @returns {Promise<{data:*,expire:string}|*>}
     *          null: 本地没有这个值
     *          object: 返回最新的这个值
     */
    async fetchObj(key) {
        console.log('io:fetch object', key);
        let update = await this.isUpdate(key);
        if (update === null) return null;
        if (update === false) {
            let v = await this.fetch(local.data.api);
            await this.delay();
            this.save(key, v);
        }
        let local = await localforge.getItem(key);
        return local;
    },

    /**
     *
     * @param key 请求搜索的键名
     * @param url 如果键名没有或过期，请求的url
     * @returns {Promise<*|string|HTMLElement|BodyInit|ReadableStream>}
     */
    async autofetch(key, url) {
        let local = await this.fetchObj(key);
        if (local === null) {
            local = await this.fetch(url);
            this.save(key, local.data);
        }
        return local.data.body;
    },

    /**
     *
     * @param url
     * @returns {Promise<{data: *}>}
     */
    async fetch(url) {
        let request = new Promise((r, j) => {
            let oReq = new XMLHttpRequest();
            oReq.open("GET", url);
            oReq.send();
            oReq.onload = function () {
                r(this.responseText);
            }
        });
        let res = await request;
        res = JSON.parse(res);
        console.log('io:fetch', res);
        return {data: res};
    },

    /**
     *
     * @param {Object} options 各种参数都在这个选项
     * @param {'GET'|'POST'}    options.method [options.method=GET] GET 或 POST请求
     * @param {string}          options.url 请求的api
     * @param {Object}               options.data 请求发送的数据
     * @returns {Promise<*>} 请求返回的数据
     */
    async request(options) {
        let request = new Promise((r, j) => {
            let oReq = new XMLHttpRequest();
            oReq.open(options.method, options.url);
            oReq.setRequestHeader('content-type', 'application/json');
            oReq.send(JSON.stringify(options.data));
            oReq.onload = function () {
                r(this.responseText);
            };
            oReq.onerror = function (ev) {
                r({status: 'error', msg: ev});
            }
        });
        let res = await request;
        res = JSON.parse(res);
        console.log('io:request', res);
        return res;
    },

    save(key, value) {
        let v = {expire: new Date().toJSON(), data: value};
        localforge.setItem(key, v);
    },
    remove(key) {
        localforge.removeItem(key);
    },

    /**
     * 检查某个对象是否是最新的，若本地无值，则不是最新的(null)
     * 若本地有值，则会使用[checkExpire]检查最新的[expire]，并和本地进行对比
     * @param key
     * @returns {Promise<*>}
     * null: 无值
     * true: 是最新的，不必更新
     * false: 不是最新的，需要更新
     */
    async isUpdate(key) {
        let local = await localforge.getItem(key);
        if (local === null) return null;
        if (local.data.checkExpire) {
            let res = await this.fetch(local.data.checkExpire);
            res = res.data;
            return res.expire <= local.expire;
        } else return true;
    }
}