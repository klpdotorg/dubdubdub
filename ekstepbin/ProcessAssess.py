import os
import json
import time
import sys

DeviceList = sys.argv[1] #this takes device list as argument

dir = os.path.dirname(__file__)
json_file = os.path.join(dir, '../datapull/ekstepv3data/data/ME_SESSION_SUMMARY.json')
output_file = os.path.join(dir, '../datapull/assessment.txt')
assess_file = open(output_file, 'w',encoding='utf-8')

with open (os.path.join(dir, '../datapull/'+DeviceList)) as f:
    device_list = [line.rstrip() for line in f]

for line in open(json_file, 'r', encoding='utf8'):
    data = json.loads(line)
    mid = data["mid"]
    uid = data["uid"]
    did = data["dimensions"]["did"]
    syncts = data["syncts"]
    gdataid = data["dimensions"]["gdata"]["id"]
    if str(did) in device_list: #Devices in ESL
            if len(data["edata"]["eks"]["itemResponses"]) > 0:
                for i in range(len(data["edata"]["eks"]["itemResponses"])):
                    assess_file.write(mid)
                    assess_file.write("|")
                    assess_file.write(uid)
                    assess_file.write("|")
                    assess_file.write(did)
                    assess_file.write("|")
                    assess_file.write(gdataid)
                    assess_file.write("|")
                    assess_file.write(str(i+1))
                    assess_file.write("|")
                    assess_file.write(data["edata"]["eks"]['itemResponses'][i]['itemId'])
                    assess_file.write("|")
                    assess_file.write(str(data["edata"]["eks"]["itemResponses"][i]["timeSpent"]))
                    assess_file.write("|")
                    s=int(data["edata"]["eks"]["itemResponses"][i]["time_stamp"])/1000.0
                    assess_file.write( time.strftime("%Y-%m-%dT%H:%M:%S",time.localtime(s)))
                    assess_file.write("|")
                    assess_file.write(str(data["edata"]["eks"]["itemResponses"][i]["score"]))
                    assess_file.write("|")
                    assess_file.write(data["edata"]["eks"]["itemResponses"][i]["pass"])
                    assess_file.write("|")
                    if 'resValues' in data["edata"]["eks"]["itemResponses"][i]:
                        assess_file.write(str(data["edata"]["eks"]["itemResponses"][i]["resValues"]).replace('\n','').replace('\r',''))
                    assess_file.write("|")
                    if 'qtitle' in data["edata"]["eks"]["itemResponses"][i]:
                        assess_file.write(str(data["edata"]["eks"]["itemResponses"][i]["qtitle"]))
                    assess_file.write("|")
                    s=int(syncts)/1000.0
                    assess_file.write( time.strftime("%Y-%m-%dT%H:%M:%S",time.localtime(s)))
                    assess_file.write("\n")
assess_file.close()
