# leaf-disease-detection
A Matlab implementation of leaf disease detection using computer vision techniques

The project includes 3 matlab scripts

1) store_feat.m - On running, this script file creates the training features dataset along with the train and test labels.

2) Detect.m - On running, this script asks for whether you want to take a webcam input.
  1 - yes. allows the user to take a snapshop of the leaf through webcam and then perform disease detection.
  2 - no. allows the user to select the leaf image from the existing database of images
              
   After identifying the disease the leaf belongs to, it asks whehter the user needs the calculation of diease affected area.
  1 - yes. asks user for 5 datapoints from the user to graphcut the leaf for calculation of the percentage of leaf area that is disease affected.
  2 - exits.
   
3) Detect_test.m - On running, this script will test the available test dataset of 80 images, generate the confusion matrix and calculate the accuracy.
