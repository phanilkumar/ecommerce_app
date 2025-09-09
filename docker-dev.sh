#!/bin/bash

# Development helper script for Docker
set -e

case "$1" in
  "start")
    echo "🚀 Starting development environment..."
    docker-compose up -d
    echo "✅ Services started. App available at http://localhost:3000"
    ;;
  "stop")
    echo "🛑 Stopping development environment..."
    docker-compose down
    echo "✅ Services stopped"
    ;;
  "restart")
    echo "🔄 Restarting development environment..."
    docker-compose down
    docker-compose up -d
    echo "✅ Services restarted"
    ;;
  "logs")
    docker-compose logs -f web
    ;;
  "shell")
    docker-compose exec web bash
    ;;
  "console")
    docker-compose exec web bundle exec rails console
    ;;
  "migrate")
    docker-compose exec web bundle exec rails db:migrate
    ;;
  "seed")
    docker-compose exec web bundle exec rails db:seed
    ;;
  "test")
    docker-compose exec web bundle exec rails test
    ;;
  "build")
    echo "🔨 Building Docker images..."
    docker-compose build
    echo "✅ Build complete"
    ;;
  "clean")
    echo "🧹 Cleaning up Docker resources..."
    docker-compose down -v
    docker system prune -f
    echo "✅ Cleanup complete"
    ;;
  *)
    echo "🐳 Docker Development Helper"
    echo ""
    echo "Usage: $0 {start|stop|restart|logs|shell|console|migrate|seed|test|build|clean}"
    echo ""
    echo "Commands:"
    echo "  start    - Start all services"
    echo "  stop     - Stop all services"
    echo "  restart  - Restart all services"
    echo "  logs     - Show web service logs"
    echo "  shell    - Access web container shell"
    echo "  console  - Open Rails console"
    echo "  migrate  - Run database migrations"
    echo "  seed     - Seed the database"
    echo "  test     - Run tests"
    echo "  build    - Build Docker images"
    echo "  clean    - Clean up Docker resources"
    ;;
esac
