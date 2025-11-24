#!/bin/bash
# Script to check deployment status and diagnose issues

PROJECT_DIR="/home/ubuntu/BellaTrix-v1"

echo "========================================"
echo "🔍 Deployment Status Check"
echo "========================================"
echo ""

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Project directory not found: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"

# 1. Check Git status
echo "📥 Git Status:"
echo "   Current branch: $(git branch --show-current)"
echo "   Latest commit: $(git log -1 --oneline)"
echo "   Remote URL: $(git remote get-url origin)"
echo ""

# 2. Check if up to date with remote
echo "🔄 Checking for updates..."
git fetch origin
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
if [ "$LOCAL" = "$REMOTE" ]; then
    echo "   ✅ Code is up to date with remote"
else
    echo "   ⚠️  Local code is behind remote!"
    echo "   Run: ./scripts/update-live-site.sh"
fi
echo ""

# 3. Check .env file
echo "🔐 Environment Configuration:"
if [ -f ".env" ]; then
    echo "   ✅ .env file exists"
    echo "   File size: $(stat -f%z .env 2>/dev/null || stat -c%s .env 2>/dev/null) bytes"
    echo "   Last modified: $(stat -f%Sm .env 2>/dev/null || stat -c%y .env 2>/dev/null | cut -d' ' -f1-2)"
else
    echo "   ❌ .env file not found!"
    echo "   Run: ./scripts/setup-from-github-secrets.sh"
fi
echo ""

# 4. Check virtual environment
echo "🐍 Python Environment:"
if [ -d ".venv" ]; then
    echo "   ✅ Virtual environment exists"
    if [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
        echo "   Python version: $(python --version)"
        echo "   Pip version: $(pip --version | cut -d' ' -f2)"
    fi
else
    echo "   ❌ Virtual environment not found!"
fi
echo ""

# 5. Check Streamlit service
echo "⚙️  Streamlit Service:"
if sudo systemctl is-active --quiet streamlit-BellaTrix-v1.service; then
    echo "   ✅ Service is running"
    echo "   Status: $(sudo systemctl is-active streamlit-BellaTrix-v1.service)"
else
    echo "   ❌ Service is not running!"
    echo "   Status: $(sudo systemctl is-active streamlit-BellaTrix-v1.service)"
fi

# Get service status
echo ""
echo "   Service details:"
sudo systemctl status streamlit-BellaTrix-v1.service --no-pager -l | head -10
echo ""

# 6. Check if port 8501 is listening
echo "🔌 Port Status:"
if sudo netstat -tuln 2>/dev/null | grep -q ":8501" || sudo ss -tuln 2>/dev/null | grep -q ":8501"; then
    echo "   ✅ Port 8501 is listening"
else
    echo "   ❌ Port 8501 is not listening"
fi
echo ""

# 7. Check Nginx
echo "🌐 Nginx Status:"
if sudo systemctl is-active --quiet nginx; then
    echo "   ✅ Nginx is running"
    if sudo nginx -t 2>&1 | grep -q "successful"; then
        echo "   ✅ Nginx configuration is valid"
    else
        echo "   ❌ Nginx configuration has errors!"
        sudo nginx -t
    fi
else
    echo "   ❌ Nginx is not running!"
fi
echo ""

# 8. Test local connection
echo "🏥 Health Check:"
if curl -f -s --max-time 5 http://localhost:8501/ > /dev/null 2>&1; then
    echo "   ✅ Local connection successful"
else
    echo "   ❌ Local connection failed"
    echo "   Streamlit might not be running or is still starting"
fi
echo ""

# 9. Check recent logs for errors
echo "📋 Recent Logs (last 5 lines):"
sudo journalctl -u streamlit-BellaTrix-v1.service -n 5 --no-pager | tail -5
echo ""

# 10. Summary
echo "========================================"
echo "📊 Summary"
echo "========================================"
echo ""
echo "🌐 Application URL: http://43.204.142.218/"
echo ""
echo "💡 Next Steps:"
if [ "$LOCAL" != "$REMOTE" ]; then
    echo "   1. Update code: ./scripts/update-live-site.sh"
fi
if [ ! -f ".env" ]; then
    echo "   2. Set up environment: ./scripts/setup-from-github-secrets.sh"
fi
if ! sudo systemctl is-active --quiet streamlit-BellaTrix-v1.service; then
    echo "   3. Start service: sudo systemctl start streamlit-BellaTrix-v1.service"
fi
echo "   4. View logs: sudo journalctl -u streamlit-BellaTrix-v1.service -f"
echo "   5. Clear browser cache if changes not visible"
echo ""

