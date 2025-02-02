##################################################################################
## Travaux pratiques: 4�me s�ance: l'ANOVA � 1 facteur
##################################################################################

# 1)	Chargez le jeu de donn�es PlantGrowth
##################################################################################
data(PlantGrowth)
str(PlantGrowth)

# 2)	Affichez les boites de dispersion de la variable weight en fonction de la 
# variable de groupement. 
##################################################################################
boxplot(weight ~ group, data = PlantGrowth)
# Sur une base visuelle, on peut constater que la diff�rence entre le traitement 1
# et le traitement 2 a l'air importante, puisqu'il n'y a pas de recouvrement entre
# les bo�tes de dispersion. Il faudra cependant recourir au test statistique pour
# le prouver avec un seuil de probabilit� d�termin�.

#3)	La fonction ci-dessous r�alise une analyse de variance et stocke les r�sultats 
# de celle-ci dans un objet appel� myAOV :
##################################################################################
myAOV = aov(weight ~ group, data = PlantGrowth)


# 4)	La fonction summary(myAOV) vous permet d'afficher les r�sultats de l'analyse 
# variance. Qu'est-ce qui a �t� test� ici ? Pr�cisez les hypoth�ses H0 et H1. Quelles 
# sont les conclusions que vous pouvez tirer de ce test ?
##################################################################################
summary(myAOV)
# Il s'agit d'une ANOVA � un facteur � 3 niveaux, qui vise � comparer les moyennes
# de poids selon que les �chantillons fassent partie du contr�le, du traitement 1 ou
# du traitement 2
# HO: les moyennes des poids du controle et des deux traitements sont �gales;
# H1: au moins une des moyennes es diff�rente des autres
# On obtient une valeur de p = 0.01591. Il y a donc une probabilit� de 0.01591
# d'obtenir une valeur de F sup�rieure ou �gale � 4.8461 si H0 �tait vrais. On peut 
# donc rejeter H0 au seuil alpha de 5%.

#5)	La fonction residuals(myAOV) vous renvoie les r�sidus de cette analyse. A l'aide 
# des fonctions hist(), qqnorm(), et shapiro.test(), v�rifiez la normalit� des r�sidus 
# de l'ANOVA.
##################################################################################
hist(residuals(myAOV))
qqnorm(residuals(myAOV))
qqline(residuals(myAOV))
shapiro.test(residuals(myAOV))
# Les quantiles des r�sidus ne sont pas parfaitement align�s sur la droite 
# de correspondance avec les quantiles d'une distribution normale. On a donc recours
# au test de Shapiro, dont H0: la variable suit une loi normale. La valeur de p du test
# �tant �gale � 0.4379, on ne rejette pas H0 au seuil alpha de 5%. Les conditions d'application
# de l'ANOVA sont donc respect�es du point de vue de la normalit� des r�sidus.  


# 6)	La fonction bartlett.test(weight ~ group, data = PlantGrowth), va nous permettre de 
# v�rifier l'homog�n�it� des variances. Quelles sont les hypoth�ses H0 et H1 de ce test ? 
# Dans ce cas ci, les variances peuvent-elles �tre consid�r�es comme �gales ?
##################################################################################
bartlett.test(weight ~ group, data = PlantGrowth)
# H0: les variances des trois groupes sont �gales
# H1: au moins une des variance diff�re des deux autres
# Oui, car la valeur de p > 0.05 nous indique que l'on ne rejette pas H0 au seuil
# alpha de 5%. Les conditions d'application de l'ANOVA sont donc respect�es du point 
# de vue de l'homosc�dasticit� (homog�n�it� des variances). 

# 7)	Chargez le jeu de donn�es InsectSprays et en utilisant les m�mes codes que dans 
# l'exemple pr�c�dent, testez l'effet des insecticides sur les nombres d'insectes observ�s. 
# V�rifiez la normalit� des r�sidus et l'homosc�dasticit�. Avant m�me de proc�der au test 
# de Bartlett, les variances semblent-elles �gales ?
##################################################################################
data(InsectSprays)
boxplot(count ~ spray, InsectSprays)
# On voit d�j� sur le boxplot que certains niveaux de la variable spray ont 
# des variabilit�s tr�s diff�rentes (indiqu�es par l'espace interquartile). Par eexemple,
# les niveaux C, D et E, ont apparement des variabilit�s beaucoup plus faibles que les 
# niveaux A, B et F
myAOV = aov(count ~ spray, InsectSprays)
summary(myAOV)
# L'analyse des variance montre un effet significatif du type de spray sur les 
# moyennes de nombres d'insectes.
hist(residuals(myAOV))
shapiro.test(residuals(myAOV))
# La valeur de p du test de Shapiro nous permet de rejetter H0 au seuil alpha de 5%, 
# les r�sidus ne suivent donc pas une loi normale.
bartlett.test(count ~ spray, InsectSprays)
# Le test de Bartlett nous permet �galement de rejetter H0; les variance des diff�rents 
# niveaux ne sont donc pas �gales.


