# RocketCyber API PowerShell Wrapper

This PowerShell module acts as a wrapper for the [RocketCyber](https://www.rocketcyber.com/) API.

* :warning: **As of 2023-03, This module has only been tested using PowerShell 5.1. Compatibility with PowerShell 7 will come later.
* :warning: **RocketCyber has deprecated its v2 API and this module as of 2.0.0 has been migrated to its v3 API

---

## Introduction

The RocketCyber's API offers users the ability to extract data from RocketCyber into third-party reporting tools.

* Full documentation for RocketCyber's RESTful API can be found [here](https://api-doc.rocketcyber.com).

This module serves to abstract away the details of interacting with RocketCyber's API endpoints in such a way that is consistent with PowerShell nomenclature. This gives system administrators and PowerShell developers a convenient and familiar way of using RocketCyber's API to create documentation scripts, automation, and integrations.

### Function Naming

RocketCyber features a REST API that makes use of common HTTPs GET actions. In order to maintain PowerShell best practices, only approved verbs are used.

* GET -> Get-

Additionally, PowerShell's `verb-noun` nomenclature is respected. Each noun is prefixed with `RocketCyber` in an attempt to prevent naming problems.

For example, one might access the `/account` API endpoint by running the following PowerShell command with the appropriate parameters:

```posh
Get-RocketCyberAccount -id 12345
```

---

## Install & Import

This module can be installed directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/RocketCyberAPI) with the following command:

* :information_source: This module supports PowerShell 5.0+ and should work in PowerShell Core.

```posh
Install-Module -Name RocketCyberAPI
```

If you are running an older version of PowerShell, or if PowerShellGet is unavailable, you can manually download the *Master* branch and place the *RocketCyberAPI* folder into the (default) `C:\Program Files\WindowsPowerShell\Modules` folder.

After installation (by either methods), load the module into your workspace:

```posh
Import-Module RocketCyberAPI
```

---

## Initial Setup

After importing this module, you will need to configure both the *base URI* & *API access token* that are used to talk with the RocketCyber API.

1. Run `Add-RocketCyberBaseURI`
   * By default, RocketCyber's `https://api-us.rocketcyber.com/v3/account` uri is used.
   * If you have your own API gateway or proxy, you may put in your own custom uri by specifying the `-base_uri` parameter:
     * `Add-RocketCyberBaseURI -base_uri http://myapi.gateway.example.com`

2. Run `Add-RocketCyberAPIKey`
   * It will prompt you to enter in your API access token
   * RocketCyber API access tokens are generated by going to *RocketCyber > Provider Settings > RocketCyber API*

[optional]

1. Run `Export-RocketCyberModuleSettings`

   * This will create a config file at `%UserProfile%\RocketCyberAPI` that securely holds the *base uri* & *API access token* information.
   * Next time you run `Import-Module -Name RocketCyberAPI`, this configuration file will automatically be loaded.
      * :warning: Exporting module settings encrypts your API access token in a format that can **only be unencrypted with your Windows account**. It makes use of PowerShell's `Windows Data Protection API (DPAPI)` type, which uses reversible encrypted tied to your user principal. This means that you cannot copy your configuration file to another computer or user account and expect it to work.
      * :warning: Exporting and importing module settings requires use of the `ConvertTo-SecureString` cmdlet, which I have not tested in PowerShell core.

---

## Usage

Calling an API resource is as simple as running `Get-RocketCyber<resourceName>`

* The following is a table of supported functions and their corresponding API resources:
* Table entries with [ `-` ] indicate that the functionality is NOT supported by the RocketCyber API at this time.

| API Resource       | Create    | Read                             | Update    | Delete    |
| -----------------  | --------- | -------------------------------- | --------- | --------- |
| Account            | -         | `Get-RocketCyberAccount`         | -         | -         |
| Agents             | -         | `Get-RocketCyberAgents`          | -         | -         |
| Apps               | -         | `Get-RocketCyberApps`            | -         | -         |
| Defender           | -         | `Get-RocketCyberDefender`        | -         | -         |
| Events             | -         | `Get-RocketCyberEvents`          | -         | -         |
| Firewalls          | -         | `Get-RocketCyberFirewalls`       | -         | -         |
| Incidents          | -         | `Get-RocketCyberIncidents`       | -         | -         |
| Office             | -         | `Get-RocketCyberOffice`          | -         | -         |

Each `Get-RocketCyber*` function will respond with the raw data that RocketCyber's API provides. Returned data is not structured the same and varies between commands

---

## Help & Usage :blue_book

To view documentation for the module as well as any commands you can browse the online Github pages

* [RocketCyber-PowerShellWrapper](https://celerium.github.io/RocketCyber-PowerShellWrapper)

As a quick summary though you can reference the following notes:

* Each `Get-RocketCyber*` function will respond with the raw data that RocketCyber's API provides.
* A full list of functions can be retrieved by running `Get-Command -Module RocketCyberAPI`.
* Help info and a list of parameters can be found by running `Get-Help <command name>`, such as:

```posh
Get-Help Get-RocketCyberAccount
Get-Help Get-RocketCyberAccount -Full
```

---

## Primary ToDo List :dart

* [x] Documentation automation
  * [ ] Updatable help
* [ ] Build a better API parameter to more securely handle API keys
* [ ] Add compatibility with PowerShell Core

## Secondary ToDo List :dart

* [ ] Example scripts & reports
* [ ] Build more robust Pester & ScriptAnalyzer tests
* [ ] Figure out how to do CI & PowerShell gallery automation