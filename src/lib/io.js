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
     * @returns {Promise<{data:*,expire:string}|null>}
     *          null: 本地没有这个值
     *          object: 返回最新的这个值
     */
    async fetchObj(key) {
        console.log('io:fetch object', key);
        let update = await this.isUpdate(key);
        if (update === null) return null;
        if (update === false) {
            let v = await this.fetch(local.data.api);
            this.save(key, v);
        }
        let local = await localforge.getItem(key);
        return local;
    },

    /**
     *
     * @param url
     * @returns {Promise<{data: *}>}
     */
    async fetch(url) {
        let res = await fetch(url);
        res = await res.json();
        console.log('io:fetch', res);
        await this.delay();
        return {data: res};
    },

    save(key, value) {
        let v = {expire: new Date().toJSON(), data: value};
        localforge.setItem(key, v);
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
        let res = await fetch(local.data.checkExpire);
        res = await res.json();
        return res.expire <= local.expire;
    }
}