#!/bin/bash
set -e

WORKSPACE="/root/.openclaw/workspace/crm"
DEPLOY_DIR="/root/.openclaw/workspace/crm/netlify-deploy"
DASHBOARD_DIR="$WORKSPACE/dashboard"

echo "🔄 CRM Dashboard Deploy Script"
echo "================================"

# Step 1: Generate fresh HTML files
echo ""
echo "📊 Step 1: Generating analytics dashboard..."
cd "$DASHBOARD_DIR"
python3 generate-analytics-with-nav.py

echo "👥 Step 2: Generating customer pages..."
python3 generate-customer-pages.py

# Step 2: Copy files to deploy directory
echo ""
echo "📦 Step 3: Copying files to deploy directory..."
rm -rf "$DEPLOY_DIR/public"
mkdir -p "$DEPLOY_DIR/public"

# Copy main dashboard
cp "$DASHBOARD_DIR/index.html" "$DEPLOY_DIR/public/"

# Copy customer pages
cp -r "$DASHBOARD_DIR/customers" "$DEPLOY_DIR/public/"

# Step 3: Create netlify.toml config
echo ""
echo "⚙️  Step 4: Creating Netlify config..."
cat << 'NETLIFY_EOF' > "$DEPLOY_DIR/netlify.toml"
[build]
  publish = "public"
  
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
NETLIFY_EOF

# Step 4: Create README
cat << 'README_EOF' > "$DEPLOY_DIR/README.md"
# Fabricken CRM Dashboard

Analytics dashboard för Fabricken kunder, projekt och kampanjer.

## Deployment

This site auto-deploys to Netlify when changes are pushed to main branch.

## Update Process

1. Data changes in SQLite database (`fabricken.db`)
2. Run `bash deploy.sh` to regenerate HTML
3. Commit and push to trigger Netlify deploy

## Structure

- `public/index.html` - Main analytics dashboard
- `public/customers/*.html` - Individual customer detail pages

## Tech Stack

- **Backend:** Python + SQLite (generates static HTML)
- **Frontend:** Chart.js for visualizations
- **Deploy:** Netlify (static hosting)
- **Update:** Cron job (daily regeneration)
README_EOF

# Step 5: Git setup
echo ""
echo "🔧 Step 5: Setting up Git repository..."
cd "$DEPLOY_DIR"

if [ ! -d ".git" ]; then
    git init
    git branch -M main
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Create .gitignore
cat << 'GITIGNORE_EOF' > .gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python

# Env
.env
venv/
ENV/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
GITIGNORE_EOF

# Step 6: Stage and commit
echo ""
echo "📝 Step 6: Staging files..."
git add .

if git diff --cached --quiet; then
    echo "⏭️  No changes to commit"
else
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "Deploy update: $TIMESTAMP"
    echo "✅ Changes committed"
fi

# Step 7: Summary
echo ""
echo "================================"
echo "✅ Deploy preparation complete!"
echo ""
echo "📊 Generated files:"
echo "   - Main dashboard: public/index.html"
echo "   - Customer pages: public/customers/*.html"
echo ""
echo "🚀 Next steps:"
echo ""
echo "1. Create GitHub repository:"
echo "   gh repo create fabricken-crm --public --source=. --remote=origin"
echo ""
echo "2. Push to GitHub:"
echo "   git push -u origin main"
echo ""
echo "3. Connect to Netlify:"
echo "   - Go to https://app.netlify.com/start"
echo "   - Connect your GitHub repo"
echo "   - Deploy settings:"
echo "     * Build command: (leave empty)"
echo "     * Publish directory: public"
echo ""
echo "4. (Optional) Setup auto-deploy cron:"
echo "   bash setup-cron.sh"
echo ""
