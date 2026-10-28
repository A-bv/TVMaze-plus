# Document d'explications

À propos de mon app démo, elle reste simple:
- Mon but n'est pas de soumettre une app super complexe et parfaite en un temps très bref, mais d'illustrer mes connaissances des dernières techniques en développement iOS natif et ma façon de penser depuis la création d'une app.
- Elle est telle qu'elle aurait été construite pas à pas en production et comme en équipe, bien que je sois ici le seul développeur. 
- Pour cette raison, je commit directement sur la branche main.
- Elle aurait pu être tout à fait adaptée aux tickets, reviews et méthode Agile.
- Les commits respectent des étapes de construction. Je n'ai pas codé plus que nécessaire selon mes objectifs fixés, à chaque étape.
- Toute amélioration pouvant être par ailleurs travaillée par la suite dans de nouveaux commits.

Mes commits:
- Ils décrivent ma réflexion, mon analyse, mes choix et solutions lors du développement.
- Ils décrivent aussi les éventuels obstacles rencontrés et leur résolution.
- Ils décrivent la construction pas à pas de l'app démo.
- Chaque étape illustre à elle seule la construction d'un aspect de l'app comme par exemple la couche réseau, persistance (si j'ai le temps), UI, etc.
- Ils situent la timeline.
- J'ai utilisé SourceTree pour le "Version Control".

Time Tracking:
- Par manque de disponibilité, je n'ai pas pu allouer 100% de mon temps au projet, ni la coder d'une seule traite (de 0 à quelques heures par jour).
- J'ai mis les dates et le temps de travail.

## Étape 1: Objectif prise de conscience du projet, aucun développement.
Time Tracking:
- (23/09/26) - Moins d'une heure.

Travail préparatoire:
- J'ai pris conscience des différents choix proposés et instructions.
- J'ai choisi le projet TVMaze car la documentation de l'API était la plus simple à comprendre parmi les 3.
- J'ai cloné le repository d'évaluation sur ma machine.

## Étape 2: Objectif création de l'app, aucun développement.
Time Tracking:
- (26/09/26) - Quelques minutes.

Commit 1 Création de l'app:
- J'ai juste créé une nouvelle app: SwiftUI, rien de plus.
- Commit 1 en local (26/09/26).

## Étape 3: Objectif appel réseau et affichage.
Time Tracking:
- (28/09/26) - (04/10/26) - Quelques heures par jour, plus de temps pendant le week-end, plus de temps alloué à l'écriture des tests.

Détails généraux:
- Cette étape touche deux aspects en même temps: réseau + architecture.
- Le choix d'afficher une réponse réseau pour contrôle m'a obligé à travailler sur l'UI et sa logique.
- J'aurais pu faire juste la partie réseau indépendamment, mais c'était plus naturel d'implémenter le tout d'un coup.
- Je séparerai cependant mon travail dans des commits différents (expliqué par la suite).

Travail réseau:
- Observation du JSON retourné par l'endpoint (GET call): https://api.tvmaze.com/search/shows?q=girls
- Écriture du modèle avec des clefs qui correspondent au JSON, par défaut non optionnelles sauf si observé autrement.
    -> Il m'aurait été utile de trouver la liste des propriétés qui le sont ou pas, car j'ai eu souvent des problèmes de décodage.
- Création de l'API service responsable d'effectuer le GET call, récupérer les données, les décoder et renvoyer mon modèle.
    -> Cela illustre la "Concurrency" (async/await).
    -> Je n'accepte que le code 200. D'autres codes de succès existent, mais j'ai limité au strict nécessaire (respectant mon "à propos").
- Création de plusieurs types d'erreurs pour couvrir tous les cas problématiques de mon service.
    -> Erreur d'URL, réponse réseau, de décodage, ou cas indéterminé (par exemple une erreur provenant d'URLSession).
- Création d'un protocole pour mon service, mon service s'y conforme désormais.
    -> Ceci me sera utile pour mes futurs tests.

Travail chargement:
- Choix d'une architecture MVVM car je souhaite extraire toute logique de mon UI vers un "viewModel".
    -> Pourquoi? Car ce n'est pas de la responsabilité de mes views.
- Création du viewModel: j'ai décidé d'utiliser le framework "Observation" avec @Observable pour la mise à jour de mes données.
    -> J'aurais pu aussi utiliser le framework Combine, mais j'ai choisi une approche plus moderne.
