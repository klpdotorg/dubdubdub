import requests
import json
import sys

# this program takes start and end date as parameters to submit a data request to EkStep
client_key = "98033218daf4a38dd3f009e4a7aea1f6f5f1541d"
dataset_id = "eks-consumption-summary"
start_date=sys.argv[1]
end_date=sys.argv[2]

url = "https://api.ekstep.in/data/v3/dataset/request/submit"

payload = "{\r\n\t\"id\": \"ekstep.analytics.dataset.request.submit\",\r\n\t\"ver\": \"1.0\",\r\n\t\"ts\": \"2016-12-07T12:40:40+05:30\",\r\n\t\"params\": {\r\n\t\t\"msgid\": \"4f04da60-1e24-4d31-aa7b-1daf91c46341\",\r\n\t\t\"client_key\":\""+client_key+"\"\r\n\t},\r\n\t\"request\": {\r\n\t\t\"dataset_id\":\""+dataset_id+"\",\r\n\t\t\"filter\": {\r\n\t\t\t\"start_date\":\""+start_date+"\",\r\n\t\t\t\"end_date\": \""+end_date+"\"\r\n\t\t},\r\n\t\t\"output_format\": \"json\"\r\n\t}\r\n}\r\n"

headers = {
    'content-type': "application/json",
    'authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI0YzBjNzY0ZjU4MTg0ZWFjOGEyZDFjMWU3ZTk3YTNlNiJ9.mkeRcbvS9LzVasPN8JvAOXqcMwcYRANhWaWTVxRqQgU",
    'cache-control': "no-cache",
    'postman-token': "b240ee2a-4ed9-5f45-c003-6961301014ae"
    }

response = requests.request("POST", url, data=payload, headers=headers)
print(response.text)
print(response.status_code)
if response.status_code == 200:
    content = json.loads(response.text)
    request_file = open('../datapull/request_id.txt', 'w',encoding='utf-8')#saves the request id from json to text file
    request_file.write(content["result"]["request_id"])
    request_file.write("\n")
    request_file.close()
    print("Request id saved.")
else:
    print("Request did not get submitted")


