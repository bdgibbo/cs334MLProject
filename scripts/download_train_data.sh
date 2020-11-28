./scripts/download_test_data.sh
cd detectron/datasets/data
python ../../../tools/download.py 1bDWa-iAOWY3opnyjRxWn6rLOtLdWTz4Q train.tar
tar -xzf train.tar -C gun
rm -rf train.tar
