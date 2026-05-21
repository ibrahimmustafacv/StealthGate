# StealthGate (formerly Lockphish) – Advanced Lock Screen Phishing Tool

**Developed & Maintained by:** Ibrahim Mustafa  
**GitHub:** [https://github.com/ibrahimmustafacv](https://github.com/ibrahimmustafacv)

---

## 📌 Description

StealthGate is a powerful **educational tool** for phishing attacks on lock screens.  
It can capture **Windows credentials, Android PIN, and iPhone passcode** using a public HTTPS link.  
The tool uses **Cloudflare Tunnel** (free, no ngrok required) to create a public link, and optionally supports ngrok.

> **⚠️ Legal Disclaimer:** This tool is designed for **authorized security testing and educational purposes only**.  
> Attacking targets without prior mutual consent is **illegal**. The developer assumes no liability for any misuse.

---

## ✨ Features

- ✅ **Lock screen phishing pages** for Windows, Android, and iPhone  
- ✅ **Manual attack type selection** (Android PIN / Windows Password / iPhone Passcode)  
- ✅ **Cloudflare Tunnel integration** (free, automatic)  
- ✅ **IP & User‑Agent tracking**  
- ✅ **Auto‑saving** of stolen credentials (PINs, passwords, passcodes)  
- ✅ **Clean landing page** with a button – no unwanted file downloads  
- ✅ **Custom redirect URL** after data capture

---

## 📦 Requirements

- Kali Linux (or any Linux distribution with PHP)  
- Internet connection (for Cloudflare Tunnel)  
- PHP (`sudo apt install php -y`)

---

## 🚀 Installation & Usage

```bash
# 1. Clone the repository (or download the script)
git clone https://github.com/ibrahimmustafacv/StealthGate.git
cd StealthGate

# 2. Make the script executable
chmod +x lockphish.sh

# 3. Run the tool
./lockphish.sh