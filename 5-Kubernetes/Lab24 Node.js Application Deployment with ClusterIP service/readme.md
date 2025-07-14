# Lab 24: Node.js Application Deployment with ClusterIP Service

This lab guides you through deploying a Node.js application in Kubernetes with a ClusterIP service, environment variables from ConfigMap/Secret, tolerations, persistent storage, and service exposure for testing.

## Requirements & Steps

1. **Create a Deployment**
   - Name: `nodejs-app`
   - Replicas: **2**
   - Use your custom Docker image from Docker Hub.

2. **Configure Environment Variables**
   - Use environment variables from a ConfigMap or Secret:
     - `DB_HOST`
     - `DB_USER`
     - `DB_PASSWORD`

3. **Add Toleration**
   - Add a toleration to the pod spec:
     - Key: `workload`
     - Value: `app`
     - Effect: `NoSchedule`

4. **Persistent Volume**
   - Configure the pod to use the statically created Persistent Volume (PV).

5. **Create a ClusterIP Service**
   - Name: `nodejs-service`
   - Type: `ClusterIP`
   - Purpose: Balance traffic across the 2 replicas of the deployment.

6. **Port Forwarding for Testing**
   - Use `kubectl port-forward` to forward a local port to the service or pod for testing.


## Example YAML Snippets

### Deployment Example
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
      tolerations:
      - key: "workload"
        operator: "Equal"
        value: "app"
        effect: "NoSchedule"
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
        volumeMounts:
        - name: app-storage
          mountPath: /data
      volumes:
      - name: app-storage
        persistentVolumeClaim:
          claimName: <your-pvc>
```

### Service Example
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nodejs-service
spec:
  type: ClusterIP
  selector:
    app: nodejs-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000 # Change to your app's port
```

### Port Forward Example
```sh
kubectl port-forward service/nodejs-service 8080:80
```

---

## Notes
- Replace placeholders (e.g., `<your-dockerhub-username>`, `<your-nodejs-image>`, `<your-configmap>`, `<your-secret>`, `<your-pvc>`) with your actual resource names.
- Ensure your Persistent Volume and Persistent Volume Claim are created and bound before deploying the app.
- Use `kubectl get pods`, `kubectl get svc`, and `kubectl logs` for troubleshooting.
