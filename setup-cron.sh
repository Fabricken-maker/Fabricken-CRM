#!/bin/bash

DEPLOY_DIR="/root/.openclaw/workspace/crm/netlify-deploy"

echo "⏰ Setting up auto-deploy cron job"
echo "===================================="
echo ""

# Create cron job script
cat << 'EOF' > "$DEPLOY_DIR/auto-deploy.sh"
#!/bin/bash
cd /root/.openclaw/workspace/crm/netlify-deploy

# Run deploy script
bash deploy.sh >> /tmp/crm-deploy.log 2>&1

# Push to GitHub (requires SSH key setup)
git push origin main >> /tmp/crm-deploy.log 2>&1

# Log result
if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Deploy successful" >> /tmp/crm-deploy.log
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ❌ Deploy failed" >> /tmp/crm-deploy.log
fi
EOF

chmod +x "$DEPLOY_DIR/auto-deploy.sh"

echo "✅ Auto-deploy script created: $DEPLOY_DIR/auto-deploy.sh"
echo ""
echo "📋 Suggested cron schedules:"
echo ""
echo "Daily at 2 AM:"
echo "0 2 * * * bash $DEPLOY_DIR/auto-deploy.sh"
echo ""
echo "Every 6 hours:"
echo "0 */6 * * * bash $DEPLOY_DIR/auto-deploy.sh"
echo ""
echo "Twice daily (9 AM & 9 PM):"
echo "0 9,21 * * * bash $DEPLOY_DIR/auto-deploy.sh"
echo ""
echo "To add cron job:"
echo "crontab -e"
echo ""
echo "Then paste one of the schedules above."
echo ""
echo "📝 Logs will be saved to: /tmp/crm-deploy.log"
