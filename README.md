# ![Jira Project Estimator](public/ms-icon-28x44.png) Jira Project Estimator 

Every software team at some point will be asked: **"When will X be finished?"**

And then you can either:
* A) Estimate the remaining work with any technique you like. _(E.g. a spreadsheet, compare with similar past experiences, rule of thumb, velocity, etc.)_
* B) Just say the date your client wants to listen. _(Please never do this)_

We know giving estimates is hard in software.

We know that sometimes estimates are considered as compromises by clients, and we can be prisoners of our own words.

We know that it's better to know that we are not going to meet the deadline as early as possible, so we can plan for the future and act accordingly.

So the purpose of this tool is to help you monitor your team's progress and automatically get estimated finish dates, and to make it something quick and easy to use. **You just need to estimate your Jira tickets and the tool will do the rest!**


## :camera: Screens
To see some of the main screens, please check the [screens](docs/SCREENS.md) page.


## :thought_balloon: Considerations
1. The tool tracks progress and generates estimates for the **Epic**, based on its Issues story points and status (To Do, In Progress, Done, ...).

2. The tool considers all types of Issues (Story, Task, Bug, ...).

3. The tool does not track progress or generate estimates for Issues without Epic.

4. The tool does not consider Sub-Tasks.

5. For calculating average velocity and generating estimates is **the unit of time is the week**. This is to avoid having to consider if the team uses sprints, and eventually the sprint length which could be different for each team. Also, estimates in number of weeks should be fine for everyone.

6. By default there are 2 estimations which are calculated based on the average velocity since: (1) the implementation start week; (2) the last 3 weeks. You can also ask for a 3rd estimation based on the average velocity you expect to achieve by using the `Expected average` filter.

7. The tool considers that weeks start on Monday and end on Sunday. Why do I mention this? Because if you started the implementation of a project on a Friday, the tool will consider that the implementation started on the previous Monday, and therefore your average velocity will be lower than expected. In this case you can either live with this difference, or use the `Implementation start date` filter and say implementation started the following Monday.

8. If you want to estimate just a subset of an Epic, you can make use of Jira labels to filter the Issues you want to consider. First label your Issues in Jira, and then use the `Label` filter.

9. The tool allows you to consider a level of uncertainty when calculating an estimation, with 5 possible values: Empty, Low, Medium, High, Very High. For each value you can set a percentage associated to it, by setting the `LOW_UNCERTAINTY_PERCENTAGE, MEDIUM_UNCERTAINTY_PERCENTAGE, HIGH_UNCERTAINTY_PERCENTAGE, VERY_HIGH_UNCERTAINTY_PERCENTAGE` environment variables. What this will do is, for example, if right now you have 20 story points remaining, and you set the `MEDIUM_UNCERTAINTY_PERCENTAGE` to 20% and select `Uncertainty level` filter to Medium, the tool will consider that you have 24 story points remaining and calculate the number of weeks remaining based on that.

10. The calculations are more accurate when you estimate **ALL** the Issues and after multiple weeks of work (the first few weeks is expected to see unaccurate estimates).

11. The tool works for Scrum, Kanban, or any other Jira board type. By default it might just work with Scrum boards by using the existing story points field, and if you need to use another custom field, you should set the `JIRA_STORY_POINTS_FIELD_CODES` environment variable, which allows comma separated values (e.g. `customfield_10016,customfield_10034`)

12. The tool allows you to define your own set of ticket statuses. By default it uses `To Do` for "not started", `Done` for "finished", and every other status for "in progress". If you need to use a different set of statuses, should set the `TO_DO_STATUSES` and `DONE_STATUSES` environment variables, which allows comma separated values and is case insensitive (e.g. `TO_DO_STATUSES=To do,Open,pending review` and `DONE_STATUSES=done,resolved,Closed`)

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

### Set the necessary ENV vars
```
JIRA_API_TOKEN=<your-api-token>
JIRA_SITE_URL=https://your-domain.atlassian.net
JIRA_USERNAME=user_email@example.com
```


## :busts_in_silhouette: Managing users
There are no web pages for creating or deleting users.

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
3.2.2
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
