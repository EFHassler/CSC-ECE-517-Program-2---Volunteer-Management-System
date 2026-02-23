# Volunteer Management System

A Rails-based volunteer management system that allows organizations to manage events and volunteers efficiently.

## Features

- **Volunteer Management**: Volunteers can register, sign up for events, and track their hours
- **Event Management**: Admins can create and manage events
- **Hour Tracking**: Track volunteer hours with approval workflow
- **Analytics**: Admin can view volunteer participation analytics

## Getting Started

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   ```
4. Load seed data for testing:
   ```bash
   rails db:seed
   ```
5. Start the server:
   ```bash
   rails server
   ```

### Access the Application

Open your browser and navigate to: `http://localhost:3000`

## Credentials

### Default Admin Account

The system comes with a preconfigured admin account:

- **Username**: `admin`
- **Password**: `admin123`

### Test Volunteer Accounts (if seed data is loaded)

- **Username**: `john_doe`, Password: `password123`
- **Username**: `jane_smith`, Password: `password123`
- **Username**: `bob_wilson`, Password: `password123`
- **Username**: `alice_brown`, Password: `password123`

## How to Use

### For Volunteers

#### Signing Up as a Volunteer

1. Go to the login page at `http://localhost:3000/`
2. Click "Sign up" link
3. Fill in the registration form:
   - Username (unique)
   - Password
   - Full Name
   - Email
   - Phone (optional)
   - Address (optional)
   - Skills (optional)
4. Click "Create Volunteer" button

#### Signing Up for an Event

1. Log in as a volunteer
2. Click "Available events" in the navigation or go to a specific event
3. On the event page, click "Sign up for this event" button
4. The volunteer assignment will be created with "pending" status

#### Withdrawing from an Event

1. Log in as a volunteer
2. Go to your profile by clicking "Profile" in the navigation
3. Under "Current assignments", find the event you want to withdraw from
4. Click "Withdraw" button next to that assignment

#### Viewing Your Hours

1. Log in as a volunteer
2. Go to your profile by clicking "Profile" in the navigation
3. View your "Total hours" - this includes hours from both approved and completed assignments

### For Admins

#### Logging in as Admin

1. Go to the login page at `http://localhost:3000/`
2. Enter admin credentials:
   - Username: `admin`
   - Password: `admin123`
3. You will be redirected to the Admin Dashboard

#### Creating a New Event

1. Log in as admin
2. Click "Manage Events" from the dashboard or navigate to `/events`
3. Click "New event" link
4. Fill in the event form:
   - Title
   - Description
   - Location
   - Event Date
   - Start Time
   - End Time
   - Required Volunteers (number)
   - Status (dropdown: open, full, completed)
5. Click "Create Event" button

#### Approving Volunteer Sign-ups

1. Log in as admin
2. Click "Manage Assignments" or navigate to `/volunteer_assignments`
3. Find the assignment with "pending" status
4. Click "Edit this volunteer assignment" link
5. Change status to "approved"
6. Click "Update Volunteer assignment" button

#### Logging Volunteer Hours

1. Log in as admin
2. Click "Manage Assignments" or navigate to `/volunteer_assignments`
3. Find the volunteer assignment (should be approved first)
4. Click "Edit this volunteer assignment" link
5. Change status to "completed"
6. Enter the hours worked (e.g., 4.0)
7. Select the date when the work was done
8. Click "Update Volunteer assignment" button

#### Viewing Analytics

1. Log in as admin
2. Click "View Analytics" from the dashboard
3. Use filters to narrow down data:
   - Date range (From Date / To Date)
   - Event (optional)
   - Volunteer (optional)
   - Top N Volunteers (default: 10)
4. Click "Apply Filters" to update the analytics

The analytics page shows:
- **Volunteer Activity Summary**: Events participated, total hours, average hours per event
- **Event Participation Summary**: Number of volunteers, total hours, average hours per volunteer
- **Top Volunteers by Hours**: Ranked list by total hours worked
- **Top Volunteers by Events**: Ranked list by number of events participated
- **Low Participation Detection**: Volunteers who haven't completed any events

#### Editing Admin Profile

1. Log in as admin
2. Click "Edit Profile" from the dashboard
3. Update fields (name, email, password)
4. Click "Update Admin" button

## Application Routes

| Path | Description |
|------|-------------|
| `/` | Login page |
| `/login` | Login page |
| `/volunteers/new` | Volunteer registration |
| `/volunteers/:id` | Volunteer profile |
| `/events` | Events list |
| `/events/new` | Create new event (admin) |
| `/events/:id` | Event details |
| `/admin` | Admin dashboard |
| `/analytics` | Analytics page (admin) |
| `/volunteer_assignments` | Volunteer assignments |

## Volunteer Assignment Statuses

- **pending**: Volunteer has signed up but not yet approved
- **approved**: Admin has approved the volunteer for the event
- **completed**: Event finished and hours have been logged
- **cancelled**: Sign-up was cancelled/withdrawn

## Technical Details

- **Authentication**: Session-based authentication for volunteers and admin
- **Authorization**: Different access levels for volunteers and admins
- **Database**: SQLite3 (can be changed to PostgreSQL/MySQL)
- **Status Workflow**: Events can be Open → Full → Completed

## Testing

RSpec validation testing of Volunteer class model aspects:
- password
- associations
- username
- full_name
- email
- phone
- Volunteer class methods (total_hours, completed_hours)

RSpec testing of Volunteer class controller:
- New
- Create
