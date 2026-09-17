This file, and the following sections, detail why I even started this branch of the project, and
what I am doing. 

## Why?
You might be asking a few questions when you see this `next` branch over the `main` branch. 
So let's just spitball them:

### Why did you make another branch?
The original repo, the bazzite-image-template, has a lot of shortcomings. This is partially
down to how the ISOs get built, including the fact it is broken out of the box, but it's also
very hard to test locally once you get to a point where the entire system is held together by
a bunch of short term hacks.

Believe it or not, that's not what I want from my tooling; It affects the end result and
ultimately means the image will no longer be stable. Whilst the regular BootC is great to start 
out with, it becomes a headache incredibly fast.

As a result, in an effort to reduce my long term headaches, I am instead sticking myself with
a likely... maybe... short term headache instead. Specifically shipping my own tooling.

### There's plenty of these, why are you making yet another?
So the problem lies with how these other operating systems/distros approach the problem and
goal. One universal trait is that they install *every single possible application you may ever
use.*
 
To me, that's not the right way to approach it, especially when it comes to atomic images. I
personally believe that whilst a distribution or "flavour" of linux may have a good reason to
bundle loads of software, it has specific disadvantages on Atomic images:
 * Larger Update Sizes; Whilst it doesn't sound too bad, consideration has to be taken into the
   fact OSTree, and BootC updates already take a heck of a long time. The bigger the image, the
   more centuries you will age waiting on OSTree to finish rebuilding and layering.
 * It makes software a pain to remove. This project actually started directly because I was a
   user of bazzite, however, it just had so much software that I would never use, like sunshine.
 * It slows boot by having many unnecessary services; It's already bad enough by being forced 
   to use GRUB (at least on my system, it's quite noticable compared to systemd-boot).

### How is this different?
The base idea is to provide the drivers and configuration for the user to not experience anything
that gets in the way. At the same time, they explicitly choose the software they want to install.

There are three main pillars by which decisions on what to add or retract is decided upon:
  1. Utility - To explain a little further, the question "Does this actually benefit anyone?" is
     to be asked... a lot. Things that are not core to the system can be ignored
  2. Privacy - Nothing should be added that could compromise the privacy of users. As a matter of
     fact, take steps to protect it.
  3. Performance - It must not hinder the performance of the system in any way. Unavoidable memory
     usage, like from KDE Plasma, can be ignored regarding this.

### Can anyone contribute?
Yes. Yes they can. Provided they don't use AI especially without checking the output and showing
tests.
