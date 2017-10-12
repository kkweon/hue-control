/* jshint esversion:6 */
const Elm = require("./elm/Main.elm");
const PortModule = require("./elm/Tplink/Tplink.elm");
const Tplink = require("./js/tplink.js");

require("./css/style.scss");

var mountNode = document.getElementById("app");
var app = Elm.Main.embed(mountNode);

// Tplink Port
const token = "74e9479a-be5813fd26d040a293430fc";
const appUrl = "https://use1-wap.tplinkcloud.com";

const myPlugUrl = appUrl + "/?token=" + token;
const deviceId = "800694C5DAE977CC4F12F237733201A417BCA26D";

function updateTplink() {
    Tplink.getStatus(deviceId, myPlugUrl, app.ports.receiveInfo.send);
}
updateTplink();

app.ports.turnOff.subscribe((ip) => {
    console.log("TurnOff");
    Tplink.turnOff(deviceId, myPlugUrl, updateTplink);
});


app.ports.turnOn.subscribe((ip) => {
    console.log("TurnOn");
    Tplink.turnOn(deviceId, myPlugUrl, updateTplink);
});
