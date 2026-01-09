cat > scripts/run_demo.sh <<'EOF'
#!/usr/bin/env bash
set -e

echo "=== Midway Demo Runner ==="
echo ""

echo "[1/7] Conda environment"
if [[ -z "${CONDA_PREFIX:-}" ]]; then
  echo "WARNING: conda environment not detected. Activate PCA26 first:"
  echo "conda activate PCA26"
else
  echo "Active conda prefix: $CONDA_PREFIX"
fi
echo ""

echo "[2/7] Python executable"
python -c "import sys; print(sys.executable)"
echo ""

echo "[3/7] PyAudio import test"
python -c "import pyaudio; print('pyaudio ok')"
echo ""

echo "[4/7] eSpeak check"
if command -v espeak >/dev/null 2>&1; then
  espeak --version | head -n 1
elif command -v espeak-ng >/dev/null 2>&1; then
  espeak-ng --version | head -n 1
else
  echo "ERROR: espeak not found. Install with: brew install espeak-ng"
  exit 1
fi
echo ""

echo "[5/7] Redis check (optional)"
if command -v redis-cli >/dev/null 2>&1; then
  if redis-cli ping >/dev/null 2>&1; then
    echo "redis ok"
  else
    echo "WARNING: redis not responding. If required, start with:"
    echo "brew services start redis"
  fi
else
  echo "WARNING: redis-cli not found. Skip if not required."
fi
echo ""

echo "[6/7] Manual steps for MARBEL"
echo "1) Open Eclipse"
echo "2) Run the MARBEL dialog manager project in Debug mode"
echo "3) Confirm Dialogflow is configured and reachable"
echo ""

echo "[7/7] Demo utterances"
if [[ -f docs/demo_script.md ]]; then
  sed -n '/## Utterances and Expected Behavior/,$p' docs/demo_script.md
else
  echo "ERROR: docs/demo_script.md not found"
  exit 1
fi
echo ""
echo "Done."
EOF

chmod +x scripts/run_demo.sh