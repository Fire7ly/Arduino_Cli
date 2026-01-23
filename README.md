# 🚀 Arduino Auto-Build Project

This project automatically builds your Arduino code for **MANY** boards at once!

---

## 📖 What Does This Project Do?

```
You write code → Push to GitHub → ✨ Magic Robot ✨ → Builds for ALL your boards!
```

When you push (save) your code to GitHub, a robot will:

1. 🔨 **Build** your code for every board you listed
2. 📦 **Save** the compiled files
3. 🎁 **Give you** download links for each one

---

## ⚙️ How To Configure (Easy!)

Open `build.config.json` and tell the robot which boards you want.

### Example: Build for ESP32 and Arduino Uno

```json
{
  "targets": [
    {
      "board": "esp32",
      "versions": ["latest"]
    },
    {
      "board": "uno",
      "versions": ["latest"]
    }
  ],
  "sketch_path": ".",
  "artifact_prefix": "My-Awesome-Build"
}
```

### 🧩 What does this mean?

- **`targets`**: The list of boards you want to build for.
- **`board`**: The name of the board (like `esp32`, `uno`, `nano`).
- **`versions`**: Which version of the core to use (usually just `["latest"]`).

---

## 🎯 Step-by-Step Tutorial

### Step 1: Make Changes ✏️

1. Open `Arduino_Cli.ino` and write your cool code.
2. Open `build.config.json` and list your boards.

### Step 2: Push to GitHub 🚀

Save your work and send it to the cloud:

```bash
git add .
git commit -m "Updated my code!"
git push
```

### Step 3: Watch The Magic! ✨

1. Go to **"Actions"** tab on GitHub.
2. Click the yellow circle 🟡 (it means the robot is working).
3. Wait for it to turn green ✅.

### Step 4: Download Your Files 📥

1. Click on the green ✅ checkmark.
2. Scroll down to **"Artifacts"**.
3. You will see a file for EACH board you listed!
   - `My-Awesome-Build-esp32-latest`
   - `My-Awesome-Build-uno-latest`
4. Click to download the one you need.

---

## 🏷️ How To Release (Publish)

When you are ready to "release" a version (like `v1.0.0`):

### Option 1: The Easy Way (GitHub Website) 🌐

1. Go to your repository on GitHub.
2. Click **"Releases"** (on the right side).
3. Click **"Draft a new release"**.
4. Click **"Choose a tag"** > Type `v1.0.0` > Click **"Create new tag"**.
5. Click **"Publish release"**.
   - The robot will wake up, build your code, and add the files to this release automatically!

### Option 2: The Hacker Way (Command Line) 💻

```bash
git tag v1.0.0
git push origin v1.0.0
```

### Option 3: Config File Release (No Tags!) ⚙️

1. Open `build.config.json`
2. Add a `settings` block to the board you want to release:
   ```json
   {
     "board": "esp32",
     "versions": ["latest"],
     "settings": {
       "version": "0.0.1",
       "release_enabled": true
     }
   }
   ```
3. Push your changes!
   - The robot will check each board. If `release_enabled` is true, it creates/updates the release `v0.0.1` with that board's binary.

---

## 📋 Supported Boards

| Name to type | Board Description |
| :----------- | :---------------- |
| `esp32`      | ESP32 Dev Module  |
| `esp32s2`    | ESP32-S2          |
| `esp32s3`    | ESP32-S3          |
| `esp8266`    | NodeMCU / ESP8266 |
| `uno`        | Arduino Uno       |
| `nano`       | Arduino Nano      |
| `mega`       | Arduino Mega      |
| `leonardo`   | Arduino Leonardo  |

---

## ❓ FAQ

**Q: Can I build for specific versions?**
A: Yes! Change `"versions": ["latest"]` to `"versions": ["2.0.6"]`.

**Q: Where is the magic code?**
A: It's in `.github/workflows/main.yml`. It uses a helper script `generate_matrix.py` to read your config and tell the robot what to do. **You don't need to touch these files!**

---

Made with ❤️ for everyone!
