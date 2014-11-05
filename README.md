WebStaDOckER - Webstack Docker
=========

Permet de dépoyer un environnement (dev, stage, test, prod), le tout en utilisant la technologie **Docker** pour isoler vos applications.

Technologies
-----------

Si vous voulez un serveur avec ces technologies :

* [postgresql] - PostgreSQL + PostGis
* [memcache] - Memcache
* [nodejs] - NodeJS : Grunt + Bower
* [varnish] - Varnish

**En environnement : production**

* [nginx] - NGINX FastCgi/PHP-FPM 5.5

**En environnement : development et staging**

* [zendserverdevelopperedition] - ZendServer7 Developper Edition (NGINX php 5.5)

En Option
-----------

* [piwik] - Piwik
* [sugarcrm] - SugarCRM
* [zimbra] - Zimbra

Options futures
-----------

* [redmine] - Redmine
* [gitlab] - Gitlab

Requis
=========

  - Debian : Wheezy(7) ou Jessie(8)

Version
----

1.0

Installation
--------------

```sh
mkdir -p ~/mon_projet && cd ~/mon_projet
git clone https://github.com/WilliamWolface/WebStaDOckER.git
```

* Copiez le fichier config.sh.dist en config.sh
* Configurez ce nouveau fichier selon vos besoins
* Lancez la commande suivante :

```sh
bash ~/mon_projet/WebStaDOckER/install.sh
```

* ...et laissez-vous guider ;)

Bonus
-----------

**Parceque vous êtes cool (et surtout des sacrés feignasses) !**

Si vous êtes en environnement de développement, le script vous proposera d'installer sur la machine hôte :

* [java] - java
* [phpstorm] - phpStorm
* [smartgit] - smartGit
* [pgadmin] - PG Admin 3

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
