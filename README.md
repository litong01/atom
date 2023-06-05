# Astra developer tool
Astra developer tool(ADT) is to setup Astra Control Services(ACS) or Astra Control Center on OS X, WSL, Windows and Linux environment for development and testing.

## One time environment setup

   * Pull Astra [polaris](https://github.com/NetApp-Polaris/polaris) source code if you have not.
   * Set up environment variables. Use this [example](myenv.sh) script to create your own and save it in a secure place so that you can easily run `source myenv.sh` when you need to. Use this [windows example](myenv.cmd) for windows
   * Ensure `/etc/hosts` file has entry `127.0.0.1 integration.astra.netapp.io`. Use `C:\Windows\System32\drivers\etc\hosts` for windows
   * Intranet connection for pulling AC images if you prefer not to build locally

## Get Astra developer tool

### For OS X and Linux system
Download [astra](./astra) file, name it `astra` and `chmod +x astra`. It is best to move `astra` to a directory in your $PATH so that you do not have to refer its location when running it.

### For Windows system
Download [astra.cmd](./astra.cmd) file, name it `astra.cmd`. It is best to move `astra.cmd` to a directory in your %PATH% so that you do not have to refer its location when running it.

## One-step AC deployment
All the command should run from your polaris root directory

1. ### Create k8s cluster and stand up Astra Control
```
   astra up -t acs   # setup ACS
   astra up -t acc   # setup ACC, when -t is not used, default to acc
```
2. ### Access ACS or ACC at [https://integration.astra.netapp.io/](https://integration.astra.netapp.io/)
3. ### Shutdown AC and remove k8s cluster
```
   astra clean
```
4. ### Shutdown AC and clean up everything including local image registry
```
   astra cleanall
```



## Multi-step AC deployment
1. ### Create k8s cluster and image repository for Astra deployment
```
   astra prepare
```
2. ### Setup Astra images
```
   astra image
```
3. ### Deploy ACS or ACC
```
   astra deploy -t acs
   astra deploy -t acc
```
4. ### Access AC using the following URLs

    * ACS dashboard at [https://integration.astra.netapp.io/](https://integration.astra.netapp.io/)
  
    * ACS grafana dashboard at [https://integration.astra.netapp.io/grafana](https://integration.astra.netapp.io/grafana)
  
    * ACS prometheus dashboard at [https://integration.astra.netapp.io/prometheus/graph](https://integration.astra.netapp.io/prometheus/graph)
 
5. ### Cleanup everything after use
```
   astra cleanall
```
6. ### Learn more
```
   astra -h
```

## Extra utilities to help one to develop Astra Control
All the commands should run in Polaris root directory and make sure
environment variables were set as [described above](#one-time-environment-setup)

- Build all images locally
```
  astra make docker
```

- Build just one image, for example, identity image
```
  astra make docker-identity
```

- Push or load local images to k8s cluster image repo:
```
  astra image
```

- Push or load just one local image to k8s cluster image repo:
```
  astra image -i identity:xxx-integration
```

- Bounce a deployment after you produced a newer image, for example, identity
```
  astra refresh -d identity
```

- Update adt itself
```
  astra update
```

- Get an interactive session to run whelp
```
  astra whelp
```

- Setup active directory service in your k8s cluster
```
  astra sambaad
```
