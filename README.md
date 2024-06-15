# Atom developer tool
Atom developer tool(ADT) is a tool to build, setup Astra Neptune

## One time environment setup

   * Pull Atom project source code [atom](https://bitbucket.ngage.netapp.com/projects/QUARK-BB/repos/volume-controller) source code if you have not.

## Get Atom developer tool

### For OS X and Linux system
Download [atom](./atom) file, name it `atom` and `chmod +x atom`. It is best to move `atom` to a directory in your $PATH so that you do not have to refer its location when running it.

### For Windows system
Download [atom.cmd](./atom.cmd) file, name it `atom.cmd`. It is best to move `atom.cmd` to a directory in your %PATH% so that you do not have to refer its location when running it.

## One-step Neptune deployment and cleanup
All the command should run from your neptune root directory

1. ### Create k8s cluster and set up neptune controller
```
   atom up
```
2. ### Remove everything the up command sets up
```
   atom cleanall
```

## Neptune development
1. ### Create k8s cluster and image repository for Neptune development
```
   atom prepare
```
2. ### Push local built Astra neptune controller image to local registry
```
   atom image
```
3. ### Deploy Neptune CRDs and control
```
   atom deploy
```
4. ### Build Neptune
```
   atom make <target>
```
   Replace <target> with any target that Neptune Makefile defines

5. ### Remove Neptune from k8s cluster
```
  atom down
```

6. ### Bounce a deployment after you produced a newer Neptune image
```
  astra refresh -d controller-manager
```

7. ### Update this tool
```
   atom update
```

8. ### Get a bash session with Neptune
```
   atom bash
```

9. ### Learn more
```
   atom -h
```
