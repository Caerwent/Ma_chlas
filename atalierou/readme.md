# Ma c'hlass - atalieroù

## Présentation

Ma c'hlass - atalieroù signifie MA classe - ateliers en Breton.

Il s'agit d'un logiciel éducatif visant plutôt la maternelle avec comme objectif d'être facile à personnaliser et de pouvoir être facilement étendu par la suite avec de nouvelles activités.

Il n'y a pour le moment que deux types d'activités gérés :

* le comptage de syllabes d'un mot
* le positionnement de sons ou de syllabes dans un mot

L'essentiel de l'application tient dans ses données. Un jeu minimum de données est embarqué de façon à pouvoir lancer et utiliser l'application immédiatement mais son principal intérêt réside en la créations de jeux de données personnalisés.
Un jeu de données consiste en une arborescence de fichiers image et audio ainsi que d'un fichier de description au format JSON qui défini les activités. Les activités sont regroupées par catégorie et sont divisées en niveaux de difficultés.
L'application ayant été pensée pour avoir un minimum de texte avec dans tous les cas une importance mineure, les activités peuvent être dans n'importe quelle langue du moment que les fichiers audio associés sont enregistrés dans cette langue.

### Écran d'accueil
![home](doc/screen_home.png)
L'écran d'accueil permet d'aller dans l'écran de configuration ou de choisir un groupe classe. Un groupe classe par défaut est affiché sans configuration personnalisée.
L'icône en haut à gauche est la fonction de navigation, elle permet de sortir de l'application sur cet écran ou de revenir à l'écran précédent dans les autres cas.

### Écran de sélection de la catégorie d'activité
![home](doc/screen_select_activity_category.png)
Une fois le groupe choisi, l'écran suivant permet de choisir la catégorie d'activité.
Il n'y a pour le moment que la phonologie, d'autres catégories viendront s'ajouter (dénombrement par exemple)

### Écran de sélection du type d'activité
![home](doc/screen_select_activity_type.png)
Une fois la catégorie choisie, l'écran suivant permet de choisir le type d'activité.
En phonologie, l'application propose pour le moment le comptage de syllabe dans un mot ou la recherche d'un son ou d'une syllabe dans un mot.

### Écran de sélection du niveau de difficulté
![home](doc/screen_select_activity_level.png)
Une fois l'activité choisie, l'écran suivant permet de sélectionner un exercice dans un niveau de difficulté.
Les niveaux de difficulté sont affichés par ligne, chaque niveau de difficulté ayant une couleur propre. Dans chaque niveau, il peut y avoir plusieurs exercices. chaque exercice ne fait que présenter de façon aléatoire un certain nombre d'éléments (10 par défaut) du jeu de données associé. Ils ne servent qu'à matérialiser des objectifs en fonction des capacités de l'élève.

### Phonologie : comptage de syllabes
![home](doc/screen_syllabe.png)
Les écrans d'activités se présentent tous de la façon suivante :

* une icône de consigne qui joue le fichier audio rappelant la consigne de l'exercice,
* une jauge qui montre la réussite de l'élève au fur et à mesure de l'avancée dans l'exercice,
* la zone centrale contenant l'image de l'élément courant sous laquelle se trouve les propositions,
* l'icône en forme d'oeil permettant à l'élève de valider son choix. tant que l'élève n'a pas valider, il peut modifier son choix.

Un fois le choix validé, le résultat s'affiche :
![home](doc/screen_syllabe_ok.png)
Le choix de l'élève est correct, il est marqué en vert et une étoile apparaît. L'icône permettant de voir le résultat devient une icône pour passer à l'élément suivant, au clic dessus, l'image change et l'étoile va rejoindre la jauge la faisant progresser.

![home](doc/screen_syllabe_ko.png)
Le choix de l'élève est incorrect, il est remplacé par une croix rouge alors que la bonne réponse s'affiche en noir. L'icône permettant de voir le résultat devient une icône pour passer à l'élément suivant mais aucune étoile ne fait progresser la jauge.

### Phonologie : recherche de son ou de syllabe
![home](doc/screen_find_sound.png)
La recherche de son ou de syllabe dans un mot est assez similiare au comptage de syllabe si ce n'est dans le choix que l'élève doit faire. Ici il s'agit de cocher les cases qui correspondent au syllabes du mot qui correspondent à la consigne (soit la recherche d'une syllabe soit la recherche d'une syllabe contenant un son). 
Il peut y avoir plusieurs choix à saisir comme sur l'exemple ci-dessus ou le son ***"o"*** est à chercher dans les syllabes du mot tobogan.
Sur cet exemple, l'élève a choisi la première et la troisième syllabe. La première syllabe est marquée en vert car ce choix est correct, la troisième syllabe est marqué par une croix rouge car ce choix est incorrect, la deuxième syllabe est marqué en noire car c'est une réponse non trouvée.

### Écran de configuration
![home](doc/config.png)
L'écran de configuration permet de choisir l'une des 3 langues d'interface disponibles (français, anglais ou breton). Ce choix n'a que peu d'impact car l'essentiel de l'application est visuel.
Il permet également de ne pas utiliser le jeu de données embarqué et de choisir un jeu de données personnalisés spécifié par un fichier au format JSON.
Toute modification n'est prise en compte qu'une fois validée par le bouton "appliquer".


## Création d'un nouveau jeu de donnée
Un jeu de données personnalisé est spécifié par plusieurs fichiers. Un premier fichier principal qui devra être sélectionné dans l'écran de configuration ainsi que plusieurs fichiers, chacun spécifiant un type d'activité.



## Présentation rapide des fichiers JSON
Un fichier JSON se compose de blocs commençant par le symbôle **{** et terminant par le symbôle **}** (accolades ouvrante et fermante).

Les blocs contiennent des champs ayant un nom est une valeur, le nom est toujours entre quotes, le nom et sa valeur sont séparés par le symbôle **:** (deux points verticaux). Les champs sont séparé par des virgules.

La valeur d'un champ peut être :
* un bloc,
* une valeur numérique,
* une chaîne de caractères entre quotes
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

## Fichier de configuration principal

Le fichier de configuration principal indique sa version de format (actuellement 1.0.0), le chemin où trouver les différents fichiers référencés (attention, il doit se terminé par **/**). LE plus souvent les fichiers seront au même emplacement que le fichier principal, dans ce cas le chemin contiendra simplement "./" pour indiquer le dossier courant.

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
        "image":"images/classe/GS.jpg",
        "children":[
              {
                  "name":"Yohann",
                  "image":"images/classe/yohann.jpg"
              },
              {
                  "name":"Anaëlle",
                  "image":"images/classe/anaelle.jpg"
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
        "name":"Petite section",
        "image":"images/classe/PS.jpg",
        "children":[
              {
                  "name":"Ninog",
                  "image":"images/classe/ninog.jpg"
              },
              {
                  "name":"Mazhéo",
                  "image":"images/classe/mazheo.jpg"
              },
              {
                  "name":"Ewen",
                  "image":"images/classe/ewen.jpg"
              }
         ],
         "activities":[
             {
                 "config":"config_PS_count_syllabes.json",
                 "category":"phono",
                 "type":"countSyllabes"
             },
             {
                 "config":"config_PS_find_syllabes.json",
                  "category":"phono",
                  "type":"findSoundOrSyllabe"
             }
        ]
    }
    
  ]
}
```


