.PHONY: run stop restart status logs

PORT ?= 8090
PID_FILE := .plandisney.pid
LOG_FILE := .plandisney.log

run:
	@if [ -f $(PID_FILE) ] && kill -0 $$(cat $(PID_FILE)) 2>/dev/null; then \
		echo "PlanDisney is already running (PID $$(cat $(PID_FILE)))."; \
	else \
		echo "Starting PlanDisney..."; \
		python3 -m http.server $(PORT) --directory public > $(LOG_FILE) 2>&1 & \
		echo $$! > $(PID_FILE); \
		sleep 1; \
		if kill -0 $$(cat $(PID_FILE)) 2>/dev/null; then \
			echo "PlanDisney is running."; \
			echo "http://localhost:$(PORT)"; \
		else \
			echo "PlanDisney failed to start."; \
			echo "Run 'make logs' for details."; \
			rm -f $(PID_FILE); \
			exit 1; \
		fi \
	fi

stop:
	@if [ -f $(PID_FILE) ]; then \
		PID=$$(cat $(PID_FILE)); \
		if kill -0 $$PID 2>/dev/null; then \
			echo "Stopping PlanDisney (PID $$PID)..."; \
			kill $$PID; \
			rm -f $(PID_FILE); \
			echo "PlanDisney stopped."; \
		else \
			echo "PlanDisney is not running."; \
			rm -f $(PID_FILE); \
		fi \
	else \
		echo "PlanDisney is not running."; \
	fi

restart: stop run

status:
	@if [ -f $(PID_FILE) ] && kill -0 $$(cat $(PID_FILE)) 2>/dev/null; then \
		echo "PlanDisney is running (PID $$(cat $(PID_FILE)))."; \
		echo "http://localhost:$(PORT)"; \
	else \
		echo "PlanDisney is not running."; \
	fi

logs:
	@if [ -f $(LOG_FILE) ]; then \
		cat $(LOG_FILE); \
	else \
		echo "No PlanDisney log exists yet."; \
	fi