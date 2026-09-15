## Inver
A slightly hardened and performant linux image built on top of bazzite including Kernel Level Memory Address Randomization, network configuration changes to always attempt DoT.

> [!caution]
> A new direction has been deciding for this image. In a bid for higher independence from upstream projects, this will be moving to a bootc base, meaning that everything
> will mostly be done from scratch. As such, it is highly recommended not to update this image with bootc for now as the new version may lack greenboot for a short period of time.
> 
> If you encounter any issues, please report them on the [GitHub repository](https://github.com/why_context/inver).

### Credits
* Bazzite
  > Providing the base image and repository this was build on.
* bearyjd/bazzite-tower
  > Code there was used to fix iso build issues from the original Bazzite Template.