- Injection du service au viewModel.
    -> Cela illustre la "Dependency injection". Pourquoi faire ça? Utile pour tester différents cas de figure en injectant différents paramètres dans le cadre des tests.
    -> Création d'une propriété locale objet "var shows: [ShowSearchModel]" pouvant contenir les données chargées.
    -> Ajout d'autres paramètres tels que des Booleans indiquant l'affichage d'un indicateur de chargement ou si une alerte doit être présentée ou non.
    -> Création d'une fonction "loadShows" utilisant le service injecté, dans le but de charger nos données et mettre à jour les Booleans.

Travail affichage de données:
- Modification de la view principale par défaut "ContentView" pour pouvoir afficher une valeur.
    -> J'ai choisi de n'afficher qu'une seule donnée "score", issue de mon objet.
        -> "score" se met à jour automatiquement grâce au framework "Observation". J'ai fait cela pour vérifier mon appel réseau.
    -> Ajout d'un modifier. Il en existe plusieurs, ici j'ai choisi .task.
        -> .task lance du code asynchrone à l'apparition de la vue et l'annule automatiquement à sa disparition.
    -> Ajout d'une action dans le modifier effectuant l'action de lancer un appel API, en appelant la fonction loadShows.
    -> Ajout d'un bouton, l'action du bouton étant la même chose que dans le modifier, ceci dans l'unique but de vérifier que mes données peuvent se mettre à jour après un clic.
    -> Renommage de "ContentView" en "ShowSearchView" et déplacement dans l'arborescence du projet.

Travail test manuel d'implémentation couche réseau:
- J'ai lancé un premier essai, pas de score à l'écran.
- Débogage à l'aide de breakpoints: mon appel API a marché mais le décodage non. La raison: certaines valeurs du JSON étaient optionnelles, et par conséquent devaient l'être aussi dans mon modèle, d'où mon erreur de décodage.
- J'ai pu ainsi corriger mon modèle et afficher le score à l'écran en essayant différents endpoints.
- J'ai ensuite vérifié que les alertes s'affichent correctement en cas de problème.

Travail tests automatisés:
- Ajout d'une unit testing target au projet pour l'implémentation de mes tests, étant donné mes tests manuels validés.
- Création d'un mock se conformant au protocole service.
    -> Ce mock me permettra de faire varier artificiellement les réponses réseau pour tester les différents cas du viewModel.
- Ajout de @testable import.
    -> Car sinon, les objets utilisés dans le projet ne sont pas reconnus dans les tests.
- Écriture des tests automatisés pour le viewModel, via Swift Testing (dernier framework développé par Apple, plus moderne que XCTest).
- Écriture des tests pour le service.
    -> URLSession doit être injectée de la même façon que le service a été injecté dans le viewModel, ceci dans le but de tester différents cas à l'aide d'un mock.
    -> L'écriture de ces tests a été plus compliquée que pour le viewModel, car j'ai dû simuler une fausse session.
    -> Pour y parvenir, j'ai créé un protocole DataSession auquel URLSession et mon MockedURLSession se conforment.
    -> Le cas invalidURL n'est pas testé car URL(string:) d'Apple ne renvoie quasiment jamais nil, ce qui rend ce cas très difficile à provoquer.

Review de mon code (exemples):
- Ajout de "final" pour certaines classes car elles ne seront pas utilisées comme subclass.
- Classement du code dans ses fichiers respectifs (04/10/26).

Travail sur les commits:
- Pour bien séparer le travail lié au networking du travail lié à l'architecture, j'ai trié les modifications dans deux commits différents.

Commit 2 Networking:
- Séparation des modifications liées au networking.
    -> Outils utilisés: le split view de SourceTree, l'option "staging", "stashing"...
- Vérification du build, vérification que les tests en lien avec le service passent.
- Commit 2 en local (04/10/26).

Commit 3 Architecture MVVM:
- Reprise de tous les éléments restants en lien avec le test d'affichage et l'architecture MVVM (viewModel, view...).
- L'UI reste de base et n'affiche qu'un score.
- Vérification du build, vérification que les tests liés au viewModel passent.
- Commit 3 en local (04/10/26).

## Étape 4: Objectif affichage de données transformées.
Time Tracking:
- (05/10/26) - plusieurs heures dans la journée.

Pré-vérification des étapes précédentes:
- Vérification manuelle que l'alerte s'affiche correctement si l'on provoque une erreur.
    -> J'ai choisi de modifier un optionnel dans mon modèle, qui n'était pas supposé l'être, pour provoquer une erreur de décodage.

Étude des données affichées:
- "Print viewModel.shows.first" et j'observe le résultat pour décider de ce que je choisis d'afficher ou pas dans mon UI.
    -> Triage des informations, celles qui ont un sens et celles qui n'ont pas d'intérêt.

