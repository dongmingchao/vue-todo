import MainContainer from "./component/main-container";
import MainList from "./component/main-list";
import BgImageManager from "./component/settings/bg-image-manager";
import SettingsManager from "./component/settings/manager";
import SettingsTags from '@/component/settings/tags';
import SettingsTest from '@/component/settings/test';
import SettingsDetail from '@/component/settings/detail';
import MainSettings from './component/main-setting';
import TestBtn from '@/component/test-btn';
import TdMain from '@/component/td-main';

export default [{
	path: '/',
	children:[{
		path:'/',
		component: MainList
	},{
		path: 'note',
		component: TdMain,
		props: (route) => ({
			// item: route.query.item,
			itemIndex: route.query.itemIndex
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
	},{
		path: 'detail',
		component: SettingsDetail
	}]
},{
	path: '/test',
	component: TestBtn
}]