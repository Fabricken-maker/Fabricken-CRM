# Netlify Deployment Guide

## ✅ Status: Ready to Deploy!

Alla filer är genererade och committade till Git. Dags att pusha till GitHub och koppla till Netlify.

---

## 🚀 Step-by-Step Guide

### 1️⃣ Push till GitHub

**Option A: Med GitHub CLI (enklast)**
```bash
cd /root/.openclaw/workspace/crm/netlify-deploy

# Skapa repo (kräver GitHub CLI autentisering)
gh auth login
gh repo create fabricken-crm --public --source=. --remote=origin --push
```

**Option B: Manuellt**
```bash
# 1. Skapa repo på github.com/new (namn: fabricken-crm)
# 2. Lägg till remote
cd /root/.openclaw/workspace/crm/netlify-deploy
git remote add origin git@github.com:DITT-USERNAME/fabricken-crm.git
git push -u origin main
```

---

### 2️⃣ Koppla till Netlify

1. **Gå till:** https://app.netlify.com/start

2. **Connect to Git Provider**
   - Välj GitHub
   - Välj `fabricken-crm` repo

3. **Deploy Settings:**
   - **Branch to deploy:** `main`
   - **Build command:** _(lämna tom)_
   - **Publish directory:** `public`
   - **Click:** Deploy site

4. **Vänta ~30 sekunder** → Site is live! 🎉

---

### 3️⃣ Custom Domain (valfritt)

**Setup `crm.fabricken.se`:**

1. **Netlify Dashboard** → Site settings → Domain management
2. **Add custom domain:** `crm.fabricken.se`
3. **Lägg till DNS-record hos din DNS-provider:**
   ```
   Type: CNAME
   Name: crm
   Value: YOUR-SITE-NAME.netlify.app
   ```
4. **Enable HTTPS** (automatiskt via Let's Encrypt)

---

### 4️⃣ Auto-Deploy (valfritt)

**Setup daglig uppdatering:**

```bash
# Sätt upp SSH-nyckel för GitHub (om inte redan gjort)
ssh-keygen -t ed25519 -C "erik@fabricken.se" -f ~/.ssh/github_fabricken
cat ~/.ssh/github_fabricken.pub
# → Lägg till på GitHub: Settings → SSH and GPG keys

# Lägg till i SSH config
cat << EOF >> ~/.ssh/config
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_fabricken
EOF

# Setup cron
bash setup-cron.sh
# Följ instruktionerna för att välja schema
```

**Recommended schedule:** Daglig deploy kl 02:00
```cron
0 2 * * * bash /root/.openclaw/workspace/crm/netlify-deploy/auto-deploy.sh
```

---

## 🔄 Update Workflow

**När data ändras i CRM:**

**Manuell deploy:**
```bash
cd /root/.openclaw/workspace/crm/netlify-deploy
bash deploy.sh
git push origin main
```

**Auto-deploy:** Sker automatiskt via cron (om aktiverat)

---

## 📊 Dashboard Features

**Main Dashboard:**
- 5 metrics-kort (kunder, projekt, pipeline, levererat, ad spend)
- Klickbar kundlista (sorterad på värde)
- 4 Chart.js-grafer (revenue by type, top customers, campaigns, CTR)
- Project timeline

**Customer Detail Pages:**
- Full profil (namn, företag, email, status)
- 6 metrics (revenue, margin, ad spend, conversions, projekt, avg CTR)
- 2 grafer (project status, campaign performance)
- Projekt-lista (pris, kostnad, margin, deadline)
- Customer journey timeline
- Senaste interaktioner

---

## 🛠️ Troubleshooting

**Build fails on Netlify:**
- Check: Publish directory = `public` (not `./public`)
- Check: Build command is empty

**Charts not loading:**
- CDN issue → Check Chart.js CDN link in HTML
- Should load from: `https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js`

**Customer pages 404:**
- Check: Files exist in `public/customers/*.html`
- Check: Netlify redirects config in `netlify.toml`

**Auto-deploy not working:**
- Check cron logs: `tail -f /tmp/crm-deploy.log`
- Check Git push auth (SSH key setup)

---

## 🎯 Next Steps

1. ✅ Push to GitHub
2. ✅ Deploy to Netlify
3. ⚙️ (Optional) Setup custom domain
4. ⏰ (Optional) Setup auto-deploy cron
5. 🎨 (Future) Add more visualizations/features

---

**Support:** Om något strular, kolla loggarna:
- Deploy script: `/tmp/crm-deploy.log`
- Netlify build: Netlify dashboard → Deploys → Latest → Deploy log
