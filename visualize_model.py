import matplotlib.pyplot as plt

def create_diagram():
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # De architectuur
    boxes = [
        "User Input\n(Recipe Dataset Sentence)",
        "BERT Model\n(bert-base-uncased)",
        "Intent Classifier\n(Intent Prediction)",
        "Slot Filler\n(BIO Tagging per Word)"
    ]
    
    # Locaties voor de blokken
    x = [1, 4, 7, 7]
    y = [5, 5, 7, 3]
    
    for i, txt in enumerate(boxes):
        ax.text(x[i], y[i], txt, style='italic',
                bbox={'facecolor': 'white', 'alpha': 0.8, 'pad': 10},
                ha='center', va='center', size=12)
    
    # Pijlen trekken
    ax.annotate("", xy=(3.1, 5), xytext=(1.9, 5), arrowprops=dict(arrowstyle="->"))
    ax.annotate("", xy=(6.1, 6.5), xytext=(4.9, 5.5), arrowprops=dict(arrowstyle="->"))
    ax.annotate("", xy=(6.1, 3.5), xytext=(4.9, 4.5), arrowprops=dict(arrowstyle="->"))
    
    ax.set_xlim(0, 9)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # Titel 
    plt.title("NLU Model Architecture - Team E1", size=16, weight='bold')
    
    # Opslaan over het oude bestand heen
    plt.savefig('docs/model_diagram.png')
    print("Succes! Het Engelse diagram voor Team E1 is opgeslagen.")

if __name__ == "__main__":
    create_diagram()
