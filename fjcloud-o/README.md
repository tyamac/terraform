# はじめに

Terraformを使ってFUJITSU Hybrid IT Service FJcloud-O上にネットワークを作成するためのテンプレートです。

# 環境と準備

### 環境

環境はTerraform v1.13.4、providerはopenstackのv1.32.0を使用しています。

```
❯ terraform version
Terraform v0.13.4
+ provider registry.terraform.io/terraform-provider-openstack/openstack v1.32.0
```


## 準備

1. `.git clone`したらfjcloud-oに移動し`terraform init`を実行します。

2. 次に`terraform.tfvars.sample`をコピーして`terraform.tfvars`を作成し、認証情報を追記します。

## 中身の説明

treeするとこんな感じ（不要なファイルは除外しています）。
```
.
├── main.tf
├── modules
│   ├── firewall
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   ├── floatingip
│   │   ├── main.tf
│   │   └── versions.tf
│   └── secgroups
│       ├── main.tf
│       └── versions.tf
├── terraform.tfvars
├── terraform.tfvars.sample
├── variables.tf
└── versions.tf
```


