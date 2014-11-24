<?php

function yesNo($S_question) {
    echo $S_question . " [yes/no] : ";
    $handle = fopen("php://stdin", "r");
    $line = fgets($handle);
    if (trim($line) != 'yes') {
        echo "ABORTING !\n";

        return FALSE;
    }
    echo "\n";
    echo "Thank you, continuing...\n";

    return TRUE;
}

class WebStaDOckER {
    private $A_PATHS;
    private $A_CONFIG;
    private $O_Colors;

    public function __construct($A_PATHS, $A_CONFIG, $O_Colors) {
        $this->A_PATHS = $A_PATHS;
        $this->A_CONFIG = $A_CONFIG;
        $this->O_Colors = $O_Colors;
        self::asciiArt();
    }

    /**
     * Plusieurs remplacement dans le même fichier
     *
     * @param $FilePath
     * @param $A_remplacements
     */
    private function multiple_replace_in_file($FilePath, $A_remplacements) {
        foreach ($A_remplacements as $key => $value) {
            $this->replace_in_file($FilePath, $key, $value);
        }
    }

    /**
     * Replaces a string in a file
     *
     * @param string $FilePath
     * @param string $OldText text to be replaced
     * @param string $NewText new text
     *
     * @return array $Result status (success | error) & message (file exist, file permissions)
     */
    private function replace_in_file($FilePath, $OldText, $NewText) {
        $Result = array('status' => 'error', 'message' => '');
        if (file_exists($FilePath) === TRUE) {
            if (is_writeable($FilePath)) {
                try {
                    $FileContent = file_get_contents($FilePath);
                    $FileContent = str_replace($OldText, $NewText, $FileContent);
                    if (file_put_contents($FilePath, $FileContent) > 0) {
                        $Result["status"] = 'success';
                    } else {
                        $Result["message"] = 'Error while writing file';
                    }
                } catch (Exception $e) {
                    $Result["message"] = 'Error : ' . $e;
                }
            } else {
                $Result["message"] = 'File ' . $FilePath . ' is not writable !';
            }
        } else {
            $Result["message"] = 'File ' . $FilePath . ' does not exist !';
        }

        return $Result;
    }

    /**
     * Ecrire dans un nouveau fichier
     *
     * @param $S_dir
     * @param $S_filename
     * @param $S_content
     */
    private function write_file($S_dir, $S_filename, $S_content) {
        $S_file = $this->A_PATHS['docker'] . '/' . $S_dir . '/' . $S_filename;
        @mkdir($this->A_PATHS['docker'] . '/' . $S_dir, 0777, TRUE);
        @unlink($S_file);
        touch($S_file);
        $fp = fopen($S_file, 'w');
        fwrite($fp, $S_content);
        fclose($fp);
    }

