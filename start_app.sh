#!/bin/bash

# Ecommerce App Startup Script
echo "🚀 Starting Ecommerce App..."

# Start PostgreSQL database
echo "📊 Starting PostgreSQL database..."
docker-compose up -d db

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 5

# Run migrations
echo "🔄 Running database migrations..."
DATABASE_URL=postgres://postgres:password@localhost:5432/ecommerce_app_development rails db:migrate

# Start Rails server
echo "🌐 Starting Rails server..."
echo "📍 Server will be available at: http://localhost:3000"
echo "🔐 OAuth login available at: http://localhost:3000/users/sign_in"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

DATABASE_URL=postgres://postgres:password@localhost:5432/ecommerce_app_development rails server




