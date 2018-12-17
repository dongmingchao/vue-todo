export default class device {
    constructor(window) {
        this.cordova = window.cordova;
        this.notification = new Notification(window);
        this.statusbar = window.StatusBar;
    }

    isAndroid() {
        // if (typeof cordova === 'undefined') return false;
        // else return cordova;
    }

    shake(){

    }

    /**
     * {
                    title: 'My first notification',
                    text: 'Thats pretty easy...',
                    foreground: true
                }
     */
}

class Notification {
    constructor(window) {
        this.cordova = window.cordova;
    }

    defaultSet(){
        return this.cordova.plugins.notification.local.getDefaults();
    }

    post(context) {
        this.cordova.plugins.notification.local.hasPermission(function (granted) {
            this.cordova.plugins.notification.local.schedule(context);
        });
    }
}