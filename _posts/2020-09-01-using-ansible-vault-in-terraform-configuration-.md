---
layout: post
title: Using ansible-vault in Terraform configuration

date: 2020-09-01
published: true
categories: infrastructure
tags: ansible terraform
---

I've started working with Terraform not so long ago and eventually reached a point where I needed to use a value that I could not simply commit to the repository. My mind immediately went back to my experience with [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html) which I used before for server provisioning. If you're not familiar with it, Vault a tool shipped with [Ansible](https://www.ansible.com/) that can encrypt files and strings to later decrypt them on-the-fly to use them in Ansible playbooks. It also has a stand-alone cli command that can can be used as a [data source](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/data_source) with Terraform's [*External provider*](https://github.com/hashicorp/terraform-provider-external).

## Implementation

Now before we start anything we will need to prepare our encrypted "vault" file, which be storing our secret variables. To that end we need to point Ansible to the encryption key file either by:

* passing its path as a option `--vault-password-file <path>` 
* or setting it as the value of an environment variable called `ANSIBLE_VAULT_PASSWORD_FILE`
 
There are [other methods](https://docs.ansible.com/ansible/latest/user_guide/vault.html#providing-vault-passwords) to achieve the same goal, but the password file was the most convinient to use locally and easiest to configure on my continuous integration tool. Just be mindful that this method requires you to be in charge of that file's lifecycle (so don't not leave it around for anyone to peek into).

In my case I export the `ANSIBLE_VAULT_PASSWORD_FILE` variable in my shell to let Ansible know where to look for the key file (which itself is a plain text file with only the password in it) and then I'm able to run all the vault commands without having to explicitly pass the path to them every time.

Having that out of the way, let's prepare our example `vault.json` file:

```json
{
	"secret_value": "highly-classified value"
}
```

*External Provider* expects JSON output which is why I've used a JSON file to store my secrets. You could store yours in i.e. YAML (which might be easier to work with, depending on what values you'll use), but you'll eventually have to translate it to JSON for the provider to be able to use it.

encrypt it:

```bash
$ ansible-vault encrypt vault.json
```

edit it (just to see that we can):

```bash
$ ansible-vault edit vault.json
```

or decrypt it:

```bash
$ ansible-vault decrypt vault.json
```

Now to the Terraform configuration. First, since I'm using the [0.13 version](https://github.com/hashicorp/terraform/releases/tag/v0.13.0), I'll add the provider version definition:

```tf
terraform {
  required_providers {
    // ...
    external = {
      source  = "hashicorp/external"
      version = "~> 1.2"
    }
  }
  required_version = ">= 0.13"
}
```

Per usual, you then need to initialize that (`terraform init`) to start using it.

Next, data source configuration:

```tf
data "external" "vault" {
  program = [
    "./bin/ansible-vault-proxy.sh",
    "vault.json"
  ]
}
```

Here the program array contains the executable path and the arguments for it. In this case I passed the vault path as an argument to my helper script that will call `ansible-vault` to decrypt our file to stdout (not necessary, but I make the data source declaration look a bit simpler):

```bash
#!/usr/bin/env bash

set -e

vault_file_path=$1
if [ -z $vault_file_path ]; then
    echo You need to provide vault file path as the first argument. None received.
    exit 2
fi

ansible-vault decrypt --output - $vault_file_path
```

the key part there is `--output -`, where that `-` value [means stdout](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html#cmdoption-ansible-vault-decrypt-output). 

Having that in place, I can reference those "secrets" like any other variable in Terraform, e.g.:

```tf
output "debug" {
    super_secret = data.external.vault.result.secret_value
}
```

That `.result` bit might give you an idea that there's more to that data source value than just the parsed output. Other things you'll find there are used query parameters which is a feature of the *External Provider* that allows you to parametrize the output from that data source. I had no need for that here though. It's a bit peculiar solution as it sends JSON to your provider script, in this example it'd be that proxy bash script. If I actually needed it, I'd probably write that script in a language with native support for JSON, like Python, rather than depend on another tool (the very-useful [`jq`](https://github.com/stedolan/jq)) as suggested in provider's documentation. 

## What about the terraform state?

In theory, because your secrets becomes regular variables, they will be included in plaintext in Terraform state. Depending on the backend you're using for storing that, this can obviously be problematic as the whole point of this exercise was not to store those values in plaintext. However that's why Terraform allows to encrypt state files, which I'd highly recommend to use anyway. 

## Alternative solutions

For the sake of completeness, here are some alternatives to consider before adding Ansible Vault to your Terraform configuration.  

If all this seems a little bit too elaborate, then you might want to look into passing your secrets via environment variables (`TF_*`). For example, if you'd want to apply your plans in a some sort of continuous integration environment capable of safely storing (encrypted) and handling (as-in not outputting all the values in plaintext) environment variables then using that might make more sense. 

Then, on the other side of the spectrum, you can use a dedicated solution specifically designed for this purpose. For example Hashicorp's own [Vault](https://www.vaultproject.io/).

## Conclusion

It's not exactly a smooth and intuitive solution, but it works and it fulfilled the needs of the project I was working on. The added bonus of it is that I also used it for server provisioning, so I could potentially massage this solution to be able to share a single secret vault between Terraform and Ansible. However if I'd need something more robust, then I'd definitely look into a dedicated solution for secrets management rather than duct-taping those two together. 