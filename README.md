WebStaDOckER - Webstack Docker
=========

Permet de dépoyer un environnement (dev, stage, test, prod), le tout en utilisant la technologie **Docker** pour isoler vos applications.

Technologies
-----------

Si vous voulez un serveur avec ces technologies :

* [postgresql] - PostgreSQL + PostGis ( avec dump de votre .pgsql )
* [memcache] - Memcache
* [nodejs] - NodeJS : Grunt + Bower
* [varnish] - Varnish

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
* [webmin] - Webmin (à venir)
* [phpdocumentor] - phpDocumentor (à venir)
* [goaccess] - GoAccess (à venir)
* [munin] - munin (à venir)
* [readthedoc] - readthedoc (à venir)

Requis
=========

  - Processeur : Architectures 64 bits
  - Debian : Wheezy(7) avec kernel 3.16 ou Jessie(8)

Installation
--------------

```sh
git clone https://github.com/EvKoh/WebStaDOckER.git ~/mon_projet && bash ~/mon_projet/wsd.sh install
```

Lancer
--------------
```sh
wsd run
```

Relancer
--------------
```sh
wsd restart
```

Entrer dans un conteneur
--------------
```sh
wsd go webstack_postgres_1
```

Bonus
-----------

**Parceque vous êtes cool (et surtout des sacrés feignasses) !**

Si vous êtes en environnement de développement, le script vous proposera d'installer sur la machine hôte :

* [java] - java
* [phpstorm] - phpStorm
* [smartgit] - smartGit
* [pgadmin] - PG Admin 3

Quel que soit l'environnement, le script vous proposera d'installer sur la machine hôte :

* [neovim] - NeoVIM ( avec quelques plugins pratiques )
* [glances] - Glances

Version
----

**1.3**

A venir
-----------

* Backup automatique / Suppression des backups trop vieux
* Sécurisation de base : SSH, firewall iptables, fail2ban...
* Etudier Panamax, cela peut être une option intéressante
* Finir le container Piwik
* Mettre en place le container Sugar CRM
* Mettre en place le conainer ZendServer, moins urgent
* Finir de mettre en place les plugins de NeoVIM et un scheme plus simpa
* Tests avec Kali Linux

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
[webmin]:http://www.webmin.com/
[phpdocumentor]:http://www.phpdoc.org/
[goaccess]:http://goaccess.io/
[munin]:http://munin-monitoring.org/
[readthedoc]:https://readthedocs.org/
