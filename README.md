# g-hel
A being who presides over a realm of the same name

According to Snorri "her dish is Hunger, her knife is Famine, her slave is
Lazy, and Slothful is her woman servant." Her bed is named Sick Bed, and
her bed curtains Gleaming Disaster.

And she watches your git commits.

## Summary

What this really is, is a pre-receive hook environment for managing git
commits being pushed to your GHE instance. For more information on this
feature, please read about [pre receive hooks](https://developer.github.com/v3/enterprise/pre_receive_hooks/)

This particular pre-receive hook environment is designed to do the
following checks/activities as efficiently as possible.

- Protect direct pushes to protected branches

- Presents you with a fortune for each successful push (fun stuff )

- Lints the commit author to avoid misconfigured git clients (TODO)

## Requirements

   GitHub Enterprise >2.12

   Docker >17.03

## Configuration

   TBD


## Usage

   TBD


## Licensing

This project is licensed under the MIT license. Please see the `LICENSE`
file for more details.