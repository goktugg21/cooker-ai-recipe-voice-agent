#This script counts the number of each intent in the train and test datasets.
#Output shows the distribution of intents for the PCA recipe assistant.


import json
from collections import Counter

# ppen train data
f = open("train.json")
train = json.load(f)
f.close()

# open test data
f = open("test.json")
test = json.load(f)
f.close()
    
# count intents in train
train_counts = {}
for item in train:
    intent = item["intent"]
    if intent in train_counts:
        train_counts[intent] = train_counts[intent] + 1
    else:
        train_counts[intent] = 1

# count intents in test
test_counts = {}
for item in test:
    intent = item["intent"]
    if intent in test_counts:
        test_counts[intent] = test_counts[intent] + 1
    else:
        test_counts[intent] = 1

# print results
print("TRAIN INTENTS:")
for intent in train_counts:
    print(intent + ": " + str(train_counts[intent]))

print("")
print("TEST INTENTS:")
for intent in test_counts:
    print(intent + ": " + str(test_counts[intent]))

print("")
print("Total train: " + str(len(train)))
print("Total test: " + str(len(test)))