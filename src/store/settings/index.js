import Vue from 'vue';
import {io} from '@/lib/io';
import localconfig from '@/lib/config/local';

export default {
    state: {
        tdlist: {
            delspeed: 200,
            movespeed: 500
        }
    },
    mutations: {
        saveOfSettings(state, {prop, value}) {
            let res = state;
            let key = prop[0];
            for (let k = 1; k < prop.length; k++) {
                if (typeof res[key] === 'undefined') {
                    res[key] = {};
                }
                res = res[key];
                key = prop[k];
            }
            Vue.set(res, key, value);
            console.log('save of settings', prop, value)
        }
    },
    actions: {
        async activateSettings({state, commit, rootState}) {
            let settings = await io.fetchObj(localconfig.dbname.settings);
            if (settings === null) return;
            let res = settings.data;
            for (let key of Object.keys(res))
                commit('saveOfSettings', {
                    prop: [key],
                    value: res[key]
                });
        }
    }
}