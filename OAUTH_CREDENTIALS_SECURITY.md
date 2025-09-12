# OAuth Credentials Security Guide

## 🔐 Methods to Encrypt OAuth Credentials

### **Method 1: Rails Encrypted Credentials (Recommended)**

This is the most secure approach for Rails applications.

#### **Step 1: Edit Rails Credentials**
```bash
# Open credentials editor
EDITOR="nano" rails credentials:edit
```

#### **Step 2: Add OAuth credentials to the file**
```yaml
# config/credentials.yml.enc
google_oauth:
  client_id: "1075541779560-43lmq1vcre5qn4r62t8sam4j9lgv35h4.apps.googleusercontent.com"
  client_secret: "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"

# Other credentials can go here
smtp:
  user_name: my-smtp-user
  password: my-smtp-password

aws:
  access_key_id: 123
  secret_access_key: 345
```

#### **Step 3: Update Devise Configuration**
```ruby
# config/initializers/devise.rb
config.omniauth :google_oauth2, 
                Rails.application.credentials.google_oauth[:client_id], 
                Rails.application.credentials.google_oauth[:client_secret],
                scope: 'email,profile'
```

#### **Step 4: Remove from .env file**
```bash
# Remove these lines from .env
# GOOGLE_CLIENT_ID=...
# GOOGLE_CLIENT_SECRET=...
```

---

### **Method 2: Environment Variables with Encryption (Alternative)**

#### **Step 1: Use encrypted environment variables**
```bash
# In your .env file (for development only)
GOOGLE_CLIENT_ID_ENCRYPTED="encrypted_client_id_here"
GOOGLE_CLIENT_SECRET_ENCRYPTED="encrypted_client_secret_here"
```

#### **Step 2: Create a credentials service**
```ruby
# app/services/credentials_service.rb
class CredentialsService
  def self.google_client_id
    decrypt_credential(ENV['GOOGLE_CLIENT_ID_ENCRYPTED'])
  end

  def self.google_client_secret
    decrypt_credential(ENV['GOOGLE_CLIENT_SECRET_ENCRYPTED'])
  end

  private

  def self.decrypt_credential(encrypted_value)
    # Use Rails' built-in encryption
    Rails.application.message_verifier('oauth_credentials').verify(encrypted_value)
  end

  def self.encrypt_credential(value)
    # For encrypting credentials (use in Rails console)
    Rails.application.message_verifier('oauth_credentials').generate(value)
  end
end
```

---

### **Method 3: Production Environment Variables (Cloud Platforms)**

#### **For Heroku:**
```bash
heroku config:set GOOGLE_CLIENT_ID="your_client_id"
heroku config:set GOOGLE_CLIENT_SECRET="your_client_secret"
```

#### **For AWS/EC2:**
```bash
# Use AWS Systems Manager Parameter Store
aws ssm put-parameter --name "/ecommerce-app/google-client-id" --value "your_client_id" --type "SecureString"
aws ssm put-parameter --name "/ecommerce-app/google-client-secret" --value "your_client_secret" --type "SecureString"
```

#### **For Docker:**
```yaml
# docker-compose.yml
services:
  web:
    environment:
      - GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
      - GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}
```

---

## 🛡️ Security Best Practices

### **1. Never Commit Credentials**
```bash
# .gitignore should include:
.env
.env.local
.env.production
config/credentials.yml.enc.key
```

### **2. Use Different Credentials for Different Environments**
- **Development**: Use Rails credentials or .env
- **Staging**: Use environment variables
- **Production**: Use cloud platform secrets management

### **3. Rotate Credentials Regularly**
- Change OAuth credentials every 90 days
- Update all environments simultaneously
- Test thoroughly after rotation

### **4. Monitor Access**
- Enable Google Cloud Console audit logs
- Monitor OAuth usage patterns
- Set up alerts for unusual activity

### **5. Use Least Privilege**
- Only request necessary OAuth scopes
- Limit redirect URIs to your domains
- Use separate OAuth apps for different environments

---

## 🔧 Implementation Steps

### **Option A: Rails Credentials (Recommended)**

1. **Edit credentials:**
```bash
EDITOR="nano" rails credentials:edit
```

2. **Add OAuth section:**
```yaml
google_oauth:
  client_id: "your_client_id"
  client_secret: "your_client_secret"
```

3. **Update Devise config:**
```ruby
config.omniauth :google_oauth2, 
                Rails.application.credentials.google_oauth[:client_id], 
                Rails.application.credentials.google_oauth[:client_secret],
                scope: 'email,profile'
```

4. **Remove from .env:**
```bash
# Remove GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET from .env
```

### **Option B: Keep Environment Variables (Simpler)**

1. **Keep current .env setup**
2. **Ensure .env is in .gitignore**
3. **Use environment variables in production**

---

## 🚨 Security Checklist

- [ ] Credentials are not in version control
- [ ] Different credentials for each environment
- [ ] OAuth app configured with correct redirect URIs
- [ ] Minimal OAuth scopes requested
- [ ] Regular credential rotation scheduled
- [ ] Monitoring and alerting set up
- [ ] Team access properly managed

---

## 🔍 Testing Security

### **Check if credentials are secure:**
```bash
# Should return empty (credentials not in git)
git grep -r "GOOGLE_CLIENT_SECRET" .

# Should not show credentials in logs
grep -r "client_secret" log/
```

### **Verify OAuth flow:**
1. Test login with Google OAuth
2. Verify user creation works
3. Check that credentials are not exposed in browser
4. Confirm proper error handling

---

## 📝 Production Deployment

### **For Heroku:**
```bash
heroku config:set GOOGLE_CLIENT_ID="your_production_client_id"
heroku config:set GOOGLE_CLIENT_SECRET="your_production_client_secret"
```

### **For AWS:**
```bash
# Use AWS Secrets Manager
aws secretsmanager create-secret --name "ecommerce-app/oauth" --secret-string '{"client_id":"...","client_secret":"..."}'
```

### **For Docker:**
```bash
# Pass as build args or environment variables
docker run -e GOOGLE_CLIENT_ID="..." -e GOOGLE_CLIENT_SECRET="..." your-app
```

---

## 🆘 Emergency Procedures

### **If credentials are compromised:**
1. **Immediately revoke** in Google Cloud Console
2. **Generate new credentials**
3. **Update all environments**
4. **Monitor for suspicious activity**
5. **Notify team members**

### **Recovery steps:**
1. Access Google Cloud Console
2. Go to OAuth 2.0 Client IDs
3. Delete compromised credentials
4. Create new OAuth application
5. Update all deployment environments




