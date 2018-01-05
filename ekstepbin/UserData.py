import json
import os
import sys
import base64
from Crypto.PublicKey import RSA
from Crypto.Cipher import AES, PKCS1_v1_5


dir = os.path.dirname(__file__)
json_file = os.path.join(dir,'../datapull/output3/exdata.json')
statinfo = os.stat(json_file)
if statinfo.st_size == 0:
    sys.exit()
else:
    print ("data in partner datafeed")

stud_file = open(os.path.join(dir,'../datapull/output3/student_mapping.txt'), 'w',encoding='utf-8')
key_file = open(os.path.join(dir,'../../.keys/ekstep-private.pem'), 'rb')
private_key = RSA.importKey(key_file.read())
cipher_rsa = PKCS1_v1_5.new(private_key)

for line in open(json_file, 'r'):
    jdata = json.loads(line)
    jsonstr = str(jdata["edata"]["data"]).replace('\'','"')
    partnerdata = json.loads(jsonstr)
    if 'key' in partnerdata:
        iv = partnerdata["iv"]
        key = partnerdata["key"]
        data = partnerdata["data"]

        data1 = base64.b64decode(data.encode())
        iv1 = base64.b64decode(iv.encode())
        sentinel = 'Failure'
        key1 = cipher_rsa.decrypt(base64.b64decode(key.encode()),sentinel)
        cipher = AES.new(key1, AES.MODE_CBC, iv1)
        final_data = str(cipher.decrypt(data1))
        final_data = final_data[2:final_data.find("}")+1]

        row  = json.loads(final_data)
        stud_file.write( row["uid"])
        stud_file.write("|")
        if 'student_id' in row:
            stud_file.write( row["student_id"])
        stud_file.write("|")
        if 'school_code' in row:
            stud_file.write( row["school_code"])
        stud_file.write("|")
        if 'school_name' in row:
            stud_file.write( row["school_name"])
        stud_file.write("|")
        if '_class' in row:
            stud_file.write( row["_class"])
        stud_file.write("|")
        if 'clust' in row:
            stud_file.write( row["clust"])
        stud_file.write("|")
        if 'block' in row:
            stud_file.write( row["block"])
        stud_file.write("|")
        if 'district' in row:
            stud_file.write( row["district"])
        stud_file.write("|")
        if 'child_name' in row:
            stud_file.write( row["child_name"])
        stud_file.write("|")
        if 'dob' in row:
            stud_file.write( row["dob"])
        stud_file.write("|")
        if 'sex' in row:
            stud_file.write( row["sex"])
        stud_file.write("|")
        if 'father_name' in row:
            stud_file.write( row["father_name"])
        stud_file.write("|")
        if 'mother_name' in row:
            stud_file.write( row["mother_name"])
        stud_file.write("\n")

stud_file.close()
