cat > docs/nlu_contract.md <<'EOF'
# NLU Output Contract

This document defines the single format that the NLU layer outputs and the dialogue manager consumes.

## JSON Schema

```json
{
  "intent": "string",
  "slots": {
    "cuisine": "string or null",
    "mealType": "string or null",
    "ingredient": ["string", "string"],
    "cookTime": 0
  },
  "confidence": 0.0,
  "raw_text": "string"
}