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
    nohup target/release/echokit_server > logs/echokit.out.log 2>&1 &
    echo $! > echokit.pid
    echo "Server started (PID: $!)"

# Stop the server
stop:
    pkill -f "echokit_server" 2>/dev/null || true
    rm -f echokit.pid 2>/dev/null || true
    echo "Server stopped"

# Check server status
status:
    if [ -f echokit.pid ] && kill -0 $(cat echokit.pid) 2>/dev/null; then \
        echo "Server running (PID: $(cat echokit.pid))"; \
    else \
        echo "Server not running"; \
    fi

# Show logs
logs:
    if [ -f logs/echokit.out.log ]; then \
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
