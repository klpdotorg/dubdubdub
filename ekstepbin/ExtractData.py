import sys
import os
import datetime as dt
import zipfile
import gzip

dir = os.path.dirname(__file__)
path_to_zip_file = os.path.join(dir,'../datapull/response.gz')
path_to_extract1 = os.path.join(dir,'../datapull/output1')
path_to_extract2 = os.path.join(dir,'../datapull/output2')
path_to_extract3 = os.path.join(dir,'../datapull/output3')


print (path_to_zip_file)

try:
    zip_ref = zipfile.ZipFile(path_to_zip_file, "r")
except:
    print("Empty Zip")
    sys.exit()
zip_ref.extractall(path_to_extract1)
zip_ref.close()

second_level_dir = os.path.join(path_to_extract1,os.listdir(path_to_extract1)[0])
print (path_to_extract1)

if os.path.isdir(second_level_dir):
    for filename in os.listdir(second_level_dir):
        sub_zip_ref = zipfile.ZipFile(second_level_dir + '/' + filename, "r")
        sub_zip_ref.extractall(path_to_extract2)
        sub_zip_ref.close()

if not os.path.exists(path_to_extract3):
    os.makedirs(path_extract3)

exdata_file  = open(os.path.join(dir,'../datapull/output3/exdata.json'), "w", encoding="utf-8")


for foldername in os.listdir(path_to_extract2):
    for filename in os.listdir(path_to_extract2 + '/' + foldername):
        sub_sub_filename = path_to_extract2 + '/' + foldername + '/' + filename
        with gzip.open(sub_sub_filename, "rb") as f:
            for line in f:
                strline = str(line, encoding="utf-8")
                if "EXDATA" in strline:
                    exdata_file.write(strline)
exdata_file.close()
