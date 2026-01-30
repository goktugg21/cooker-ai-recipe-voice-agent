# A Speech-Based Conversational Recipe Recommendation Agent  
**Final Project Report**

---

## Group Information

- **Group Number:** E1  
- **Students – Student Numbers – Email Addresses**
  - Baris Kaban – 2837738 – b.kaban@student.vu.nl  
  - Goktug Yildirim – 2814081 – g.yildirim2@student.vu.nl  
  - Danila Popusoi – 2842345 – d.popusoi@student.vu.nl  
  - Murat Gundogan – 2847823 – m.gundogan2@student.vu.nl  
  - Romaissa Bezghout – 2784982 – r.bezghout@student.vu.nl  

---

## 1. Introduction

### 1.1 Introduction to the Project

This project focuses on the design and implementation of a **speech-based conversational recipe recommendation agent**.  
The agent is an example of a **Task-Oriented Spoken Dialogue System (TOSDS)**, designed to assist users in achieving a concrete goal: finding suitable recipes through natural language interaction.

Unlike open-domain conversational systems, task-oriented dialogue systems operate over **well-defined tasks** and rely on structured representations of user intent, parameters, and dialogue state. They require robust **intent recognition**, **slot filling**, and **dialogue state tracking** to support coherent multi-turn interactions.

Our agent supports recipe recommendation, interactive filtering, and recipe selection. The conversation is managed using explicit MARBEL dialogue patterns, enabling the system to incrementally refine results while maintaining a consistent internal knowledge representation.

### 1.2 Goals

The main objectives of this project are:

- To build a conversational agent capable of recommending recipes based on user preferences.
- To support **multi-turn dialogue** with memory of previously stated constraints.
- To allow both **inclusion and exclusion** of ingredients, cuisines, and meal types.
- To implement and evaluate a custom **intent and slot classifier**.
- To ensure transparent system behavior through **logs and UI evidence**.
- To deliver a **pilot-ready conversational agent** suitable for a user study.

---

## 2. How Does the Conversational Agent Work?

### 2.1 Functionality

The agent supports the following primary use cases:

- Greeting the user and self-identification.
- Requesting and generating recipe recommendations.
- Adding inclusion filters (e.g., ingredients, cuisine types).
- Adding exclusion filters (e.g., “no chicken”, “without garlic”).
- Managing multiple active exclusions simultaneously.
- Removing individual exclusions or clearing all exclusions.
- Selecting a specific recipe from the recommendation list.
- Maintaining dialogue state across multiple turns.

These capabilities allow users to iteratively refine their preferences through natural language interaction.

### 2.2 Conversational Flow

A typical interaction proceeds as follows:

1. The user provides an utterance through speech or text.
2. The system performs **intent recognition** and **slot filling**.
3. The MARBEL dialogue manager selects a matching **conversation pattern**.
4. The system updates its **knowledge representation (KR)**.
5. The agent selects and executes the next action, producing spoken and visual output.

This structured flow ensures predictable, explainable behavior throughout the dialogue.

### 2.3 Example Interactions

Example utterances supported by the system:

- “Hello”
- “Who are you?”
- “Can you recommend me something?”
- “I want something with chicken”
- “No garlic”
- “Remove chicken”
- “Clear all filters”
- “Select recipe number three”

**Example multi-turn interaction:**

User: “Can you recommend me something?”  
Agent: “Here are three recipes you might like.”

User: “I want something with chicken.”  
Agent: “I found recipes with chicken. Would you like to exclude anything?”

User: “No garlic.”  
Agent: “I removed recipes containing garlic. Here are the updated results.”

---

## 3. Intent and Slot Classifier

### 3.1 Intent and Slot Classification

The intent and slot classifier identifies **user intentions** and extracts structured parameters required for dialogue management.

Example output:

- Intent: `deleteFilterValue`
- Slot: `ingredient = chicken`

This information enables MARBEL to update the KR and select appropriate dialogue patterns.

### 3.2 Evaluation Results

#### Intent Classification

- **Overall Accuracy:** 89.3%
- **Weighted F1-score:** 0.89
- **Macro F1-score:** 0.85

**Top performing intents:**
- `addFilter`: F1 = 0.96 (917 samples)
- `farewell`: F1 = 0.95 (100 samples)
- `checkCapability`: F1 = 0.96 (101 samples)
- `greeting`: F1 = 0.93 (100 samples)

**Lower performing intents (mainly due to class imbalance):**
- `noMoreFilters`: F1 = 0.51 (recall = 0.36)
- `disconfirmation`: F1 = 0.73
- `deleteParameter`: F1 = 0.80

#### Slot Classification

- **Overall Slot Accuracy:** 98.4%
- **Weighted F1-score:** 0.98
- **BIO Tagging F1-score:** 0.98

**Top performing slot types:**
- `recipe`: F1 = 0.93
- `ingredient`: F1 = 0.89
- `cuisine`: F1 = 0.91
- `dietaryRestriction`: F1 = 0.91

### 3.3 Model Improvements

The classifier was improved through:

- Use of BERT-based contextual embeddings.
- Hyperparameter tuning.
- Training data refinement.
- Improved slot normalization and label consistency.

The trained model checkpoint is available at:  
https://drive.google.com/file/d/1hA6I3CTXnhVXeObN1ZV8Z9ngpmpwAwVi/view

---

## 4. Exclusion

### 4.1 Implementation

