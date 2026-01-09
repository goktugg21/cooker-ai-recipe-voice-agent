cat > docs/nlu_contract.md <<'EOF'
# NLU Output Contract

Midway backend: Dialogflow
Custom classifier: trained and evaluated, integration can follow after midway

## Contract JSON

```json
{
  "intent": "string",
  "slots": {},
  "confidence": 0.0,
  "raw_text": "string"
}