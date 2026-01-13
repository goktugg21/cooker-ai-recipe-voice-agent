
import torch
from sic_framework.services.nlu.utils.dataset import intent_label_encoder, slot_label_encoder, tokenizer
from sic_framework.services.nlu.utils.utils import *
from dataset import intent_label_encoder, slot_label_encoder, tokenizer
from model import BERTNLUModel

def predict(model, text, max_length=16, device="cpu"):
    """
    Performs inference on a single input text, predicting the intent and slot tags in BIO format.

    Args:
        model (nn.Module): Trained NLU intent_slot_classification_model.
        text (str): Input sentence for prediction.
        max_length (int): Maximum token length for padding/truncation.
        device (str or torch.device): Device to perform inference on ("cpu" or "cuda").

    Returns:
        tuple:
        - intent (str): Predicted intent label.
        - slots (list): List of predicted slot tags in BIO format.
    """
    model.to(device)
    model.eval()

    with torch.no_grad():
        # Tokenize and encode the input text
        encoding = tokenizer(
            text,
            return_tensors="pt",
            padding="max_length",
            truncation=True,
            max_length=max_length
        )

        # Prepare input run_data and move to the specified device
        input_ids = encoding['input_ids'].squeeze().to(device)
        attention_mask = encoding['attention_mask'].squeeze().to(device)

        # Get intent_slot_classification_model predictions
        intent_logits, slot_logits = model(input_ids.unsqueeze(0), attention_mask.unsqueeze(0))





        # Decode intent
        intent_probs = torch.softmax(intent_logits, dim=1).squeeze()
        intent_pred = torch.argmax(intent_probs).item()
        intent = intent_label_encoder.inverse_transform([intent_pred])[0]
        intent_confidence = intent_probs[intent_pred].item()

        # Decode slots and compute slot probabilities
        slot_probs = torch.softmax(slot_logits, dim=2).squeeze()
        slot_preds = torch.argmax(slot_probs, dim=1).tolist()
        slot_confidences = [slot_probs[i, pred].item() for i, pred in enumerate(slot_preds)]
        # Decode slots
        # slot_preds = torch.argmax(slot_logits, dim=2).squeeze().tolist()
        slots = slot_label_encoder.inverse_transform(slot_preds)
        slot_dict = extract_slots_from_text(slots, text)

        # Normalize the slots using the ontology
        normalized_slots = normalize_slots(slot_dict)

        return intent, intent_confidence, normalized_slots, slot_confidences


if __name__ == "__main__":
    import argparse
    from dataset import load_ontology, fit_encoders
    from model import BERTNLUModel

    # 1. Instellingen uit de terminal halen
    parser = argparse.ArgumentParser()
    parser.add_argument("--text", type=str, required=True)
    args = parser.parse_args()

    # 2. Alles voorbereiden (net als bij trainen/evaluatie)
    ontology = load_ontology("data/ontology.json")
    fit_encoders("data/ontology.json")
    
    # Model laden met de juiste hoeveelheid slots
    from dataset import slot_label_encoder
    model = BERTNLUModel(num_intents=len(ontology['intents']), 
                         num_slots=len(slot_label_encoder.classes_))
    
    # getrainde brein inladen
    model.load_state_dict(torch.load("model_baseline.pth"))

    # 3. De voorspelling doen
    intent, confidence, slots, _ = predict(model, args.text)

    # 4. Het resultaat op scherm printen
    print("\n" + "="*30)
    print(f"INPUT: {args.text}")
    print("-" * 30)
    print(f"INTENT: {intent} ({confidence:.2%})")
    print(f"SLOTS:  {slots}")
    print("="*30 + "\n")
