
# TimeOff.Management

Web application for managing employee absences.

<a href="https://travis-ci.org/timeoff-management/timeoff-management-application"><img align="right" src="https://travis-ci.org/timeoff-management/timeoff-management-application.svg?branch=master" alt="Build status" /></a>

## Features

**Multiple views of staff absences**

Calendar view, Team view, or Just plain list.

**Tune application to fit into your company policy**

Add custom absence types: Sickness, Maternity, Working from home, Birthday etc. Define if each uses vacation allowance.

Optionally limit the amount of days employees can take for each Leave type. E.g. no more than 10 Sick days per year.

Setup public holidays as well as company specific days off.

Group employees by departments: bring your organisational structure, set the supervisor for every department.

Customisable working schedule for company and individuals.

**Third Party Calendar Integration**

Broadcast employee whereabouts into external calendar providers: MS Outlook, Google Calendar, and iCal.

Create calendar feeds for individuals, departments or entire company.

**Three Steps Workflow**

Employee requests time off or revokes existing one.

Supervisor gets email notification and decides about upcoming employee absence.

Absence is accounted. Peers are informed via team view or calendar feeds.

**Access control**

There are following types of users: employees, supervisors, and administrators.

Optional LDAP authentication: configure application to use your LDAP server for user authentication.

**Ability to extract leave data into CSV**

Ability to back up entire company leave data into CSV file. So it could be used in any spreadsheet applications.

**Works on mobile phones**

The most used customer paths are mobile friendly:

* employee is able to request new leave from mobile device

* supervisor is able to record decision from the mobile as well.

**Lots of other little things that would make life easier**

Manually adjust employee allowances
e.g. employee has extra day in lieu.

Upon creation employee receives pro-rated vacation allowance, depending on start date.

Email notification to all involved parties.

Optionally allow employees to see the time off information of entire company regardless of department structure.

## Screenshots

![TimeOff.Management Screenshot](https://raw.githubusercontent.com/timeoff-management/application/master/public/img/readme_screenshot.png)

## Installation

### Cloud hosting

Visit http://timeoff.management/

Create company account and use cloud based version.

### Azure Hosted using Terraform and Azure DevOps

This is the architecture diagram of the application hosting, it was done using Azure.
![image](https://user-images.githubusercontent.com/27838418/230555481-7b5c6ea3-ad6b-460d-9ca9-cf6ce283a2ae.png)

Prerequisites:
- Have an Azure account.
- Have an Azure DevOps project and organization with Agent Pools configured.
- Have Azure CLI in your machine.
- Have Terraform locally installed and Azure configured, for more information on how to configure it, follow this [documentation](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#authenticate-using-the-azure-cli).

Steps:
First: Create the infrastructure.
1. Inside the project, open a terminal.
2. Go to the IaC folder by using ```cd IaC```.
3. Enter ```terraform init```.
4. Enter ```terraform plan```.
5. Enter ```terraform apply -auto-approve```.
6. Once done, run the following script to connect the policy to the Front Door service:
```bash
# Change the <subscriptionId> for your Azure Subscription ID
az afd security-policy create \
    --resource-group TimeOffManagement-RG-FD \
    --profile-name tom-frontdoor-profile \
    --security-policy-name tomsecuritypolicy \
    --domains /subscriptions/<subscriptionId>/resourcegroups/TimeOffManagement-RG-FD/providers/Microsoft.Cdn/profiles/tom-frontdoor-profile/afdEndpoints/tom-frontdoor-endpoint \
    --waf-policy /subscriptions/<subscriptionId>/resourcegroups/TimeOffManagement-RG-FD/providers/Microsoft.Network/frontdoorwebapplicationfirewallpolicies/tomfdfirewallpolicy
```

Second: Build and deploy the project in Azure DevOps
1. Go to Pipelines.
2. Go to New Pipeline.
3. Select where your repository is (GitHub, Azure Repos, etc.)
4. Select your repository.
5. From there, you can select a Starter pipeline.
6. Go to Variables -> New variable and in there set the following:
    1. Name: azSubId
    2. Value: your-subscription-id
7. Click on Ok, and then in Save.
8. Copy/paste the following YAML code: [azure-pipelines.yml](https://github.com/aleguerrero/timeoff-management-application/blob/2a8897d61963d8bfb3d71a1ac850b03751f1e042/azure-pipelines.yml)
    NOTE: If you need to change the agent pool name, do it on each pool->name in the YAML 
    ```yaml
    pool: 
        name: agentPoolName
    ```
10. Once done, select Save and run.


### Self hosting

Install TimeOff.Management application within your infrastructure:

(make sure you have Node.js (>=4.0.0) and SQLite installed)

```bash
git clone https://github.com/timeoff-management/application.git timeoff-management
cd timeoff-management
npm install
npm start
```
Open http://localhost:3000/ in your browser.

## Run tests

We have quite a wide test coverage, to make sure that the main user paths work as expected.

Please run them frequently while developing the project.

Make sure you have Chrome driver installed in your path and Chrome browser for your platform.

If you want to see the browser execute the interactions prefix with `SHOW_CHROME=1`

```bash
USE_CHROME=1 npm test
```

(make sure that application with default settings is up and running)

Any bug fixes or enhancements should have good test coverage to get them into "master" branch.

## Updating existing instance with new code

In case one needs to patch existing instance of TimeOff.Managenent application with new version:

```bash
git fetch
git pull origin master
npm install
npm run-script db-update
npm start
```

## How to?

There are some customizations available.

## How to amend or extend colours available for colour picker?
Follow instructions on [this page](docs/extend_colors_for_leave_type.md).

## Customization

There are few options to configure an installation.

### Make sorting sensitive to particular locale

Given the software could be installed for company with employees with non-English names there might be a need to
respect the alphabet while sorting customer entered content.

For that purpose the application config file has `locale_code_for_sorting` entry.
By default the value is `en` (English). One can override it with other locales such as `cs`, `fr`, `de` etc.

### Force employees to pick type each time new leave is booked

Some organizations require employees to explicitly pick the type of leave when booking time off. So employee makes a choice rather than relying on default settings.
That reduce number of "mistaken" leaves, which are cancelled after.

In order to force employee to explicitly pick the leave type of the booked time off, change `is_force_to_explicitly_select_type_when_requesting_new_leave`
flag to be `true` in the `config/app.json` file.

## Use Redis as a sessions storage

Follow instructions on [this page](docs/SessionStoreInRedis.md).

## Feedback

Please report any issues or feedback to <a href="https://twitter.com/FreeTimeOffApp">twitter</a> or Email: pavlo at timeoff.management

