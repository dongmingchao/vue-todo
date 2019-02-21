import MainContainer from "./component/main-container";
import BgImageManager from "./component/settings/bg-image-manager";
import SettingsManager from "./component/settings/manager";
import SettingsTags from '@/component/settings/tags';
import SettingsTest from '@/component/settings/test';
import MainSettings from './component/main-setting';
import TestBtn from '@/component/test-btn';
import TdNote from '@/component/td-note';
import MdList from "@/component/md-list";

export default [{
	path: '/',
	children:[{
		path:'/',
		component: MdList
	},{
		path: 'note',
		component: TdNote,
		props: (route) => ({
			item: route.query.item,
			index: route.query.index
		})
	}],
	component: MainContainer
},{
	path: '/settings',
	component: MainSettings,
	children:[{
		path: 'manager',
		component: SettingsManager
	},{
		path: 'tags',
		component: SettingsTags
	},{
		path: 'bg-image',
		component: BgImageManager
	},{
		path: 'test',
		component: SettingsTest
	}]
}]