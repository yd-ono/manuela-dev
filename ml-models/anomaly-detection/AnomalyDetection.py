from joblib import dump, load
import numpy as np

import os, sys
import time

from pathlib import Path


# ML Framework and High Level API
import tensorflow as tf
from tensorflow import keras


class AnomalyDetection(object):
    def __init__(self):

        print("Initializing...")
        current_path = Path().cwd()

        filepath = current_path.joinpath('ml-models/anomaly-detection/lstm_autoencoder_model')

        # load the model from disk
        self.loaded_model = tf.keras.models.load_model(filepath)


    def predict(self, X, feature_names):
        print("Predict features: ", X) 
        
        X1 = np.array([X])
        
        print(X1.shape)

        prediction = self.loaded_model.predict(X1)
       
        print("Prediction: " , prediction)

        
        return prediction

if __name__ == "__main__":
    p = AnomalyDetection()
    
    X = np.asarray([[16.1,  15.40,  15.32,  13.47,  17.70]], dtype=np.float32)
    print(" Features types: ", type(X),  type(X[0][0])) 

    prediction = p.loaded_model.predict(X)
    print(prediction)


