# Production Email Configuration Guide

This guide explains how to configure email delivery for production deployment.

## Environment Variables

Set the following environment variables in your production environment:

### Required Variables

```bash
# SMTP Server Configuration
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_DOMAIN=yourdomain.com
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true

# Mailer Host (your production domain)
MAILER_HOST=yourdomain.com
```

## SMTP Provider Examples

### Gmail
```bash
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_AUTHENTICATION=plain
# Note: Use App Password, not your regular Gmail password
```

### SendGrid
```bash
SMTP_ADDRESS=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USERNAME=apikey
SMTP_PASSWORD=your-sendgrid-api-key
```

### Mailgun
```bash
SMTP_ADDRESS=smtp.mailgun.org
SMTP_PORT=587
SMTP_USERNAME=your-mailgun-smtp-username
SMTP_PASSWORD=your-mailgun-smtp-password
```

### Amazon SES
```bash
SMTP_ADDRESS=email-smtp.us-east-1.amazonaws.com
SMTP_PORT=587
SMTP_USERNAME=your-ses-smtp-username
SMTP_PASSWORD=your-ses-smtp-password
```

## Deployment Platforms

### Heroku
```bash
heroku config:set SMTP_ADDRESS=smtp.gmail.com
heroku config:set SMTP_PORT=587
heroku config:set SMTP_DOMAIN=yourdomain.com
heroku config:set SMTP_USERNAME=your-email@gmail.com
heroku config:set SMTP_PASSWORD=your-app-password
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set MAILER_HOST=yourdomain.com
```

### Railway
Add environment variables in your Railway dashboard under the Variables tab.

### DigitalOcean App Platform
Add environment variables in your app settings.

## Security Notes

1. **Never commit email credentials to version control**
2. **Use App Passwords for Gmail** (not your regular password)
3. **Use environment variables** for all sensitive configuration
4. **Enable 2FA** on your email account before using App Passwords

## Testing

After deployment, test the forgot password feature:

1. Visit your production site
2. Go to the login page
3. Click "Forgot your password?"
4. Enter a valid email address
5. Check that the reset email is delivered

## Troubleshooting

### Common Issues

1. **Authentication failed**: Check username/password
2. **Connection timeout**: Verify SMTP address and port
3. **SSL/TLS errors**: Ensure `SMTP_ENABLE_STARTTLS_AUTO=true`
4. **Domain not verified**: For SES, verify your domain

### Logs

Check your application logs for email delivery errors:
```bash
# Heroku
heroku logs --tail

# Railway
railway logs

# DigitalOcean
doctl apps logs your-app-id
```
