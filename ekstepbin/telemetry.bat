echo $1
echo $2
mypath="/home/ubuntu/dubdubdub/datapull/"
file=$mypath"response"$1".gz"
filedest=$mypath"response.gz"
params=$mypath"params.json"
curl -X POST -H "Content-Type: application/json" -H "Authorization: Basic ZWtzdGVwOmdlbmllNDI=" -H "Cache-Control: no-cache" -H "Postman-Token: 9631e426-8bd8-fe95-c8d2-d93a4b46f0a3" --data-binary @"$params" "https://api.ekstep.in/telemetry/v1/datasets/D002/98033218daf4a38dd3f009e4a7aea1f6f5f1541d/$1/$2" > $file
cp $file $filedest
