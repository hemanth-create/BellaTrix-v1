# Quick Deployment Guide for EC2

## 🚀 One-Command Deployment

### On EC2 Instance:

```bash
# SSH into EC2
ssh -i your-key.pem ubuntu@43.204.142.218

# Clone repository (first time only)
cd /home/ubuntu
git clone https://github.com/infofitsoftwaresolution/BellaTrix-v1.git
cd BellaTrix-v1

# Run deployment script
chmod +x scripts/deploy-to-ec2.sh
./scripts/deploy-to-ec2.sh
```

That's it! The script will:
1. ✅ Pull latest code from GitHub
2. ✅ Set up environment from GitHub Secrets
3. ✅ Install dependencies
4. ✅ Configure Nginx
5. ✅ Set up systemd service
6. ✅ Start the application
7. ✅ Perform health check

---

## 🔄 Quick Update (After Initial Deployment)

```bash
cd /home/ubuntu/BellaTrix-v1
./scripts/deploy-to-ec2.sh
```

Or use the quick deploy script:

```bash
cd /home/ubuntu/BellaTrix-v1
./scripts/quick-deploy.sh
```

---

## 📋 Prerequisites Checklist

Before running deployment, ensure:

- [ ] EC2 instance is running at `43.204.142.218`
- [ ] Security Group allows port 80 (HTTP)
- [ ] GitHub Secrets are configured in repository
- [ ] SSH access to EC2 is working

---

## 🔍 Verify Deployment

After deployment, check:

1. **Service Status:**
   ```bash
   sudo systemctl status streamlit-BellaTrix-v1.service
   ```

2. **Access Application:**
   Open browser: `http://43.204.142.218/`

3. **View Logs:**
   ```bash
   sudo journalctl -u streamlit-BellaTrix-v1.service -f
   ```

---

## 🛠️ Troubleshooting

### Service won't start?
```bash
sudo journalctl -u streamlit-BellaTrix-v1.service -n 50
```

### Can't access from browser?
1. Check Security Group (port 80 open)
2. Check Nginx: `sudo systemctl status nginx`
3. Check Streamlit: `sudo systemctl status streamlit-BellaTrix-v1.service`

### Environment variables missing?
```bash
cd /home/ubuntu/BellaTrix-v1
./scripts/setup-from-github-secrets.sh
```

---

For detailed deployment instructions, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

