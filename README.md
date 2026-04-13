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
