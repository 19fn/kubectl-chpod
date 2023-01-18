# checkPODS

### Prerequisites
- `kubectl` should be installed (v1.26 or more recent is fine)
-  You should pass only one argument and should be a `namespace`.


## Understanding chpod

The checkPODs alias chpod script has very simple logic. It works with the output of the following command 
```sh
'kubectl get pods --namespace example-ns'.
```
The script checks the status of deployed containers and prints containers that do not have a `Running` status.

### Usage
```sh
chpod [ namespace name ]
```
