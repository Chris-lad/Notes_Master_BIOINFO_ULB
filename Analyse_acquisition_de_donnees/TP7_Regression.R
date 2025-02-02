##################################################################################
## Travaux pratiques: 6�me s�ance: la r�gression lin�aire I
##################################################################################

# 1)  Chargez le jeu de donn�es �faithful� et faites un graphique de la dur�e des 
# �ruption du geyser en fonction du temps d�attente.
##################################################################################
data(faithful)
str(faithful)
plot(eruptions~waiting, data = faithful)

# 2) La fonction �lm()� qui g�n�re un objet de type � r�gression lin�aire � s��crit de la 
# m�me mani�re que la fonction �aov()� utilis�e pr�c�demment. Utilisez cette fonction 
# ainsi que la fonciton abline() pour construire une r�gression lin�aire.
##################################################################################
mylm = lm(eruptions~waiting, data = faithful)
abline(mylm)

# 3) En fonction des �l�ments vus au cours, d�taillez les �l�ments fournis par la fonction 
# �summary()� appliqu� � l�objet r�gression.
##################################################################################
summary(mylm)

# La fonction nous permet d'afficher l'ordonn�e � l'origine de la droite de r�gression (-1.87),
# le co�ficient angulaire de la droite (0.075), leurs statistiques t respectives, et la probabilit�
# d'obtenir une statistique t sup�rieure � celle-l� sous H0 (ordonn�es � l'origine nulle et pente nulle, 
# respectivement). Ici, on peut dans les deux cas rejeter H0 avec un seuil alpha de 0.001.
# La fonction nous affiche �galement le co�ficient de d�termination R-squared, et l'on
# voit dont que 81.1 % de la variabilit� est expliqu�e par la droite de r�gression. Enfin, la r�gression
# est globalement significative, puisque qu'il est tr�s hautement peu probable (p < 10^-16) d'obtenir
# un statistique de F sup�rieure � celle-ci (1162) si H0 �tait vrais.



# 4)	Chargez le jeu de donn�es " longley ". A l'aide de la fonction pairs(), 
# examinez les relations bi-vari�es entre ces variables. Quelle variables selon 
# vous devrait permettre de pr�dire de number de personnes ayant un emplois ? 
# (variable " Employed ")
##################################################################################
data(longley)
pairs(longley)

# Les variables GNP.deflator, GNP, Population et Year semblent �tre des variables
# qui permettraient de pr�dire la variable "Employed" avec un bon niveau de pr�cision


# 5)  A l'aide de cette fonction, faites une r�gression du nombre de personnes employ�es 
# en fonction de l'ann�e d'une part (" Year "), et du PNB d'autre part (variable " GNP ").
# Comment interpr�tez-vous ces deux r�gressions ? L'une vous semble-t-elle pr�f�rable 
# � l'autre ? Pourquoi ?
##################################################################################
myReg = lm(Employed ~ Year, longley)
summary(myReg)
plot(Employed ~ Year, longley)
abline(myReg)

myReg = lm(Employed ~ GNP, longley)
summary(myReg)
plot(Employed ~ GNP, longley)
abline(myReg)

# Les deux r�gressions sont globalement significatives. En effet la valeur de p associ�e 
# � la statistique F est dans les deux cas inf�rieure au seuil alpha de 5%. Les deux r�gressions
# pr�sentent une ordonn�es � l'origine significativement diff�rente de z�ro (valeur de p associ�e
# au test t sur l'intercept < 0.05), et une pente de la droite significativement diff�rente de z�ro
# (valeur de p associ�e au test t sur le co�ficient < 0.05). Les deux r�gressions expliquent une tr�s 
# grande proportion de la variabilit� (R2 > 90%. Cependant, la seconde r�gression pr�sentant un R2
# l�g�rement plus �lev�, elle est � privil�gier. 

# 6).	Ajoutez la variable " Armed.Forces " � votre mod�le de r�gression. Cela am�liore-t-il 
# le mod�le ? A-t-on des raisons de conserver cette variable ?
##################################################################################
myReg = lm(Employed ~ GNP +  Armed.Forces, longley)
summary(myReg)

# La variable Armed.forces ne pr�sente pas un co�ficient significativement
# diff�rent de z�ro (valeur de p associ�e � la statistique t > 0.05). On a donc
# aucune raison de maintenir cette variable dans le mod�le.

# 7) Ajoutez la variable " Population " � votre mod�le de r�gression. Cela am�liore-t-il 
# le mod�le ? A-t-on des raisons de conserver cette variable ?
##################################################################################
myReg = lm(Employed ~ GNP + Population, longley)
summary(myReg)

# Cette fois-ci, cette seconde variable am�liore l�g�rement le mod�le. En effet, elle 
# a une pente significativement diff�rente de z�ro au seuil alhpa de 5%, et le R2 est pass� de 0.9674 � 0.9791. 
# On a donc gagn� en pr�dictabilit�. Ce gain est mineur, mais significatif

# 8)	Calculez le taux d'emploi, et �tudiez si l'ann�e, la population totale, 
# les personnes employ�es par l'arm�e, et le PNB permettent de pr�dire le taux 
# d'emplois. Peut-on simplifier ce mod�le ?
##################################################################################
longley$EmpRate = longley$Employed / (longley$Employed + longley$Unemployed)
myReg = lm(EmpRate ~ GNP + Population + Year + Armed.Forces, longley)
summary(myReg)

# On peut simplifier le mod�le en enlevant la variable Population qui n'est pas 
# significative.

myReg = lm(EmpRate ~ GNP + Year + Armed.Forces, longley)
summary(myReg)

# Toutes les variables du mod�le sont significatives. On ne peut plus simplifier.
# On obtient un mod�le final qui est globalement significatif, et qui pr�dit 92.9% de 
# la variabilite. Il faudra en outre v�rifier les conditions d'application de la 
# r�gression lin�aire (cf s�ance suivante)

# 9) A l�aide la fonction plot(myReg, which = 1) et plot(myReg, which = 2) appliqu�e 
# � votre objet r�gression, et du test de Shapiro, v�rifiez les conditions d�application 
# de votre mod�le. Celles-ci vous semblent-elles rencontr�es ?
##################################################################################
plot(myReg, which = 1)
# les r�sidus ont l'air relativement homog�ne, mais le nombre de points, tr�s faible
# ne permet pas de se faire une bonne id�e sur une base graphique.
plot(myReg, which = 2)
shapiro.test(residuals(myReg))
# Le test de Shapiro indique que les r�sidus ne semblent pas s'�carter de la normale.









