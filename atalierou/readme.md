# Ma c'hlass - atalieroù

## Présentation

**Ma c'hlass - atalieroù** signifie *Ma classe - ateliers* en Breton.

Il s'agit d'un logiciel éducatif visant plutôt la maternelle avec comme objectif d'être facile à personnaliser et de pouvoir être facilement étendu par la suite avec de nouvelles activités.

Il n'y a pour le moment que deux types d'activités gérés :

* le comptage de syllabes d'un mot
* le positionnement de sons ou de syllabes dans un mot

L'essentiel de l'application tient dans ses données. Un jeu minimum de données est embarqué de façon à pouvoir lancer et utiliser l'application immédiatement mais son principal intérêt réside en la création de jeux de données personnalisés.
Un jeu de données consiste en une arborescence de fichiers image et audio ainsi que de fichiers de description au format JSON qui définissent les activités. Les activités sont regroupées par catégorie et sont divisées en niveaux de difficultés.
L'application ayant été pensé pour avoir un minimum de texte avec dans tous les cas une importance mineure, les activités peuvent être dans n'importe quelle langue du moment que les fichiers audio associés sont enregistrés dans cette langue.

### Écran d'accueil
![home](doc/screen_home.png)
L'écran d'accueil permet d'aller dans l'écran de configuration ou de choisir un groupe. Deux groupes par défaut sont affichés sans configuration personnalisée. Le premier propose des activités en utilisant le jeu de données intégré en français, le second utilise le jeu de données intégré en breton.
L'icône en haut à gauche est la fonction de navigation, elle permet de sortir de l'application sur cet écran ou de revenir à l'écran précédent dans les autres cas.

