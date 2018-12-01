# edm-terraform

Uses terraform to create all 5 edm applications:

1. [edm-relay](https://github.com/trevorscott/edm-relay)
1. [edm-stream](https://github.com/trevorscott/edm-stream)
1. [edm-stats](https://github.com/trevorscott/edm-stats)
1. [edm-ui](https://github.com/trevorscott/edm-ui)
1. [edm-dashboard](https://github.com/trevorscott/edm-dashboard)

Additionally this creates:

1. a hobby-dev postgresql database
1. a basic-0 multi-tenant kafka cluster

## Requirements

1. Heroku Account
1. Git LFS

![Event Driven Microservices with Apache Kafka on Heroku Demo Architecture](https://s3.amazonaws.com/octo-public/kafka-microservices.png "EDM")

## Config

### Heroku Authorization

Authorization tokens used with Terraform must have *global* scope to perform the various create, read, update, & delete actions on the Heroku API. If you want to isolate Terraform's capabilities from your existing account, then it should be authorized using a separate Heroku account.

First, check your current login to confirm that you're using the account intended for Terraform. If you want to switch identities, logout & then login as intended using the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

```bash
heroku whoami
heroku logout
heroku login
```

Second, [generate an authorization token](https://devcenter.heroku.com/articles/heroku-cli-commands#heroku-authorizations) using the Heroku CLI. The description is a human-readable name to indicate the purpose or identity of each authorization:

```
heroku authorizations:create --description terraform-my-app
```

Once you have acquired your Heroku authorization token, combine it with your heroku account email, your AWS credentials, the desired Redshift information and save them as [enviornment variables for Terraform](https://www.terraform.io/docs/configuration/variables.html#environment-variables):


```bash
export \
  TF_VAR_heroku_email='your-heroku-email' \
  TF_VAR_heroku_api_key='you-heroku-auth-token'
```

## Usage

```bash
terraform init
```

Choose a deployment name. Keep it short as your resources will be prefixed by the chosen name.

```
terraform apply \
  -var name=<your-deployment-name> \
  -var aws_region=us-west-2
```
