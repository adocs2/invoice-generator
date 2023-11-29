# Invoice Generator Project

This project is designed to generate invoices using Ruby 2.7.7 and Rails 7.0.8. It follows the B/CDD (Behavior/Component-Driven Development) methodology and utilizes the u-case gem. For more information, refer to the [blog post by serradura](https://serradura.github.io/pt-BR/blog/aprenda_bcdd_e_u-case/).

## Getting Started

To access the platform, enter your email in "generate token." You will receive an authentication token by email to log in to the platform or access the API.

**API Access:** To access the API, include your `authentication_token` in the `Authorization` header.

## Running the Rails Project

### 1. Clone the Repository
```bash
git clone <repository_url>
cd <project_directory>
```
### 2. Install Dependencies
```bash
bundle install
```
### 3. Database Setup
```bash
rails db:create
rails db:migrate
```
### 4. Run the Server
```bash
rails s
```

## Installing Mailcatcher to View Sent Emails

### 1. Install Mailcatcher
```bash
gem install mailcatcher
```
### 2. Run Mailcatcher
```bash
mailcatcher
```
### 3. Open Mailcatcher
This will start Mailcatcher's web interface at http://127.0.0.1:1080. You can view sent emails and their content here

## Rspec

### 1. Run rspec
```bash
bundle exec rspec
```

### 2. Coverage
You can view the coverage using the SimpleCov inside the project.

Right now the coverage is like that:

Finished in 5.31 seconds (files took 7.69 seconds to load)
80 examples, 0 failures

Coverage report generated for RSpec to /home/adocs2/invoice_generator/coverage. 299 / 338 LOC (88.46%) covered

## API Routes

| HTTP Method | Endpoint                                   | Description                                      |
|-------------|--------------------------------------------|--------------------------------------------------|
| `GET`       | `/api/v1/invoices`                         | Retrieve a list of invoices                      |
| `GET`       | `/api/v1/invoices/:id`                     | Retrieve details of a specific invoice           |
| `POST`      | `/api/v1/invoices/create`                  | Create and send email for a new invoice          |
| `POST`      | `/api/v1/users/generate/token`             | Generate a token and send activation email       |
| `POST`      | `/api/v1/users/activate/token`             | Activate user account with the provided token    |

### Request Bodies

1. **Create Invoice example: `/api/v1/invoices/create`**
   ```json
   {
     "invoice_record": {
       "number": "123",
       "date": "2023-12-01",
       "company": "Test Company",
       "billing_to": "Test Billing",
       "total_amount": 100,
       "emails": "test@example.com" //you can pass N emails separate by comma
     }
   }
   ```

   with your `authentication_token` in the `Authorization` header
## To do

1. Make more tests to increase the coverage
2. Use another DB, now the project use sqlite to simplify the implementation
3. Explore the replacement of current screen creation tools with more modern technologies, such as React on Rails, to enhance efficiency and user experience.
4. Use the Docker tool to facilitate application setup