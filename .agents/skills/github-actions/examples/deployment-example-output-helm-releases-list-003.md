# Example Output: Helm Releases List

**Category**: deployment
**Source**: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller

## Description

This example shows the typical output from the helm list -A command after a successful installation of the Actions Runner Controller. It displays the arc controller and arc-runner-set with a 'deployed' status, along with their respective namespaces, revisions, and chart versions. This output confirms that the Helm charts have been correctly installed.

## Example Code

```text
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                                       APP VERSION
arc             arc-systems     1               2023-04-12 11:45:59.152090536 +0000 UTC deployed        gha-runner-scale-set-controller-0.4.0       0.4.0
arc-runner-set  arc-runners     1               2023-04-12 11:46:13.451041354 +0000 UTC deployed        gha-runner-scale-set-0.4.0                  0.4.0
```
