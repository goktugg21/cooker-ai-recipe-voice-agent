# A Speech-Based Conversational Recipe Recommendation Agent  
**Final Project Report**

---

## Group Information

- **Group Number:E1**  
- **Students-Student Numbers-Email Addresses**  
  - Baris Kaban - 2837738 - b.kaban@student.vu.nl
  - Goktug Yildirim - 2814081 - g.yildirim2@student.vu.nl
  - Danila Popusoi - 2842345 - d.popusoi@student.vu.nl
  - Murat Gundogan - 2847823 - m.gundogan2@student.vu.nl
  - Romaissa Bezghout - 2784982 - r.bezghout@student.vu.nl

---

## 1. Introduction 

### 1.1 Introduction to the Project

This project focuses on the design and implementation of a **speech-based conversational recipe recommendation agent**.  
The agent is an example of a **Task-Oriented Spoken Dialogue System (TOSDS)**, designed to assist users in achieving a concrete goal: finding suitable recipes through natural language interaction.

Unlike open-domain conversational systems, task-oriented dialogue systems operate over **well-defined tasks** and rely on structured representations of user intent, parameters, and dialogue state. They typically require robust **intent recognition**, **slot filling**, and **dialogue state tracking** to support coherent multi-turn interactions.

In our system, the agent supports recipe recommendation, interactive filtering, and recipe selection. The conversation is managed through explicit dialogue patterns, allowing the agent to progressively refine recommendations while maintaining a consistent internal state.

### 1.2 Goals

The main objectives of this project are:

- To build a conversational agent capable of recommending recipes based on user preferences.
- To support **multi-turn dialogue** with memory of previously stated constraints.
- To allow both **inclusion and exclusion** of ingredients, cuisines, and meal types.
- To integrate a custom **intent and slot classifier** into the dialogue pipeline.
- To provide transparent system behavior through **reproducible logs and UI evidence**.
- To deliver a **pilot-ready conversational agent** suitable for a user study.

---

## 2. How Does the Conversational Agent Work? 

### 2.1 Functionality

The conversational agent supports the following primary use cases:

- Greeting the user and self-identifying.
- Requesting and generating recipe recommendations.
- Adding inclusion filters (e.g., ingredients, cuisine types).
- Adding exclusion filters (e.g., “no chicken”, “without garlic”).
- Managing multiple active exclusions simultaneously.
- Removing individual exclusions or clearing all exclusions.
- Selecting a specific recipe from the recommendation list.
- Maintaining dialogue state across multiple turns.

These capabilities allow users to iteratively refine their preferences and reach a final recipe choice through natural conversation.

### 2.2 Conversational Flow

A typical interaction proceeds as follows:

1. The user provides an utterance through speech or text.
2. The system performs **intent recognition** and **slot filling**.
3. The MARBEL dialogue manager selects an appropriate **conversation pattern**.
4. The system updates its **knowledge representation (KR)** to reflect new constraints.
5. A next agent action is selected and executed, producing a spoken and visual response.

This structured flow ensures that user preferences are accumulated consistently and that system behavior remains predictable and explainable.

### 2.3 Example Interactions

The following utterances can be used to test the system end to end:

- “Hello”
- “Who are you?”
- “Can you recommend me something?”
- “I want something with chicken”
- “No garlic”
- “Remove chicken”
- “Clear all filters”
- “Select recipe number three”

These examples demonstrate greeting, recommendation, inclusion filtering, exclusion filtering, filter removal, and recipe selection.

**Example multi-turn interaction:**

User: “Can you recommend me something?”  
Agent: “Here are three recipes you might like.”  

User: “I want something with chicken.”  
Agent: “I found recipes with chicken. Would you like to exclude anything?”  

User: “No garlic.”  
Agent: “I have removed recipes containing garlic. Here are the updated results.”

---

## 3. Intent and Slot Classifier 

### 3.1 Intent and Slot Classification

The intent and slot classifier is responsible for identifying **user intentions** and extracting structured information from utterances.  
For example:

