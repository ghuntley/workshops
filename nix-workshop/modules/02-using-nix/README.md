# Using Nix

## Overview

This section will provide a run-through of how to perform common task using the
suite of programs collectively known as the "Nix package manager", as well as some
third-party utilities.

If you have done the NixOS workshop, you will have already used some of these
programs, like `nix-env` and `nix-channel`, to perform truly essential tasks.
We'll put these tasks at the beginning, in a "recap" section.

Then we'll focus on several activities, and how to perform them, rather than
focus on the tools themselves. The executables come with very good manpages and
`--help` sections, and the [Nix Manual] contains a more detailed reference.

This module doesn't contain any NixOS-specific commands, and can be worked
through on a regular user account, either on NixOS or on any other Nix-enabled
OS.

## 🗹 Recap

We've already been using the Nix package manager during the NixOS tutorial. If
you started at the Nix tutorial, this is your chance to catch up:

* We installed software with `nix-env -iA nixos.$PACKAGE`
* We searched packages with `nix-env -qaP | grep $PACKAGE`
* We listed generations of the current profile with `nix-env --list-generations`
* We cleared up unused builds from the `/nix/store` with `nix-collect-garbage`
* We queried available package channels with `nix-channel --list`
* We added a channel with `nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs`
* We updated the channel package list with `nix-channel --update` or `nix-channel -u`
* We rolled-back the channel state with `nix-channel --roll-back`

Now we're going to look a bit deeper into how to perform more tasks with the Nix package manager.

Where are your packages coming from?
------------------------------------

We *could* get our packages by checking out a copy of the set of
community packages:

    # About 500Mb is downloaded at the time of writing
    git clone https://github.com/NixOS/nixpkgs my-nixpkgs-checkout

then finding the right branch and installing what we want. After that
we’d have to periodically update the repository and perhaps update the
things that we had installed.

Instead, we can use channels to manage this for us. A Nix channel gives
a git checkout of a package collection a name and makes it available via
an environment variable, so that we don’t have to keep using the full
path to the checkout. There are a few other details, but that is all
that matters for now.

The Nix installer already set a channel up for us, which we can verify:

    > nix-channel --list
    nixpkgs https://nixos.org/channels/nixpkgs-unstable

We make use of this channel - indirectly - through the `NIX_PATH`
environment variable:

    > echo $NIX_PATH
    nixpkgs=/home/username/.nix-defexpr/channels/nixpkgs

We can update the channel with:

    > nix-channel --update nixpkgs
    downloading Nix expressions from ‘https://d3g5gsiof5omrk.cloudfront.net/nixpkgs/nixpkgs-17.09pre111304.5328102325/nixexprs.tar.xz’...
    downloading ‘https://d3g5gsiof5omrk.cloudfront.net/nixpkgs/nixpkgs-17.09pre111304.5328102325/nixexprs.tar.xz’... [2185/8847 KiB, 1047.5 KiB/s]
    unpacking channels...

and then can update the packages installed into the current environment
with:

    > nix-env -u

From here on we’ll be mostly be using channels to manage our
environment. If you’re playing along at home, we’ll still be looking at
how to make use of a git checkout of a package collection, so now would
be a good time to clone the repository as shown above.

Searching for packages
----------------------

We *query* for packages using `nix-env -q`.

Let’s have a look for the package containing the `tree` utility.

If we use `-q` on its own, we are querying the set of packages which is
installed in this environment:

    > nix-env -q tree
    error: selector 'tree' matches no derivations

It makes sense that we didn’t find `tree`, since we haven’t installed it
yet.

If we don’t give a package to query for, we’ll get a list of all of the
packages installed in the environment:

    > nix-env -q
    nix-1.11.13

If we use `-qa` to *query* for the packages which are *available* to
install:

    > nix-env -qa tree
    tree-1.7.0

and we can use wildcards if we want:

    > nix-env -qa 'tree.*'
    tree-1.7.0
    treesheets-2017-03-27

or we can ask for everything and use `grep` for our filtering:

    > nix-env -qa | grep '^tree'
    tree-1.7.0
    treesheets-2017-03-27

### Querying with attribute paths

