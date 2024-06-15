# Atom developer tool
Atom developer tool(ADT) is a tool to build, setup Atom

## One time environment setup

   * Pull Atom project source code [atom](https://bitbucket.ngage.netapp.com/projects/QUARK-BB/repos/volume-controller) source code if you have not.

## Get Atom developer tool

### For OS X and Linux system
Download [atom](./atom) file, name it `atom` and `chmod +x atom`. It is best to move `atom` to a directory in your $PATH so that you do not have to refer its location when running it.

### For Windows system
Download [atom.cmd](./atom.cmd) file, name it `atom.cmd`. It is best to move `atom.cmd` to a directory in your %PATH% so that you do not have to refer its location when running it.

## One-step Atom deployment and cleanup
All the command should run from your atom root directory

1. ### Create k8s cluster and set up atom controller
```
   atom up
```
2. ### Remove everything the up command sets up
```
   atom cleanall
```

## Atom development
1. ### Create k8s cluster and image repository for Atom development
```
   atom prepare
```
2. ### Push local built Atom controller image to local registry
```
   atom image
```
3. ### Deploy Atom CRDs and control
```
   atom deploy
```
4. ### Build Atom
```
   atom make <target>
```
   Replace <target> with any target that Atom Makefile defines

5. ### Remove Atom from k8s cluster
```
  atom down
```

6. ### Bounce a deployment after you produced a newer Atom image
```
  astra refresh -d controller-manager
```

7. ### Update this tool
```
   atom update
```

8. ### Get a bash session with Atom
```
   atom bash
```

9. ### Learn more
```
   atom -h
```
