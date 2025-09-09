# Docker Setup for Ecommerce App

This document explains how to set up and run the ecommerce application using Docker.

## Prerequisites

- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)

## Quick Start

1. **Clone and navigate to the project:**
   ```bash
   cd ecommerce_app
   ```

2. **Run the setup script:**
   ```bash
   ./docker-setup.sh
   ```

3. **Access the application:**
   - Web app: http://localhost:3000
   - Database: localhost:5432
   - Redis: localhost:6379

## Manual Setup

If you prefer to set up manually:

1. **Build and start services:**
   ```bash
   docker-compose up --build -d
   ```

2. **Set up the database:**
   ```bash
   docker-compose exec web bundle exec rails db:create
   docker-compose exec web bundle exec rails db:migrate
   docker-compose exec web bundle exec rails db:seed
   ```

3. **Install dependencies:**
   ```bash
   docker-compose exec web bundle install
   docker-compose exec web yarn install
   ```

## Development Commands

Use the helper script for common development tasks:

```bash
./docker-dev.sh [command]
```

Available commands:
- `start` - Start all services
- `stop` - Stop all services
- `restart` - Restart all services
- `logs` - Show web service logs
- `shell` - Access web container shell
- `console` - Open Rails console
- `migrate` - Run database migrations
- `seed` - Seed the database
- `test` - Run tests
- `build` - Build Docker images
- `clean` - Clean up Docker resources

## Services

### Web Application
- **Container:** `web`
- **Port:** 3000
- **Command:** Rails server
- **Volumes:** Source code, bundle cache, node_modules

### Database (PostgreSQL)
- **Container:** `db`
- **Port:** 5432
- **Database:** ecommerce_app_development
- **Username:** postgres
- **Password:** password

### Redis
- **Container:** `redis`
- **Port:** 6379
- **Purpose:** Caching and background jobs

### Background Worker
- **Container:** `worker`
- **Command:** Solid Queue worker
- **Purpose:** Process background jobs

## Environment Variables

Copy `env.example` to `.env` and modify as needed:

```bash
cp env.example .env
```

Key variables:
- `DB_HOST` - Database host (use `db` for Docker)
- `DATABASE_URL` - Full database connection string
- `REDIS_URL` - Redis connection string
- `RAILS_ENV` - Rails environment

## File Structure

```
ecommerce_app/
├── Dockerfile              # Production Docker image
├── Dockerfile.dev          # Development Docker image
├── docker-compose.yml      # Multi-service configuration
├── .dockerignore           # Files to exclude from Docker context
├── docker-setup.sh         # Initial setup script
├── docker-dev.sh           # Development helper script
├── init.sql                # Database initialization
├── env.example             # Environment variables template
└── README-Docker.md        # This file
```

## Troubleshooting

### Database Connection Issues
```bash
# Check if database is running
docker-compose ps db

# View database logs
docker-compose logs db

# Reset database
docker-compose exec web bundle exec rails db:drop db:create db:migrate db:seed
```

### Port Conflicts
If ports 3000, 5432, or 6379 are already in use, modify the ports in `docker-compose.yml`:

```yaml
ports:
  - "3001:3000"  # Change 3000 to 3001
```

### Permission Issues
```bash
# Fix file permissions
sudo chown -R $USER:$USER .
```

### Clean Start
```bash
# Stop and remove all containers, networks, and volumes
docker-compose down -v

# Remove all unused Docker resources
docker system prune -f

# Rebuild and start
docker-compose up --build -d
```

## Production Deployment

For production deployment, use the existing `Dockerfile` with Kamal or your preferred deployment method. The production Dockerfile is optimized for size and security.

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Rails Docker Guide](https://guides.rubyonrails.org/getting_started_with_devcontainer.html)
