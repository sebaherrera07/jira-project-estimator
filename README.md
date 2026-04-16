# ![Jira Project Estimator](public/ms-icon-28x44.png) Jira Project Estimator 

Every software team will eventually be asked: **"When will this project be finished?"**

At that point, you can either:
* A) Estimate the remaining work using any technique you like. _(For example: a spreadsheet, comparison with similar past work, rules of thumb, velocity, etc.)_
* B) Just give the date the other person wants to hear. _(Please never do this.)_

We know that estimating software work is hard.

We also know that clients or managers may sometimes treat estimates as commitments, and teams can become trapped by their own forecasts.

It is better to realize as early as possible that a deadline may slip, so you can adjust plans and act accordingly.

The purpose of this tool is to help you monitor your team's progress and automatically forecast finish dates, while keeping the process quick and easy. **Just estimate your Jira tickets, and the tool does the rest.**


## :camera: Screens
To see more screenshots, check the [screens](docs/SCREENS.md) page.

![Epic dashboard](docs/images/03_epic_dashboard.png)


## :thought_balloon: Considerations
1. The tool tracks progress and generates estimates for an **Epic** based on its issues’ points and status (_To Do_, _In Progress_, _Done_, ...).

2. The tool includes all issue types (_Story_, _Task_, _Bug_, ...).

3. The tool does not track progress or generate estimates for issues without an Epic.

4. The tool does not consider sub-tasks.

5. For average velocity and estimates, **the time unit is one week**. This avoids dealing with whether you use sprints (and sprint lengths that may vary by team). Estimates in weeks should work for everyone.

6. By default, the tool provides two estimates based on average velocity over different periods: since the implementation start week, and over the last 3 weeks. You can also request a third estimate based on the average velocity you expect to achieve by using the `Expected average` filter.

7. The tool assumes weeks start on Monday and end on Sunday. Why mention this? If implementation starts on a Friday, the tool treats the start as the previous Monday, which can make your average velocity look lower than expected. You can either accept the difference, or set the Epic start date in Jira and treat implementation as starting the following Monday. If you need a different custom field for the start date, set `JIRA_START_DATE_FIELD_CODES` (comma-separated, e.g. `customfield_10015,customfield_10034`).

8. To estimate only a subset of an Epic, use Jira labels to filter the issues you want. Label the issues in Jira, then use the `Label` filter.

9. You can include uncertainty in the estimate with five levels: Empty, Low, Medium, High, and Very High. Each level maps to a percentage via `LOW_UNCERTAINTY_PERCENTAGE, MEDIUM_UNCERTAINTY_PERCENTAGE, HIGH_UNCERTAINTY_PERCENTAGE, VERY_HIGH_UNCERTAINTY_PERCENTAGE`. For example, if you have 20 points remaining, set `MEDIUM_UNCERTAINTY_PERCENTAGE` to 20%, and select `Uncertainty level` = Medium. The tool will then treat it as 24 points remaining and estimate the remaining time based on that.

10. Estimates become more accurate when you estimate **ALL** issues and after multiple weeks of work (the first few weeks are expected to be less accurate).

11. The tool works with Scrum, Kanban, or any Jira board type. By default it uses the existing points field (often enough for Scrum boards). If you need a different custom field, set `JIRA_STORY_POINTS_FIELD_CODES` (comma-separated, e.g. `customfield_10016,customfield_10034`).

12. You can define your own ticket statuses. By default, the tool treats `To Do` as “not started”, `Done` as “finished”, and any other status as “in progress”. To customize this, set `TO_DO_STATUSES` and `DONE_STATUSES` (comma-separated, case-insensitive; e.g. `TO_DO_STATUSES=To do,Open,pending review` and `DONE_STATUSES=done,resolved,Closed`).

## :electric_plug: Connecting to your Jira instance

### Create an API token
Extracted from: [Manage API tokens for your Atlassian account](https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/)

> You can use an API token to authenticate a script or other process with an Atlassian cloud product. You generate the token from your Atlassian account, then copy and paste it to the script.
>
> Steps:
> 1. Log in to https://id.atlassian.com/manage-profile/security/api-tokens
> 2. Click Create API token.
> 3. From the dialog that appears, enter a memorable and concise Label for your token and click Create.
> 4. Click Copy to clipboard, then paste the token to your script, or elsewhere to save:
>
> Notes:
> * For security reasons it isn't possible to view the token after closing the creation dialog; if necessary, create a new token.
> * You should store the token securely, just as for any password.

### Set the required environment variables
```
JIRA_API_TOKEN=<your-api-token>
JIRA_SITE_URL=https://your-domain.atlassian.net
JIRA_USERNAME=user_email@example.com
```


## :busts_in_silhouette: Managing users
There is no web UI for creating or deleting users.

You can create users with the following command in the `rails console`:

```ruby
User.create(first_name: 'First', last_name: 'Last', email: 'admin@example.com', password: 's3cur3_P4ssw0rd#!')
```

You can delete users with the following command in the `rails console`:

```ruby
User.find_by(email: 'admin@example.com').destroy!
```


## :computer: Development
### Ruby version
```
4.0.2
```

### Database creation
You need to have PostgreSQL installed. You can install it with `brew`, `Postgres.app`, `asdf`, or any other way that works for you.

Then run:

```
rails db:create
rails db:migrate
```

### How to run the test suite
```
bundle exec rspec
```

### How to run the linters
```
bundle exec rubocop
bundle exec brakeman
bundle exec bundler-audit
```


## :raising_hand: Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/sebaherrera07/jira-project-estimator.


## :ledger: License
This software is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
