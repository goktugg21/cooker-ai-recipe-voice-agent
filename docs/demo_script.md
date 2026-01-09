cat > docs/demo_script.md <<'EOF'
# Midway Demo Script

## Setup
Environment: PCA26
Backend: Dialogflow or Custom NLU
Start steps:
1. (fill in)
2. (fill in)

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
EOF