We can use `-qaP` *query* for the packages which are *available* to
install and to also print the *attribute path* of the package, which is
the unambiguous path to the package in the Nix world:

    > nix-env -qaP tree
    nixpkgs.tree  tree-1.7.0

This is telling us that it found the `tree` utility in the `nixpkgs`
channel, so referring to the package as `nixpkgs.tree` would be
unambiguous. This becomes important once we have multiple channels in
use.

Let’s add one now, partly to see what happens and partly to see that
working with multiple channels is no big deal:

    > nix-channel --add https://nixos.org/channels/nixos-17.03 nixos
    > nix-channel --list
    nixos https://nixos.org/channels/nixos-17.03
    nixpkgs https://nixos.org/channels/nixpkgs-unstable
    > nix-channel --update nixos
    downloading Nix expressions from ‘https://d3g5gsiof5omrk.cloudfront.net/nixos/17.03/nixos-17.03.1599.f1311880c7/nixexprs.tar.xz’...
    downloading ‘https://d3g5gsiof5omrk.cloudfront.net/nixos/17.03/nixos-17.03.1599.f1311880c7/nixexprs.tar.xz’... [2381/9232 KiB, 1148.1 KiB/s]
    unpacking channels...
    created 5 symlinks in user environment

Now if we repeat that query, we get two results:

    > nix-env -qaP tree
    nixos.tree    tree-1.7.0
    nixpkgs.tree  tree-1.7.0

We can then use some or all of the attribute path to limit our search:

    > nix-env -qaP -A nixpkgs tree
    nixpkgs.tree  tree-1.7.0
    > nix-env -qaP -A nixpkgs.tree
    nixpkgs.tree  tree-1.7.0

Let’s tidy up our channels to keep the output of these commands a bit
simpler:

    > nix-channel --remove nixos
    uninstalling ‘nixos-17.03.1599.f1311880c7’

Attribute paths are useful for more than just channel management. Some
language ecosystems are namespaced away from the other packages via
attribute paths.

Let’s look for the `hail` package, which is written in Haskell:

    > nix-env -qaP 'hail.*'
    error: selector ‘hail’ matches no derivations

We didn’t find any results, because the Haskell packages are all placed
within the `haskellPackages` namespace.

We can find it by adding that to the attribute path in our query:

    > nix-env -qaP -A nixpkgs.haskellPackages 'hail.*'
    nixpkgs.haskellPackages.hail            hail-0.1.0.3
    nixpkgs.haskellPackages.hailgun         hailgun-0.4.1.4
    nixpkgs.haskellPackages.hailgun-send    hailgun-send-0.1.1.1
    nixpkgs.haskellPackages.hailgun-simple  hailgun-simple-0.1.0.0
    nixpkgs.haskellPackages.hails-bin       hails-bin-0.1.1.1

In this case, `haskellPackages` is an alias for the set of Haskell
packages built with the latest stable version of GHC (the main Haskell
compiler).

We can be specific about our compiler if we want:

    > nix-env -qaP -A nixpkgs.haskell.packages.ghc802 'hail.*'
    nixpkgs.haskell.packages.ghc802.hail  hail-0.1.0.3

but that’s getting ahead of ourselves.