#8)	Essayez de tester l'effet d'une transformation des variables (transformation racine,
# et log), ceci am�liore-t-il la normalit� des r�sidus ? Et l'homosc�dasticit� ?
##################################################################################
# Transformation racine
InsectSprays$Sqrt = sqrt(InsectSprays$count)
boxplot(Sqrt ~ spray, InsectSprays)
myAOV = aov(Sqrt ~ spray, InsectSprays)
summary(myAOV)
hist(residuals(myAOV))
shapiro.test(residuals(myAOV))
bartlett.test(Sqrt ~ spray, InsectSprays)
# Transformation Log
InsectSprays$Log = log10(InsectSprays$count + 1)
boxplot(Log ~ spray, InsectSprays)
myAOV = aov(Log ~ spray, InsectSprays)
summary(myAOV)
hist(residuals(myAOV))
shapiro.test(residuals(myAOV))
bartlett.test(Log ~ spray, InsectSprays)
# Oui, les deux types de transformation on permit de normaliser les r�sidus de l'ANOVA;
# et d'am�liorer l'homosc�dasticit� des r�sidus, puisque les valeurs de p des deux tests
# ne permettent pas de rejetter H0 pour les deux tests (Shapiro et Bartlett).

# 9.  Chargez le package MASS en tapant :
##################################################################################
library(MASS)
# 10.	Chargez � pr�sent le jeu de donn�es " cabbages ". Quelle-est l'exp�rience r�alis�e 
# ici ? D�crivez ce jeu de donn�es (statistiques et/ou graphes descriptifs). Sur cette base, 
# pensez-vous qu'il y ait un effet du cultivar et de la date sur le poids des choux et sur 
# leur contenance en vitamines C ? Avant de proc�der aux analyses, pensez-vous qu'il y ait 
# une interaction entre la date et le cultivar dans leur effet sur les poids de choux, et 
# sur le taux de vitamines C ? Pourquoi ?
##################################################################################
data(cabbages)
# Il s'agit d'une exp�rience dans laquelle deux variables quantitatives ont �t� mesur�es
# sur des choux (le poids et le taux de vitamine C), en fonction de deux types de cultivars
# (variable qualitative 1) et de dates (variable qualitative 2).

# A) Analyse des poids
boxplot(HeadWt ~ Cult, cabbages)
# Les choux du cultivar c39 semblent avoir un poids plus �lev� que ceux du cultivar c52
# mais comme il y a recouvrement entre les bo�tes de dispersion, il va falloir recourir
# au test statistique pour v�rifier si cette diff�rence est significative
boxplot(HeadWt ~ Date, cabbages)
# La date de plantation n'a pas un effet clair sur le poids. Les boites de dispersion 
# se recouvrent, il est difficile de se prononcer sans un recours au test
boxplot(HeadWt ~ Date + Cult, cabbages)
# Il semble il y avoir un effet d'interaction entre le cultivar et la date
# en effet, la s�rie des trois dates du cultivar c39 ne montrent pas une tendance
# similaire � la s�rie des trois dates du cultivar c52, pour lequel la date d20 donne clairement
# un poids plus important des choux.

# A) Analyse des taux de vitamine C
boxplot(VitC ~ Cult, cabbages)
# Le cultivar c52 semble avoir le taux de vitamines C le plus �lev�. A v�rifier par les tests.
boxplot(VitC ~ Date, cabbages)
# La date de plantation n'a pas un effet clair sur le taux de vitamines C
# Les boites de dispersion se recouvrent, il est difficile de se prononcer sans un recours au test
boxplot(VitC ~ Date + Cult, cabbages)
# Les boites de dispersion en fonction des deux facteurs montrent qu'il semble ily avoir � la fois
# un effet cultivar (la serie des trois dates du c39 semblent avoir des taux plus faible que la 
# s�rie des trois dates du c52), et un effet date (pour les deux cultivars, la troisi�me date 
# semblent avoir le taux de vitamines C le plus �lev�)