    /**
     * Juste pour le fun
     */
    public function asciiArt() {
        echo $this->O_Colors->getColoredString(NULL, "yellow", NULL) . "\n";
        echo "##################################################################################\n";
        echo "#####                              WebStaDOckER                              #####\n";
        echo "##################################################################################\n";
        echo $this->O_Colors->getColoredString(NULL, "light_blue", NULL) . "\n";
        echo "

                                        ##        .
                                  ## ## ##       ==
                               ## ## ## ##      ===
                           /\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\___/ ===
                      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
                           \______ o          __/
                             \    \        __/
                              \____\______/

 __          __  _     _____ _        _____   ____       _    ______ _____
 \ \        / / | |   / ____| |      |  __ \ / __ \     | |  |  ____|  __ \
  \ \  /\  / /__| |__| (___ | |_ __ _| |  | | |  | | ___| | _| |__  | |__) |
   \ \/  \/ / _ \ \'_ \\___ \| __/ _` | |  | | |  | |/ __| |/ /  __| |  _  /
    \  /\  /  __/ |_) |___) | || (_| | |__| | |__| | (__|   <| |____| | \ \
     \/  \/ \___|_.__/_____/ \__\__,_|_____/ \____/ \___|_|\_\______|_|  \_\


";
        echo $this->O_Colors->getColoredString(NULL, "yellow", NULL) . "\n";
        echo "##################################################################################\n";
        echo $this->O_Colors->getColoredString(NULL, "light_blue", NULL);
    }

    /**
     * Permet de récupérer le projet avec Git
     */
    public function get_project() {
        system('apt-get -y -qq install git');
        $cd = 'cd ' . $this->A_PATHS['base'] . '/data/www && ';
        system($cd . 'git clone ' . $this->A_CONFIG['git']['clone']);
        system($cd . 'git config core.fileMode false');
        system($cd . 'git gc');
        system($cd . 'git fsck');
        // Droits
        system($cd . 'chown -R ' . $this->A_CONFIG['system']['user'] . ' *');
        system($cd . 'find ./ -type d -exec chmod 755 {} +');
        system($cd . 'find ./ -type f -exec chmod 644 {} +');
    }

    /**
     * Permet de récupérer simplement des images
     */
    public function pull_images() {
        system('docker pull crosbymichael/skydns');
        system('docker pull crosbymichael/skydock');
        system('docker pull maxexcloo/phppgadmin');
        system('docker pull jacksoncage/varnish');
    }

    /**
     * Installer les logiciels sur la machine hôte
     */
    public function install_hote() {
        // Todo : sudoers
        //Création des répertoires
        @mkdir($this->A_PATHS['base'] . '/backups', 0777, TRUE);
        @mkdir($this->A_PATHS['base'] . '/data/logs', 0777, TRUE);
        @mkdir($this->A_PATHS['base'] . '/data/certs', 0777, TRUE);
        @mkdir($this->A_PATHS['base'] . '/data/database', 0777, TRUE);
        @mkdir($this->A_PATHS['base'] . '/data/www/' . $this->A_CONFIG['project']['name'], 0777, TRUE);
        system('apt-get update && apt-get upgrade -y');
        if (yesNo('Rendre sudoers l\'utilisateur : ' . $this->A_CONFIG['system']['user'])) {
            system('apt-get install -y sudo');
            system('echo ' . $this->A_CONFIG['system']['user'] . ' \'         ALL=(ALL)       PASSWD: ALL\' >> /etc/sudoers;');
        }
        // Outils
        system('apt-get -y update && apt-get -y upgrade');
        system('/bin/bash ' . $this->A_PATHS['lib'] . '/install_docker.sh');
        system('/bin/bash ' . $this->A_PATHS['lib'] . '/install_software.sh ' . $this->A_CONFIG['project']['environment']);
    }

    /**
     * Permet de reconstruire toutes les images
     */
    public function build_all_images() {
        $this->pull_images();
        $this->build_phpfpm();
        $this->build_nginx();
        $this->build_postgres();
        $this->build_composer();
        $this->build_nodejs_bower_grunt();
        $this->build_piwik();
        system('docker images');
        $this->run_all_container();
    }

    /**
     * Permet de construire une image Postgres SQL
     */
    public function build_postgres() {
        system('docker rmi wsd_postgres');
        // Certificats
        $cd = 'cd ' . $this->A_PATHS['base'] . '/data/certs && ';
        system($cd . 'rm -f *');
        system($cd . 'openssl req -new -text -out server.req');
        system($cd . 'openssl rsa -in privkey.pem -out server.key');
        system($cd . 'rm -f privkey.pem');
        system($cd . 'openssl req -x509 -in server.req -text -key server.key -out server.crt');
        system($cd . 'chmod og-rwx server.key;');
        // Vhost
        if ($this->A_CONFIG['project']['environment'] == 'development') {
            system('echo "127.0.0.1   phppgadmin.' . $this->A_CONFIG['project']['domain'] . '" >> /etc/hosts');
        }
        // Postgres SQL
        system('docker build -t wsd_postgres ' . $this->A_PATHS['docker'] . '/postgres/.');
        system('rm -rf ' . $this->A_PATHS['base'] . '/data/database/*');
        $this->delete_container_by_image('wsd_postgres');
        system('docker run \
                --name webstack_postgres_1 \
                -it \
                -v ' . $this->A_PATHS['base'] . '/data/database:/var/lib/postgresql/data:rw \
                -v ' . $this->A_PATHS['base'] . '/data/certs:/wsd/certs:rw \
                --dns=172.17.42.1 \
                -d wsd_postgres');
        system('sleep 30 && docker exec \
                -it \
                webstack_postgres_1 \
                /bin/bash /wsd/build.sh "' . $this->A_CONFIG['postgres']['database']['name'] . '" "' . $this->A_CONFIG['postgres']['user'] . '" "' . $this->A_CONFIG['postgres']['password'] . '"');
        $this->run_postgres();
    }

    /**
     * Construction de l'image Piwik
     */
    public function build_piwik() {
        system('docker rmi wsd_piwik');
        system('docker build -t wsd_piwik ' . $this->A_PATHS['docker'] . '/piwik/.');
        system('docker run \
                --name webstack_piwik_1 \
                -it \
                -p 4578:80 \
                -d wsd_piwik');
        system('docker exec \
                -it \
                webstack_piwik_1 \
                /bin/bash /wsd/build.sh "' . $this->A_CONFIG['piwik']['database']['password'] . '" "' . $this->A_CONFIG['project']['domain'] . '"');
        $this->run_piwik();
    }

    /**
     * Construction de l'image Composer
     */
    public function build_composer() {
        $this->delete_exited_container();
        $this->delete_container_by_image('wsd_composer', 'latest');
        system('docker rmi wsd_composer');
        system('docker build -t wsd_composer ' . $this->A_PATHS['docker'] . '/composer/.');
        $this->run_composer();
    }

    /**
     * Construction de l'image PHP FPM
     */
    public function build_phpfpm() {
        system('docker rmi wsd_phpfpm');
        system('docker build -t wsd_phpfpm ' . $this->A_PATHS['docker'] . '/phpfpm/.');
        $this->run_phpfpm();
    }

    /**
     * Construction de l'image Memcached
     */
    public function build_memcached() {
        system('docker rmi wsd_memcached');
        system('docker build -t wsd_memcached ' . $this->A_PATHS['docker'] . '/memcached/.');
        $this->run_memcached();
    }

    /**
     * Permet de construire une image NodeJs avec Bower et Grunt
     */
    public function build_nodejs_bower_grunt() {
        system('docker rmi wsd_nodejs_bower_grunt');
        /*$this->write_file('nodejs_bower_grunt','package.json',json_encode(array(
            'name' => $this->A_CONFIG['project']['name'],
            'version' => '1.0.0',
            'description' => $this->A_CONFIG['project']['name'],
            'main' => 'Gruntfile.js',
            'scripts' => array(
                'test' => 'echo "Error: no test specified" && exit 1',
            ),
            'repository' => array(
                'type' => 'git',
                'url' => $this->A_CONFIG['git']['clone'],
            ),
            'author' => $this->A_CONFIG['identity']['name'],
            'license' => 'ISC',
            'devDependencies' => array(
                'grunt' => '^0.4.5',
                'grunt-contrib-concat' => '^0.5.0',
                'grunt-contrib-sass' => '^0.8.1',
                'grunt-contrib-uglify' => '^0.5.1',
                'grunt-contrib-watch' => '^0.6.1',
                'node-sass' => '~0.9.6',
            ),
        )));*/
        system('docker build -t wsd_nodejs_bower_grunt ' . $this->A_PATHS['docker'] . '/nodejs_bower_grunt/.');
        $this->run_nodejs_bower_grunt('install');
    }

    /**
     * Permet de construire l'image NGINX
     */
    public function build_nginx() {
        system('docker rmi wsd_nginx');
        // vhosts
        copy($this->A_PATHS['docker'] . '/nginx/require/sites-available/example', $this->A_PATHS['docker'] . '/nginx/require/sites-enabled/' . $this->A_CONFIG['project']['name']);
        $this->multiple_replace_in_file($this->A_PATHS['docker'] . '/nginx/require/sites-enabled/' . $this->A_CONFIG['project']['name'], array(
            'wsd_project_name'                => $this->A_CONFIG['project']['name'],
            'wsd_project_domain'              => $this->A_CONFIG['project']['domain'],
            'wsd_project_environment_domains' => $this->A_CONFIG['project']['environment_domains'],
            'wsd_project_environment'         => $this->A_CONFIG['project']['environment'],
        ));
        // htpasswd
        if (!is_null($this->A_CONFIG['project']['password'])) {
            $S_encrypted_password = crypt($this->A_CONFIG['project']['password'], base64_encode($this->A_CONFIG['project']['password']));
            $this->write_file('nginx/require/htpasswds/' . $this->A_CONFIG['project']['name'], 'htpasswd', 'wsd:' . $S_encrypted_password);
        }
        system('docker build -t wsd_nginx ' . $this->A_PATHS['docker'] . '/nginx/.');
        $this->run_nginx();
    }

    /**
     * Démarre toute l'infrastructure
     */
    public function run_all_container() {
        $this->run_skydns_skydock();
        $this->run_phpfpm();
        $this->run_nginx();
        $this->run_varnish();
        $this->run_memcached();
        $this->run_postgres();
        $this->run_phppgadmin();
        $this->run_composer();
        $this->run_nodejs_bower_grunt('update');
        $this->run_piwik();
        system('docker ps -a');
        system('dig @172.17.42.1 dev.local.docker');
        $this->resume();
    }

    /**
     * Lance Piwik
     */
    public function run_piwik() {
        system('sudo docker exec \
                -it \
                webstack_piwik_1 \
                /bin/bash /wsd/run.sh');
        system('docker logs webstack_piwik_1');
    }

    /**
     * Permet de récupérer les vendors
     */
    public function run_composer() {
        system('sudo docker run \
                    -v ' . $this->A_CONFIG['project']['directory'] . ':/app:rw \
                    wsd_composer install');
    }

    /**
     * Permet de lancer PHP FPM
     */
    public function run_phpfpm() {
        system('sudo docker run \
                --name webstack_php_1 \
                -p 9000:9000 \
                -v ' . $this->A_CONFIG['project']['directory'] . ':/var/www:rw \
                --dns=172.17.42.1 \
                -d wsd_phpfpm');
        system('docker logs webstack_php_1');
    }

    /**
     * Permet de lancer Memcached
     */
    public function run_memcached() {
        system('sudo docker run \
                --name webstack_memcached_1 \
                -p 11211:11211 \
                --dns=172.17.42.1 \
                -d wsd_memcached');
        system('docker logs webstack_memcached_1');
    }

    /**
     * Permet de démarrer un serveur DNS SkyDNS/SkyDOCK
     */
    public function run_skydns_skydock() {
        $this->delete_container_by_image('skydns');
        $this->delete_container_by_image('skydock');
        // SkyDNS
        system('docker run \
                -d \
                -p 172.17.42.1:53:53/udp \
                --name skydns \
                crosbymichael/skydns \
                -nameserver 8.8.8.8:53 \
                -domain local.docker');
        system('docker logs skydns');
        system('dig @172.17.42.1 dev.local.docker');
        // SkyDOCK
        system('docker run \
                -d \
                -v /var/run/docker.sock:/docker.sock \
                --name skydock \
                crosbymichael/skydock \
                -ttl 30 \
                -environment dev \
                -s /docker.sock \
                -domain local.docker \
                -name skydns');
        system('docker logs skydock');
        system('dig @172.17.42.1 dev.local.docker');
    }

    /**
     * Permet de lancer NodeJS avec Bower et Grunt
     *
     * @param $S_action
     */
    public function run_nodejs_bower_grunt($S_action = 'update') {
        system('docker run \
                -i \
                --rm \
                -e "environment=' . $this->A_CONFIG['project']['environment'] . '" \
                -e "action=' . $S_action . '" \
                -v ' . $this->A_CONFIG['project']['directory'] . ':/project:rw \
                wsd_nodejs_bower_grunt;');
    }

    /**
     * Permet de lancer Varnish
     */
    public function run_varnish() {
        $this->delete_container_by_image('varnish');
        system('docker run \
                --name webstack_varnish_1 \
                -v ' . $this->A_PATHS['docker'] . '/varnish/require/default.vcl:/etc/varnish/default.vcl:ro \
                -p 80:80 \
                --dns=172.17.42.1 \
                -d jacksoncage/varnish');
        system('docker logs webstack_varnish_1');
    }

    /**
     * Permet de lancer NGINX
     */
    public function run_nginx() {
        $this->delete_container_by_image('wsd_nginx');
        system('docker run \
                --name webstack_nginx_1 \
                -t \
                -i \
                -p 8080:80 \
                -v ' . $this->A_CONFIG['project']['directory'] . ':/var/www:rw \
                -v ' . $this->A_PATHS['docker'] . '/nginx/require/htpasswds:/etc/nginx/htpasswds:ro \
                -v ' . $this->A_PATHS['docker'] . '/nginx/require/sites-available:/etc/nginx/sites-available:ro \
                -v ' . $this->A_PATHS['docker'] . '/nginx/require/sites-enabled:/etc/nginx/sites-enabled:ro \
                -v ' . $this->A_PATHS['base'] . '/data/logs:/var/log/nginx:rw \
                --dns=172.17.42.1 \
                -d wsd_nginx;');
        system('docker logs webstack_nginx_1');
    }

    /**
     * Permet de lancer phpPgAdmin
     */
    public function run_phppgadmin() {
        system('docker run \
                --name webstack_phppgadmin_1 \
                -p 3321:80 \
                --link webstack_postgres_1:postgresql \
                -e "VIRTUAL_HOST=phppgadmin.' . $this->A_CONFIG['project']['domain'] . '" \
                --dns=172.17.42.1 \
                -d maxexcloo/phppgadmin');
    }

    /**
     * Permet de lancer Postgres
     */
    public function run_postgres() {
        system('docker run \
                --name webstack_postgres_1 \
                -it \
                -v ' . $this->A_PATHS['base'] . '/data/database:/var/lib/postgresql/data:rw \
                -v ' . $this->A_PATHS['base'] . '/data/certs:/wsd/certs:rw \
                --dns=172.17.42.1 \
                -d wsd_postgres');
        system('docker logs webstack_postgres_1');
    }

    /**
     * Stop tous les conteneurs
     *
     * @param bool $drop_all_images Si a TRUE : toutes les images seront supprimées
     */
    public function stop_all_containers($drop_all_images = FALSE) {
        system('docker stop $(sudo docker ps -a -q)');
        system('docker rm $(sudo docker ps -a -q)');
        if ($drop_all_images === TRUE) {
            system('docker rmi $(sudo docker images -q)');
        }
    }

    /**
     * Permet de supprimer les conteneurs fermé
     */
    public function delete_exited_container() {
        system('docker rm `docker ps --no-trunc -aq`');
    }

    /**
     * Permet de supprimer un container en fonction de l'image source
     *
     * @param $S_image
     * @param $S_tag
     */
    public function delete_container_by_image($S_image, $S_tag = 'latest') {
        echo 'Container(s) supprimé : ';
        system('docker rm  $(docker ps -a | awk \'/' . $S_image . ':' . $S_tag . '/{print $1}\')');
    }

    /**
     * Offre un résumé complet de la situation
     */
    public function resume() {
        echo "Utilisez ces HOSTNAMEs pour communiquer avec vos conteneurs :\n";
        echo "\n";
        echo "phpPgAdmin : webstack_phppgadmin_1.phppgadmin.dev.local.docker\n";
        echo "Postgres SQL : webstack_postgres_1.wsd_postgres.dev.local.docker\n";
        echo "Memcached : webstack_memcached_1.wsd_memcached.dev.local.docker\n";
        echo "Varnish : webstack_varnish_1.wsd_varnish.dev.local.docker\n";
        echo "PHP FPM : webstack_phpfpm_1.wsd_phpfpm.dev.local.docker\n";
        echo "NGINX : webstack_nginx_1.wsd_nginx.dev.local.docker\n";
        echo "NodeJS - Bower/Grunt : webstack_nodejs_bower_grunt_1.wsd_nodejs_bower_grunt.dev.local.docker\n";
        echo "\n\n";

        if($this->A_CONFIG['project']['environment'] != 'development') {
            echo "Veuillez ne pas oublier de configurer les DNS : \n";
            echo "phppgadmin.".$this->A_CONFIG['project']['domain'];
            echo "\n\n";
        }

        echo 'Vos URLs :';
        echo '';
        echo "phpPgAdmin : http://phppgadmin.".$this->A_CONFIG['project']['domain'].":3321/";
        echo "-user : ".$this->A_CONFIG['postgres']['user'];
        echo "-password : ".$this->A_CONFIG['postgres']['password'];
        echo '';
        echo "Piwik : http://piwik.".$this->A_CONFIG['project']['domain'].":4578/";
        echo "-user : admin";
        echo "-password : admin";
        echo "\n\n";

        system('docker images');
        system('docker ps -a');
        system('dig @172.17.42.1 dev.local.docker');
    }
}

