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
- 🔊 Requires only **Termux:API** and **FFmpeg**

---

## ⚙️ Requirements

Make sure you have the following installed in Termux:

```bash
pkg update
pkg install termux-api ffmpeg
```
