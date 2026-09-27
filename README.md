# Gourmet App — application Flutter multi-écrans

Application de recettes réalisée pour le projet de certification Flutter. Elle présente une navigation multi-écrans, une recherche avec filtre par catégorie, des détails accessibles par identifiant, la gestion des favoris et un formulaire de création validé.

## Fonctionnalités

- Accueil, liste des recettes, détails, ajout d’une recette et favoris.
- Navigation déclarative avec GoRouter et routes nommées.
- Recherche sur les noms et ingrédients, plus filtre par catégorie.
- Écran détail identifié par paramètre d’URL (`/details/:id`).
- Formulaire validé : nom, durée en minutes, catégorie, difficulté et ingrédients. Les nouvelles recettes sont ajoutées au dépôt partagé en mémoire.
- Favoris et bascule claire/sombre.
- Mise en page adaptative : grille selon la largeur disponible et détail en deux colonnes sur tablette.
- Widgets réutilisables sous `lib/widgets/` : bouton, barre de recherche, carte, mise en page responsive, image de recette et contrôle de thème.
- Images distantes avec visuel de remplacement si l’image n’est pas disponible.

> Les recettes et favoris sont conservés uniquement en mémoire : ils sont réinitialisés au redémarrage de l’application.

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

Les tests widget couvrent la navigation vers la liste, le filtrage, la route détail, la validation et l’ajout du formulaire, ainsi que le changement de thème.

## Structure principale

```text
lib/
  data/       dépôt et modèle des recettes
  routes/     configuration GoRouter
  screens/    accueil, liste, détails, formulaire, favoris
  theme/      thèmes clair et sombre
  widgets/    composants réutilisables et responsive
 test/        tests widget
```

## Captures d’écran et publication

Avant la remise, lancer l’application sur un émulateur ou un appareil et ajouter de vraies captures d’écran dans `screenshots/` (accueil, liste/recherche, détail, formulaire, thème sombre et vue tablette). Ajouter les images au dépôt puis les référencer ici, par exemple :

```md
![Liste des recettes](screenshots/recipe-list.png)
```

Pour publier le projet, créer un dépôt GitHub public, ajouter le dépôt distant, puis pousser la branche principale. Ne pas inclure les clés ou fichiers de configuration contenant des secrets.
