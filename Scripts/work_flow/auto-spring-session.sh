#!/bin/bash

SESSION_NAME="spring"
COMMAND="mvn spring-boot:run"

# Check if a session named "spring" exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
	echo "Found existing spring session, terminating..."
	tmux kill-session -t "$SESSION_NAME"
	echo "Original spring session terminated"
else
	echo "No spring session found, proceeding to create new session"
fi

# Create a new spring session without attaching immediately
echo "Creating new spring session..."
tmux new-session -d -s "$SESSION_NAME"

# Send the command to the session
# C-m represents the Enter key to execute the command
tmux send-keys -t "$SESSION_NAME" "$COMMAND" C-m

echo "Successfully created spring session and executed command: $COMMAND"
echo "To attach to this session, run: tmux attach -t $SESSION_NAME"
echo "To view session list, run: tmux ls"
