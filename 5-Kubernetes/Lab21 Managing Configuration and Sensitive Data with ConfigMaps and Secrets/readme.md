# Lab 21: Managing Configuration and Sensitive Data with ConfigMaps and Secrets

## Objective
This lab demonstrates how to manage non-sensitive and sensitive MySQL configuration data in Kubernetes using ConfigMaps and Secrets.

---

## 1. Define a ConfigMap for Non-Sensitive MySQL Configuration
Create a ConfigMap to store non-sensitive MySQL configuration variables:
- **DB_HOST**: The hostname of the MySQL StatefulSet service
- **DB_USER**: The database user that the application will use to connect to the ivolve database

**Example ConfigMap YAML:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config

data:
  DB_HOST: "mysql"
  DB_USER: "ivolve_user"
```

---

## 3. How to Base64 Encode Secret Data Values
You must encode the secret values using base64 before adding them to the Secret manifest.

**Example (Linux):**
```sh
echo 'SuperStrongPassword' | base64
```

**Output:**
```bash
U3Ryb25nUGFzc3dvcmQK
```


## 2. Define a Secret for Sensitive MySQL Credentials
Create a Secret to store sensitive MySQL credentials securely:
- **DB_PASSWORD**: The password for the DB_USER
- **MYSQL_ROOT_PASSWORD**: The root password for MySQL database

**Note:** Secret data values must be base64 encoded.


**Example Secret YAML:**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret

data:
  DB_PASSWORD: U3Ryb25nUGFzc3dvcmQK
  MYSQL_ROOT_PASSWORD: U3Ryb25nUGFzc3dvcmQK
```


## 4. References
- [Kubernetes ConfigMap Documentation](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Kubernetes Secret Documentation](https://kubernetes.io/docs/concepts/configuration/secret/)