Exclusion allows users to explicitly remove items from consideration, including ingredients and cuisine types.

Supported features include:

- Understanding exclusion expressions (e.g., “no X”, “without X”).
- Maintaining an exclusion list in the KR.
- Supporting multiple simultaneous exclusions.
- Removing a specific exclusion.
- Clearing all exclusions.
- Dynamically updating recommendations.

The implementation integrates MARBEL dialogue patterns, Prolog-based reasoning, and Python-based KR updates.

### 4.2 Exclusion Test Evidence

**Example log evidence:**

User: “I don’t want chicken”  
Intent: `deleteFilterValue`  
Slots: `ingredientDel = chicken` (confidence ≈ 64%)

System behavior:
- Recipe count updated from 173 → 35
- Filters updated:  
  `[With parsley, With chicken] → [With parsley]`

This demonstrates correct exclusion handling and KR updates.

### 4.3 Pros and Cons

**Strengths:**
- Fine-grained user control.
- Improved personalization.
- Transparent state changes visible in UI and logs.

**Limitations:**
- Conflicting constraints may reduce available options.
- Complex exclusion combinations may require clarification.

---

## 5. Extensions to the Pipeline

### 5.1 Implemented Extensions

The following extensions were implemented:

- Support for multiple simultaneous exclusions.
- Removal of individual exclusions.
- Clear-all-filters functionality.
- Restart and stop dialogue actions.
- Improved clarification responses.

**Visual enhancements in the UI:**
- Recipe name
- Recipe image
- Preparation time
- Number of servings
- Cuisine type

Implementation changes include updates to:
- `dialog_update.mod2g`
- `pca.js`
- `recipe_confirmation.html`

### 5.2 Pipeline Connection (Clarification)

The custom BERT-based intent and slot classifier was successfully trained and evaluated, achieving strong performance metrics.

The integration code for full pipeline connection (`run-eis --use-nlu --use-whisper`) is complete. However, due to timing and synchronization issues between the Whisper ASR and NLU components during live execution, the final demonstration uses **Dialogflow as a stable fallback**.

The classifier implementation and trained model are ready for future full integration once these timing issues are resolved.

---

## 6. Pilot User Study

### 6.1 Study Setup

- **Participants:**  
  Peer reviewers from the course (students familiar with conversational agents).

- **Tasks:**
  - Find a recipe using conversational interaction.
  - Apply inclusion and exclusion filters.
  - Modify or remove constraints.
  - Restart the dialogue when needed.

- **Data Collection:**
  - Interaction logs generated by the system.
  - Observational notes during the interaction.
  - Qualitative feedback from peer reviewers.

---

### 6.2 Results

The pilot user study consisted of two structured demo runs executed by peer reviewers.  
All core functionalities of the conversational agent were successfully demonstrated.

#### Demo Run 1 – Inclusion and Exclusion Flow

**Conversation:**

User:  
“Hello”

User:  
“I want something with chicken.”

User:  
“No garlic.”

User:  
“Recommend me something.”

User:  
“Yes.”

**Observed Behavior:**
- The agent correctly identified the ingredient inclusion (chicken).
- The exclusion of garlic was detected and stored in the knowledge representation.
- Recipe recommendations were updated accordingly.
- The conversation proceeded without errors or clarification breakdowns.

---

#### Demo Run 2 – Constraint Changes and Restart

**Conversation:**

User:  
“Can you recommend me something with lettuce?”

User:  
“I want vegetarian food.”

User:  
“I want garlic.”

User:  
“Remove garlic.”

User:  
“Restart.”

**Observed Behavior:**
- The agent handled multiple sequential constraints correctly.
- Inclusion and exclusion updates were reflected in the recommendation set.
- Removing an exclusion updated the internal state as expected.
- The restart command successfully reset the dialogue state.

---

#### Quantitative Results

- **Task success rate:** 100% (both demo runs completed successfully).
- **Dialogue failures:** None observed.
- **Average response time:** Within acceptable conversational latency.

#### Qualitative Results

- Users reported that the dialogue flow was intuitive and easy to follow.
- Exclusion feedback was clear and understandable.
- The restart functionality was perceived as useful for recovering from complex constraints.

---

### 6.3 Analysis

The pilot user study indicates that the conversational agent is **pilot-ready** and robust enough for interactive use.

**What worked well:**
- Inclusion and exclusion filters behaved consistently.
- Multi-turn dialogue state was preserved correctly.
- Users could recover from restrictive constraints using removal or restart actions.

**Observed challenges:**
- Some utterances required precise phrasing to avoid ambiguity.
- More explicit confirmations could further improve clarity in complex interactions.

**Opportunities for improvement:**
- Add additional clarification prompts when multiple constraints are active.
- Improve paraphrase handling for exclusion expressions.
- Enhance feedback when the result set becomes very small or empty.

Overall, the pilot study confirms that the agent fulfills the project requirements and is suitable for further evaluation and extension.

---

## 7. Conclusion

This project demonstrates the successful development of a **task-oriented conversational recipe recommendation agent** with multi-turn dialogue, exclusion handling, and structured dialogue management.

Key outcomes include:
- A robust exclusion mechanism integrated into MARBEL.
- A high-performing custom intent and slot classifier.
- Transparent logging and UI feedback.
- A pilot-ready system suitable for user evaluation.

The system provides a strong foundation for future extensions, including full end-to-end pipeline integration and richer user modeling.