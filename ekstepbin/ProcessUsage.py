import os
import json
import time
import sys

DeviceList = sys.argv[1] #this takes device list as argument
TagList = sys.argv[2] #this takes Tag list as argument

dir = os.path.dirname(__file__)
json_file = os.path.join(dir, '../datapull/ekstepv3data/data/ME_SESSION_SUMMARY.json')
output_file = os.path.join(dir, '../datapull/usage.txt')
usage_file = open(output_file, 'w',encoding='utf-8')

with open (os.path.join(dir, '../datapull/'+DeviceList)) as f:
    device_list = [line.rstrip() for line in f]
with open (os.path.join(dir, '../datapull/'+TagList)) as e:
    tag_list = [line.rstrip() for line in e]

for line in open(json_file, 'r'):
    valid_data = False
    data = json.loads(line)
    if 'app' in data["etags"]:
        if len(data["etags"]["app"]) > 0:
            if str(data["etags"]["app"][0]) in tag_list:
                valid_data = True
    if not valid_data:
       if (str(data["dimensions"]["did"]) in device_list):
           valid_data = True
    if valid_data:
            usage_file.write( data["mid"])
            usage_file.write("|")
            usage_file.write( data["uid"])
            usage_file.write("|")
            usage_file.write( data["dimensions"]["did"])
            usage_file.write("|")
            usage_file.write( str(data["edata"]["eks"]["timeSpent"]))
            usage_file.write("|")
            usage_file.write( str(data["dimensions"]["gdata"]["id"]))
            usage_file.write("|")
            s=int(data["context"]["date_range"]["from"])/1000.0
            usage_file.write( time.strftime("%Y-%m-%dT%H:%M:%S",time.localtime(s)))
            usage_file.write("|")
            s=int(data["context"]["date_range"]["to"])/1000.0
            usage_file.write( time.strftime("%Y-%m-%dT%H:%M:%S",time.localtime(s)))
            usage_file.write("|")
            s=int(data["syncts"])/1000.0
            usage_file.write( time.strftime("%Y-%m-%dT%H:%M:%S",time.localtime(s)))
            usage_file.write("\n")

usage_file.close()

