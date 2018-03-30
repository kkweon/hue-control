import "./css/style.scss";
import * as TpLink from "./js/tplink";

const Elm = require("./elm/Main.elm");
const mountNode: HTMLElement | null = document.getElementById("app");
const app = Elm.Main.embed(mountNode);

// Tplink Port
const token: string = "74e9479a-A2qZEDqXP1y5AsCrZSFLvDm";

const appUrl = "https://use1-wap.tplinkcloud.com";
const myPlugUrl = `${appUrl}/?token=${token}`;
const deviceId = "800694C5DAE977CC4F12F237733201A417BCA26D";

function updateTpLink(): void {
  TpLink.getStatus(deviceId, myPlugUrl, app.ports.receiveInfo.send);
}

updateTpLink();

app.ports.turnOff.subscribe(() => {
  TpLink.turnOff(deviceId, myPlugUrl, updateTpLink);
});

app.ports.turnOn.subscribe(() => {
  TpLink.turnOn(deviceId, myPlugUrl, updateTpLink);
});
