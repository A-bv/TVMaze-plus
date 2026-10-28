# TVMazeApp

Application iOS native en SwiftUI pour rechercher des séries TV via l'[API TVMaze](https://www.tvmaze.com/api), consulter leur fiche détaillée et enregistrer ses favoris.

Le projet est volontairement simple : son but n'est pas d'empiler les fonctionnalités, mais de montrer une façon de construire une app iOS moderne, pas à pas, comme en production et en équipe — architecture claire, code testable et choix justifiés.

<!-- Captures d'écran : ajouter ici 2 ou 3 images (recherche, détail, favoris). -->

## Fonctionnalités

- Recherche de séries par nom
- Défilement horizontal des résultats sous forme de cartes (affiche, années, statut, note)
- Fiche détaillée : grande affiche, genres, type, langue, résumé, lien vers le site officiel
- Favoris persistants, ajoutés ou retirés depuis les cartes et la fiche détaillée
- Onglet dédié à la liste des favoris
- Gestion des erreurs réseau et de décodage avec une alerte

## Stack technique

| Domaine | Choix |
|---|---|
| UI | SwiftUI, Liquid Glass (iOS 26) |
| Architecture | MVVM, injection de dépendances via protocoles |
| État | Framework Observation (`@Observable`) |
| Concurrence | async/await, isolation `MainActor` par défaut |
| Réseau | `URLSession` derrière un protocole `DataSession` |
| Persistance | SwiftData |
| Tests | Swift Testing |

Aucune dépendance externe.

## Architecture

```
TVMazeApp/
├── Networking/                 Couche réseau
│   ├── TVMazeAPIService        Protocole du service
│   ├── TVMazeAPIServiceImpl    Appel GET, vérification du statut, décodage
│   ├── TVMazeAPIServiceError   Erreurs typées (URL, réponse, décodage)
│   ├── DataSession             Abstraction d'URLSession pour les tests
│   ├── ShowSearchModel         Modèle décodé depuis le JSON de l'API
│   └── ShowSearchTransformer   Conversion vers le modèle d'affichage
└── Features/ShowSearch/
    ├── Models/Domain           ShowItemModel, prêt à afficher
    ├── Models/Persistance      SavedShowModel (SwiftData)
    ├── ViewModel               ShowSearchViewModel
    └── Views                   Recherche, carte, détail, favoris, onglets
```

Le flux de données est à sens unique :
`API → ShowSearchModel → ShowSearchTransformer → ShowItemModel → Vues`

- Le **service** ne fait que récupérer et décoder les données.
- Le **transformer** formate les dates et la note, nettoie le HTML du résumé et fournit des valeurs par défaut pour les champs absents.
- Le **ViewModel** orchestre le chargement et expose l'état aux vues.
- Les **vues** n'ont aucune logique métier : elles affichent des données déjà prêtes.

## Lancer le projet

Prérequis : Xcode 26 et un simulateur ou appareil sous iOS 26.5 ou plus.

1. Ouvrir `TVMazeApp/TVMazeApp.xcodeproj`.
2. Choisir le schéma `TVMazeApp` et un simulateur.
3. Lancer avec `⌘R`.

## Tests

Lancer les tests avec `⌘U` dans Xcode.

| Suite | Ce qui est couvert |
|---|---|
| `TVMazeAPIServiceTests` | Statut 200 et autres codes, JSON invalide, décodage d'une vraie réponse de l'API |
| `ShowSearchViewModelTests` | Succès, chaque type d'erreur, erreur inattendue, état de chargement |
| `ShowSearchTransformerTests` | Transformation complète et valeurs par défaut quand les champs sont `nil` |

Le service et le ViewModel sont testés grâce à des mocks injectés (`DataSession`, `TVMazeAPIService`). La fixture `girls_search_response.json` contient deux séries réelles : l'une la plus complète possible, l'autre avec le plus de champs absents ou `nil`.

## Démarche de développement

L'app a été construite par étapes, chacune centrée sur un aspect précis : réseau, architecture, transformation des données, UI, persistance. À chaque étape, je n'ai codé que ce qui était nécessaire à l'objectif fixé ; les améliorations pouvaient venir ensuite.

### Étape 1 : Création du projet
- Création d'une app SwiftUI vierge.

### Étape 2 : Couche réseau
- Observation du JSON renvoyé par l'endpoint `https://api.tvmaze.com/search/shows?q=girls`.
- Écriture du modèle avec des clés correspondant au JSON, non optionnelles par défaut sauf si observé autrement.
- Création du service chargé d'effectuer l'appel GET, de récupérer les données et de les décoder, avec async/await.
    - Seul le code 200 est accepté : d'autres codes de succès existent, mais je me suis limité au strict nécessaire.