Commit 4 Data transformer et affichage:
- Certaines données ne sont pas au bon format, un modèle local transformé serait plus propre.
    -> Création du transformer et de ses fonctions.
    -> Un struct, car ses propriétés n'évoluent pas dans le temps.
    -> Formatage des dates et du rating, conversion du code HTML.
    -> Valeurs par défaut pour les cas particuliers "nil".
- Injection du transformer dans le viewModel, shows vidé en cas d'erreur.
- Création des tests pour le data transformer, avec les cas particuliers "nil". Premiers tests en échec, corrigés.
- Affichage de quasi toutes les données transformées sur la view principale pour contrôle.
- Commit 4 en local (05/10/26).

## Étape 5: Objectif résolution d'un bug intermédiaire.
Time Tracking:
- (06/10/26) - quelques heures dans la journée.

Commit 5 Correction du modèle:
- En testant davantage de cas, je me suis aperçu que mon alerte se déclenchait, notamment avec l'endpoint "girls".
    -> Débogage: decoding error dans l'objet "show", d'autres optionnels qui devaient l'être et qui ne l'étaient pas dans mon modèle.
    -> Le "score" étant toujours présent dans la réponse, son affichage fonctionnait déjà à l'étape 3, les problèmes se situant uniquement dans "show".
    -> Après les corrections faites, je me suis dit que mes tests précédents étaient passés à côté de ce cas.
    -> J'ai donc sauvegardé la réponse problématique dans un fichier JSON local et construit mes tests avec ce fichier pour couvrir les cas manqués.
- Commit 5 en local (06/10/26).

Commit 6 Bug récurrent par manque d'informations:
- Bug récurrent, toujours de la même source, car je n'ai pas trouvé dans la documentation de l'API TVMaze (https://www.tvmaze.com/api) la liste des optionnels.
    -> Dans le commit 5, je me suis basé sur plusieurs shows retournés par le même endpoint "girls", mais j'ai ensuite décidé d'en tester d'autres. 
    -> J'ai optimisé mon JSON local pour couvrir les cas additionnels: j'ai deux shows, l'un le plus rempli possible (le first), l'autre le moins (le last).
    -> Quand je trouve un nouvel optionnel, je modifie "last" en mettant la valeur de la propriété en question à nil.
    -> J'ai eu aussi le cas de la propriété absente, auquel cas la propriété est supprimée de last.
- Commit 6 en local (06/10/26).

## Étape 6: Objectif UI et UX.
Time Tracking:
- (06/10/26) - quelques heures.

Commit 7 Choix de l'UI:
- Triage des informations, celles à mettre dans mes cellules et celles dans mon écran détails.
- J'imagine une disposition avec une barre de recherche, un défilement de "shows" que l'on peut sélectionner pour plus de détails.
- Ajout d'un champ de recherche et redisposition des éléments à l'écran.
- Mon but ici est de rendre l'interface fonctionnelle, tout travail graphique / travail esthétique est secondaire pour le moment.
- Commit 7 en local et push sur main (06/10/26).

Commit 8 Navigation et vue détail:
- La création des vues en SwiftUI est maintenant très directe.
    -> Toutes les données sont disponibles et pré-traitées après le chargement du ViewModel.
    -> Ajout de la vue détail.
- Connexion des vues avec NavigationLink.
- Commit 8 en local et push sur main (06/10/26).

## Étape 7: Persistance.
Time Tracking:
- (07/10/26) - environ une heure.

Commit 9 Persistance des données avec SwiftData:
- Grandement simplifié par rapport à Core Data.
    -> L'idée de faire une sauvegarde et l'idée serait de sauvegarder des favoris.
    -> Le show en question sera sauvegardé dans un nouveau modèle.
    -> Création d'un bouton reutilisable pouvant supprimer / ajouter un "show".
    -> Création d'une vue simple qui liste les favoris accessible par tabView.
- Amélioration de l'arborescence.
- Correction d'un optional (voir commit 5)
- Commit 9 en local et push sur main (06/10/26).

## Étape 8: Finition.
Time Tracking:
- (07/10/26) 

Commit 10 oublis et petites rectifications:
- Après verification de l'UI, j'ai corrigé quelques oublis.
- Commit 10 en local et push sur main (07/10/26).

Commit 11 finitions minimales:
- Amélioration de la disposition des éléments et verification de l'experience utilisateur.
    -> J'ai changé l'icône dans ma liste de favoris car l'action était trompeuse.
- Amélioration minimaliste du design.
    -> Utilisation du dernier langage visuel d'Apple, le liquid Glass (iOS 26).
- Commit 10 en local et push sur main (07/10/26).
