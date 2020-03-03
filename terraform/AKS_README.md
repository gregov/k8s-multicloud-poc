1. Install Azure CLI

```
$ brew update && brew install azure-cli

$ az login
You have logged in. Now let us find all the subscriptions to which you have access...
[
  {
    "cloudName": "AzureCloud",
    "id": "cecf816f-9adc-4ee9-85ab-b54cd437ba37",
    "isDefault": true,
    "name": "Free Trial",
    "state": "Enabled",
    "tenantId": "7716efba-1788-422a-96e1-8f7de58de594",
    "user": {
      "name": "***@gmail.com",
      "type": "user"
    }
  }
]
```

2. Configure Terraform with Azure
```
$ az account list --query "[].{name:name, subscriptionId:id, tenantId:tenantId}"
[
  {
    "name": "Free Trial",
    "subscriptionId": "cecf816f-9adc-4ee9-85ab-b54cd437ba37",
    "tenantId": "7716efba-1788-422a-96e1-8f7de58de594"
  }
]
$ SUBSCRIPTION_ID=cecf816f-9adc-4ee9-85ab-b54cd437ba37
$ az account set --subscription="${SUBSCRIPTION_ID}"
$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
Creating a role assignment under the scope of "/subscriptions/cecf816f-9adc-4ee9-85ab-b54cd437ba37"
  Retrying role assignment creation: 1/36
{
  "appId": "e079d779-31e6-49d6-ac9d-d6b158e2588a",
  "displayName": "azure-cli-2020-02-11-00-03-26",
  "name": "http://azure-cli-2020-02-11-00-03-26",
  "password": "***",
  "tenant": "7716efba-1788-422a-96e1-8f7de58de594"
}
```