# 11.	Faites une ANOVA � deux facteurs (mod�le complet avec terme d'interaction) pour comparer 
# les moyennes de poids (variable HeadWt) en fonction du cultivar et de la date. Que pouvez-vous
# constater sur base des r�sultats ? 
##################################################################################
myAOV = aov(HeadWt ~ Date + Cult + Date:Cult, cabbages)
summary(myAOV)
# Ici, on a test� simultan�ment l'effet date, cultivar et l'interaction entre ces deux facteurs
# sur le poids des choux. On constate un effet date significatif (on peut donc rejeter H0: les moyennes 
# des trois dates sont les m�mes), un effet cultivar significatif (on rejette H0: les moyennes des deux cultivars
# sont �gales), et un effet d'interaction (on rejette H0: il n'y a pas d'interaction entre les facteurs), ce qui
# veut dire qu'il existe certaines dates pour lesquelles l'effet cultivar est diff�rent)

# 12.	Sur base des ce qui a �t� vu � la s�ance pr�c�dente de travaux pratiques, v�rifiez 
# les conditions d'application de l'ANOVA
##################################################################################
shapiro.test(residuals(myAOV))
# La valeur de p >= au seuil alpha de 0.05, on ne rejette donc pas H0: la distribution des r�sidus ne 
# diff�re pas de celle d'une loi normale
bartlett.test(HeadWt ~ Cult, cabbages)
# La valeur de p >= au seuil alpha de 0.05, on ne rejette donc pas H0: les variance des diff�rents cultivars 
# ne sont pas diff�rentes
bartlett.test(HeadWt ~ Date, cabbages)
# La valeur de p >= au seuil alpha de 0.05, on ne rejette donc pas H0: les variance des diff�rentes dates 
# ne sont pas diff�rentes

# 13.	A l'aide de la fonction TukeyHSD, r�alisez les tests de comparaison multiple sur cette analyse de 
# variance. Comment interpr�tez-vous ces r�sultats ?
TukeyHSD(myAOV)
# Au niveaux des dates: on ne trouve pas de diff�rence significative entre les moyennes des dates d20 et d16, 
# les diff�rence entre les autres dates sont toutes deux significatives.
# Au niveau des cultivars, on observe bien un diff�rence significative entre les poids moyens des deux cultivars.
# Au niveaux des combinaisons des facteurs, les combinaisons suivantes pr�sentent une diff�rence significative 
# entre les moyennes des poids au seuil alpha de 5%:
# d16:c52-d16:c39
# d21:c52-d16:c39
# d21:c52-d20:c39
# d21:c52-d21:c39
# d21:c52-d20:c52
# Toutes les autres combinaisons ne pr�sentent pas de diff�rence de moyenne significative

# 14.	R�p�tez l'analyse (points 3 � 5), mais en �tudiant cette fois la contenance en vitamines C (VitC). 
# Les r�sultats sont-ils comparables ? 
##################################################################################
myAOV = aov(VitC ~ Date + Cult + Date:Cult, cabbages)
summary(myAOV)
shapiro.test(residuals(myAOV))
bartlett.test(VitC ~ Cult, cabbages)
bartlett.test(VitC ~ Date, cabbages)
TukeyHSD(myAOV)
# Non, dans ce cas ci, seuls les effets Cultivar et Dates sont significatifs, et le terme d'interaction
# ne l'est pas, puisque la valeur de p associ�e � la statistique F est sup�rieure au seuil alpha de 5%.
# L'analyse des r�sidus nous montre que les conditions d'application de l'ANOVA sont remplies.
# Les test post-hoc nous montrent que
# Au niveaux des dates: on ne trouve pas de diff�rence significative entre les moyennes des dates d20 et d16, 
# les diff�rence entre les autres dates sont toutes deux significatives.
# Au niveau des cultivars, on observe bien un diff�rence significative entre les taux moyens de vitamine C des deux cultivars.
# Au niveaux des combinaisons des facteurs, les combinaisons suivantes pr�sentent une diff�rence significative 
# entre les moyennes des taux en vitamines C au seuil alpha de 5%:
# d16:c52-d16:c39
# d21:c52-d16:c39
# d16:c52-d20:c39
# d20:c52-d20:c39
# d21:c52-d20:c39
# d21:c52-d21:c39
# d21:c52-d16:c52
# d21:c52-d20:c52
# Toutes les autres combinaisons ne pr�sentent pas de diff�rence de moyenne significative

# 15.	Quel cultivar et quelle date de plantation recommanderiez-vous en fonction de ces analyses ?
##################################################################################
# La combinaison d20.c52 semble la meilleure puisqu'elle pr�sente un poids moyen
# �lev� tout en ayant �galement un taux important en vitamines C. 







