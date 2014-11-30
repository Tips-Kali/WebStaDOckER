<?php

/**
 * Yes / No Question
 *
 * @param $S_question
 *
 * @return bool
 */
function yesNo($S_question) {
    echo $S_question . " [yes/no], [y/n], [oui/non] ou [o/n]: ";
    $handle = fopen("php://stdin", "r");
    $line = strtolower(trim(fgets($handle)));
    if ($line != 'yes' AND $line != 'y' AND $line != 'oui' AND $line != 'o') {
        echo "Ok, next !\n";

        return FALSE;
    }
    echo "\n";
    echo "Thank you, continuing...\n";

    return TRUE;
}

/**
 * Class WebStaDOckER
 */
class WebStaDOckER {
    private $A_PATHS;
    private $A_CONFIG;
    private $O_Colors;

    /**
     * Constructeur
     *
     * @param $A_PATHS
     * @param $A_CONFIG
     * @param $O_Colors
     */
    public function __construct($A_PATHS, $A_CONFIG, $O_Colors) {
        $this->clear();
        $this->A_PATHS = $A_PATHS;
        $this->A_CONFIG = $A_CONFIG;
        $this->O_Colors = $O_Colors;
        self::asciiArt();
        system('echo "alias wsd=\'bash '.$this->A_PATHS['base'].'/wsd.sh\'" >> /etc/profile');
        system('/bin/bash -c "source /etc/profile";');
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
     *
     * @param bool $B_new
     */
    public function get_project($B_new = FALSE) {
        system('apt-get -y -qq install git');
        $cd = 'cd ' . $this->A_PATHS['base'] . '/data/www && ';
        if ($B_new === TRUE) {
            system('rm -rf ' . $this->A_PATHS['base'] . '/data/www/' . $this->A_CONFIG['git']['project']);
            system($cd . 'git clone ' . $this->A_CONFIG['git']['clone']);
        } else {
            system($cd . 'git pull');
        }
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
        system('docker pull jacksoncage/varnish');
    }

    /**
     * Installer les logiciels sur la machine hôte
     */
    public function install_hote() {
        //Création des répertoires
        @mkdir($this->A_PATHS['base'] . '/backups', 0777, TRUE);
        @mkdir($this->A_PATHS['base'] . '/data/logs', 0777, TRUE);
        @mkdir($this->A_PATHS['base'] . '/data/certs', 0777, TRUE);
        @mkdir($this->A_PATHS['base'] . '/data/database', 0777, TRUE);
        @mkdir($this->A_PATHS['base'] . '/data/www/' . $this->A_CONFIG['project']['name'], 0777, TRUE);
        system('apt-get update && apt-get upgrade -y');
        if (yesNo('Rendre sudoers l\'utilisateur : ' . $this->A_CONFIG['system']['user'])) {
            system('apt-get install -y sudo');
            // Todo : sudoers
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
        $this->build_memcached();
        $this->build_phpfpm();
        $this->build_nginx();
        $this->build_postgres();
        $this->build_phppgadmin();
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
        $this->delete_image('wsd_postgres');
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
        echo 'Démarrage de Postgres, veuillez patienter...';
        system('sleep 60 && docker exec \
                -it \
                webstack_postgres_1 \
                /bin/bash /wsd/build.sh "' . $this->A_CONFIG['postgres']['database']['name'] . '" "' . $this->A_CONFIG['postgres']['user'] . '" "' . $this->A_CONFIG['postgres']['password'] . '"');
    }

    /**
     * Construction de l'image Piwik
     */
    public function build_piwik() {
        $this->delete_image('wsd_piwik');
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
    }

    /**
     * Construction de l'image Composer
     */
    public function build_composer() {
        $this->delete_image('wsd_composer');
        system('docker build -t wsd_composer ' . $this->A_PATHS['docker'] . '/composer/.');
    }

    /**
     * Construction de l'image Composer
     */
    public function build_phppgadmin() {
        $this->delete_image('wsd_phppgadmin');
        system('docker build -t wsd_phppgadmin ' . $this->A_PATHS['docker'] . '/phppgadmin/.');
    }

    /**
     * Construction de l'image PHP FPM
     */
    public function build_phpfpm() {
        $this->delete_image('wsd_phpfpm');
        system('docker build -t wsd_phpfpm ' . $this->A_PATHS['docker'] . '/phpfpm/.');
    }

    /**
     * Construction de l'image Memcached
     */
    public function build_memcached() {
        $this->delete_image('wsd_memcached');
        system('docker build -t wsd_memcached ' . $this->A_PATHS['docker'] . '/memcached/.');
    }

    /**
     * Permet de construire une image NodeJs avec Bower et Grunt
     */
    public function build_nodejs_bower_grunt() {
        $this->delete_image('wsd_nodejs_bower_grunt');
        system('docker build -t wsd_nodejs_bower_grunt ' . $this->A_PATHS['docker'] . '/nodejs_bower_grunt/.');
    }

    /**
     * Permet de construire l'image NGINX
     */
    public function build_nginx() {
        $this->delete_image('wsd_nginx');
        // vhosts
        system('echo "127.0.0.1   ' . $this->A_CONFIG['project']['environment_domains'] . '" >> /etc/hosts');
        copy($this->A_PATHS['docker'] . '/nginx/require/sites-available/example', $this->A_PATHS['docker'] . '/nginx/require/sites-enabled/' . $this->A_CONFIG['project']['name']);
        $this->multiple_replace_in_file($this->A_PATHS['docker'] . '/nginx/require/sites-enabled/' . $this->A_CONFIG['project']['name'], array(
            'wsd_project_name' => $this->A_CONFIG['project']['name'],
            'wsd_project_domain' => $this->A_CONFIG['project']['domain'],
            'wsd_project_environment_domains' => $this->A_CONFIG['project']['environment_domains'],
            'wsd_project_environment' => $this->A_CONFIG['project']['environment'],
        ));
        // htpasswd
        if (!is_null($this->A_CONFIG['project']['password'])) {
            $S_encrypted_password = crypt($this->A_CONFIG['project']['password'], base64_encode($this->A_CONFIG['project']['password']));
            $this->write_file('nginx/require/htpasswds/' . $this->A_CONFIG['project']['name'], 'htpasswd', 'wsd:' . $S_encrypted_password);
        }
        system('docker build -t wsd_nginx ' . $this->A_PATHS['docker'] . '/nginx/.');
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
        $this->resume();
    }

    /**
     * Lance Piwik
     */
    public function run_piwik() {
        $this->delete_container('webstack_piwik_1');
        system('docker run \
                --name webstack_piwik_1 \
                -it \
                -p 4578:80 \
                -d wsd_piwik');
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
        $this->delete_container('webstack_php_1');
        system('sudo docker run \
                --name webstack_php_1 \
                -p 9000:9000 \
                -v ' . $this->A_CONFIG['project']['directory'] . ':/var/www/' . $this->A_CONFIG['project']['name'] . ':rw \
                --dns=172.17.42.1 \
                -d wsd_phpfpm');
        system('docker logs webstack_php_1');
    }

    /**
     * Permet de lancer Memcached
     */
    public function run_memcached() {
        $this->delete_container('webstack_memcached_1');
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
        $this->delete_container('skydns');
        $this->delete_container('skydock');
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
        $this->delete_container('webstack_varnish_1');
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
        $this->delete_container('webstack_nginx_1');
        system('docker run \
                --name webstack_nginx_1 \
                -t \
                -i \
                -p 8080:80 \
                -v ' . $this->A_CONFIG['project']['directory'] . ':/var/www/' . $this->A_CONFIG['project']['name'] . ':rw \
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
        $this->delete_container('webstack_phppgadmin_1');
        system('docker run \
                --name webstack_phppgadmin_1 \
                -p 3321:80 \
                -e "VIRTUAL_HOST=phppgadmin.' . $this->A_CONFIG['project']['domain'] . '" \
                --dns=172.17.42.1 \
                -d wsd_phppgadmin');
        system('docker logs webstack_phppgadmin_1');
    }

    /**
     * Permet de lancer Postgres
     */
    public function run_postgres() {
        $this->delete_container('webstack_postgres_1');
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
     * Permet d'entrer dans un container
     *
     * @param $S_container_name
     */
    public function go($S_container_name) {
        passthru('docker exec -it ' . $S_container_name . ' /bin/bash');
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
        system('docker stop ' . $this->get_cid_by_cname($S_image, $S_tag));
        system('docker rm -f ' . $this->get_cid_by_cname($S_image, $S_tag));
    }

    /**
     * Permet de récupérer un container ID en fonction d'un container name
     *
     * @param        $S_image
     * @param string $S_tag
     */
    public function get_cid_by_cname($S_image, $S_tag = 'latest') {
        return system('docker ps -a | awk \'/' . $S_image . ':' . $S_tag . '/{print $1}\'');
    }

    /**
     * Permet de savoir si un container est bien lancé
     *
     * @param $S_container_name
     *
     * @return bool
     */
    public function check_container_is_running($I_container_name) {
        $B_returned = FALSE;
        $S_result = system('docker inspect -f {{.State.Running}} ' . $I_container_name);
        if ($S_result === TRUE OR $S_result == 'true') {
            $B_returned = TRUE;
        }

        return $B_returned;
    }

    /**
     * Arrêt et Suppression d'un container
     *
     * @param $S_container_name
     */
    public function delete_container($S_container_name) {
        if ($this->check_container_is_running($S_container_name)) {
            system('docker stop ' . $S_container_name);
            system('docker rm -f ' . $S_container_name);
        }
    }

    /**
     * Suppression d'image
     *
     * @param $S_image_name
     */
    public function delete_image($S_image_name) {
        $this->delete_container_by_image($S_image_name);
        system('docker rmi ' . $S_image_name);
    }

    /**
     * Permet d'effacer l'écran
     */
    public function clear(){
        system('clear');
    }

    /**
     * Offre un résumé complet de la situation
     */
    public function resume() {
        system('docker images');
        echo "##################################################################################\n";
        system('docker ps -a');
        echo "##################################################################################\n";
        system('dig @172.17.42.1 dev.local.docker');
        echo str_replace("    ",NULL,"\n\n\n
        Utilisez ces HOSTNAMEs pour communiquer entre vos conteneurs :
        \n
        \tphpPgAdmin : webstack_phppgadmin_1.phppgadmin.dev.local.docker
        \tPostgres SQL : webstack_postgres_1.wsd_postgres.dev.local.docker
        \tMemcached : webstack_memcached_1.wsd_memcached.dev.local.docker
        \tVarnish : webstack_varnish_1.wsd_varnish.dev.local.docker
        \tPHP FPM : webstack_php_1.wsd_phpfpm.dev.local.docker
        \tNGINX : webstack_nginx_1.wsd_nginx.dev.local.docker
        \tNodeJS - Bower/Grunt : webstack_nodejs_bower_grunt_1.wsd_nodejs_bower_grunt.dev.local.docker
        \n\n\n");
        if ($this->A_CONFIG['project']['environment'] != 'development') {
            echo str_replace("    ",NULL,"Veuillez ne pas oublier de configurer les DNS : \n
            phppgadmin." . $this->A_CONFIG['project']['domain'] . "
            \n\n\n");
        }
        echo 'Vos URLs :' . str_replace("    ",NULL,"\n
        \n
        \tphpPgAdmin : http://phppgadmin." . $this->A_CONFIG['project']['domain'] . ":3321/" . "
        \t\t-user : " . $this->A_CONFIG['postgres']['user'] . "
        \t\t-password : " . $this->A_CONFIG['postgres']['password'] . "
        \n
        \tPiwik : http://piwik." . $this->A_CONFIG['project']['domain'] . ":4578/
        \t\t-user : admin
        \t\t-password : admin
        \n\n\n");
    }
}

// Paths
$A_PATHS['lib'] = __DIR__;
$A_PATHS['base'] = $A_PATHS['lib'] . '/..';
$A_PATHS['docker'] = $A_PATHS['base'] . '/dockerfiles';
// Require
require $A_PATHS['base'] . "/config.php";
require $A_PATHS['lib'] . "/Colors.php";
// Object
$O_WebStaDOckER = new WebStaDOckER($A_PATHS, $A_CONFIG, $O_Colors);
// Args spécifique
if (isset($argv[2]) AND isset($argv[1])) {
    if ($argv[1] == 'go') {
        $O_WebStaDOckER->go($argv[2]);
    } else {
        $dynamicFunction = $argv[1] . '_' . $argv[2]; // Example : restart postgres
        $O_WebStaDOckER->{$dynamicFunction}();
    }
} else {
    // Args générique
    if (isset($argv[1])) {
        switch ($argv[1]) {
            case 'install' :
                $O_WebStaDOckER->install_hote();
                // Clone project
                $O_WebStaDOckER->get_project(TRUE);
                // Build All :
                $O_WebStaDOckER->stop_all_containers(TRUE);
                $O_WebStaDOckER->build_all_images();
                // Start All :
                $O_WebStaDOckER->run_all_container();
                break;
            case 'start':
            default:
                $O_WebStaDOckER->run_all_container();
                break;
            case 'stop':
                $O_WebStaDOckER->stop_all_containers();
                break;
            case 'restart':
                $O_WebStaDOckER->stop_all_containers();
                $O_WebStaDOckER->run_all_container();
                break;
            case 'rebuild':
                $O_WebStaDOckER->stop_all_containers(TRUE);
                $O_WebStaDOckER->build_all_images();
                break;
            case 'help':
                echo $O_Colors->getColoredString(NULL, "light_green", NULL) . "\n";
                echo str_replace("    ",NULL,"Exemple d'utilisation (simple) : \n
                \n
                \twsd [install|start|stop|restart|rebuild|go [container name]|help] \n
                \n
                Exemple d'utilisation (pour un conteneur spécifique) : \n
                \n
                \twsd build postgres \n
                \twsd run postgres \n
                \twsd go webstack_postgres_1 \n
                \n\n");
                if (yesNo('Afficher également le résumé de votre infrastructure ?')) {
                    echo $O_WebStaDOckER->resume();
                }
                echo $O_Colors->getColoredString(NULL, "light_blue", NULL);
                break;
        }
    }
}