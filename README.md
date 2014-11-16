WebStaDOckER - Webstack Docker
=========

Permet de dépoyer un environnement (dev, stage, test, prod), le tout en utilisant la technologie **Docker** pour isoler vos applications.

Technologies
-----------

Si vous voulez un serveur avec ces technologies :

* [postgresql] - PostgreSQL + PostGis ( avec dump de votre .pgsql )
* [memcache] - Memcache (à venir)
* [nodejs] - NodeJS : Grunt + Bower
* [varnish] - Varnish (à venir)

**En environnement : production**

* [nginx] - NGINX FastCgi/PHP-FPM 5.5

**En environnement : development et staging**

* [zendserverdevelopperedition] - ZendServer7 Developper Edition (NGINX php 5.5) (à venir)

En Option
-----------

* [piwik] - Piwik (à venir)
* [sugarcrm] - SugarCRM (à venir)
* [zimbra] - Zimbra (à venir)

Options futures
-----------

* [redmine] - Redmine (à venir)
* [gitlab] - Gitlab (à venir)

Requis
=========

  - Debian : Wheezy(7) ou Jessie(8)

Version
----

1.2

Récupération
--------------

```sh
mkdir -p ~/mon_projet && cd ~/mon_projet && git clone https://github.com/WilliamWolface/WebStaDOckER.git
```

Installation
--------------

Lisez le [wiki](https://github.com/WilliamWolface/WebStaDOckER/blob/master/library/wiki.md) !

* Copiez le fichier config.sh.dist en config.sh
* Configurez ce nouveau fichier selon vos besoins
* Lancez la commande suivante :

```sh
bash ~/mon_projet/WebStaDOckER/wsd.sh install
```

* ...et laissez-vous guider ;)

(Re)Lancer
--------------

```sh
bash ~/mon_projet/WebStaDOckER/wsd.sh restart
```

Bonus
-----------

**Parceque vous êtes cool (et surtout des sacrés feignasses) !**

Si vous êtes en environnement de développement, le script vous proposera d'installer sur la machine hôte :

* [java] - java
* [phpstorm] - phpStorm (à venir)
* [smartgit] - smartGit (à venir)
* [pgadmin] - PG Admin 3
* [neovim] - NeoVIM ( avec quelques plugins pratiques )
* [glances] - Glances

[nginx]:http://nginx.org/
[zendserverdevelopperedition]:http://www.zend.com/en/products/server/editions-development
[java]:https://www.java.com/fr/
[phpstorm]:https://www.jetbrains.com/phpstorm/
[smartgit]:http://www.syntevo.com/smartgit/
[varnish]:https://www.varnish-cache.org/
[postgresql]:http://www.postgresql.org/
[memcache]:http://memcached.org/
[nodejs]:http://nodejs.org/
[piwik]:http://piwik.org/
[sugarcrm]:http://www.sugarcrm.com/
[zimbra]:http://www.zimbra.com/
[redmine]:http://www.redmine.org/
[gitlab]:https://about.gitlab.com/
[pgadmin]:http://www.pgadmin.org/
[neovim]:http://neovim.org/
[glances]:https://github.com/nicolargo/glances
