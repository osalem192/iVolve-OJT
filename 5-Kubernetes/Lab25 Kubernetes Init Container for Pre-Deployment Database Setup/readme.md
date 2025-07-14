# Lab 25: Kubernetes Init Container for Pre-Deployment Database Setup

This lab demonstrates how to use a Kubernetes init container to set up a MySQL database and user before deploying a Node.js application. The init container will run before the main app container, ensuring the database and user are ready for the app to use.

## Objectives
- Modify the existing Node.js Deployment to include an init container.
- Use a MySQL client image (e.g., `mysql:5.7`) for the init container.
- Pass DB connection parameters using environment variables.
- The init container should create the `ivolve` database and an `appuser` with all privileges on it.
- Verify the init container's actions using logs and manual MySQL connection.
- Use `kubectl port-forward` for local testing.

---

## 1. Prerequisites
- A running Kubernetes cluster
- Node.js app Docker image (from previous labs)
- MySQL server running (can be in-cluster or external)
- ConfigMap/Secret for DB credentials (see Lab 24)

---

## 2. Example Deployment with Init Container

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodejs-app
  template:
    metadata:
      labels:
        app: nodejs-app
    spec:
      containers:
      - name: nodejs
        image: <your-dockerhub-username>/<your-nodejs-image>:<tag>
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: <your-configmap>
              key: DB_HOST
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: <your-secret>
              key: DB_USER
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: <your-secret>
              key: DB_PASSWORD
        ports:
        - containerPort: 3000
      initContainers:
      - name: init-mysql-db
        image: mysql:5.7
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: <your-secret>
              key: MYSQL_ROOT_PASSWORD
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: <your-configmap>
              key: DB_HOST
        - name: APP_DB
          value: ivolve
        - name: APP_USER
          value: appuser
        - name: APP_PASSWORD
          valueFrom:
            secretKeyRef:
              name: <your-secret>
              key: APP_PASSWORD
        command:
        - sh
        - -c
        - |
          mysql -h "$DB_HOST" -u root -p"$MYSQL_ROOT_PASSWORD" -e "\
            CREATE DATABASE IF NOT EXISTS $APP_DB; \
            CREATE USER IF NOT EXISTS '$APP_USER'@'%' IDENTIFIED BY '$APP_PASSWORD'; \
            GRANT ALL PRIVILEGES ON $APP_DB.* TO '$APP_USER'@'%'; \
            FLUSH PRIVILEGES;"
```

---

## 3. Explanation
- **initContainers** run before app containers. If the DB/user already exist, the commands are safe (idempotent).
- Environment variables are used for DB connection and credentials.
- The MySQL client connects to the DB host and runs SQL to create the database and user.

---

## 4. Verification Steps

### a. Check Init Container Logs
```sh
kubectl logs <pod-name> -c init-mysql-db
```
Look for errors or confirmation that the DB/user were created.

### b. Connect to MySQL and Verify
- Port-forward MySQL service (if running in-cluster):
```sh
kubectl port-forward service/mysql 3306:3306
```
- Connect using a MySQL client:
```sh
mysql -h 127.0.0.1 -u appuser -p
# Enter APP_PASSWORD when prompted
mysql> SHOW DATABASES;
mysql> SHOW GRANTS FOR 'appuser'@'%';
```
- Ensure `ivolve` DB exists and `appuser` has privileges.

### c. Port-Forward Node.js App for Testing
```sh
kubectl port-forward service/nodejs-service 8080:80
```

---

## 5. Notes
- Replace placeholders (`<your-dockerhub-username>`, `<your-nodejs-image>`, `<your-configmap>`, `<your-secret>`, etc.) with your actual resource names.
- The MySQL server must be reachable from the init container (networking, service, etc.).
- You can adapt the SQL in the init container for more complex setups.
- Use `kubectl get pods`, `kubectl describe pod <pod-name>`, and `kubectl logs` for troubleshooting.

---

## 6. References
- [Kubernetes Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- [MySQL Docker Hub](https://hub.docker.com/_/mysql)
