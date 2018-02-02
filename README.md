# TeamCity Azure Resource Manager Template

[![official project](http://jb.gg/badges/incubator.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

The template allows to deploy TeamCity [server](https://hub.docker.com/r/jetbrains/teamcity-server/) and [agent](https://hub.docker.com/r/jetbrains/teamcity-agent/) in Azure cloud. It creates MySQL database, virtual machine with CoreOS and starts TeamCity in docker container.

[![Deploy to Azure](https://azuredeploy.net/deploybutton.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJetBrains%2Fteamcity-azure-template%2Fmaster%2Fazuredeploy.json) 

Template provides following installation types:

| Installation Size | VM Size         | VM Data Disk | Database                    |
| ----------------- |---------------- | ------------ | --------------------------- |
| Small             | Standard_A2_v2  | 32 GB HDD    | Basic / 50 DTU / 50 GB      |
| Medium            | Standard_F2s_v2 | 64 GB SSD    | Basic / 100 DTU / 50 GB     |
| Large             | Standard_F4s_v2 | 128 GB SSD   | Standard / 100 DTU / 125 GB |

**Note**: Pricing for Azure [virtual machines](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/) and [MySQL database](https://azure.microsoft.com/en-us/pricing/details/mysql/).

## Configuration

After deployment you will be able to connect to the `teamcity` virtual machine via SSH. In CoreOS TeamCity works as a following systemd service:

* `teamcity-server.service` - launches TeamCity server.
* `teamcity-agent.service` - launches TeamCity agent. 
* `teamcity-update.service` - check for TeamCity version updates.

## Azure Plugins

The template installs the following Azure integration plugins in TeamCity:

* [Azure Cloud Agents](https://plugins.jetbrains.com/plugin/9260-azure-resource-manager-cloud-support) - allows to scale the pool of TeamCity build agents by leveraging Azure virtual machines.
* [Azure Artifacts Storage](https://plugins.jetbrains.com/plugin/9617-azure-artifact-storage) - allows to store build artifacts in Azure Cloud Storage Blobs.
* [Azure Active Directory](https://plugins.jetbrains.com/plugin/9083-azure-active-directory) - allows to use Azure AD authentication in TeamCity.

## Update TeamCity

While deployment `teamcity` virtual machine tagged with `teamcity-version` tag.
To update TeamCity to the different version update the tag value and restart TeamCity systemd services or virtual machine.

## Feedback

Please feel free to send a PR or file an issue in the [TeamCity issue tracker](https://youtrack.jetbrains.com/newIssue?project=TW&clearDraft=true&summary=TeamCity+ARM+template%3A&c=Assignee+Dmitry.Tretyakov&c=Subsystem+Distribution+packages).