If you can’t find what you’re looking for, it might be worth browsing
the chapter in the Nixpkgs manual on [lanaguage and framework
support](http://nixos.org/nixpkgs/manual/#chap-language-support) to see
if you are dealing with something that is namespaced away.

At this point we should be able to look around and find what we’re
looking for.

### Querying from other sources

What if we wanted to query from our git checkout of `nixpkgs`, or from a
custom package source?

For that, we can specify which *file* to use:

    > nix-env -f ./my-nixpkgs-checkout -qaP 'tree.*'
    tree        tree-1.7.0
    treesheets  treesheets-2017-03-27

This doesn’t have the channel as the prefix of the attribute path. We
have specified which file we want to work with, so there is not
potential ambiguity to deal with.

There is one more thing worth noting here.

We can assign names to different versions of `nixpkgs` in the `NIX_PATH`
environment variable. By default, we have an entry for the channel that
was set up by the Nix installer:

    > echo $NIX_PATH
    nixpkgs=/home/username/.nix-defexpr/channels/nixpkgs

We can look up the file referred to by `aliasname` with `<aliasname>`,
so you’ll occasionally see snippets like this:

    > nix-env -f "<nixpkgs>" -qaP 'tree.*'
    tree        tree-1.7.0
    treesheets  treesheets-2017-03-27

Installing packages
-------------------

Before we install the `tree` utility, let us check that we don’t already
have it:

    > which tree
    <no output>

We also don’t have anything `tree` related in the nix store:

    > ls /nix/store/*tree*
    ls: cannot access '/nix/store/*tree*': No such file or directory

It’s also worth taking note of the current generation, although I’ll
explain what it means in a moment:

    > nix-env --list-generations
       1   2017-07-26 16:32:12   (current)

The stage is now set: let us *install* our first Nix package.

    > nix-env -i tree
    ... output elided ...

Let’s take it for a spin, in the home directory of a recent Ubuntu
install:

    > tree -L 1
    .
    ├── Desktop
    ├── Documents
    ├── Downloads
    ├── examples.desktop
    ├── Music
    ├── Pictures
    ├── Public
    ├── Templates
    └── Videos

So far, so good.

Where is it coming from?

    > which tree
    /home/username/.nix-profile/bin/tree

It seems to be coming from somewhere Nix-related, so that’s a start.

We also now have `tree`-related things in the Nix store:

    > ls /nix/store/*tree*
    /nix/store/cidnc4ljs1zg7s0zh087pai8xdmsilya-tree-1.7.0.tgz.drv
    /nix/store/xsky6ny1gnlg45imr8aqrmj7ngzvdw2j-tree-1.7.0.drv

    /nix/store/i3gb14wy41qxsc9l0dsspg5n6jr7dqmq-tree-1.7.0:
    bin  share

(In this case they are, respectively: a derivation describing how to
fetch the sources for `tree`, a derivation describing how to build
`tree`, and the output of building the derivation for `tree`)

If we look at the list of generations, we can see that things have
changed there as well:

    > nix-env --list-generations
       1   2017-07-26 16:32:12
       2   2017-07-26 16:34:50   (current)

So things have changed, but it’s probably not clear how those changes
are all related.

### Poking around in the profiles

There’s one piece of information that is key to working out what is
going on here: Nix uses a lot of symlinks, in collections referred to as
profiles.

We’re going to use that to examine what happened when we installed
`tree` in a bit more detail.

We saw that tree was in the `.nix-profile` directory:

    > which tree
    /home/username/.nix-profile/bin/tree

and we can verify that is in our PATH:

    > echo $PATH
    /home/username/.nix-profile/bin:/home/username/.nix-profile/sbin:... other paths ...

Let’s look a bit closer at that `.nix-profile` directory:

    > ls -l ~/.nix-profile
    .nix-profile -> /nix/var/nix/profiles/default

and then follow that:

    > ls -l /nix/var/nix/profiles/default
    /nix/var/nix/profiles/default -> default-2-link

and continue along:

    > ls -l /nix/var/nix/profiles/default-2-link
    /nix/var/nix/profiles/default-2-link -> /nix/store/dycyy34alkg4maza38xn445pz5hdz6xi-user-environment

and then take one more step down the rabbit hole:

    > ls -l /nix/store/dycyy34alkg4maza38xn445pz5hdz6xi-user-environment/bin
    ...
    tree -> /nix/store/i3gb14wy41qxsc9l0dsspg5n6jr7dqmq-tree-1.7.0/bin/tree
    ...

and we’ve found our actual binary.

Why does Nix put itself through such contortions? It’s actually a pretty
nifty scheme.

Let’s have a look in the `/nix/var/nix/profiles` directory, because that
holds the key to what is going on here:

    > ls -l /nix/var/nix/profiles
    default -> default-2-link
    default-1-link -> /nix/store/qxng2qbahcf6dz19llqb4ivxw0bar57l-user-environment
    default-2-link -> /nix/store/dycyy34alkg4maza38xn445pz5hdz6xi-user-environment

A *user environment* is a collection of links that makes various things
in the Nix store available - things like binaries, libraries and
documentation.

A *profile* is a symbolic link to a user environment. Whenever we change
our environment with `nix-env` - by installing or updating or removing a
package - a new environment is built. This environment is used as a new
*generation* of our profile.

Once everything is in place, the symbolic link to our profile (`default`
in this case) is updated to point to the most recent generation of the
profile.

This is what gives us the ability to update things atomically - the
change doesn’t effect us until the moment that symbolic link is changed.
Anything that was already running continues to run using the environment
in which it was started, and anything we run after the change will make
use of the new user environment.

For the most part you won’t need to dive into this too much. It can be
handy to know about this in case you need to debug something hairy, or
in case you just get curious about what is going on. It also helps
demystify some of the terminology around profiles, environments and
generations.

Rolling back and switching generations
--------------------------------------

Now that we know a bit more about profiles and generations, we can play
around with them some more.

At the moment we have two generations:

    > nix-env --list-generations
       1   2017-07-26 16:32:12   
       2   2017-07-26 16:34:50   (current)

The first generation is the one we started off in, with access to Nix
and not much else. The second generation is just like the first one,
with the addition of the `tree` utility.

We can rollback to the generation before our last modification to the
environment:

    > nix-env --rollback
    switching from generation 2 to 1
    > nix-env --list-generations
       1   2017-07-26 16:32:12   (current)
       2   2017-07-26 16:34:50   

From there we can check that we no longer have access to the `tree`
utility:

    > which tree
    <no output>

although it is still available in the Nix store:

    > ls /nix/store/*tree*
    /nix/store/cidnc4ljs1zg7s0zh087pai8xdmsilya-tree-1.7.0.tgz.drv
    /nix/store/xsky6ny1gnlg45imr8aqrmj7ngzvdw2j-tree-1.7.0.drv

    /nix/store/i3gb14wy41qxsc9l0dsspg5n6jr7dqmq-tree-1.7.0:
    bin  share

We can jump back to generation 2:

    > nix-env --switch-generation 2
    switching from generation 1 to 2
    > nix-env --list-generations
       1   2017-07-26 16:32:12   
       2   2017-07-26 16:34:50   (current)

and we have access to `tree` again:

    > which tree
    /home/username/.nix-profile/bin/tree

This can be pretty handy if you think you’ve broken something, or if you
want to quickly test the effect a change to the environment might have
had on a project.

Uninstalling packages
---------------------

We can *erase* the `tree` utility from our current environment with:

    nix-env -e tree

This puts us into a similar state to when we rolled back the
installation of `tree`:

    > which tree
    <no output>
    > ls /nix/store/*tree*
    /nix/store/cidnc4ljs1zg7s0zh087pai8xdmsilya-tree-1.7.0.tgz.drv
    /nix/store/xsky6ny1gnlg45imr8aqrmj7ngzvdw2j-tree-1.7.0.drv

    /nix/store/i3gb14wy41qxsc9l0dsspg5n6jr7dqmq-tree-1.7.0:
    bin  share

although it has created a new generation:

    > nix-env --list-generations
       1   2017-07-26 16:32:12   
       2   2017-07-26 16:34:50   
       3   2017-07-27 11:13:59   (current)

Since we already have `tree` in the Nix store, we can install it again
really quickly:

    > nix-env -i tree
    installing ‘tree-1.7.0’

although we’ll end up in a new generation:

    > nix-env --list-generations
       1   2017-07-26 16:32:12   
       2   2017-07-26 16:34:50   
       3   2017-07-27 11:13:59   
       4   2017-07-27 11:20:50   (current)

“Hold up”, some of you may be thinking, “haven’t we been in this state
before?”. Indeed we have - generations 2 and 4 are both pristine Nix
installs with the addition of the `tree` utility.

There is no wastage here.

If we poke around in the profiles, we can see that these two generations
share a build environment.

    > ls -l /nix/var/nix/profiles
    default -> default-4-link
    default-1-link -> /nix/store/qxng2qbahcf6dz19llqb4ivxw0bar57l-user-environment
    default-2-link -> /nix/store/dycyy34alkg4maza38xn445pz5hdz6xi-user-environment
    default-3-link -> /nix/store/klvss49gcz8g7d37am3k5m845g2ipwjd-user-environment
    default-4-link -> /nix/store/dycyy34alkg4maza38xn445pz5hdz6xi-user-environment

This happens because Nix hashes everything, and the hash of the user
environments for generation 2 an generation 4 will be the same because
they are built from the same things.

Collecting garbage
------------------

We’ve seen that erasing `tree` from the user environment doesn’t remove
it from the Nix store.

Things are only removed from the Nix store when they aren’t being used
and a garbage collection is run.

There are options for deleting specific generations, or deleting
generations that are more than a certain number of days old. That is
covered pretty well in the [garbage
collection](http://nixos.org/nix/manual/#sec-garbage-collection) section
of the NixOS manual.

If you want to delete all your old generations and then run the garbage
collector, you can do that with:

    > nix-collect-garbage -d
    ...
    > nix-env --list-generations
       4   2017-07-27 11:20:50   (current)

Probably don’t do that if you still think you might want to roll back a
generation or two at some point, but otherwise it works pretty well.

If you’ve been playing along, we currently have `tree` installed. Let’s
erase `tree` and then run another garbage collection.

We do the erase:

    nix-env -e tree
    uninstalling ‘tree-1.7.0’
    building path(s) ‘/nix/store/klvss49gcz8g7d37am3k5m845g2ipwjd-user-environment’
    created 6 symlinks in user environment

and then we do the garbage collection:

    > nix-collect-garbage -d
    removing old generations of profile /nix/var/nix/profiles/per-user/username/channels
    removing old generations of profile /nix/var/nix/profiles/default
    removing generation 4
    finding garbage collector roots...
    deleting garbage...
    deleting ‘/nix/store/dycyy34alkg4maza38xn445pz5hdz6xi-user-environment’
    deleting ‘/nix/store/8gpmwqz1k1zvp504lqbvr1c7nnf4kdjb-user-environment.drv’
    deleting ‘/nix/store/hxbhq1ggzikyxcg2pk5z3cnjx4chd5s6-env-manifest.nix’
    deleting ‘/nix/store/i3gb14wy41qxsc9l0dsspg5n6jr7dqmq-tree-1.7.0’
    deleting ‘/nix/store/i95x934ljf3ginapkmqs2rrik472zlnx-glibc-2.25’
    deleting ‘/nix/store/trash’
    deleting unused links...
    note: currently hard linking saves -0.00 MiB
    5 store paths deleted, 22.00 MiB freed

This leaves us with a new generation of our profile:

    > nix-env --list-generations
       5   2017-07-27 12:21:05   (current)

No access to `tree`:

    > which tree
    <no output>

And now `tree` is no longer in the Nix store:

    > ls /nix/store/*tree*
    ls: cannot access '/nix/store/*tree*': No such file or directory

Taking a package out for a quick spin
-------------------------------------

If we wanted to give `tree` a try without installing it into our user
environment, we can do

    > nix-shell -p tree
    nix-shell >

to put us inside a Nix shell with access to the `tree` package:

    nix-shell > which tree
    /nix/store/i3gb14wy41qxsc9l0dsspg5n6jr7dqmq-tree-1.7.0/bin/tree

for as long as we are in that shell:

    nix-shell > exit
    > which tree
    <no output>

(We could also tidy up after ourselves with `nix-collect-garbage -d`,
but we’d normally just leave that until the next time that it occurred
to us to run the garbage collector)

What is `nix-shell` for? We normally use `nix-shell` when we’re
developing new Nix packages - which is the topic of the [next
post](../building-things-with-nix/).


## Acknowledgements
* Original material by Dave Laing on the Queensland Functional Programming Lab's
  websitge as [Getting started with Nix].


## 📚 Additional material
* [Nixp manual]


## ⏭️ What's next

Now we'd like to show you how to write packages for Nix.
But first, a short detour into [the Nix expression language].


<!-- in-line links -->
[Nix Manual]: https://nixos.org/nix/manual/
[Getting started with Nix]: http://qfpl.io/posts/nix/getting-started-with-nix/
[the Nix expression language]: ../03-the-nix-language/README.md