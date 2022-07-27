# About

Add a description of the application here.

## Considerations
* Mention specifics about how the estimations are calculated.
* Mention how the JIRA project, epics and issues should be structured to use this tool.


# Development
## Ruby version
3.1.2

## Database creation
You need to have PostgreSQL installed. You can install it with `brew`, `Postgres.app`, or any other way that works for you.

Then run:

```
rails db:create
rails db:migrate
```

_Note: so far nothing is being persisted in the database. PostgreSQL was added for future requirements._

## How to run the test suite
```
bundle exec rspec
```


# Connecting to your JIRA instance

## Create an API token
Steps:
1. Step 1
2. Step 2
3. Step 3

## Set the necessary ENV vars
```
JIRA_API_TOKEN=<your-api-token>
JIRA_SITE_URL=https://your-domain.atlassian.net
JIRA_USERNAME=user_email@example.com
```
