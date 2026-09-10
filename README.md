# JobPortal

A modern, role-based job board built with React 19, Vite, and Tailwind CSS. Job seekers browse and apply to openings, employers post jobs and manage applicants, and admins oversee the whole platform — all running on a simulated backend so the entire experience works without any server setup.

![React](https://img.shields.io/badge/React-19-61DAFB?logo=react&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-7-646CFF?logo=vite&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind%20CSS-4-06B6D4?logo=tailwindcss&logoColor=white)
![React Router](https://img.shields.io/badge/React%20Router-7-CA4245?logo=reactrouter&logoColor=white)

## Overview

JobPortal is a full-featured job board SPA with three distinct user roles, each with their own dashboard and permissions. It ships with a rich mock data layer (jobs, companies, applications) and simulated async services, so you can clone it and immediately explore a realistic product without wiring up a database or API.

## Features

**For job seekers**
- Browse and filter jobs by title, location, category, and type
- View detailed job and company pages
- Apply to jobs and track application status
- Save jobs for later
- Build and edit a candidate profile (skills, experience, education, resume)

**For employers**
- Post and manage job listings
- Review and manage applicants per job
- Company profile management

**For admins**
- Platform-wide dashboard
- Manage companies and employers
- Review contact form submissions

**Everywhere**
- Light/dark theme
- Fully responsive, mobile-first layout
- Toast notifications for key actions
- Protected routes with per-role access control

## Tech stack

| Layer         | Choice                                   |
|---------------|-------------------------------------------|
| UI            | React 19 (functional components only)    |
| Build tool    | Vite 7                                   |
| Styling       | Tailwind CSS 4                           |
| Routing       | React Router 7                           |
| State         | React Context (Auth, Jobs, Theme, Companies) |
| Icons         | Font Awesome + Lucide React               |
| Notifications | react-toastify                           |
| Data layer    | Mock data + localStorage (no backend)    |

## Getting started

### Prerequisites

- Node.js 18+
- npm

### Installation

```bash
git clone https://github.com/Diags/job-portal-ui.git
cd job-portal-ui
npm install
```

### Run the dev server

```bash
npm run dev
```

The app will be available at `http://localhost:5173`.

### Other scripts

```bash
npm run build     # Production build
npm run preview   # Preview the production build locally
npm run lint      # Run ESLint
```

## Try it out

The app ships with demo accounts for each role — no registration required:

| Role        | Email                    | Password       |
|-------------|---------------------------|----------------|
| Job seeker  | `jobseeker@email.com`     | `jobseeker123` |
| Employer    | `employer@company.com`    | `employer123`  |
| Admin       | `admin@portal.com`        | `admin123`     |

You can also register a new job seeker or employer account from the app itself.

## Project structure

```
job-portal-ui/
├── public/               # Static assets (favicons, company logos)
├── src/
│   ├── components/       # Reusable UI components (Navbar, Footer, Layout, ProtectedRoute, etc.)
│   ├── context/          # Core contexts: AuthContext, JobContext, ThemeContext
│   ├── contexts/         # Data-fetching contexts: JobsDataContext, CompaniesContext
│   ├── data/             # mockData.js — all seed data (jobs, companies, users)
│   ├── pages/             # Route-level page components
│   │   └── admin/        # Admin-only pages (Dashboard, CompanyManagement, etc.)
│   ├── services/         # Simulated async API service functions
│   ├── utils/             # Shared utilities (delay.js)
│   ├── App.jsx            # Root component — router + provider tree
│   └── main.jsx           # Entry point
├── eslint.config.js
├── vite.config.js
└── index.html
```

## Roles & routing

| Role                | Routes                                                        |
|----------------------|----------------------------------------------------------------|
| Public               | `/`, `/jobs`, `/jobs/:id`, `/companies`, `/companies/:id`, `/contact`, `/login`, `/register` |
| `ROLE_JOB_SEEKER`    | `/profile`, `/applied-jobs`, `/saved-jobs`                    |
| `ROLE_EMPLOYER`      | `/post-job`, `/employer/jobs`, `/job-applicants/:jobId`        |
| `ROLE_ADMIN`         | `/admin`, `/admin/companies`, `/admin/employers`, `/admin/contact-messages` |

Access is enforced by the `ProtectedRoute` component, which redirects unauthorized users based on their role.

## Architecture notes

- **No backend** — all data lives in `src/data/mockData.js` and is persisted to `localStorage` under keys like `jobPortalUser`, `jobApplications_{userId}`, `savedJobs_{userId}`, and `postedJobs_{userId}`.
- **Simulated latency** — every service call in `src/services/` runs through a `delay()` helper to mimic real network calls.
- **Two-layer context** — `src/context/` holds core app state (auth, applications, theme); `src/contexts/` holds cached data-fetching state (jobs list with a 5-minute TTL, companies).
- **No TypeScript** — plain JSX throughout, functional components only.

## Contributing

This project follows [Conventional Commits](https://www.conventionalcommits.org/) and a simple branch naming scheme:

```
feature/add-job-filter-sidebar
fix/employer-route-redirect-loop
chore/upgrade-dependencies
```

See [`CLAUDE.md`](./CLAUDE.md) for the full set of coding standards and conventions used in this repository.
