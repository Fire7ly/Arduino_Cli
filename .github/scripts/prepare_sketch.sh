#!/bin/bash
# prepare_sketch.sh - Find and prepare Arduino sketch for compilation

set -e

echo "🔍 Searching for .ino files..."

# Find all .ino files
INO_FILES=$(find . -name "*.ino" -type f | grep -v "./build/" | head -20)
INO_COUNT=$(echo "$INO_FILES" | grep -c ".ino" || echo "0")

echo "Found $INO_COUNT .ino file(s):"
echo "$INO_FILES"

if [ "$INO_COUNT" -eq 0 ]; then
  echo "❌ No .ino files found!"
  exit 1
fi

# Get the sketch path from config
SKETCH_PATH=$(jq -r '.sketch_path // "."' build.config.json)

# Look for .ino in the specified path first
if ls "$SKETCH_PATH"/*.ino 1> /dev/null 2>&1; then
  INO_FILE=$(ls "$SKETCH_PATH"/*.ino | head -1)
else
  INO_FILE=$(echo "$INO_FILES" | head -1)
fi

echo "📄 Selected sketch: $INO_FILE"

# Get sketch name without extension
INO_BASENAME=$(basename "$INO_FILE")
SKETCH_NAME="${INO_BASENAME%.ino}"
SKETCH_DIR=$(dirname "$INO_FILE")

echo "  Sketch name: $SKETCH_NAME"
echo "  Sketch directory: $SKETCH_DIR"

# Arduino CLI requires folder name = sketch name
FOLDER_NAME=$(basename "$SKETCH_DIR")

if [ "$FOLDER_NAME" = "." ]; then
  # Sketch is in root directory - need to create proper folder
  echo "📁 Sketch is in root. Creating proper folder structure..."
  
  mkdir -p "./$SKETCH_NAME"
  cp "$INO_FILE" "./$SKETCH_NAME/"
  
  # Copy any related source files (.h, .cpp, etc.)
  for ext in h cpp c hpp ino; do
    if ls ./*.$ext 1> /dev/null 2>&1; then
      cp ./*.$ext "./$SKETCH_NAME/" 2>/dev/null || true
    fi
  done
  
  # Copy common Arduino project folders if they exist
  for folder in src lib include data; do
    if [ -d "./$folder" ]; then
      echo "📂 Copying $folder folder..."
      cp -r "./$folder" "./$SKETCH_NAME/"
    fi
  done
  
  FINAL_SKETCH_PATH="./$SKETCH_NAME"
  echo "✅ Created folder: $FINAL_SKETCH_PATH"
  
elif [ "$FOLDER_NAME" != "$SKETCH_NAME" ]; then
  # Folder name doesn't match sketch name - rename sketch
  echo "📝 Folder name ($FOLDER_NAME) doesn't match sketch name ($SKETCH_NAME)"
  echo "   Renaming sketch to match folder..."
  
  NEW_INO_FILE="$SKETCH_DIR/$FOLDER_NAME.ino"
  mv "$INO_FILE" "$NEW_INO_FILE"
  SKETCH_NAME="$FOLDER_NAME"
  INO_FILE="$NEW_INO_FILE"
  FINAL_SKETCH_PATH="$SKETCH_DIR"
  echo "✅ Renamed to: $NEW_INO_FILE"
  
else
  # Everything is fine
  FINAL_SKETCH_PATH="$SKETCH_DIR"
  echo "✅ Folder structure is correct"
fi

# List final sketch contents
echo ""
echo "📁 Final sketch folder contents:"
ls -la "$FINAL_SKETCH_PATH"

# Output values for GitHub Actions
echo "ino_file=$INO_FILE" >> $GITHUB_OUTPUT
echo "sketch_name=$SKETCH_NAME" >> $GITHUB_OUTPUT
echo "sketch_path=$FINAL_SKETCH_PATH" >> $GITHUB_OUTPUT
