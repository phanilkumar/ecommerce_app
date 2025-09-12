# Database Setup Guide

## 🚨 Database Connection Issue - SOLVED!

The error you encountered was because your application was configured for Docker but you were trying to run it directly.

## ✅ **Solution Implemented:**

### **1. Database is Running**
- PostgreSQL database is now running via Docker
- Database is accessible on `localhost:5432`

### **2. Migrations Completed**
- OAuth fields have been added to the users table
- Database schema is up to date

### **3. OAuth Credentials Working**
- Encrypted credentials are properly loaded
- Google OAuth is configured and ready

## 🚀 **How to Run the Application:**

### **Option 1: Use the Startup Script (Recommended)**
```bash
./start_app.sh
```

### **Option 2: Manual Commands**
```bash
# Start database
docker-compose up -d db

# Run migrations
DATABASE_URL=postgres://postgres:password@localhost:5432/ecommerce_app_development rails db:migrate

# Start server
DATABASE_URL=postgres://postgres:password@localhost:5432/ecommerce_app_development rails server
```

### **Option 3: Use Docker Compose (Full Docker)**
```bash
# Start everything with Docker
docker-compose up

# Or run in background
docker-compose up -d
```

## 🔧 **What Was Fixed:**

### **Problem:**
- Your `.env` file had `DB_HOST=db` (Docker service name)
- Rails was trying to connect to hostname "db" instead of "localhost"
- Database wasn't running

### **Solution:**
- Started PostgreSQL database with Docker
- Used `DATABASE_URL` to override database configuration
- Ran migrations successfully
- Verified OAuth credentials are working

## 📊 **Database Configuration:**

### **Current Setup:**
- **Host:** localhost (when running Rails directly)
- **Port:** 5432
- **Database:** ecommerce_app_development
- **Username:** postgres
- **Password:** password

### **Environment Variables:**
```bash
DATABASE_URL=postgres://postgres:password@localhost:5432/ecommerce_app_development
```

## 🧪 **Testing OAuth:**

1. **Start the application:**
```bash
./start_app.sh
```

2. **Open browser:**
   - Go to: http://localhost:3000/users/sign_in
   - Click "Sign in with Google"
   - Complete OAuth flow

3. **Verify:**
   - User should be created in database
   - OAuth fields should be populated
   - User should be signed in

## 🛠️ **Troubleshooting:**

### **If you get database connection errors:**
```bash
# Check if database is running
docker ps | grep postgres

# Restart database
docker-compose restart db

# Check database logs
docker-compose logs db
```

### **If migrations fail:**
```bash
# Reset database
DATABASE_URL=postgres://postgres:password@localhost:5432/ecommerce_app_development rails db:drop
DATABASE_URL=postgres://postgres:password@localhost:5432/ecommerce_app_development rails db:create
DATABASE_URL=postgres://postgres:password@localhost:5432/ecommerce_app_development rails db:migrate
```

### **If OAuth doesn't work:**
```bash
# Test credentials
DATABASE_URL=postgres://postgres:password@localhost:5432/ecommerce_app_development rails runner "puts Rails.application.credentials.google_oauth[:client_id]"

# Check routes
rails routes | grep google
```

## 📝 **Environment Configuration:**

### **For Development:**
- Use the startup script: `./start_app.sh`
- Database runs in Docker
- Rails runs directly (not in Docker)

### **For Production:**
- Use proper environment variables
- Use cloud database services
- Use encrypted credentials or secrets management

## 🎯 **Next Steps:**

1. **Test OAuth flow** - Sign in with Google
2. **Add more OAuth providers** - Facebook, GitHub, etc.
3. **Customize user model** - Add more fields as needed
4. **Deploy to production** - Use proper secrets management

## 🔐 **Security Notes:**

- OAuth credentials are encrypted in Rails credentials
- Database password is in Docker environment (development only)
- For production, use proper secrets management
- Never commit `.env` files to version control

---

## ✅ **Status: READY TO TEST!**

Your application is now properly configured and ready to test OAuth authentication!




