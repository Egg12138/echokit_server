# EchoKit Server Management with just
# Do not remove comments for subcommands, which displayed as help messages
# Default recipe
default:
    @just --list

# Build release version
build:
    cargo build --release

# Build debug version
build-dbg:
    cargo build

# Start server in background
start: build
    mkdir -p logs
    export RUST_LOG=debug
    # Start server and capture PID
    nohup target/release/echokit_server > logs/echokit.out.log 2> logs/echokit.err.log &
    # Wait for process to start and get the correct PID
    sleep 0.5
    @pgrep -n "echokit_server" > echokit.pid
    echo "Server started (PID: $(cat echokit.pid))"

# Stop the server
stop:
    pkill -f "echokit_server" 2>/dev/null || true
    rm -f echokit.pid 2>/dev/null || true
    echo "Server stopped"

# Check server status
status:
    @if pgrep -f echokit_server > /dev/null; then \
        echo "Server is running"; \
    else \
        echo "Server is not running"; \
    fi


# Show logs
logs:
    @echo "Ctrl-C to exit."
    @if [ -f logs/echokit.out.log ]; then \
        tail -f logs/echokit.out.log; \
    else \
        echo "No log file found"; \
    fi

# Clean build artifacts and generated files (except logs)
clean:
    if [ -f echokit.pid ] && kill -0 $(cat echokit.pid) 2>/dev/null; then \
        echo "Error: Server is running. Please stop the server first with 'just stop'"; \
        exit 1; \
    fi
    echo "Cleaning build artifacts and generated files..."
    rm -rf target/
    rm -f echokit.pid
    find . -name "*.log" -not -path "./logs/*" -delete 2>/dev/null || true
    echo "Clean completed (logs preserved)"

# Register new llm factory information: <url>, <model> and <key>
new-llm:
    echo "Not implemented yet"

# Show help
help:
    @just --list
