# 🎙️ Lundy Recorder  
> _"Agent Lundy never missed a word."_  

A **Termux-based field recorder** that turns your Android device into a professional-grade voice logger —  
complete with **start, pause, resume, and stop** commands, automatic **segment merging**, and **48 kHz / 32-bit PCM** recording quality.

It’s designed for hobbyists, journalists, and anyone who’s ever wanted to feel like a detective conducting secret fieldwork.

---

## 🧩 Features

- 🎤 Record high-quality WAV audio directly from your microphone  
- ⏸️ Pause and resume seamlessly — each session is stored as a segment  
- 🎚️ Auto-merges all segments into one final file when you stop  
- 💾 Saves to a persistent folder (`~/Recordings/Lundy` by default)  
- 🕵️ Interactive command shell (start, pause, resume, stop, status, exit)  
- 📂 Archives all raw segments for safekeeping  
- 🔊 Requires only **Termux:API** & **FFmpeg**

---

## ⚙️ Requirements

Make sure you have the following installed in Termux:

```bash
pkg update
pkg install termux-api ffmpeg
```

Grant microphone permission:
```bash
termux-microphone-record -g
```

Optionally allow file storage:
```bash
termux-setup-storage
```

---

## 🚀 Installation

Clone this repo:
```bash
https://github.com/HassanIQ777/Lundy-Recorder.git
cd Lundy-Recorder
chmod +x lundy_recorder.sh
```

---

## 🕹️ Usage

Launch the recorder:
```bash
./lundy_recorder.sh
```

Then control everything live with these commands:

| Command  | Description                                        |
| -------- | -------------------------------------------------- |
| `start`  | Begin recording a new segment                      |
| `pause`  | Stop current recording but keep data               |
| `resume` | Start recording another segment                    |
| `stop`   | Finalize session, merge all segments into one file |
| `status` | Show session info and current segments             |
| `exit`   | Quit the recorder safely                           |
| `force`  | Emergency exit (kills recording)                   |

---

## 📁 Where files go

Final recordings are saved by default in:
```bash
~/Recordings/Lundy/
```

Each session produces:

- A merged, high-quality WAV file named like Lundy_20251111_213400.wav
- An archive folder with the raw recording segments


---

## 🔬 Audio Specs

| Setting     | Value      |
| ----------- | ---------- |
| Sample rate | 48,000 Hz  |
| Channels    | Stereo (2) |
| Format      | 32-bit PCM |
| Container   | WAV        |

These specs ensure lossless, studio-quality audio suitable for transcription or **forensic** analysis.

---

## 🕵️ Fun Uses

- Field interviews
- Storyboarding voice notes
- Detective / roleplay recording
- DIY evidence logger
- Personal “voice journal” system

You’ll feel like you’re running surveillance ops from your terminal.

---

## ⚠️ Notes & Tips

- Always stop before exiting — otherwise your last segment won’t be merged.
- You can change the output folder by editing:
```bash
TARGET_FOLDER_DEFAULT="$HOME/Recordings/Lundy"
```
- You can run this script even while offline — everything is local.

---

## 💡 Coming Soon (Ideas)

- Live ASCII VU meter (mic level indicator)
- Configurable audio format (FLAC, MP3, etc.)
- “Case mode” — name each session after a case ID

---

## 🧾 License

MIT License — free to use, modify, and improve.
Attribution appreciated but not required.

---

🧍‍♂️ Credits

- Built by HassanIQ777

Inspired by *FBI Special Agent Frank Lundy* (From *Dexter*).

> _"You never know when the truth will speak — keep the tape rolling."_
























