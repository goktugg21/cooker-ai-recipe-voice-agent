cat > docs/dialogflow_setup.md <<'EOF'
# Dialogflow Setup (Midway)

Midway backend: Dialogflow

## Agent
- Agent name: (fill in)
- Project or workspace: (fill in)

## Intents used in the midway demo
- greet (fill in exact intent name)
- selfIdentify (fill in exact intent name)
- requestRecommendation (fill in exact intent name)
- addFilter inclusion (fill in exact intent name)
- selectRecipe (fill in exact intent name)
- fallback (fill in exact intent name)

## Entities and slots
- cuisine (entity name: fill in)
- mealType (entity name: fill in)
- ingredient (entity name: fill in)
- cookTime (entity name: fill in, if used)

## Credentials and configuration
- Where credentials are stored: (env vars or config file, fill in)
- How MARBEL connects to Dialogflow: (fill in)

## How to test quickly
1. Open Dialogflow console
2. Use the built in test panel
3. Test these phrases and confirm the detected intent and extracted entities:
   - hello
   - recommend a recipe
   - I want italian lunch with chicken
   - select option 2

## Evidence to add to the repo
- artifacts/screenshots/dialogflow_intents.png
- artifacts/screenshots/dialogflow_entities.png
EOF