- Intent: `featureInquiry`
- Slot: `ingredient = chicken`

This structured output enables the dialogue manager to reason over user input and apply changes to the internal knowledge representation.

### 3.2 Performance Analysis

The classifier was evaluated using standard metrics:

- Accuracy
- Precision
- Recall
- F1-score

Results were compared against the **Intent and Slot Classifier Evaluation Thresholds** provided in the course materials.  
Key challenges included ambiguous utterances and overlapping slot categories, which were mitigated through data refinement and architectural adjustments.

### 3.3 Model Improvements

Improvements made to the classifier include:

- Use of pre-trained language models (BERT-based embeddings).
- Hyperparameter tuning and training refinement.
- Improved handling of slot normalization.
- Architectural adjustments to improve generalization and robustness.

---

## 4. Exclusion 

### 4.1 Implementation

Exclusion enables users to explicitly remove items from consideration, such as ingredients, cuisines, or meal types. Exclusion is supported for multiple slot types, including ingredients and cuisine types, allowing users to express diverse negative preferences.

Our implementation supports:

- Understanding exclusion expressions (e.g., “no X”, “without X”).
- Storing exclusions in a dedicated exclusion list within the KR.
- Supporting multiple simultaneous exclusions.
- Removing a specific exclusion.
- Clearing all exclusions at once.
- Ensuring excluded items are removed from all subsequent recommendations.

The implementation integrates:

- MARBEL dialogue management.
- Prolog-based conversational patterns.
- Python-based orchestration and KR updates.

### 4.2 Pros and Cons

**Strengths:**
- Provides fine-grained user control.
- Enables iterative refinement of recommendations.
- Improves user satisfaction by respecting negative constraints.

**Limitations:**
- Complex exclusion combinations may require clarification.
- Conflicting constraints can reduce available options significantly.

### 4.3 Performance Analysis

We compared system behavior under:

- Inclusion-only filtering.
- Combined inclusion and exclusion filtering.

Exclusion increased dialogue complexity but resulted in more accurate and satisfying recommendations.

---

## 5. Extensions to the Pipeline 

### 5.1 Implemented Extensions

The following extensions were implemented beyond the baseline requirements:

- Multiple exclusion handling.
- Removal of individual exclusions.
- Clearing all filters.
- Improved clarification and confirmation responses.
- Restart and stop dialogue actions.

### 5.2 Motivation and Impact

These extensions improve usability, robustness, and conversational flexibility.  
The pipeline was tested with the custom intent and slot classifier fully connected to MARBEL, replacing Dialogflow and enabling full end-to-end control. The replacement of Dialogflow with a custom intent and slot classifier enabled full control over exclusion handling and ensured consistent behavior across the dialogue pipeline.

---

## 6. Pilot User Study 

### 6.1 Study Setup

- **Participants:**  
  *(To be filled after study)*

- **Tasks:**  
  - Find a recipe using conversational interaction.  
  - Apply inclusion and exclusion filters.  
  - Select a recipe.

- **Data Collection:**  
  - Interaction logs.  
  - Observational notes.  
  - User feedback questionnaires.

### 6.2 Results

**Quantitative Results:**  
- Task success rates.  
- Error rates.  
- Average response times.

**Qualitative Results:**  
- User feedback excerpts.  
- Observations of interaction behavior.

### 6.3 Analysis

This section will analyze:

- What worked well in user interactions.
- Where users experienced confusion.
- Opportunities for improving robustness and clarity.

---

## 7. Conclusion 

This project demonstrates the successful development of a **task-oriented conversational recipe recommendation agent** with support for inclusion and exclusion filtering, multi-turn dialogue, and end-to-end pipeline integration.

We reflect on:

- Effective dialogue modeling using MARBEL.
- Successful integration of a custom NLU component.
- The importance of transparent state tracking and logging.
- Areas for future improvement, including richer user modeling and scalability.

The system is pilot-ready and provides a strong foundation for further research and development in conversational recommendation systems.

---