import {io, Sync} from '@/lib/io';

export default {
	state: {
		async find(props){
			let storgae = await io.fetchObj(props[0]);
			let key = props[1];
			if (storgae === null) return;
			if (typeof key === 'undefined') return storgae;
			let res = storgae.data;
			for (let k = 1; k < props.length - 1; k++) {
				if (typeof res[key] === 'undefined') {
					res[key] = {};
				}
				res = res[key];
				key = props[k + 1];
			}
			return res[key];
		},
		async saveRing(prop, value) {
			console.log('save ring', prop, value);
			let key = prop[1];
			if (typeof key === 'undefined') {
				io.save(prop[0], value);
				return;
			}
			let storgae = await io.fetchObj(prop[0]);
			if (storgae === null) return;
			let res = storgae.data;
			for (let k = 1; k < prop.length - 1; k++) {
				if (typeof res[key] === 'undefined') {
					res[key] = {};
				}
				res = res[key];
				key = prop[k + 1];
			}
			res[key] = value;
			io.save(prop[0], storgae.data);
		},
		main_controller: null,
		sync: null
	},
	mutations: {
		setSync(state, mc) {
			state.main_controller = mc;
			state.sync = new Sync(mc);
		}
	}
}