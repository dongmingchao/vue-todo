import App from './App'
import MainContainer from "./component/main-container";
import BgImageManager from "./component/bg-image-manager";
import SettingsManager from "./component/settings-manager";
import MainSettings from './component/main-setting';

export default [{
	path: '/',
	component: MainContainer
},{
	path: '/settings/manager',
	component: SettingsManager
},{
	path: '/settings/bg-image',
	component: BgImageManager
}]