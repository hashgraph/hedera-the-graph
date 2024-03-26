# HederaTheGraph (HTG) Authentication Layer Server

The Authentication Layer Server is a KeyCloak server that provides authentication and authorization services for the HederaTheGraph (HTG). It is based on the [KeyCloak](https://www.keycloak.org/) open source identity and access management solution. 
With the following configurations:
- Realm preconfigured with the HTG (htg-auth-layer) client
- Groups and Roles preconfigured for the HTG client
- Custom claim mappers for the HTG client
- Token expiration time set to 10 hours (plenty of time for a one day work session)
- Disabled refresh tokens
- Other custom configurations
    - User registration is disabled
    - Forgot password is enabled
    - Email as username is enabled
    - Login with email is enabled

**For more information about KeyCloak Configuration, please visit the [KeyCloak Documentation](https://www.keycloak.org/docs/latest/server_admin/index.html)**

## Prerequisites
- Minikube or a Kubernetes cluster [(more here)](https://minikube.sigs.k8s.io/docs/start/)
- Helm 3 [(install instructions here)](https://helm.sh/docs/intro/install/)
- kubectl [(install instructions here)](https://kubernetes.io/docs/tasks/tools/)

## Installation

To install the Authentication Layer Server, run the following commands:

- Install the chart, using the custom values file provided in the `values.yaml` file
```bash
helm dependency update
helm install htg-auth-server .
```

### Helm Chart Overrides

#### Admin Password

Define a custom password, use `keycloak.auth.adminPassword` like this: 
```bash
helm install htg-auth-server . --set keycloak.auth.adminPassword=yourpassword
```

#### Client Secret

Define a custom client secret, use `clientSecret` like this: 
```bash
helm install htg-auth-server . --set clientSecret=yourclientsecret
```

if setting the client secret from an umbrella chart and need to re-use the same client secret for other charts is recommended to use the `global.auth.clientSecret` property.
```yaml
global:
    auth:
        clientSecret: yourclientsecret
```

#### Use External DB (PostgreSQL)
By default as part of the helm chart, it will deploy a PostgreSQL database. If you want to use an external database, you can use the following configuration:

```yaml
keycloak:
    postgresql:
        enabled: false
    externalDatabase:
        host: myexternalhost    
        user: myuser
        password: mypassword
        database: mydatabase
        port: 5432
```


*After installation please give some time (a few minutes) for the KeyCloak server to start and be ready to use.*

*For a whole list of configurable parameters see the oficial documentation of the [KeyCloak Helm Chart from Bitnami](https://artifacthub.io/packages/helm/bitnami/keycloak/12.1.3)*

### Configuration

#### Port Forwarding
You will need to port-forward the KeyCloak service to access the admin console. Run the following command to port-forward the service:
```bash
kubectl port-forward service/htg-auth-server-keycloak 8080:80
```
#### Login to the Admin Console
Access console on the following URK: http://localhost:8080/admin/master/console/#/HederaTheGraph

Login with the following credentials:
- Username: `admin`
- Password: if not provided a random password is generated and can be found in the `htg-auth-server` secret with the following command:

```bash
kubectl get secret htg-auth-server-keycloak -o jsonpath="{.data.admin-password}" | base64 --decode; echo
```

#### Regenerate the Client Secret (optional)

The client secret is provided as a Value override using property `global.auth.clientSecret` or `clientSecret`, with global having precedence, and if neither is provided, a random secret is generated.

Is possible to see or regenerate the `htg-auth-layer` client secret from the KeyCloak admin console following these steps:

After successful login:
1. Select the `HederaTheGraph` realm from the dropdown menu. 
2. Then navigate to `Clients` and select the `htg-auth-layer` client. 
3. Click on the `Credentials` tab and 
4. Click on the `Regenerate` butto of `Client Secret` section to generate a new client secret.
5. Copy the new client secret since that will be needed to requests tokens from the Authentication Layer Server and to call the instrospection endpoint.

#### Configure Email service

The Auth server will need to send emails for the forgot password feature, and verify email. The service is configured following the next steps:
1. Login to the KeyCloak admin console. 
2. Select the `HederaTheGraph` realm from the dropdown menu.
3. Then navigate to `Realm Settings` and select the `Email` tab.
4. Fill in the email settings and click on the `Save` button.

Uses `smtp` host, port and optionally credentials (username and password) to send emails.
Is also required to confiture `From` and recommended to configure `From Display Name` fields.

*Once the email service is configured, is possible to test the email service by sending a test email from the `Email` tab to verify that the email service is working.*


### Usage

#### Create a new user

Once you have your KeyCloak server running, you can create a new user by following these steps:

1. Login to the KeyCloak admin console.
2. Select the `HederaTheGraph` realm from the dropdown menu (if not selected already).
3. Then navigate to `Users` and click on the `Add user` button.
4. Fill in the user details and click on the `Save` button.
5. After saving the user, navigate to the `Credentials` tab and set a password for the user (prefferably a temporary one, that forces the user to update it at next login).
6. Assign Roles or Grpups to the user.
7. Set `subgraph_access` attribute to the user, this will give the user access to these subgraphs. This is done by click the `Attributes` tab and adding a new attribute with the name `subgraph_access` and the value being the subgraph id. The value can be a CSV string with many subgraph names, ie: `subgraph1,subgraph2,subgraph3`.

#### Groups and Roles

**a. Subgraph Admin:**, has access to all the subgraphs admin endpoints. (`subgraph_create`, `subgraph_remove`, `subgraph_deploy`,`subgraph_pause` and `subgraph_resume`)
**b. Subgraph Deployer:**, has access to: `subgraph_pause`, `subgraph_resume` and `subgraph_deploy` endpoints.
**c. Subgraph Operator:**, has access to: `subgraph_pause` and 'subgraph_resume' endpoints.

#### Get a Token from the Authentication Layer Server

If using port-forwarding, you can get a token from the Authentication Layer Server by running the following command, you will need the following information:
- `username` or `email` of the user
- `user-password` of the user
- `client-secret` of the `htg-auth-layer` client


```bash
curl --location 'http://localhost:8080/realms/HederaTheGraph/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'username=<username or email>' \
--data-urlencode 'password=<user-password>' \
--data-urlencode 'client_id=htg-auth-layer' \
--data-urlencode 'client_secret=<client-secret>'
```

*However is recommended to expose the service using a FQDN since the token that is created using the host `localhost` is only valid for the `localhost` host when calling the instrospection endpoint. So port-forwarding is only recommended for testing purposes.*


#### Verify a Token
To verify a token, you can call the introspection endpoint of the Authentication Layer Server. The introspection endpoint is available at the following URL: `http://localhost:8080/auth/realms/HederaTheGraph/protocol/openid-connect/token/introspect`

```bash
curl --location 'http://localhost:8080/realms/HederaTheGraph/protocol/openid-connect/token/introspect' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'token=<access-token>' \
--data-urlencode 'client_id=htg-auth-layer' \
--data-urlencode 'client_secret=<client-secret>'
```

if the token is valid, the response will be a JSON object with the token information, otherwise, the response will be a JSON object with the `active` property set to `false`.

**Successful example:**

Verify that it contains the assigned roles, and the desired subgraph_access.

```json
{
    "exp": 1709785194,
    "iat": 1709749194,
    "jti": "b61662b4-e3b5-4009-bc08-a7821fcfa2ee",
    "iss": "http://localhost:8080/realms/HederaTheGraph",
    "aud": "account",
    "sub": "6e942cb3-4e82-447b-ac0c-641c764ef8f3",
    "typ": "Bearer",
    "azp": "htg-auth-layer",
    "session_state": "99891cd0-dc7f-44fd-9187-34f30f57e5d0",
    "acr": "1",
    "allowed-origins": [
        "/*"
    ],
    "realm_access": {
        "roles": [
            "default-roles-hederathegraph",
            "subgraph_remove",
            "subgraph_create",
            "subgraph_deploy",
            "offline_access",
            "uma_authorization",
            "subgraph_resume",
            "subgraph_pause"
        ]
    },
    "resource_access": {
        "account": {
            "roles": [
                "manage-account",
                "manage-account-links",
                "view-profile"
            ]
        }
    },
    "scope": "profile subgraph_access email",
    "sid": "99891cd0-dc7f-44fd-9187-34f30f57e5d0",
    "email_verified": true,
    "name": "User name",
    "subgraph_access": "subgraph1,subgraph2",
    "preferred_username": "user@swirldslabs.com",
    "given_name": "User First Name",
    "family_name": "User Last Name",
    "email": "user@swirldslabs.com",
    "client_id": "htg-auth-layer",
    "username": "user@swirldslabs.com",
    "token_type": "Bearer",
    "active": true
}
```

**Unsuccessful example: (invalid token or expired)**

```json
{
    "active": false
}
```

**Unsuccessful example: (invalid client_id or client_secret)**

```json
{
    "error": "invalid_request",
    "error_description": "Authentication failed."
}
```