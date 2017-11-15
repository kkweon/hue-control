import requests
import os

data = {
    "method": "login",
    "params": {
        "appType": "Kasa_Android",
        "cloudUserName": os.environ["GMAIL_ID"] + "@gmail.com",
        "cloudPassword": os.environ["GMAIL_PW"],
        "terminalUUID": "49390202-5cdb-4012-b8ff-84b4a9f4f611"
    }
}

url = "https://wap.tplinkcloud.com"

res = requests.post(url, json=data)
print(res.text)
