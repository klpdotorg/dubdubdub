import urllib.request, urllib.parse, urllib.error
import sys
import os
import datetime as dt
import zipfile
import gzip
import shutil
from shutil import copyfile

# The argument to this program is the date for which you are processing the data
date=sys.argv[1]
print (date)
dir = os.path.dirname(__file__)
reqID_file = open(os.path.join(dir,"../datapull/request_id.txt"),"r")#takes the request id from text file
reqID = (reqID_file.read()).rstrip("\r\n")
print(reqID)
url = 'https://s3-ap-south-1.amazonaws.com/ekstep-public-prod/data-exhaust/'+str(reqID)+'.zip'
print(url)
f = urllib.request.urlopen(url)
data = f.read()
with open(os.path.join(dir,"../datapull/v3data.zip"), "wb") as code:
    code.write(data)
path_to_zip_file = os.path.join(dir,'../datapull/v3data.zip')
path_to_extract1 = os.path.join(dir,'../datapull/ekstepv3data')
try:
    zip_ref = zipfile.ZipFile(path_to_zip_file, "r")
except:
    print("Empty Zip")
    sys.exit()
zip_ref.extractall(path_to_extract1)
zip_ref.close()
print ("File downloaded and unzzipped.")
src = os.path.join(dir,"../datapull/ekstepv3data/data/ME_SESSION_SUMMARY.json")
dst = os.path.join(dir,"../datapull/ekstepv3data/history/ME_SESSION_SUMMARY")+str(date)+".json"
copyfile(src, dst)
