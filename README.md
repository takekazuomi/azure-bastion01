# deploy flatcar vm and bastion

## deploy

```sh
export RESOURCE_GROUP=your-rg deploy
cd deploy
make create-rg deploy
```

## ssh login

```sh
$ make ssh
az network bastion ssh --name bastion --resource-group your-rg \
--target-resource-id /subscriptions/eb366cce-xxxx-xxxx-b5d0-cf4a7a262b37/resourceGroups/your-rg/providers/Microsoft.Compute/virtualMachines/flatcar \
--auth-type ssh-key --username core --ssh-key ./.secure/vm-keys
```

### note

This template includes some useful features for flatcat VM.

1. Opened ssh NSG port from only deployed address.
2. Generate a new ssh key for deployed VM. see: ./.secure/vm-keys and .pub.
3. VM login account set up in config.yml. If you use this template that can be changed.
4. You can deploy this template from VS Code dev containers terminal.


## License

Copyright (c) Takekazu Omi. All rights reserved.
Licensed under the MIT License. See [LICENSE](https://github.com/Microsoft/vscode-dev-containers/blob/master/LICENSE).
