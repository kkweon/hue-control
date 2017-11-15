/* jshint esversion:6 */

export function getStatus(deviceId, url, callback) {
  let data = JSON.stringify({
    method: "passthrough",
    params: {
      deviceId: deviceId,
      requestData:
        '{"system": {"get_sysinfo": null}, "emeter": {"get_realtime": null}}'
    }
  });

  let xhr = new XMLHttpRequest();
  xhr.withCredentials = true;

  xhr.addEventListener("readystatechange", function() {
    if (this.readyState === 4) {
      let result = JSON.parse(this.responseText).result.responseData;
      let log = JSON.parse(result).system.get_sysinfo;
      console.log(log);
      if (callback) {
        callback(log);
      }
    }
  });

  xhr.open("POST", url);
  xhr.setRequestHeader("content-type", "application/json");
  xhr.setRequestHeader("cache-control", "no-cache");
  xhr.send(data);
}

export function turnOn(deviceId, url, callback) {
  let data = JSON.stringify({
    method: "passthrough",
    params: {
      deviceId: deviceId,
      requestData: '{"system": {"set_relay_state": {"state": 1}}}'
    }
  });

  let xhr = new XMLHttpRequest();
  xhr.withCredentials = true;

  xhr.addEventListener("readystatechange", function() {
    if (this.readyState === 4) {
      console.log("called turnOn from tplink.js", this.responseText);
      if (callback) callback();
    }
  });

  xhr.open("POST", url);
  xhr.setRequestHeader("content-type", "application/json");
  xhr.setRequestHeader("cache-control", "no-cache");
  xhr.send(data);
}

export function turnOff(deviceId, url, callback) {
  let data = JSON.stringify({
    method: "passthrough",
    params: {
      deviceId: deviceId,
      requestData: '{"system": {"set_relay_state": {"state": 0}}}'
    }
  });

  let xhr = new XMLHttpRequest();
  xhr.withCredentials = true;

  xhr.addEventListener("readystatechange", function() {
    if (this.readyState === 4) {
      console.log("called turnOff from tplink.js", this.responseText);
      if (callback) callback();
    }
  });

  xhr.open("POST", url);
  xhr.setRequestHeader("content-type", "application/json");
  xhr.setRequestHeader("cache-control", "no-cache");
  xhr.send(data);
}
