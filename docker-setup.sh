#!/bin/bash

# Docker setup script for ecommerce app
set -e

echo "🚀 Setting up Docker environment for ecommerce app..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Build and start services
echo "📦 Building and starting Docker services..."
docker-compose up --build -d

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Setup database
echo "🗄️  Setting up database..."
docker-compose exec web bundle exec rails db:create
docker-compose exec web bundle exec rails db:migrate
docker-compose exec web bundle exec rails db:seed

# Install dependencies
echo "📚 Installing dependencies..."
docker-compose exec web bundle install
docker-compose exec web yarn install

# Precompile assets
echo "🎨 Precompiling assets..."
docker-compose exec web bundle exec rails assets:precompile

echo "✅ Docker setup complete!"
echo ""
echo "🌐 Your app is now running at: http://localhost:3000"
echo "🗄️  Database is available at: localhost:5432"
echo ""
echo "📋 Useful commands:"
echo "  docker-compose up -d          # Start services"
echo "  docker-compose down           # Stop services"
echo "  docker-compose exec web bash  # Access web container"
echo "  docker-compose logs web       # View web logs"
echo "  docker-compose logs db        # View database logs"
