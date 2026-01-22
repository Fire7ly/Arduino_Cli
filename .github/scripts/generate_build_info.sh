#!/bin/bash
# generate_build_info.sh - Generate build information files

set -e

# Arguments passed from workflow
COMPILE_TIME="${1:-unknown}"
SKETCH_NAME="${2:-unknown}"
SKETCH_PATH="${3:-unknown}"
INO_FILE="${4:-unknown}"
BOARD="${5:-unknown}"
BOARD_NAME="${6:-unknown}"
FQBN="${7:-unknown}"
PLATFORM="${8:-unknown}"
PLATFORM_VERSION="${9:-unknown}"
PLATFORM_URL="${10:-unknown}"
CLI_VERSION="${11:-unknown}"
ARTIFACT_NAME="${12:-unknown}"
RETENTION_DAYS="${13:-30}"

mkdir -p ./build

echo "📋 Generating build info files..."

# Create detailed build info file
cat > ./build/BUILD_INFO.txt << EOF
╔══════════════════════════════════════════════════════════════════╗
║                    🔧 ARDUINO BUILD INFORMATION                   ║
╚══════════════════════════════════════════════════════════════════╝

📅 BUILD DETAILS
────────────────────────────────────────────────────────────────────
  Build Date      : $(date '+%Y-%m-%d %H:%M:%S UTC')
  Build Time      : $COMPILE_TIME
  Build Status    : ✅ SUCCESS
  Workflow Run    : #${GITHUB_RUN_NUMBER:-0}
  Run ID          : ${GITHUB_RUN_ID:-0}

📦 PROJECT INFORMATION
────────────────────────────────────────────────────────────────────
  Repository      : ${GITHUB_REPOSITORY:-unknown}
  Branch          : ${GITHUB_REF_NAME:-unknown}
  Commit SHA      : ${GITHUB_SHA:-unknown}

📄 SKETCH INFORMATION
────────────────────────────────────────────────────────────────────
  Sketch Name     : $SKETCH_NAME
  Sketch Path     : $SKETCH_PATH
  Original File   : $INO_FILE

🎯 BOARD CONFIGURATION
────────────────────────────────────────────────────────────────────
  Board (Config)  : $BOARD
  Board Name      : $BOARD_NAME
  FQBN            : $FQBN
  Platform        : $PLATFORM
  Platform Version: $PLATFORM_VERSION
  Platform URL    : $PLATFORM_URL

🛠️ BUILD TOOLS
────────────────────────────────────────────────────────────────────
  Arduino CLI     : $CLI_VERSION
  Runner OS       : ${RUNNER_OS:-unknown}
  Runner Arch     : ${RUNNER_ARCH:-unknown}

📊 OUTPUT FILES
────────────────────────────────────────────────────────────────────
$(ls -lh ./build/*.bin ./build/*.elf ./build/*.hex 2>/dev/null | awk '{print "    " $9 " (" $5 ")"}' || echo "    No binary files found")

📝 ARTIFACT SETTINGS  
────────────────────────────────────────────────────────────────────
  Artifact Name   : $ARTIFACT_NAME
  Retention Days  : $RETENTION_DAYS

══════════════════════════════════════════════════════════════════════
EOF

# Create JSON version for programmatic access
cat > ./build/build_info.json << EOF
{
  "build": {
    "date": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
    "time": "$COMPILE_TIME",
    "status": "success",
    "workflow_run": ${GITHUB_RUN_NUMBER:-0},
    "run_id": "${GITHUB_RUN_ID:-0}"
  },
  "project": {
    "repository": "${GITHUB_REPOSITORY:-unknown}",
    "branch": "${GITHUB_REF_NAME:-unknown}",
    "commit_sha": "${GITHUB_SHA:-unknown}"
  },
  "sketch": {
    "name": "$SKETCH_NAME",
    "path": "$SKETCH_PATH",
    "original_file": "$INO_FILE"
  },
  "board": {
    "config_name": "$BOARD",
    "full_name": "$BOARD_NAME",
    "fqbn": "$FQBN",
    "platform": "$PLATFORM",
    "platform_version": "$PLATFORM_VERSION",
    "platform_url": "$PLATFORM_URL"
  },
  "tools": {
    "arduino_cli": "$CLI_VERSION",
    "runner_os": "${RUNNER_OS:-unknown}",
    "runner_arch": "${RUNNER_ARCH:-unknown}"
  },
  "artifact": {
    "name": "$ARTIFACT_NAME",
    "retention_days": $RETENTION_DAYS
  }
}
EOF

echo "✅ Build info files generated!"
echo "   - BUILD_INFO.txt"
echo "   - build_info.json"
