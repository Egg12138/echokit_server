# Setup the EchoKit server

You will need an EchoKit device, or create your own ESP32 device with the [EchoKit firmware](https://github.com/second-state/echokit_box).

## Build

```
git clone https://github.com/second-state/echokit_server
```

Edit `config.toml` to customize the VAD, ASR, LLM, TTS services, as well as prompts and MCP servers. You can [see many examples](examples/).

```
cargo build --release
```

## Configure AI services

The `config.toml` can use any combination of open-source or proprietary AI services, as long as they offer OpenAI-compatible API endpoints. Here are instructions to start open source AI servers for the EchoKit server.

* VAD: https://github.com/second-state/silero_vad_server
* ASR: https://llamaedge.com/docs/ai-models/speech-to-text/quick-start-whisper
* LLM: https://llamaedge.com/docs/ai-models/llm/quick-start-llm
* Streaming TTS: https://github.com/second-state/gsv_tts

Alternatively, you could use Google Gemini Live services for VAD + ASR + LLM, and even optionally, TTS. See [config.toml examples](examples/gemini).

You can also [configure MCP servers](examples/gaia/mcp/config.toml) to give the EchoKit server tool use capabilities. 

## Configure the device "skin"

The following two files in the server's current directory will be sent to the EchoKit device when it connects to the server.

* `background.gif` is the background image displayed on the device's screen.
* `hello.wav` is the greeting the device will say to prompt the user to speak.

## Run the EchoKit server

### Option 1: Simple Method (cargo-make)

For quick development and testing, use cargo-make:

```bash
# Install cargo-make (if not already installed)
cargo install cargo-make

# Build and start the server in background
cargo make server

# Check if server is running
cargo make server-status

# Stop the server
cargo make server-stop
```

**Best for:**
- Quick development setups
- Simple process management
- Teams already using cargo-make
- Cross-platform development

### Option 2: Advanced Method (just + nohup)

For production-like environments with full process management:

```bash
# Install just (if not already installed)
# Ubuntu/Debian: sudo apt install just
# macOS: brew install just
# Cargo: cargo install just

# Build and start the server with full management
just start

# Check detailed server status
just status

# View live logs
just logs

# Stop the server gracefully
just stop

# For development: build, restart and show logs
just dev

# See all available commands
just
```

**Best for:**
- Production-like environments
- Long-running servers
- Detailed logging and monitoring
- Complete process lifecycle management
- Development with auto-restart capabilities

### Manual Method

```bash
export RUST_LOG=debug
nohup target/release/echokit_server &
```

## Test on a web page

Go here: https://echokit.dev/chat/

Click on the link to save the `index.html` file to your local hard disk.

Double click the local `index.html` file and open it in your browser. 

In the web page, set the URL to your own EchoKit server address, and start chatting!

## Configure a new device

Go to web page: https://echokit.dev/setup/  and use Bluetooth to connect to the `GAIA ESP332` device.

![Bluetooth connection](https://hackmd.io/_uploads/Hyjc9ZjEee.png)

Configure WiFi and server

* WiFi SSID (e.g., `MyHome`)
* WiFi password (e.g., `MyPassword`)
* Server URL (e.g., `ws://34.44.85.57:9090/ws/`) -- that IP address and port are for the server running `echokit_server`

![Configure Wifi](https://hackmd.io/_uploads/HJkh5ZjVee.png)

## Use the device

**Chat:** press the `K0` button once or multiple times util the screen shows "Listening ...". You can now speak and it will answer.

**Record:** long press the `K0` until the screen shows "Recording ...". You can now speak and the audio will be recorded on the server.

**Config:** press `RST` and, at the same time, press and hold `K0` to enter the configuration mode. Then [open the configuration UI](https://echokit.dev/setup/) to connect to the device via BT.
