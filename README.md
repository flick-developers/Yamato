> [!CAUTION]
> ### Do Not Use This Image
> Yamato is far from ready, and as of 17/08/26, does not create an image yet. This is because we 
> are writing our toolchain to be able to build the project how we want with less headaches over
> time.

# Yamato
This is the monorepo for the Yamato project. (Called that because it quite literally translates 
into "Great Harmony")

## Directory Structure
- `/TOOLING` - Custom tooling and packages that get built as  an OCI image.
- `/DOCS` - Details on how to setup and use the tooling, as well as forking this repository.
- `/BUILD` - Build scripts and configuration for the operating system.
- `/BRANDING` - The customised branding for this project.

## Technical Details
Yamato will be formed of several parts, namely a custom Debian BootC image, alongside the processes
required to build dependencies such as MESA, Sched_ext, and nvidia-open. Debian is being chosen due
to it's long standing reputation for being reliable.
