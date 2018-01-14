import axios from "axios";

interface TpStatus {
    data: {
        result: {
            responseData: string
        }
    }
}

interface TpResponse {
    system: {
        get_sysinfo: object
    }
}

export function getStatus(deviceId: string, url: string, callback: (sysInfo: object) => void): void {
    const data = {
        method: "passthrough",
        params: {
            deviceId: deviceId,
            requestData: '{"system": {"get_sysinfo": null}, "emeter": {"get_realtime": null}}'
        }
    };

    axios
        .post(url, data, {
            headers: {
                "content-type": "application/json",
                "cache-control": "no-cache"
            }
        })
        .then((response: TpStatus) => {
            console.log("getStatus =>", )
            const responseData: TpResponse = JSON.parse(response.data.result.responseData);
            const sysInfo: object = responseData.system.get_sysinfo;

            if (callback) callback(sysInfo);
        }).catch((error: object) => {
            console.error(error)
        })
}

export function turnOn(deviceId: string, url: string, callback: () => void): void {
    const data = {
        method: "passthrough",
        params: {
            deviceId: deviceId,
            requestdata: '{"system": {"set_relay_state": {"state": 1}}}'
        }
    }

    axios
        .post(url, data, {
            headers: {
                "content-type": "application/json",
                "cache-control": "no-cache"
            }
        })
        .then((response: TpStatus) => {
            console.log("turnOn =>", )
            console.log(response);
            if (callback) callback();
        }).catch((error: object) => {
            console.error(error)
        })
}

export function turnOff(deviceId: string, url: string, callback: () => void) {
    const data = {
        method: "passthrough",
        params: {
            deviceId: deviceId,
            requestData: '{"system": {"set_relay_state": {"state": 0}}}'
        }
    };

    axios
        .post(url, data, {
            headers: {
                "content-type": "application/json",
                "cache-control": "no-cache"
            }
        })
        .then((response: TpStatus) => {
            console.log("turnOff() => ")
            console.log(response);
            if (callback) callback();
        }).catch((error: object) => {
            console.error(error)
        })
}
