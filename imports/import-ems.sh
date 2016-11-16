# TODO: Check if the csv data can be copied from devi's home in pre-import
# ./imports/pre-import.sh -d dubdubdub

./imports/importdatatodb.sh -d dubdubdub -t
./imports/importdatafromdb.sh -d dubdubdub

# TODO: make post-import accept -d param
./imports/post-import.sh -d dubdubdub