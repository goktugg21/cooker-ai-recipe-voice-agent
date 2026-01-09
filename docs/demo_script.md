cat > docs/demo_script.md <<'EOF'
# Midway Demo Script

## Setup
Environment: PCA26
Backend: Dialogflow
Start steps:
1. Open terminal, conda activate PCA26
2. Start Redis if the project uses it
3. Open Eclipse, run dialog manager project in Debug
4. Confirm Dialogflow is configured and reachable
5. Follow the utterance list below exactly

## Utterances and Expected Behavior
1. hello
Proves: greet and self identify
Expected: agent greets and introduces itself

2. recommend a recipe
Proves: request recommendation
Expected: agent shows recipe options

3. I want italian lunch with chicken
Proves: inclusion filtering
Expected: cuisine, mealType, ingredient added as filters and results update

4. select option 2
Proves: selection flow
Expected: agent confirms selection and shows details

## Health Checks
- python -c "import sys; print(sys.executable)"
- redis-cli ping
- espeak --version
- python -c "import pyaudio; print('pyaudio ok')"

## Evidence to Capture
- Save demo logs to: artifacts/logs/
- Save screenshots to: artifacts/screenshots/
- Note exact commands used in: docs/run_instructions.md
EOF