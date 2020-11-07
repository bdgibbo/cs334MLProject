

# Gun-Detection-With-Detectron-Using-Synthetic-Data
This is an example of how synthetic data can increase quality of object detection and classification.

<div align="center">
  <img src="demo/output/image1.jpg" width="700px" />
  <p>Bounding box prediction comparision.</p>
</div>

**Table of Contents**
* [Introduction](#Introduction)
* [Installation](#Installation)
* [Usage](#Usage)
* [Detectron](#Detectron)
* [Dataset](#Dataset)

## Introduction

There are object detection and classifition tasks for which it is hard to get images to build proper train data. Such an example is the gun detection. Here demonstrated how synthetic data can significantly improve the quality of gun detection.
Project implemented using Facebook AI Research's [Detectron](https://github.com/facebookresearch/Detectron).

## Installation

Please find installation instructions for  Detectron  in [INSTALL.md](https://github.com/edgecase-ai/Detectron-Using-Synthetic-Data/blob/master/INSTALL.md)

## Usage

### Demo
Use `scripts/download_models.sh` to download trained models 
```
cd /your/Detectron-Using-Synthetic-Data/path
./scripts/download_models.sh
```
To run inference on a directory of image files (`demo/*.jpg` in this example), you can use the `infer_simple.py` tool. In this example, we are using an end-to-end trained Mask R-CNN model with a ResNet-50-FPN backbone(90000 iterations on synthetic images and then 90000 on real images):
```
python tools/infer_simple.py \
    --cfg configs/gun/real.yaml \
    --output-dir /tmp/gun-visualizations \
    --image-ext jpg \
    --wts detectron/datasets/data/trained_weights/syntheticThenReal.pkl \
    demo
```
The tool will output visualizations of the detections in PDF format in the directory specified by `--output-dir`.
  
**Notes:**

- to run Detectron with the model trained only on real images you need to specify `detectron/datasets/data/trained_weights/real.pkl` for `--wts`

### Evaluate net
Use `scripts/download_test_data.sh` to download images for evaluation
```
cd /your/Detectron-Using-Synthetic-Data/path
./scripts/download_test_data.sh
```
This example shows how to run an end-to-end trained Mask R-CNN model(90000 iterations on synthetic images and then 90000 on real images) using a single GPU for inference. As configured, this will run inference on all images in `gun_real_test`
```
python tools/test_net.py \
    --cfg configs/gun/real.yaml \
    TEST.WEIGHTS  detectron/datasets/data/trained_weights/syntheticThenReal.pkl \
    NUM_GPUS 1
```
You can see the results at the end of evaluation

**Notes:**

- to run evaluation with the model trained only on real images you need to specify `detectron/datasets/data/trained_weights/real.pkl` for `TEST.WEIGHTS`

### Training a Model
Use `scripts/download_train_data.sh` to download train data

```
cd /your/Detectron-Using-Synthetic-Data/path
./scripts/download_train_data.sh
```
#### 1. Training using only real data
```
python tools/train_net.py \
    --cfg configs/gun/real.yaml \
    OUTPUT_DIR /tmp/detectron-output/gun-real
```
  
**Expected results:**

- Training should take around 9 hours (1 x P40)
- Inference time should be around 90ms
- Box AP50 on `gun_real_val` should be around 82% 

#### 2. Training a Model on synthetic images then on real images 
Train the model on synthetic images
```
python tools/train_net.py \
    --cfg configs/gun/synthetic.yaml \
    OUTPUT_DIR /tmp/detectron-output/gun-synthetic
```
  
  Continue training of the model with real images
```
mkdir -p /tmp/detectron-output/gun-synthetic-then-real
cp /tmp/detectron-output/gun-synthetic/train/gun_synthetic_train/generalized_rcnn/model_final.pkl /tmp/detectron-output/gun-synthetic-then-real/synthetic.pkl

python tools/train_net.py \
    --cfg configs/gun/real.yaml \
    TRAIN.COPY_WEIGHTS True \
    TRAIN.WEIGHTS /tmp/detectron-output/gun-synthetic-then-real/synthetic.pkl \
    OUTPUT_DIR /tmp/detectron-output/gun-synthetic-then-real
    
```  
**Expected results:**

- Training should take around 9 hours (1 x P40)
- Inference time should be around 90ms
- Box AP50 on `gun_real_val` should be around 88.7%  


## Detectron
More about using  [Detectron](https://github.com/facebookresearch/Detectron) see [`GETTING_STARTED.md`](https://github.com/facebookresearch/Detectron/blob/master/GETTING_STARTED.md)

## Dataset
**The [edgecase.ai](https://www.edgecase.ai/)  Synthetic Gun Detection [Dataset](https://docs.google.com/forms/d/e/1FAIpQLSffVbLwfuhgSvwxrU66NDTZLfz0RrqcQ-KXJxEN9HIZiqxBeg/viewform?vc=0&c=0&w=1) - the largest open source synthetic gun detection dataset in the world.**
