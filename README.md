# Astra developer tool
Astra3 developer tool(ADT) is a tool to build, setup Astra Neptune

## One time environment setup

   * Pull Astra [neptune](https://github.com/NetApp-Polaris/neptune) source code if you have not.

## Get Astra developer tool

### For OS X and Linux system
Download [astra3](./astra3) file, name it `astra3` and `chmod +x astra3`. It is best to move `astra3` to a directory in your $PATH so that you do not have to refer its location when running it.

### For Windows system
Download [astra3.cmd](./astra3.cmd) file, name it `astra3.cmd`. It is best to move `astra3.cmd` to a directory in your %PATH% so that you do not have to refer its location when running it.

## One-step Neptune deployment and cleanup
All the command should run from your neptune root directory

1. ### Create k8s cluster and set up neptune controller
```
   astra3 up
```
2. ### Remove everything the up command sets up
```
   astra3 cleanall
```

## Neptune development
1. ### Create k8s cluster and image repository for Neptune development
```
   astra3 prepare
```
2. ### Push local built Astra neptune controller image to local registry
```
   astra3 image
```
3. ### Deploy Neptune CRDs and control
```
   astra3 deploy
```
4. ### Build Neptune
```
   astra3 make <target>
```
   Replace <target> with any target that Neptune Makefile defines

5. ### Remove Neptune from k8s cluster
```
  astra3 down
```

6. ### Bounce a deployment after you produced a newer Neptune image
```
  astra refresh -d controller-manager
```

7. ### Update this tool
```
   astra3 update
```

8. ### Get a bash session with Neptune
```
   astra3 bash
```

9. ### Learn more
```
   astra3 -h
```
