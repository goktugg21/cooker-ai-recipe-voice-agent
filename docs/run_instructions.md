cat > docs/run_instructions.md <<'EOF'
# Run Instructions for Midway

This is the exact run path we will use during the midway presentation.

## Quickstart
1. Open Terminal
2. Go to repo root
3. Activate environment
   conda activate PCA26

4. Verify dependencies
   python -c "import sys; print(sys.executable)"
   python -c "import pyaudio; print('pyaudio ok')"
   espeak --version

5. Redis check (only if your pipeline uses Redis)
   redis-cli ping

   If it fails with connection refused, start Redis
   brew services start redis
   redis-cli ping

6. Run the agent
   Open Eclipse
   Import or open the MARBEL project if needed
   Run the dialog manager in Debug mode

7. Run the demo
   Follow docs/demo_script.md utterances in order

8. Save evidence
   Copy log files into artifacts/logs/
   Save screenshots into artifacts/screenshots/

## Common Fixes
1. Conda environment not active
   conda activate PCA26

2. Redis connection refused
   brew services start redis

3. Python packages missing
   Ensure you are in PCA26, then install
   python -m pip install -e .
   or install the missing package using pip or conda as required

4. Eclipse Debug mode unusable
   In MARBEL settings, runtime must not include initial KR updates
   Logging options must be enabled and logging directory noted
EOF