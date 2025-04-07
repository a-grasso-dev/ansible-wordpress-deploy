# Ansible - Déploiement d'une application Wordpress

Ce projet vise à automatiser le déploiement d'un applicatif entier Wordpress sur des machines Debian.

## En développement, deux machines virtuelles sous Debian ont été utilisées
  - server-01 (production) - adresse IP : 192.168.95.129
  - server-02 (staging) - adresse IP : 192.168.95.130

> ⚠️ Dans cette documentation, les adresses IP ci-dessus sont utilisées à titre d'exemple. Pensez à adapter ces adresses en fonction de vos propres serveurs.

## Environnement de développement
- WSL Ubuntu sous Windows
- IDE : Visual Studio Code
- Déploiement automatisé via Ansible
- Versionning : Git et Gilab

## Services déployés

- Serveur web : Nginx
- Serveur PHP : PHP-FPM
- Base de données : MariaDB
- Application : Wordpress

## Rôles Ansible spécifiques

- `nginx` : installation et configuration du serveur web
- `php` : installation de PHP-FPM et des extensions requises
- `mysql` : installation de MariaDB, création de base et utilisateur
- `wordpress` : clonage du dépôt Wordpress, création de `wp-config.php`
- `motd` : message dynamique différent selon l'environnement (staging / production)

## Gestion des environnements

- `group_vars/production.yml` : variables (chiffrées) pour server-01
- `group_vars/staging.yml` : variables (chiffrées) pour server-02

> Chaque environnement dispose de sa propre base de données, d’un utilisateur et d’un mot de passe différents, conformément au cahier des charges.

## Fichiers principaux

- `main.yml` : point d'entrée principal, importe `webservers.yml` et `dbservers.yml`
- `webservers.yml` : joue les rôles nginx, php, wordpress, motd
- `dbservers.yml` : joue le rôle mysql
- `inventories/hosts.yml` : définit les groupes `webservers`, `dbservers`, `production`, `staging`

## Prérequis pour les accès aux serveurs

1. Adapter l'adresse IP attribuée à chaque serveur dans `inventories/hosts.yml` 

2. Vérifier et créer, si nécessaire, une clé SSH publique :
```bash
ls ~/.ssh/id_rsa.pub
ssh-keygen -t rsa -b 4096
```

3. Ajouter la clé sur chaque serveur :
```bash
ssh-copy-id ansible@192.168.95.129
ssh-copy-id ansible@192.168.95.130
```

4. Démarrer l’agent SSH et charger la clé privée :
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```
5. Démarrer l’environnement shell Ansible
```bash
make sh
```

## Playbooks

> ⚠️ Au lancement des playbooks valider la connexion des deux serveurs

```bash
Are you sure you want to continue connecting (yes/no/[fingerprint])?
yes
ok: [server-02]
yes
ok: [server-01]
```
### Lancer le déploiement complet (tous les rôles, toutes les machines)

```bash
ansible-playbook main.yml --ask-vault-pass
```

### Lancer uniquement un environnement

```bash
# Production
ansible-playbook main.yml --limit production --ask-vault-pass
```
```bash
# Staging
ansible-playbook main.yml --limit staging --ask-vault-pass
```

### Lancer uniquement certains rôles via tags

```bash
# Php
ansible-playbook main.yml --tags php --ask-vault-pass
```
```bash
# Wordpress
ansible-playbook main.yml --tags wordpress --ask-vault-pass
```
```bash
# Php + wordpress
ansible-playbook main.yml --tags "php,wordpress" --ask-vault-pass
```
## Sécurité et gestion des secrets

Les mots de passe de la base de données sont chiffrés avec Ansible Vault dans les fichiers group_vars/production.yml et group_vars/staging.yml

## Accès au site Wordpress

Une fois le déploiement terminé, accéder à l’application WordPress via un navigateur :

- Production : http://192.168.95.129
- Staging : http://192.168.95.130

## Auteur

Nom : Grasso

Prénom : Andrea

E-mail : [andrea.grasso@etu.univ-lyon1.fr](mailto\:andrea.grasso@etu.univ-lyon1.fr)

Numéro étudiant : p2413874

## Repositorys

- [Dépot du projet](https://forge.univ-lyon1.fr/p2413874/ansible-wordpress-deploy)

- [Cahier des charges](https\://forge.univ-lyon1.fr/iut-lyon-devops-ansible/ansible-project)

