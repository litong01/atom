# Astra developer tool
Astra developer tool(ADT) is to setup Astra Control Services(ACS) on OS X, WSL and Linux environment for development and testing.

## One time environment setup

   * Pull Astra [polaris](https://github.com/NetApp-Polaris/polaris) source code if you have not.
   * Use your NetApp BlueXP user id and password create a file like [this](/scripts/beta/auth2.json), save it in a secure place. If you do not have BlueXP id, go to [NetApp BlueXP](https://cloudmanager.netapp.com/working-environments) to sign up.
   * Set up environment variables. Use this [example](myenv.sh) script to create your own and save it in a secure place so that you can easily run `source myenv.sh` when you need to.
   * Ensure `/etc/hosts` file has entry `127.0.0.1 integration.astra.netapp.io`
   * Login to NetApp docker registry to avoid image pulling failures
    `docker login -u <your SSO login> https://docker.repo.eng.netapp.com/v2`

## Get Astra developer tool

```
curl -o astra -sL https://tinyurl.com/yc89kjvf && chmod +x astra
```

## One-step ACS deployment
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
   astra deploy -a post      # post install script
```
4. ### Access ACS at [https://integration.astra.netapp.io/](https://integration.astra.netapp.io/)
5. ### Cleanup everything after use
```
   astra clean
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
  make docker
```

- Build just one image, for example, identity image
```
  make docker-identity
```

- Pull all images from netapp Astra image repo:
```
  astra pull
```
- Pull just one image from netapp Astra image repo:
```
  astra pull -i identity
```
- Push or load local images to k8s cluster image repo:
```
  astra image
```

- Push or load just one local image to k8s cluster image repo:
```
  astra image -s identity:xxx-integration
```

- Bounce a deployment after you produced a newer image, for example, identity
```
  astra refresh -d identity
```
