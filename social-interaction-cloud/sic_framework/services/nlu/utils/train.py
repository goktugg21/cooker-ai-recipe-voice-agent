"""
train.py

This module provides the training functionality for a BERT-based Natural Language Understanding (NLU) intent_slot_classification_model
designed for intent classification and slot filling tasks. The intent_slot_classification_model leverages tokenized input with BIO tagging
for slot filling.

Features:
1. `train_model`:
   - Trains a BERT-based intent_slot_classification_model for intent classification and slot filling.
   - Uses separate loss functions for intent and slot tasks.
   - Optimizes the intent_slot_classification_model using backpropagation over multiple epochs.
   - Supports training on both CPU and GPU.

Dependencies:
- `NLURecipeDataset`: A dataset class for tokenized and padded inputs.
- `BERTNLUModel`: The BERT-based intent_slot_classification_model for intent and slot prediction.
- PyTorch: For run_data loading, intent_slot_classification_model training, and optimization.

Usage:
- Import `train_model` and call it with the preprocessed dataset and intent_slot_classification_model configuration:
    from train import train_model
    intent_slot_classification_model = train_model(...)
"""

import torch
from torch.utils.data import DataLoader
import torch.nn as nn
from sic_framework.services.nlu.utils.dataset import  NLURecipeDataset
from sic_framework.services.nlu.utils.model import BERTNLUModel


def train_model(model, dataset, num_epochs=3, batch_size=2, learning_rate=5e-5, device="cpu"):
    """
    Trains a BERT-based Natural Language Understanding (NLU) model for intent classification and slot filling.

    Args:
        model (BERTNLUModel): The BERT-based model to be trained.
        dataset (NLURecipeDataset): A preprocessed dataset ready for training.
        num_epochs (int): The number of epochs to train the model. Default is 3.
        batch_size (int): The size of data batches used in training. Default is 2.
        learning_rate (float): The learning rate for the Adam optimizer. Default is 5e-5.
        device (str or torch.device): The device to use for training ("cpu" or "cuda"). Default is "cpu".

    Returns:
        BERTNLUModel: The trained model, ready for evaluation or inference.
    """
    # Move the model to the specified device (e.g., CPU or CUDA)
    model.to(device)

    # Define the loss functions for intent and slot classification
    intent_loss_fn = nn.CrossEntropyLoss()
    slot_loss_fn = nn.CrossEntropyLoss()

    # Define the optimizer (use torch.optim.Adam with the model parameters and learning_rate)
    optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)

    # Prepare the DataLoader
    dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=True)

    # Training loop for the specified number of epochs
    for epoch in range(num_epochs):
        # Set the model to training mode
        model.train()

        for batch in dataloader:
            # Zero out gradients from the previous step
            optimizer.zero_grad()

            # Move inputs and labels to the specified device
            input_ids = batch['input_ids'].to(device) 
            attention_mask = batch['attention_mask'].to(device) 
            intent_labels = batch['intent_label'].to(device).long()
            slot_labels = batch['slot_labels'].to(device).long()
            # Perform a forward pass through the model
            intent_logits, slot_logits = model(input_ids, attention_mask)

            # Compute the intent and slot losses
            intent_loss = intent_loss_fn(intent_logits, intent_labels)
            slot_loss = slot_loss_fn(slot_logits.view(-1, slot_logits.shape[-1]), slot_labels.view(-1))

            # Combine the intent and slot losses
            loss = intent_loss + slot_loss

            # Backpropagation step - send loss backward
            loss.backward()

            # Update model parameters with optimizer
            optimizer.step()

            # Print progress for the current epoch and batch loss
            print(f'Epoch {epoch + 1}, Loss: {loss.item()}')

    # Return the trained model
    return model


if __name__ == "__main__":
    import argparse
    from sic_framework.services.nlu.utils.dataset import NLURecipeDataset
    from sic_framework.services.nlu.utils.model import BERTNLUModel

    # Instellingen ophalen uit de terminal (zoals --epochs)
    parser = argparse.ArgumentParser()
    parser.add_argument("--epochs", type=int, default=1)
    args = parser.parse_args()


    # 1. De data laden en klaarmaken
    print("Data laden...")
    from sic_framework.services.nlu.utils.dataset import load_ontology, load_data, preprocess_data, fit_encoders
    
    # Laad de ruwe bestanden
    ontology = load_ontology("data/ontology.json")
    raw_data = load_data("data/train.json")
    
    # Bereid de encoders en de data voor
    fit_encoders("data/ontology.json")
    processed_data = preprocess_data(raw_data)
    
    # Maak nu pas de dataset aan met de verwerkte data
    dataset = NLURecipeDataset(processed_data, ontology)

    
    # 2. Het model initialiseren
    print("Model initialiseren...")
    # We halen het exacte aantal unieke BIO-tags uit de slot_encoder
    from sic_framework.services.nlu.utils.dataset import slot_label_encoder
    
    model = BERTNLUModel(num_intents=len(ontology['intents']), 
                         num_slots=len(slot_label_encoder.classes_))

    # 3. De training echt starten
    print("--- START TRAINING ---")
    train_model(model, dataset, num_epochs=args.epochs, batch_size=16)
    print("--- TRAINING VOLTOOID ---")
    
    # Sla het model op zodat je het later kunt evalueren
    torch.save(model.state_dict(), "model_baseline.pth")
    print("Model opgeslagen als model_baseline.pth")
