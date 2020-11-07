cd detectron/datasets/data
if test -f "trained_weights/real.pkl"; then
	echo 'models are downloaded'
else
	echo 'downloading the models...'
	python ../../../tools/download.py 1YO_HP87RicnCHRCB1BzOY3WjXQQm7mUP trained_weights.tar
	tar -xzf trained_weights.tar
	rm -rf trained_weights.tar
	echo 'done'
fi
mkdir -p gun
python ../../../tools/download.py 10Ahd37N67F0W4qbAf50MoUZJ9FtCIgtX test.tar
tar -xzf test.tar -C gun
rm -rf test.tar



