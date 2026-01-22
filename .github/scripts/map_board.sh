#!/bin/bash
# map_board.sh - Map friendly board name to FQBN and platform

set -e

# Read user's simple config
BOARD=$(jq -r '.board' build.config.json)
BOARD_VERSION=$(jq -r '.board_version // "latest"' build.config.json)
ARTIFACT=$(jq -r '.artifact_name // "Arduino-Binary"' build.config.json)
RETENTION=$(jq -r '.retention_days // 30' build.config.json)

# Convert friendly name to lowercase for matching (remove spaces, hyphens, underscores)
BOARD_LOWER=$(echo "$BOARD" | tr '[:upper:]' '[:lower:]' | tr -d ' ' | tr -d '_' | tr -d '-')

echo "🎯 Mapping board: $BOARD -> $BOARD_LOWER"
echo "📦 Board version: $BOARD_VERSION"

# Board mapping - friendly name to FQBN
case "$BOARD_LOWER" in
  # ESP32 variants
  esp32|esp32dev|esp32devmodule)
    FQBN="esp32:esp32:esp32"
    PLATFORM="esp32:esp32"
    PLATFORM_URL="https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json"
    BOARD_NAME="ESP32 Dev Module"
    ;;
  esp32s2|esp32s2dev)
    FQBN="esp32:esp32:esp32s2"
    PLATFORM="esp32:esp32"
    PLATFORM_URL="https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json"
    BOARD_NAME="ESP32-S2 Dev Module"
    ;;
  esp32s3|esp32s3dev)
    FQBN="esp32:esp32:esp32s3"
    PLATFORM="esp32:esp32"
    PLATFORM_URL="https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json"
    BOARD_NAME="ESP32-S3 Dev Module"
    ;;
  esp32c3|esp32c3dev)
    FQBN="esp32:esp32:esp32c3"
    PLATFORM="esp32:esp32"
    PLATFORM_URL="https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json"
    BOARD_NAME="ESP32-C3 Dev Module"
    ;;
  esp32c6|esp32c6dev)
    FQBN="esp32:esp32:esp32c6"
    PLATFORM="esp32:esp32"
    PLATFORM_URL="https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json"
    BOARD_NAME="ESP32-C6 Dev Module"
    ;;
  # ESP8266 variants
  esp8266|nodemcu|nodemcuv2|d1mini)
    FQBN="esp8266:esp8266:nodemcuv2"
    PLATFORM="esp8266:esp8266"
    PLATFORM_URL="https://arduino.esp8266.com/stable/package_esp8266com_index.json"
    BOARD_NAME="NodeMCU 1.0 (ESP8266)"
    ;;
  # Arduino boards
  uno|arduinouno)
    FQBN="arduino:avr:uno"
    PLATFORM="arduino:avr"
    PLATFORM_URL=""
    BOARD_NAME="Arduino Uno"
    ;;
  nano|arduinonano)
    FQBN="arduino:avr:nano"
    PLATFORM="arduino:avr"
    PLATFORM_URL=""
    BOARD_NAME="Arduino Nano"
    ;;
  mega|arduinomega|mega2560)
    FQBN="arduino:avr:mega"
    PLATFORM="arduino:avr"
    PLATFORM_URL=""
    BOARD_NAME="Arduino Mega 2560"
    ;;
  leonardo|arduinoleonardo)
    FQBN="arduino:avr:leonardo"
    PLATFORM="arduino:avr"
    PLATFORM_URL=""
    BOARD_NAME="Arduino Leonardo"
    ;;
  # Default fallback
  *)
    echo "❌ Unknown board: $BOARD"
    echo ""
    echo "Supported boards:"
    echo "  ESP32:    esp32, esp32s2, esp32s3, esp32c3, esp32c6"
    echo "  ESP8266:  esp8266, nodemcu, d1mini"
    echo "  Arduino:  uno, nano, mega, leonardo"
    exit 1
    ;;
esac

# Handle version - append version to platform if not "latest"
if [ "$BOARD_VERSION" != "latest" ] && [ -n "$BOARD_VERSION" ]; then
  PLATFORM_WITH_VERSION="${PLATFORM}@${BOARD_VERSION}"
  echo "📌 Using specific version: $PLATFORM_WITH_VERSION"
else
  PLATFORM_WITH_VERSION="$PLATFORM"
  echo "📌 Using latest version"
fi

echo ""
echo "✅ Board mapped successfully!"
echo "   Board Name    : $BOARD_NAME"
echo "   FQBN          : $FQBN"
echo "   Platform      : $PLATFORM"
echo "   Install       : $PLATFORM_WITH_VERSION"

# Output values for GitHub Actions
echo "board=$BOARD" >> $GITHUB_OUTPUT
echo "board_name=$BOARD_NAME" >> $GITHUB_OUTPUT
echo "board_version=$BOARD_VERSION" >> $GITHUB_OUTPUT
echo "fqbn=$FQBN" >> $GITHUB_OUTPUT
echo "platform=$PLATFORM" >> $GITHUB_OUTPUT
echo "platform_install=$PLATFORM_WITH_VERSION" >> $GITHUB_OUTPUT
echo "platform_url=$PLATFORM_URL" >> $GITHUB_OUTPUT
echo "artifact=$ARTIFACT" >> $GITHUB_OUTPUT
echo "retention=$RETENTION" >> $GITHUB_OUTPUT
