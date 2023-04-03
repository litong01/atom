# Astra developer tool
Astra developer tool(ADT) is to setup Astra Control Services(ACS) on OS X, WSL, Windows and Linux environment for development and testing.

## One time environment setup

   * Pull Astra [polaris](https://github.com/NetApp-Polaris/polaris) source code if you have not.
   * Set up environment variables. Use this [example](myenv.sh) script to create your own and save it in a secure place so that you can easily run `source myenv.sh` when you need to.
   * Ensure `/etc/hosts` file has entry `127.0.0.1 integration.astra.netapp.io`

## Get Astra developer tool

### For OS X and Linux system
Download [astra](./astra) file, name it `astra` and `chmod +x astra`. It is best to move `astra` to a directory in your $PATH so that you do not have to refer its location when running it.

### For Windows system
Download [astra.cmd](./astra.cmd) file, name it `astra.cmd`. It is best to move `astra.cmd` to a directory in your %PATH% so that you do not have to refer its location when running it.

## One-step ACS deployment
All the command should run from your polaris root directory

1. ### Create k8s cluster and stand up ACS
```
   astra up
```
2. ### Access ACS at [https://integration.astra.netapp.io/](https://integration.astra.netapp.io/)
3. ### Shutdown ACS and remove k8s cluster
```
   astra clean
```

## Multi-step ACS deployment
1. ### Pull all Astra images
```
   astra pull
```
2. ### Create k8s cluster and image repository for Astra deployment
```
   astra prepare
```
3. ### Install ACS
```
   astra deploy
```
Note: This step will deploy traefik first, a proxy, then all other ACS components. You may also choose to use the fine grained tasks to deploy ACS components step by step, so that you can verify each step after it is done. If any of the steps fails, you can re-run the failed step like below.
```
   astra deploy -a traefik   # traefik and proxy
   astra deploy -a main      # all Astra components except traefik
   astra deploy -a dash      # astra product grafana/prometheus dashboard
   astra deploy -a service   # deploy astra service account
   astra deploy -a user      # create astra accounts, users, subscription
```
4. ### Access ACS using the following URLs

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

## Develop Astra Control Services
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

- Pull all necessary images:
```
  astra pull
```
- Pull a specific image:
```
  astra pull -i identity:xxx-integration
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