- Création d'erreurs typées pour couvrir chaque cas : URL, réponse réseau, décodage, et cas indéterminé (une erreur venant d'`URLSession` par exemple).
- Création d'un protocole pour le service, afin de pouvoir le remplacer par un mock dans les tests.
- Tests du service : pour simuler une fausse session, j'ai créé le protocole `DataSession`, auquel `URLSession` et le mock se conforment. Ces tests ont été plus délicats à écrire que ceux du ViewModel.
    - Le cas `invalidURL` n'est pas testé, car `URL(string:)` ne renvoie quasiment jamais `nil`, ce qui rend ce cas très difficile à provoquer.

### Étape 3 : Architecture MVVM
- Choix de MVVM pour extraire toute logique des vues, car ce n'est pas leur responsabilité.
- Utilisation du framework Observation (`@Observable`) plutôt que Combine, pour une approche plus moderne.
- Injection du service dans le ViewModel, afin de tester différents scénarios.
- Le ViewModel expose les séries chargées, un indicateur de chargement et l'état de l'alerte, et une fonction `loadShows` met à jour l'ensemble.
- Première vue minimale n'affichant que le `score`, pour valider l'appel réseau de bout en bout.
- Tests du ViewModel avec Swift Testing et un mock du service.

### Étape 4 : Transformation des données
- Certaines données n'étaient pas au bon format pour l'affichage : un modèle local transformé est plus propre.
- Création du transformer, sous forme de `struct` car il n'a pas d'état qui évolue.
    - Formatage des dates et de la note, suppression des balises HTML du résumé.
    - Valeurs par défaut pour les cas `nil`.
- Injection du transformer dans le ViewModel ; les résultats sont vidés en cas d'erreur.
- Tests du transformer, y compris les cas `nil`. Les premiers tests ont échoué et ont permis de corriger le code.

### Étape 5 : Résolution d'un bug de décodage récurrent
- En testant d'autres recherches, l'alerte se déclenchait, notamment avec « girls ».
    - Cause : une erreur de décodage dans l'objet `show`, dont certains champs devaient être optionnels.
    - Le `score` étant toujours présent, l'affichage de l'étape 3 fonctionnait : le problème ne concernait que `show`.
- Mes tests précédents étaient passés à côté de ce cas. J'ai donc enregistré la réponse problématique dans un fichier JSON local et construit des tests à partir de celui-ci.
- Le bug est revenu avec d'autres séries, car la documentation de l'API ne précise pas quels champs sont optionnels. J'ai alors optimisé la fixture :
    - deux séries, l'une la plus remplie possible (`first`), l'autre la moins remplie (`last`) ;
    - à chaque nouvel optionnel découvert, je mets la valeur correspondante à `nil` dans `last` ;
    - quand une propriété est carrément absente, je la supprime de `last`.

### Étape 6 : Interface et navigation
- Tri des informations : celles à afficher dans les cartes et celles réservées à la fiche détaillée.
- Disposition avec une barre de recherche et un défilement de cartes que l'on peut sélectionner.
- Ajout de la fiche détaillée et de la navigation avec `NavigationLink`. Comme toutes les données sont déjà prêtes après le chargement, la création des vues est directe.

### Étape 7 : Persistance avec SwiftData
- Sauvegarde des favoris dans un modèle dédié, beaucoup plus simple à mettre en place qu'avec Core Data.
- Bouton réutilisable pour ajouter ou retirer un favori.
- Onglet listant les favoris, accessible via un `TabView`.

### Étape 8 : Finitions
- Vérification de l'UI et de l'expérience utilisateur, correction de quelques oublis.
- Changement de l'icône de suppression dans la liste des favoris, car l'action précédente était trompeuse.
- Habillage minimaliste avec Liquid Glass, le dernier langage visuel d'Apple (iOS 26).

## Améliorations possibles

- Afficher une image de remplacement quand une série n'a pas d'affiche.
- Ajouter des états vides : avant la première recherche et quand une recherche ne renvoie aucun résultat.
- Enrichir les favoris : miniature et navigation vers la fiche détaillée.
- Construire l'URL avec `URLComponents` pour gérer les caractères comme `&` dans une recherche.
- Annuler la recherche précédente quand une nouvelle est lancée.
- Ne décoder que les champs réellement utilisés, pour rendre le modèle moins sensible aux variations de l'API.
- Localiser les textes avec un String Catalog.
- Ajouter des fonctionnalités : épisodes, casting, saisons.
