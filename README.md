# TeamCity Azure Resource Manager Template

[![official project](http://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

The template allows deploying aTeamCity [server](https://hub.docker.com/r/jetbrains/teamcity-server/) and [agent](https://hub.docker.com/r/jetbrains/teamcity-agent/) in Azure cloud. It creates a MySQL database, a virtual machine with CoreOS and starts TeamCity in a docker container.

During deployment will be created TeamCity server deployment with [auto-retrieval of SSL certificates](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) from the [Let's Encrypt](https://letsencrypt.org/) and [nginx reverse proxy](https://github.com/jwilder/nginx-proxy).

[![Deploy to Azure](https://azuredeploy.net/deploybutton.svg)](https://goo.gl/nXap7u)

**Note**: You need to deploy it into a dedicated resource group. Deployment will take around 10 minutes, use `teamcityUrl` template output value to access the TeamCity web UI.

## Parameters

#### TeamCity Version

Allows specifying the required version of TeamCity for deployment.

#### Installation Size

List of pre-configured installation types:

| Installation Size | Typical Usage             | VM Size        | VM Data Disk | Database                    |
| ----------------- | ------------------------- | -------------- | ------------ | --------------------------- |
| Small             | 3 users, 100 builds/day   | Standard_A2_v2 | 32 GB HDD    | Basic / 50 DTU / 50 GB      |
| Medium            | 5 users, 300 builds/day   | Standard_F2s   | 64 GB SSD    | Basic / 100 DTU / 50 GB     |
| Large             | 20 users, 1000 builds/day | Standard_F4s   | 128 GB SSD   | Standard / 100 DTU / 125 GB |

**Note**: Pricing for Azure [virtual machines](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/) and [MySQL database](https://azure.microsoft.com/en-us/pricing/details/mysql/).

#### VM Admin Username

Allows specifying username to login to a virtual machine where TeamCity is running.

#### SSH Key Data

Allows specifying a [publish ssh key](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed) for the user used to connect to virtial machine with TeamCity.

#### Database Password

Allows specifying password for the MySQL database.

## Configuration

After deployment you will be able to connect to the `teamcity` virtual machine via SSH. In CoreOS TeamCity works as the following systemd service:

* `teamcity-server.service` - launches TeamCity server.
* `teamcity-agent.service` - launches TeamCity agent. 
* `teamcity-update.service` - check for TeamCity version updates.
* `nginx.service` - provides reverse proxy for TeamCity server.
* `letsencrypt.service` - executes auto SSL certificate retrieval for domain name.

To diagnose problems you could use the following commands:

* `sudo systemctl (start|stop|status|restart) <serviceName>` - to manage service operation state.
* `sudo journalctl -u <serviceName>` - to view history of service log.
* `sudo journalctl -f -u <serviceName>` - to execute tail view of service log.

### Installed Plugins

The template installs the following Azure integrations in TeamCity:

* [Azure Cloud Agents](https://plugins.jetbrains.com/plugin/9260-azure-resource-manager-cloud-support) - allows to scale the pool of TeamCity build agents by leveraging Azure virtual machines.
* [Azure Artifacts Storage](https://plugins.jetbrains.com/plugin/9617-azure-artifact-storage) - allows to store build artifacts in Azure Cloud Storage Blobs.
* [Azure Active Directory](https://plugins.jetbrains.com/plugin/9083-azure-active-directory) - allows to use Azure AD authentication in TeamCity.

## TeamCity Update

During deployment, a `teamcity` virtual machine will be tagged with the `teamcity-version` tag. To change the TeamCity version, you need to update the tag value and restart the `teamcity-server.service` and `teamcity-agent.service` systemd services or the virtual machine.

## Feedback

Please feel free to send a PR or file an issue in the [TeamCity issue tracker](https://youtrack.jetbrains.com/newIssue?project=TW&clearDraft=true&summary=TeamCity+ARM+template%3A&c=Assignee+Dmitry.Tretyakov&c=Subsystem+Distribution+packages).
