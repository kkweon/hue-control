import axios from "axios";

interface ITpStatus {
  data: {
    result: {
      responseData: string;
    };
  };
}

interface ITpResponse {
  system: {
    get_sysinfo: object;
  };
}

/**
 * get status of tp link devices
 */
export function getStatus(
  deviceId: string,
  url: string,
  callback: (sysInfo: object) => void,
): void {
  const data = {
    method: "passthrough",
    params: {
      deviceId,
      requestData:
        '{"system": {"get_sysinfo": null}, "emeter": {"get_realtime": null}}',
    },
  };

  axios
    .post(url, data, {
      headers: {
        "cache-control": "no-cache",
        "content-type": "application/json",
      },
    })
    .then((response: ITpStatus) => {
      console.log("getStatus =>");
      const responseData: ITpResponse = JSON.parse(
        response.data.result.responseData,
      );
      const sysInfo: object = responseData.system.get_sysinfo;

      if (callback) callback(sysInfo);
    })
    .catch((error: object) => {
      console.error(error);
    });
}

export function turnOn(
  deviceId: string,
  url: string,
  callback: () => void,
): void {
  const data = {
    method: "passthrough",
    params: {
      deviceId,
      requestdata: '{"system": {"set_relay_state": {"state": 1}}}',
    },
  };

  axios
    .post(url, data, {
      headers: {
        "cache-control": "no-cache",
        "content-type": "application/json",
      },
    })
    .then((response: ITpStatus) => {
      console.log("turnOn =>");
      console.log(response);
      if (callback) callback();
    })
    .catch((error: object) => {
      console.error(error);
    });
}

export function turnOff(deviceId: string, url: string, callback: () => void) {
  const data = {
    method: "passthrough",
    params: {
      deviceId,
      requestData: '{"system": {"set_relay_state": {"state": 0}}}',
    },
  };

  axios
    .post(url, data, {
      headers: {
        "cache-control": "no-cache",
        "content-type": "application/json",
      },
    })
    .then((response: ITpStatus) => {
      console.log("turnOff() => ");
      console.log(response);
      if (callback) callback();
    })
    .catch((error: object) => {
      console.error(error);
    });
}
