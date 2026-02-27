PRD
LibaasLoop

Version: 1.1 (MVP + Admin Portal – Monolithic Architecture)
Date: February 2026
Technology Stack: Ruby on Rails 8.x (Latest Stable), Ruby 3.x, PostgreSQL 16+, Devise

1. Product Overview

LibaasLoop is a peer-to-peer ethnic wear rental marketplace where:

Users can list outfits

Rent outfits from others

Manage bookings

Version 1.1 introduces an Admin Portal for platform-level monitoring and control.

2. System Architecture

Monolithic Web Application

Single Rails codebase

Role-based access control (RBAC)

User Roles:

User (default)

Admin

3. User Module
3.1 Authentication

Registration (Name, Email, Password)

Login / Logout

Password encryption via Devise

Role column added to users table

Users Table Update

Add:

role (string, default: "user")

Possible values:

user

admin

4. Listing Module

Users can:

Create listing

Edit own listing

Delete own listing

View all listings

Admin can:

View all listings

Delete any listing

Block inappropriate listings

5. Rental Module

Users can:

Request rental

View rental status

Listing owner can:

Approve

Reject

Mark returned

Admin can:

View all rentals

Update rental status (if dispute)

Cancel rental

6. Admin Portal (New Module)
6.1 Admin Authentication

Admin logs in using same Devise system

Access restricted via:

before_action

role check

Only users with role = "admin" can access:

/admin/dashboard
6.2 Admin Dashboard
Overview Metrics

Total Users

Total Listings

Total Rentals

Active Rentals

Completed Rentals

6.3 User Management (Admin)

Admin can:

View all users

View user details

Delete user

Deactivate user

Optional (if time allows):

Ban user (boolean field)

6.4 Listing Management (Admin)

Admin can:

View all listings

Delete any listing

See listing owner details

6.5 Rental Management (Admin)

Admin can:

View all rentals

Filter by status

Force update rental status

Cancel rental

7. Routing Structure

Public:

/

/listings

/listings/:id

User:

/my_listings

/my_rentals

Admin Namespace:

/admin/dashboard
/admin/users
/admin/listings
/admin/rentals

Use Rails namespace:

namespace :admin do
  resources :users
  resources :listings
  resources :rentals
  get "dashboard"
end
8. Authorization Rules
Action  User  Owner Admin
Create Listing  ✅ — ✅
Edit Own Listing  ✅ ✅ ✅
Edit Others Listing ❌ ❌ ✅
Request Rental  ✅ ❌ ✅
Approve Rental  ❌ ✅ ✅
Delete User ❌ ❌ ✅
9. Database Schema Updates
Users Table

id

name

email

encrypted_password

role (string, default: "user")

created_at

updated_at

10. Admin Middleware Logic

Add method:

def authenticate_admin!
  redirect_to root_path unless current_user&.role == "admin"
end

Apply in admin controllers.

11. Non-Functional Requirements

Role-based access

Secure authentication

Clean namespace separation

Admin-only routes protected

Server-side authorization checks

12. Out of Scope (Still Not Included)

Payment Gateway

Escrow Automation

AI Features

GPS Radius Search

Community Circles

Reviews & Ratings

ID Verification

13. Success Criteria (Version 1.1)

System is successful if:

Users can register and create listings

Rental requests flow works

Admin can:

View users

Delete listings

Manage rentals

Admin routes are protected

Role-based access enforced