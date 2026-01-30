# Task Tracker API

A RESTful API built with Ruby on Rails 8.1.2 for managing tasks. This API provides endpoints to create and list tasks with token-based authentication.

## Features

- **Task Management**: Create and retrieve tasks
- **Token-based Authentication**: Secure API access using X-API-TOKEN header
- **RESTful API**: Clean JSON API following REST conventions
- **SQLite Database**: Lightweight database for easy setup
- **Docker Support**: Fully containerized for easy deployment
- **Health Check Endpoint**: Monitor API status
- **RSpec Test Suite**: Comprehensive test coverage

## API Endpoints

### Health Check
- **GET** `/up`
  - Returns the health status of the API
  - No authentication required

### Tasks

#### List All Tasks
- **GET** `/api/v1/tasks`
  - Returns all tasks ordered by creation date (newest first)
  - **Authentication**: Required (X-API-TOKEN header)
  - **Response**: 
    ```json
    {
      "status": 200,
      "data": [
        {
          "id": 1,
          "description": "Complete project documentation",
          "created_at": "2024-01-30T18:44:39.000Z",
          "updated_at": "2024-01-30T18:44:39.000Z"
        }
      ]
    }
    ```

#### Create a Task
- **POST** `/api/v1/tasks`
  - Creates a new task
  - **Authentication**: Required (X-API-TOKEN header)
  - **Request Body**:
    ```json
    {
      "task": {
        "description": "New task description"
      }
    }
    ```
  - **Success Response** (201):
    ```json
    {
      "status": 201,
      "data": {
        "id": 1,
        "description": "New task description",
        "created_at": "2024-01-30T18:44:39.000Z",
        "updated_at": "2024-01-30T18:44:39.000Z"
      }
    }
    ```
  - **Error Response** (422):
    ```json
    {
      "status": 422,
      "errors": ["Description can't be blank"]
    }
    ```

## Authentication

All API endpoints (except `/up`) require authentication using the `X-API-TOKEN` header:

```bash
curl -H "X-API-TOKEN: your-secret-token" http://localhost:3000/api/v1/tasks
```

The token is configured via the `FRONTEND_API_TOKEN` environment variable.

## Requirements

- Docker and Docker Compose (for containerized deployment)
- Ruby 3.2.2 (for local development)
- SQLite3

## Quick Start with Docker

### 1. Clone the repository

```bash
git clone <repository-url>
cd task-tracker-api
```

### 2. Set up environment variables

Create a `.env` file in the root directory:

```bash
FRONTEND_API_TOKEN=your-secret-token-here
RAILS_MASTER_KEY=<your-master-key-from-config/master.key>
```

**Note**: The `RAILS_MASTER_KEY` is required for production. You can find it in `config/master.key` or generate a new one.

### 3. Build and run with Docker Compose

```bash
docker-compose up --build
```

The API will be available at `http://localhost:3000`

### 4. Stop the container

```bash
docker-compose down
```

## Docker Commands

### Build the image

```bash
docker build -t task-tracker-api .
```

### Run the container

```bash
docker run -d \
  -p 3000:80 \
  -e RAILS_MASTER_KEY=<your-master-key> \
  -e FRONTEND_API_TOKEN=your-secret-token \
  -v $(pwd)/storage:/rails/storage \
  --name task-tracker-api \
  task-tracker-api
```

### View logs

```bash
docker logs -f task-tracker-api
```

### Execute commands in the container

```bash
docker exec -it task-tracker-api bash
```

## Local Development (without Docker)

### 1. Install dependencies

```bash
bundle install
```

### 2. Set up the database

```bash
bin/rails db:create db:migrate
```

### 3. Set environment variables

```bash
export FRONTEND_API_TOKEN=your-secret-token-here
```

Or create a `.env` file (if using dotenv-rails):

```bash
FRONTEND_API_TOKEN=your-secret-token-here
```

### 4. Start the server

```bash
bin/rails server
```

The API will be available at `http://localhost:3000`

## Running Tests

### With Docker

```bash
docker-compose run --rm api bin/rails test
# or for RSpec
docker-compose run --rm api bin/rails spec
```

### Locally

```bash
# Run all tests
bin/rails test

# Run RSpec tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/requests/api/v1/tasks/index_spec.rb
```

## Example API Usage

### List all tasks

```bash
curl -H "X-API-TOKEN: your-secret-token" \
  http://localhost:3000/api/v1/tasks
```

### Create a task

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-TOKEN: your-secret-token" \
  -d '{"task":{"description":"Complete the project"}}' \
  http://localhost:3000/api/v1/tasks
```

### Health check

```bash
curl http://localhost:3000/up
```

## Project Structure

```
task-tracker-api/
├── app/
│   ├── controllers/
│   │   ├── api/v1/
│   │   │   └── tasks_controller.rb
│   │   └── application_controller.rb
│   └── models/
│       └── task.rb
├── config/
│   ├── routes.rb
│   ├── database.yml
│   └── environments/
├── db/
│   ├── migrate/
│   └── schema.rb
├── spec/
│   ├── requests/
│   └── models/
├── Dockerfile
├── docker-compose.yml
└── README.md
```

## Database

The application uses SQLite3 for simplicity. The database files are stored in the `storage/` directory:

- Development: `storage/development.sqlite3`
- Test: `storage/test.sqlite3`
- Production: `storage/production.sqlite3`

### Database Migrations

```bash
# Create a new migration
bin/rails generate migration MigrationName

# Run migrations
bin/rails db:migrate

# Rollback last migration
bin/rails db:rollback
```

## Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `FRONTEND_API_TOKEN` | API authentication token | Yes | - |
| `RAILS_MASTER_KEY` | Rails master key for encrypted credentials | Yes (production) | - |
| `RAILS_ENV` | Rails environment | No | `development` |

## Security

- All API endpoints (except health check) require authentication
- Token-based authentication using secure comparison
- API-only mode (no views, helpers, or assets)
- SQL injection protection via ActiveRecord
- Parameter filtering for sensitive data

## Troubleshooting

### Database issues

If you encounter database errors:

```bash
# Reset the database
bin/rails db:reset

# Or in Docker
docker-compose run --rm api bin/rails db:reset
```

### Port already in use

If port 3000 is already in use, modify `docker-compose.yml`:

```yaml
ports:
  - "3001:80"  # Change 3000 to 3001 or any available port
```

### Authentication errors

Ensure the `FRONTEND_API_TOKEN` environment variable is set and matches the token in your requests.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

[Add your license here]

## Support

For issues and questions, please open an issue on the repository.
