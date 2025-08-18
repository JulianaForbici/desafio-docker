<p align="center">
  <img src="https://images.squarespace-cdn.com/content/v1/551a19f8e4b0e8322a93850a/1602020393443-L6M0DGZK4C75DRNR7GZH/Title_Animation.gif" alt="Pizza Banner" width="500"/>
</p>

<p align="center">
  <img src="https://cdn.pixabay.com/photo/2020/04/20/16/28/pizza-5068912_1280.png" alt="Pixel Pizza" width="120"/>
  <img src="https://i.pinimg.com/originals/60/cd/20/60cd200955c90b607efe0c7ff2f46975.gif" alt="Pizza Pixel GIF" width="120"/>
</p>

---

# 🍕 Pizzaria Auto-Deploy Project

Welcome to **Forbici's Pizzaria**, a dynamic, self-updating Dockerized project that makes sure your app is always fresh... like a good pizza out of the oven! 🔥

---

## 🚀 Features

- Automatic install of all required dependencies
- Pulls the latest code from GitHub
- Rebuilds Docker containers **only if code changed**
- Runs on `cron` every 5 minutes to auto-update
- Exposes:
  - Frontend: `http://localhost`
  - Backend: `http://localhost:5001`

---

## 🛠️ How to deploy

### Run this on your server:
```bash
curl -O https://raw.githubusercontent.com/JulianaForbici/desafio-docker/main/deploy.sh
chmod +x deploy.sh
sudo ./deploy.sh