### Écran de sélection de la catégorie d'activité
![Écran de sélection de la catégorie d'activité](doc/screen_select_activity_category.png)
Une fois le groupe choisi, l'écran suivant permet de choisir la catégorie d'activité.
Il n'y a pour le moment que la phonologie, d'autres catégories viendront s'ajouter (dénombrement par exemple)

### Écran de sélection du type d'activité
![Écran de sélection du type d'activité](doc/screen_select_activity_type.png)
Une fois la catégorie choisie, l'écran suivant permet de choisir le type d'activité.
En phonologie, l'application propose pour le moment le comptage de syllabes dans un mot ou la recherche d'un son ou d'une syllabe dans un mot.

### Écran de sélection du niveau de difficulté
![Écran de sélection du niveau de difficulté](doc/screen_select_activity_level.png)
Une fois l'activité choisie, l'écran suivant permet de sélectionner un exercice dans un niveau de difficulté.
Les niveaux de difficulté sont affichés par ligne, chaque niveau de difficulté ayant une couleur propre. Dans chaque niveau, il peut y avoir plusieurs exercices. Chaque exercice ne fait que présenter de façon aléatoire un certain nombre d'éléments (10 par défaut) du jeu de données associé. Ils ne servent qu'à matérialiser des objectifs en fonction des capacités de l'élève.

### Phonologie : comptage de syllabes
![Écran comptage de syllabes](doc/screen_syllabe.png)
Les écrans d'activités se présentent tous de la façon suivante :

* une icône de consigne qui joue le fichier audio rappelant la consigne de l'exercice,
* une jauge qui montre la réussite de l'élève au fur et à mesure de l'avancée dans l'exercice,
* la zone centrale contenant l'image de l'élément courant sous laquelle se trouve les propositions,
* l'icône en forme d'oeil permet à l'élève de valider son choix. tant que l'élève n'a pas valider, il peut modifier son choix.

Un fois le choix validé, le résultat s'affiche :
![choix de l'élève correct](doc/screen_syllabe_ok.png)
Le choix de l'élève est correct, il est marqué en vert et une étoile apparaît. L'icône permettant de voir le résultat devient une icône pour passer à l'élément suivant, au clic dessus, l'image change et l'étoile va rejoindre la jauge la faisant progresser.

![choix de l'élève incorrect](doc/screen_syllabe_ko.png)
Le choix de l'élève est incorrect, il est remplacé par une croix rouge alors que la bonne réponse s'affiche en noir. L'icône permettant de voir le résultat devient une icône pour passer à l'élément suivant mais aucune étoile ne fait progresser la jauge.

### Phonologie : recherche de son ou de syllabe
![Phonologie : recherche de son ou de syllabe](doc/screen_find_sound.png)
La recherche de son ou de syllabe dans un mot est assez similiare au comptage de syllabes si ce n'est dans le choix que l'élève doit faire. Ici il s'agit de cocher les cases associées aux syllabes du mot qui correspondent à la consigne (soit la recherche d'une syllabe soit la recherche d'une syllabe contenant un son). 
Il peut y avoir plusieurs choix à saisir comme sur l'exemple ci-dessus ou le son ***"o"*** est à chercher dans les syllabes du mot tobogan.
Sur cet exemple, l'élève a choisi la première et la troisième syllabe. La première syllabe est marquée en vert car ce choix est correct, la troisième syllabe est marqué par une croix rouge car ce choix est incorrect, la deuxième syllabe est marqué en noire car c'est une réponse non trouvée.

### Écran de configuration
![Écran de configuration](doc/config.png)
L'écran de configuration permet de choisir l'une des 3 langues d'interface disponibles (français, anglais ou breton). Ce choix n'a que peu d'impact car l'essentiel de l'application est visuel.
Il permet également de ne pas utiliser le jeu de données embarqué et de choisir un jeu de données personnalisé spécifié par un fichier au format JSON.
Toute modification n'est prise en compte qu'une fois validée par le bouton "appliquer".


## Jeu de données personnalisé
Un jeu de données personnalisé permet de définir des groupes et une liste d'élèves pour chacun d'eux. Il permet également de spécifier des activités différentes pour ces groupes.
L'application gère les scores par élève et il est possible de suivre leur progression. 

### Activité par élève
![Liste d'élève](doc/custom_select_child.png)
Lorsqu'une liste d'élèves est définie dans le jeu de données personnalisé, un écran de sélection de l'élève s'affiche après la sélection d'un groupe.

![Sélection du niveau](doc/custom_select_level.png)
Sur l'écran de sélection du niveau d'une activité, le score moyen par niveau pour l'élève est affiché sous la forme d'une jauge.

Le niveau suivant n'est débloqué que lorsque le score moyen du niveau précédent atteind le seuil défini par le jeu de données (80% de taux de réussite par défaut).

### Suivi de la progression par élève
Lorsqu'un jeu de données personnalisé est sélectionné dans l'écran de configuration, un bouton apparaît permettant d'afficher l'écran de suivi des scores.
![Suivi de la progression par élève](doc/config_scores.png)
Cet écran permet de choisir un groupe, puis dans ce groupe de choisir un ou une élève. Si l'élève a déjà réalisé au moins une activité, les scores apparaîssent, chaque score est daté ce qui permet de suivre la progression. 

Le score moyen est également affiché par catégorie, par type et par niveau d'activité.

Il est également possible d'exporter les scores dans un fichier CSV qui peut ensuite être ouvert avec un tableur comme Excel ou Libre Office Calc pour un suivi plus poussé (filtrage, création de courbes, etc).



## Création d'un nouveau jeu de données 
Un jeu de données personnalisé est spécifié par plusieurs fichiers. Un premier fichier principal qui devra être sélectionné dans l'écran de configuration ainsi que plusieurs fichiers, chacun spécifiant un type d'activité, ces fichiers sont au format JSON.



## Présentation rapide des fichiers JSON
Un fichier JSON se compose de blocs commençant par le symbôle **{** et terminant par le symbôle **}** (accolades ouvrante et fermante).

Les blocs contiennent des champs ayant un nom est une valeur, le nom est toujours entre quotes, le nom et sa valeur sont séparés par le symbôle **:** (deux points verticaux). Les champs sont séparé par des virgules.

La valeur d'un champ peut être :

* un bloc,
* une valeur numérique,
* une chaîne de caractères entre quotes,
* une liste de valeurs entre le symbôle **[** et **]** (crochets ouvrant et fermant), les élements de la liste étant séparés par une virgule. Ces élements peuvent être des blocs, des valeurs numériques ou des chaînes de caractères, mais doivent tous être de même nature pour une même liste.

Exemple de contenu au format JSON :

```
{
	"nom":"Pignon",
	"prénom":"François",
	"age":77,
	"adresse":{
		"rue":" 7 rue du cinéma",
		"code postal": 29000
	},
	"loisirs":["cinéma", "lecture", "sport"]
}
```

Pour s'assurer qu'aucune erreur de syntaxe n'est présente, il est possible d'utiliser une application de validation de contenu JSON. Il est facile d'en trouver disponible gratuitement en ligne, comme par exemple [jsonlint.com](https://jsonlint.com/) où il suffit de copier/coller le contenu JSON et d'appuyer sur le bouton de validation.

## Fichier de configuration principal

Le fichier de configuration principal indique sa version de format (actuellement 1.0.0), le chemin où trouver les différents fichiers référencés (attention, il doit se terminer par **/**). Le plus souvent les fichiers seront au même emplacement que le fichier principal, dans ce cas le chemin contiendra simplement "./" pour indiquer le dossier courant.

Vient ensuite la liste des groupes. Chaque groupe défini un nom et une image qui seront présentés sur l'écran d'accueil de l'application. Vient ensuite une liste d'élèves, chacun étant défini par un nom et une image.

Et enfin, une liste des activités proposées pour ce groupe. Une activité est définie par un fichier de configuration, une catégorie (actuellement seule la catégorie **phono** est supportée) et un type d'activité (actuellement **countSyllabes** et **findSoundOrSyllabe**). Attention à bien respecter la syntaxe, majuscules comprises.

Les images peuvent être au format JPG, PNG ou encore SVG.

```
{
"fileFormatVersion":"1.0.0",
"path":"./",
"groups":[
    {
        "name":"Grande section",
        "image":"images/groupes/GS.jpg",
        "children":[
              {
                  "name":"Yohann",
                  "image":"images/groupes/yohann.jpg"
              },
              {
                  "name":"Anaëlle",
                  "image":"images/groupes/anaelle.jpg"
              }
         ],
         "activities":[
             {
                 "config":"config_GS_count_syllabes.json",
                 "category":"phono",
                 "type":"countSyllabes"
             },
             {
                 "config":"config_GS_find_syllabes.json",
                  "category":"phono",
                  "type":"findSoundOrSyllabe"
             }
        ]
    },
    
    {
        "name":"Moyenne section",
        "image":"images/groupes/MS.jpg",
        "children":[
              {
                  "name":"Ninog",
                  "image":"images/groupes/ninog.jpg"
              },
              {
                  "name":"Mazhéo",
                  "image":"images/groupes/mazheo.jpg"
              },
              {
                  "name":"Ewen",
                  "image":"images/groupes/ewen.jpg"
              }
         ],
         "activities":[
             {
                 "config":"config_MS_count_syllabes.json",
                 "category":"phono",
                 "type":"countSyllabes"
             },
             {
                 "config":"config_MS_find_syllabes.json",
                  "category":"phono",
                  "type":"findSoundOrSyllabe"
             }
        ]
    }
    
  ]
}
```

## Arborescence type d'un jeu de données personnalisé
Voici un exemple type d'arborescence de fichiers pour un jeu de données personnalisé.

On y trouve le fichier de configuration principal, un dossier contenant les images (celles-ci peuvent être partagées pour plusieurs activités ou même pour plusieurs langues dans le cas d'activités bilingues) et un ou plusieurs dossiers contenant les fichiers audio.

Chaque image doit avoir sa correspondance audio.

```
.
├── config.json
├── fr
│   ├── audio
│   │   ├── abeille.mp3
│   │   ├── allumettes.mp3
│   │   ├── ...
│   │   ├── help_phono_countSyllabes.mp3
│   │   ├── help_phono_findSyllabe.mp3
│   │   ├── help_phono_findSyllabes_a.mp3
│   │   ├── help_phono_findSyllabes_o.mp3
│   │   ├── ...
│   │   ├── velo.mp3
│   │   └── voiture.mp3
│   ├── config_activity_count_syllabes.json
│   └── config_activity_find_sound.json
└── images
    ├── abeille.png
    ├── allumettes.png
    ├── ...
    ├── groupes
    │   ├── GS.jpg
    │   ├── MS.jpg
    │   └── ...
    ├── ...
    ├── velo.png
    └── voiture.png
```

En plus des images et fichiers audio pour chaque élément des activités, on y trouve un fichier audio par consigne et les images utilisées pour les groupes et les élèves. Il est également nécessaire d'y mettre les fichiers audio contenant les sons ou syllabes recherchés dans l'activité de recherche de sons ou syllabes.

## Fichier de configuration pour l'activité de comptage de syllabes

Comme le fichier de configuration principal, ce fichier indique sa version de format (actuellement 1.0.0), le chemin où trouver les différents fichiers référencés (attention, il doit se terminer par **/**). Dans cet exemple, les images ne se trouve pas au même niveau que le fichier de configuration de l'activité, on peut donc choisir de prendre comme chemin de référence soit le dossier où se trouve le fichier de configuration (la valeur sera alors "./") ou bien le dossier parent (la valeur sera alors "../"). Les deux choix se valent du moment que les noms des fichiers sont ensuite relatifs à ce chemin.

Le champ **helpFile** indique le nom du fichier audio de consigne, s'il n'est pas présent, le fichier de consigne par défaut de l'activité sera utilisé.

Vient ensuite la liste des niveaux, chacun contenant les champs :

* **level** indique le niveau (il commence à 1 et doit être incrémenté de 1).
* **nbItemsPerExercice** indique le nombre d'éléments à présenter par exercice. Chaque exercice prendra ce nombre d'éléments de façon aléatoire dans la liste des éléments pour les présenter à l'élève.
* **exercices** contient la liste des exercices à présenter pour ce niveau. Chaque exercice utilisant le même nombre d'éléments choisis de façon aléatoires, ils ne servent qu'à aider à attribuer des objectifs.
* **unlockScorePercent** indique le score à atteindre sur le niveau précédent pour débloquer ce niveau. Si rien n'est indiqué, la valeur par défaut de 80% est utilisée.
* **items** contient la liste des éléments disponibles.

Chaque élément comporte l'emplacement du fichier image et du fichier audio, le champ **max** indique le nombre maximum de syllabes à proposer à l'élève et **value** indique le nombre de syllabes correct pour cet élément.

```
{
"fileFormatVersion":"1.0.0",
"path":"./",
"helpFile":"fr/audio/help_phono_countSyllabes.mp3",
"levels":[
   {
            "level":1,

            "items": [
                {
                    "image":"../images/abeille.png",
                    "sound":"fr/audio/abeille.mp3",
                    "max":3,
                    "value":2
                },
                {
                    "image":"../images/velo.jpg",
                    "sound":"fr/audio/velo.mp3",
                    "max":3,
                    "value":2
                }, 
                ...
             ],
             "nbItemsPerExercice":10,
             "exercices":["exo1","exo2"]
    },

    {
            "level":2,
            "unlockScorePercent":80,
            "items": [
                {
                    "image":"../images/allumettes.jpg",
                    "sound":"fr/audio/allumettes.mp3",
                    "max":4,
                    "value":3
                },
                {
                    "image":"../images/voiture.jpg",
                    "sound":"fr/audio/voiture.mp3",
                    "max":4,
                    "value":2
                }
            ],
            "nbItemsPerExercice":10,
            "exercices":["exo1"]
    }
]
}
```

## Fichier de configuration pour l'activité de positionnement de sons ou syllabes

Comme pour tous les autres fichiers de configuration, ce fichier indique sa version de format (actuellement 1.0.0), le chemin où trouver les différents fichiers référencés (attention, il doit se terminer par **/**). Une fois de plus, dans l'exemple, les images ne se trouve pas au même niveau que le fichier de configuration de l'activité, on peut donc choisir de prendre comme chemin de référence soit le dossier où se trouve le fichier de configuration (la valeur sera alors "./") ou bien le dossier parent (la valeur sera alors "../"). Les deux choix se valent du moment que les noms des fichiers sont ensuite relatifs à ce chemin.

```
{
"fileFormatVersion":"1.0.0",
"path":"./",
"helpFile":"fr/audio/help_phono_findSyllabe.mp3",
"levels":[
   {
            "level":1,

            "items": [
                {
                    "image":"../images/abeille.png",
                    "sound":"fr/audio/abeille.mp3",
                    "helpFile":"audio/help_phono_findSyllabes_a.mp3",
                    "max":2,
                    "value":[1]
                },
                {
                    "image":"../images/velo.jpg",
                    "sound":"fr/audio/velo.mp3",
                    "helpFile":"audio/help_phono_findSyllabes_o.mp3",
                    "max":2,
                    "value":[2]
                }, 
                ...
             ],
             "nbItemsPerExercice":10,
             "exercices":["exo1","exo2"]
    },

    {
            "level":2,
            "unlockScorePercent":80,
            "items": [
                {
                    "image":"../images/allumettes.jpg",
                    "sound":"fr/audio/allumettes.mp3",
                    "helpFile":"audio/help_phono_findSyllabes_a.mp3",
                    "max":3,
                    "value":[1]
                },
                {
                    "image":"../images/tobogan.jpg",
                    "sound":"fr/audio/tobogan.mp3",
                    "helpFile":"audio/help_phono_findSyllabes_o.mp3",
                    "max":3,
                    "value":[1,2]
                }
            ],
            "nbItemsPerExercice":10,
            "exercices":["exo1"]
    }
]
}
```
Ce fichier ressemble beaucoup à celui de l'activité de comptage de syllabes.

On y retrouve le champ **helpFile** indiquant le nom du fichier audio de consigne, s'il n'est pas présent, le fichier de consigne par défaut de l'activité sera utilisé.

Vient ensuite la liste des niveaux, chacun contenant les champs :

* **level** indique le niveau (il commence à 1 et doit être incrémenté de 1).
* **nbItemsPerExercice** indique le nombre d'éléments à présenter par exercice. Chaque exercice prendra ce nombre d'éléments de façon aléatoire dans la liste des éléments pour les présenter à l'élève.
* **exercices** contient la liste des exercices à présenter pour ce niveau. Chaque exercice utilisant le même nombre d'éléments choisis de façon aléatoires, ils ne servent qu'à aider à attribuer des objectifs.
* **unlockScorePercent** indique le score à atteindre sur le niveau précédent pour débloquer ce niveau. Si rien n'est indiqué, la valeur par défaut de 80% est utilisée.

La différence vient des champs pour chaque élément. On y retrouve l'emplacement pour le fichier image et audio, mais également le fichier consigne pour l'élément. Il contient le son ou la syllabe recherché pour l'élément et sera jouer à la fin du fichier de consigne de l'activité.

Par exemple, si le fichier de consigne pour l'activité contient la phrase :
***Regarde l'image et trouve la position des syllabes contenant le son***

Et si le fichier de consigne pour l'élément contient le son ***o***, alors à chaque fois que la consigne sera jouée, l'élève entendra la phrase :
***Regarde l'image et trouve la position des syllabes contenant le son o***

On retrouve ensuite le nombre maximum de choix à afficher à l'élève, ici il devra correspondre au nombre de syllabes dans le mot (si la consigne et de trouver les syllabes contenant un son donné).

Le champ **value** contient la liste des positions correctes. S'il n'y a qu'une seule position correct, la liste ne contient que cette position, sinon elle contient la liste de toutes les positions attendues. Par exemple, si on cherche le son **o** dans le mot tobogan, la liste devra contenir les valeurs 1 et 2 séparées par une virgule.
