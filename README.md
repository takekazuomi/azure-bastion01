# deploy flatcar vm and bastion

## deploy

```sh
export RESOURCE_GROUP=your-rg deploy
cd deploy
make create-rg deploy
```

### note

This template includes some useful features for flatcat VM.

1. Opened ssh NSG port from only deployed address.
2. Generate a new ssh key for deployed VM. see: ./.secure/vm-keys and .pub.
3. VM login account set up in config.yml. If you use this template that should be changed.
4. You can deploy this template from VS Code dev containers terminal.

```sh
az network bastion ssh --name MyBastionHost --resource-group MyResourceGroup --target-
        resource-id vmResourceId --auth-type ssh-key --username xyz --ssh-key C:/filepath/sshkey.pem
```


```sh
az network bastion ssh --name flatcar-bastion --resource-group omivm01-rg \
--target-resource-id /subscriptions/eb366cce-61a4-447f-b5d0-cf4a7a262b37/resourceGroups/omivm01-rg/providers/Microsoft.Compute/virtualMachines/flatcar \
--auth-type ssh-key --username core --ssh-key ./.secure/vm-keys
```

## License

Copyright (c) Takekazu Omi. All rights reserved.
Licensed under the MIT License. See [LICENSE](https://github.com/Microsoft/vscode-dev-containers/blob/master/LICENSE).
