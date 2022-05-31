# FileBrowser

As fast files exchange point, public.

# TL;DR;

````bash
./deploy_all.sh
````

# Requirements

- OpenShift Container Platform cluster (tested with 4.9 and 4.10)
- Default Storage Class configured
- Cluster-Admin account to execute it

# Created resources

- Namespace
- Service Account
- Cluster Role Binding (privileged)
- Statefulset (with 10Gi pvc)
- Service
- Route
- Configmap

## License

<img src="./img/by-sa.png">

This work is under [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

Please read the LICENSE files for more details.
