# Example Output: Kubernetes Pod Status

**Category**: general
**Source**: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller

## Description

This example illustrates the expected output from the kubectl get pods -n arc-systems command, showing the healthy status of the Actions Runner Controller and listener pods. It provides details such as pod names, readiness, current status ('Running'), restart count, and age. This output confirms the operational state of the controller components.

## Example Code

```text
NAME                                                   READY   STATUS    RESTARTS   AGE
arc-gha-runner-scale-set-controller-594cdc976f-m7cjs   1/1     Running   0          64s
arc-runner-set-754b578d-listener                       1/1     Running   0          12s
```
