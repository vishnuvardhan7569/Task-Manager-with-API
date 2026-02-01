# Task Manager API

A RESTful backend built with Ruby on Rails 8 (API mode) and MySQL.

## Features
- JWT Authentication with 2-hour token expiration
- User Management (Signup, Login, Delete Account)
- Project Management (CRUD with task statistics)
- Task Management (CRUD with status tracking)
- User-based access control (users can only access their own data)
- Welcome email on signup

## Tech Stack
- **Ruby:** 3.2.2
- **Rails:** 8.1.2 (API mode)
- **Database:** MySQL 8
- **Authentication:** JWT with bcrypt
- **Email:** Letter Opener (development)

## API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/signup` | Create new account |
| POST | `/login` | Login and get JWT token |
| GET | `/me` | Get current user info |
| DELETE | `/account` | Delete account |

### Projects
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/projects` | List all projects (paginated) |
| POST | `/projects` | Create new project |
| GET | `/projects/:id` | Get project details |
| PATCH | `/projects/:id` | Update project |
| DELETE | `/projects/:id` | Delete project |

### Tasks
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/projects/:project_id/tasks` | List project tasks |
| POST | `/projects/:project_id/tasks` | Create new task |
| PATCH | `/projects/:project_id/tasks/:id` | Update task |
| DELETE | `/projects/:project_id/tasks/:id` | Delete task |

## Authentication

All protected routes require JWT token in header:
```
Authorization: Bearer <JWT_TOKEN>
```

**Token expires after 2 hours.** When expired, API returns 401.

## Setup

```bash
# Install dependencies
bundle install

# Setup database
rails db:create db:migrate

# Start development server
rails s
```

## Email Preview (Development)

Emails are opened in browser instead of being sent. Visit:
```
http://localhost:3000/letter_opener
```

## Testing

```bash
rails test
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DATABASE_URL` | MySQL connection string |
| `SECRET_KEY_BASE` | Rails secret key |

## Project Structure

```
app/
  controllers/     # API controllers
  models/          # ActiveRecord models
  mailers/         # Email handlers
  views/           # Email templates
config/
  routes.rb        # API routes
  environments/    # Environment configs
db/
  migrate/         # Database migrations
  schema.rb        # Database schema
```
