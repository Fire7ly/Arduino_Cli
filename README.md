# 🚀 Arduino Auto-Build Project

This project automatically builds your Arduino code and saves the compiled file every time you push code to GitHub!

---

## 📖 What Does This Project Do?

```
You write code → Push to GitHub → ✨ Magic happens ✨ → Download ready-to-use file!
```

When you push your Arduino code to GitHub, a robot (called GitHub Actions) will:

1. 🔨 **Build** your Arduino code
2. 📦 **Save** the compiled `.bin` file
3. 🎁 **Give you** a download link

---

## 🎯 Step-by-Step Tutorial

### Step 1: Get The Code 📥

**Option A: Download as ZIP**

1. Click the green **"Code"** button on GitHub
2. Click **"Download ZIP"**
3. Unzip the folder on your computer

**Option B: Use Git (if you have it)**

```bash
git clone https://github.com/Fire7ly/Arduino_Cli.git
```

---

### Step 2: Look at The Files 👀

Your project folder looks like this:

```
📁 Arduino_Cli/
├── 📁 .github/
│   ├── 📁 scripts/               ← 🔧 Build helper scripts
│   │   ├── 📄 prepare_sketch.sh
│   │   ├── 📄 map_board.sh
│   │   └── 📄 generate_build_info.sh
│   └── 📁 workflows/
│       └── 📄 main.yml           ← 🤖 The robot instructions
├── 📄 Arduino_Cli.ino            ← ✏️ Your Arduino code
├── 📄 build.config.json          ← ⚙️ Settings file (edit this!)
├── 📄 README.md                  ← 📖 This tutorial!
```

| File                | What It Does                                     |
| ------------------- | ------------------------------------------------ |
| `build.config.json` | ⚙️ **Settings file** - change board/options here |
| `Arduino_Cli.ino`   | Your actual Arduino program                      |
| `.github/scripts/`  | Helper scripts (auto-find sketch, map boards)    |
| `main.yml`          | Workflow file (don't edit this!)                 |

---

### Step 3: Understand The Arduino Code 💡

Open `Arduino_Cli.ino` - here's what it does:

```cpp
#include <Arduino.h>          // ← Gives us Arduino powers!

void setup() {
    Serial.begin(2400);       // ← Start talking to computer
}

void loop() {
    Serial.println("Hello, World!");  // ← Say "Hello, World!"
    delay(1000);                       // ← Wait 1 second
}
```

**In simple terms:**

- `setup()` runs **once** when Arduino starts
- `loop()` runs **forever**, again and again
- This code prints "Hello, World!" every second!

---

### Step 4: Make Changes ✏️

1. Open `Arduino_Cli.ino` in any text editor
2. Change the message to whatever you want!

```cpp
Serial.println("I love pizza! 🍕");
```

3. Save the file

---

### Step 5: Push to GitHub 🚀

**If you're new to Git, here's what to do:**

1. **Open Terminal/Command Prompt** in your project folder

2. **Add your changes:**

   ```bash
   git add .
   ```

3. **Save with a message:**

   ```bash
   git commit -m "My awesome change"
   ```

4. **Send to GitHub:**
   ```bash
   git push
   ```

---

### Step 6: Watch The Magic! ✨

1. Go to your GitHub repository in a web browser
2. Click the **"Actions"** tab at the top

   ![Actions Tab](https://docs.github.com/assets/images/help/repository/actions-tab.png)

3. You'll see your build running with a 🟡 yellow dot
4. Wait for it to turn ✅ green (about 2-3 minutes)

---

### Step 7: Download Your File 📥

1. Click on the completed (green ✅) workflow run
2. Scroll down to **"Artifacts"**
3. Click on **"Arduino-Binary-xxxxx"** to download
4. Unzip the downloaded file
5. You now have your `.bin` file ready to upload to ESP32!

---

## 🔧 How The Magic Works

The file `.github/workflows/main.yml` tells GitHub what to do:

```yaml
# When you push to 'main' branch...
on:
  push:
    branches:
      - main

# Do these steps:
steps: 1. Download your code
  2. Install Arduino tools
  3. Install ESP32 support
  4. Build your .ino file
  5. Save the .bin file for download
```

---

## ❓ Common Questions

### Q: Why is my build failing? 🔴

**Check these things:**

1. ✅ Your code has no typos
2. ✅ All brackets `{ }` are matched
3. ✅ Semicolons `;` at end of lines
4. ✅ `void` is lowercase (not `Void`)

### Q: Where are my files?

After the build succeeds:

1. Go to **Actions** tab
2. Click the latest green ✅ run
3. Scroll to bottom → **Artifacts** section
4. Download!

### Q: Can I use a different board?

Yes! Just edit `build.config.json` and change the board name:

```json
{
  "board": "esp32s3"
}
```

**That's it!** Just type the board name - no complicated codes to remember!

**Supported boards:**

| Type This              | Board             |
| ---------------------- | ----------------- |
| `esp32`                | ESP32 Dev Module  |
| `esp32s2`              | ESP32-S2          |
| `esp32s3`              | ESP32-S3          |
| `esp32c3`              | ESP32-C3          |
| `esp32c6`              | ESP32-C6          |
| `esp8266` or `nodemcu` | NodeMCU / ESP8266 |
| `uno`                  | Arduino Uno       |
| `nano`                 | Arduino Nano      |
| `mega`                 | Arduino Mega      |
| `leonardo`             | Arduino Leonardo  |

---

## ⚙️ Config File Explained

The `build.config.json` file is super simple:

```json
{
  "board": "esp32", // ← Just type the board name!
  "board_version": "latest", // ← Optional: "latest" or specific version "2.0.14"
  "sketch_path": ".", // ← Where your .ino file is
  "artifact_name": "Arduino-Binary", // ← Download file name
  "retention_days": 30 // ← Days to keep the file
}
```

**Examples:**

Want ESP32-S3?

```json
{ "board": "esp32s3" }
```

Want Arduino Uno?

```json
{ "board": "uno" }
```

Want NodeMCU?

```json
{ "board": "nodemcu" }
```

```

**Just edit this file and push - no need to touch the workflow!**

---

## 📋 Quick Reference Card

| Action         | Command                         |
| -------------- | ------------------------------- |
| Add changes    | `git add .`                     |
| Save changes   | `git commit -m "message"`       |
| Push to GitHub | `git push`                      |
| Check build    | GitHub → Actions tab            |
| Download file  | Actions → Click run → Artifacts |

---

## 🎉 You Did It!

Congratulations! You now have an automatic Arduino builder!

Every time you push code:

```

📝 Edit code → 🚀 git push → ⏳ Wait 2 min → 📦 Download .bin file!

```

---

## 🆘 Need Help?

- 📚 [Arduino Reference](https://www.arduino.cc/reference/en/)
- 📚 [ESP32 Arduino Guide](https://docs.espressif.com/projects/arduino-esp32/)
- 📚 [GitHub Actions Docs](https://docs.github.com/en/actions)

---

Made with ❤️ for beginners!
```
