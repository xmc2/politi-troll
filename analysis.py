# opening up the file and the badword file
# python 3.5

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from numpy import genfromtxt


a_file = open('badwords.txt', encoding='latin-1')


db = pd.read_csv('outputs/db.csv', sep=',', header=0, encoding='latin-1')
print(db.head())
db['text1']
