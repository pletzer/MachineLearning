## How to count dots using TensorFlow

# Install the software

You must have Anaconda installed. 
```
conda install -c conda-forge tensorflow tensorflow-hub
```

Download the retrain.py script
```
curl -LO https://github.com/tensorflow/hub/raw/master/examples/image_retraining/retrain.py
```

Download the label_image.py script
```
curl -LO https://github.com/tensorflow/tensorflow/raw/master/tensorflow/examples/label_image/label_image.py
```

# Prepare the data

Image files should be put in directory `train` with subdirectories `1`, `2`, ... `5` according to the number of dots in the file
```
for line in $(cat ../../Data/Synthetic/Dots/train/train.csv); do
  id=$(echo $line | awk -F, '{print $2}')
  if [ $id != "\"imageId\"" ]; then
    numDots=$(echo $line | awk -F, '{print $3}')
    mkdir -p train/$numDots
    echo "copying ../../Data/Synthetic/Dots/train/img${id}.jpg to train/$numDots"
    cp ../../Data/Synthetic/Dots/train/img${id}.jpg train/$numDots
  fi
done
```

# Re-train the model

```
rm -rf output; mkdir -p output/intermediate; mkdir -p output/summaries
python retrain.py --image_dir=train \
       --summary_dir=output/summaries --saved_model_dir=output/model \
       --output_labels=output/labels.txt --output_graph=output/graph.pb
```

# Check how well the training performed

```
tensorboard --logdir=/tmp/retrain_logs/
```

# Test the classification

```
score="0"
numFailures="0"
for line in $(cat ../../Data/Synthetic/Dots/test/test.csv); do
  id=$(echo $line | awk -F, '{print $2}')
  if [ $id != "\"imageId\"" ]; then
    numDots=$(echo $line | awk -F, '{print $3}')
    # classify
    echo "classifying img${id}.jpg"
    python label_image.py --image=../../Data/Synthetic/Dots/test/img${id}.jpg \
       --graph=output/graph.pb --labels=output/labels.txt \
       --input_layer=Placeholder --output_layer=final_result >& result.txt
    # find the most likely label
    gotNumDots=$(python findNumDots.py result.txt)
    diffSquare=$(python -c "print(($numDots - $gotNumDots)**2)")
    if [ $diffSquare != "0" ]; then
      echo "found $gotNumDots in img${id}.jpg but there were $numDots dots"
      numFailures=$(python -c "print($numFailures + 1)")
    else
      echo "found $numDots dots (correct)"
    fi
    # update the score
    score=$(python -c "print($score + $diffSquare)")
  fi
done
echo "score is $score"
echo "number of failures: $numFailures"
```