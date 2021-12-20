#1
git show -s aefea

commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>                                                                                                                                                                                  Date:   Thu Jun 18 10:29:58 2020 -0400
Update CHANGELOG.md
--------------------------------------------------------------

#2
git show -s 85024d3

tag: v0.12.23
--------------------------------------------------------------

#3
git show --pretty=format:"%P" b8d720

56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b
--------------------------------------------------------------

#4
git log  v0.12.23..v0.12.24 --oneline

b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
--------------------------------------------------------------
#5

git grep "func providerSource("

provider_source.go:func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {


git log -L:providerSource:provider_source.go

commit 8c928e83589d90a031f811fae52a81be7153e82f
+func providerSource(services *disco.Disco) getproviders.Source {

--------------------------------------------------------------
#6

git grep "globalPluginDirs("

commands.go:            GlobalPluginDirs: globalPluginDirs(),
commands.go:    helperPlugins := pluginDiscovery.FindPlugins("credentials", globalPluginDirs())
plugins.go:func globalPluginDirs() []string {


git log -q --oneline -L:globalPluginDirs:plugins.go

78b122055 Remove config.go and update things using its aliases
52dbf9483 keep .terraform.d/plugins for discovery
41ab0aef7 Add missing OS_ARCH dir to global plugin paths
66ebff90c move some more plugin search path logic to command
8364383c3 Push plugin discovery down into command package

--------------------------------------------------------------
#7

Функция synchronizedWriters в проекте из репозитория https://github.com/hashicorp/terraform - отсутствует
Нашел функцию synchronizedWriter в файле synchronized_writers.go одноименного проекта в репозитоиии https://github.com/koding/terraform