// Paths
$A_PATHS['lib'] = __DIR__;
$A_PATHS['base'] = $A_PATHS['lib'] . '/..';
$A_PATHS['docker'] = $A_PATHS['base'] . '/dockerfiles';
// Require
require $A_PATHS['base'] . "/configuration.php";
require $A_PATHS['lib'] . "/Colors.php";
// Object
$O_WebStaDOckER = new WebStaDOckER($A_PATHS, $A_CONFIG, $O_Colors);
// Args spécifique
if (isset($argv[2]) AND isset($argv[1])) {
    $dynamicFunction = $argv[1] . '_' . $argv[2]; // Example : restart postgres
    $O_WebStaDOckER->{$dynamicFunction}();
} else {
    // Args générique
    if (isset($argv[1])) {
        switch ($argv[1]) {
            case 'install' :
                $O_WebStaDOckER->install_hote();
                // Rebuild :
                $O_WebStaDOckER->stop_all_containers(TRUE);
                $O_WebStaDOckER->build_all_images();
                break;
            case 'run':
            default:
                $O_WebStaDOckER->run_all_container();
                break;
            case 'restart':
                $O_WebStaDOckER->stop_all_containers();
                $O_WebStaDOckER->run_all_container();
                break;
            case 'stop':
                $O_WebStaDOckER->stop_all_containers();
                break;
            case 'rebuild':
                $O_WebStaDOckER->stop_all_containers(TRUE);
                $O_WebStaDOckER->build_all_images();
                break;
            case 'init':
                $O_WebStaDOckER->get_project(TRUE);
                break;
            case 'help':
                echo $O_Colors->getColoredString(NULL, "light_green", NULL) . "\n";
                echo "Exemple d'utilisation (simple) : \n";
                echo "\n";
                echo "    bash ./wsd.sh [install|run|restart|stop|rebuild|init|help] \n";
                echo "\n";
                echo "Exemple d'utilisation (avancé) : \n";
                echo "\n";
                echo "    bash ./wsd.sh build postgres \n";
                echo "    bash ./wsd.sh run postgres \n";
                echo "\n";
                echo "    bash ./wsd.sh build phpfpm \n";
                echo "    bash ./wsd.sh run phpfpm \n";
                echo "\n";
                echo "    ...et ce avec chaque conteneur !";
                echo "\n\n";
                echo $O_Colors->getColoredString(NULL, "light_blue", NULL);
                echo "aaa";
                break;
        }
    }
}