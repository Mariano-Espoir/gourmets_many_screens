# Gourmet App — application Flutter multi-écrans

Application de recettes réalisée pour le projet de certification Flutter. Elle présente une navigation multi-écrans, une recherche avec filtre par catégorie, des détails accessibles par identifiant, la gestion des favoris et un formulaire de création validé.

Le projet adapte aussi les critères Dart de conception (modèle, repository, gestionnaire métier, génériques, exceptions et tests isolés) à une application Flutter : au lieu d’une interface CLI, les cas d’usage sont accessibles dans les écrans de l’application.

## Correspondance avec la grille d’évaluation Dart

La grille fournie décrit à l’origine un gestionnaire de tâches CLI. Elle n’est donc pas appliquée littéralement : ce dépôt reste une application Flutter de recettes. Les critères transférables sont traités par leurs équivalents :

| Critère | Équivalent dans l’application |
| --- | --- |
| Ajouter et afficher des éléments triés | Création de recettes, liste triée par nom ou durée, recherche et filtres |
| Marquer comme terminé | Marquer une recette en favori et retrouver la liste des favoris |
| Supprimer un élément | Suppression d’une recette depuis sa page de détail, avec confirmation |
| Persistance JSON | Sérialisation du modèle `Recipe` en JSON dans le stockage local SharedPreferences |
| Modèles séparés | `Recipe` est séparé dans `lib/models/` |
| Repository, abstraction et génériques | Interfaces `RecipeRepository`/`Repository<T>` et repository JSON dans `lib/data/` |
| Gestionnaire métier | `RecipeManager` valide, recherche, trie, ajoute, supprime et persiste les recettes |
| Exceptions personnalisées | Erreurs métier et stockage dédiées dans `recipe_exceptions.dart` |
| Tests unitaires isolés | `RecipeManager` testé avec un repository en mémoire, plus tests widget Flutter |
| README et exécution des tests | Instructions ci-dessous et commandes documentées |

Les fonctionnalités propres à la certification Flutter (écrans, navigation, responsive et thèmes) sont également couvertes. La grille citée ne donne pas de barème spécifique à cette application Flutter : aucun score de certification n’est garanti.

## Fonctionnalités

- Accueil, liste des recettes, détails, ajout d’une recette et favoris.
- Navigation déclarative avec GoRouter et routes nommées.
- Recherche sur les noms et ingrédients, plus filtre par catégorie.
- Écran détail identifié par paramètre d’URL (`/details/:id`).
- Formulaire validé : nom, durée en minutes, catégorie, difficulté et ingrédients. Les créations et suppressions sont enregistrées.
- Ajout, affichage trié (nom ou durée), recherche, favoris et suppression des recettes.
- Persistance locale JSON via SharedPreferences : les recettes et favoris survivent au redémarrage.
- Mise en page adaptative : grille selon la largeur disponible et détail en deux colonnes sur tablette.
- Widgets réutilisables sous `lib/widgets/` : bouton, barre de recherche, carte, mise en page responsive, image de recette et contrôle de thème.
- Images distantes avec visuel de remplacement si l’image n’est pas disponible.

> Le stockage JSON est local à l’appareil : il n’y a pas de synchronisation entre appareils ou de compte utilisateur.

## Prérequis et lancement

Installer Flutter et vérifier l’installation :

```sh
flutter doctor
```

Depuis la racine du dépôt :

```sh
flutter pub get
flutter run
```

Pour choisir une cible, lister les appareils avec `flutter devices`, puis lancer par exemple :

```sh
flutter run -d chrome
```

## Vérifications

```sh
flutter analyze
flutter test
```

Les 15 tests couvrent la navigation, le filtrage, la route détail, le formulaire et le thème, ainsi que le `RecipeManager` (tri, validation métier, favoris, suppression, exceptions), le repository JSON (sauvegarde/restauration et données corrompues) et un faux repository en mémoire pour l’isolation.

## Structure principale

```text
lib/
  data/       gestionnaire métier, repository JSON, exceptions et données de départ
  models/     modèle Recipe et sérialisation JSON
  routes/     configuration GoRouter
  screens/    accueil, liste, détails, formulaire, favoris
  theme/      thèmes clair et sombre
  widgets/    composants réutilisables et responsive
test/         tests widget et tests unitaires avec faux repository
```

## Captures d’écran et publication

Avant la remise, lancer l’application sur un émulateur ou un appareil et ajouter de vraies captures d’écran dans `screenshots/` (accueil, liste/recherche, détail, formulaire, thème sombre et vue tablette). Ajouter les images au dépôt puis les référencer ici, par exemple :

```md
![Liste des recettes](screenshots/recipe-list.png)
```

Pour publier le projet, créer un dépôt GitHub public, ajouter le dépôt distant, puis pousser la branche principale. Ne pas inclure les clés ou fichiers de configuration contenant des secrets.
