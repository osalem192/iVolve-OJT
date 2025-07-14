# Lab 22: Persistent Storage Setup for Application Logging

This lab demonstrates how to set up persistent storage for application logging in Kubernetes using a Persistent Volume (PV) and a Persistent Volume Claim (PVC).

## Steps

### 1. Define a Persistent Volume (PV)
Create a Persistent Volume with the following specifications:
- **Size:** 1Gi
- **Storage type:** `hostPath`
- **Path:** `/mnt/app-logs` on the node file system  
  > **Note:** The directory `/mnt/app-logs` must be created on the application node with `777` permissions.
- **Access mode:** `ReadWriteMany` (allows all replicas read/write access)
- **Reclaim policy:** `Retain`

**Example PV YAML:**
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: app-logs-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /mnt/app-logs
```

### 2. Define a Persistent Volume Claim (PVC)
Create a Persistent Volume Claim that requests 1Gi of storage and matches the PV's access mode.

**Example PVC YAML:**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-logs-pvc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```

### 3. Ensure Access Mode Matches
Make sure the PVC access mode matches the PV (`ReadWriteMany`).

### 4. Additional Notes
- The `/mnt/app-logs` directory must exist on the node(s) where the pod(s) will run, and must have permissions set to `777` to allow read/write access by all pods.
- The `Retain` reclaim policy ensures that the data is preserved even after the PVC is deleted.

---

**Summary:**
- Create a PV with `hostPath`, 1Gi, `ReadWriteMany`, and `Retain` policy.
- Create a matching PVC requesting 1Gi and `ReadWriteMany`.
- Ensure the host directory exists and is accessible.
