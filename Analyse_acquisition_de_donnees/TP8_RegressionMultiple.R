##################################################################################
## Travaux pratiques: 7�me s�ance: la r�gression lin�aire II
##################################################################################

# 1) Charge le jeu de donn�es (chemin d'acces a mettre a jour)
##################################################################################
myD = read.delim("http://www.ulb.ac.be/sciences/lubies/downloads/ips.txt")
myD = na.omit(myD)

# 2.  Construire un nouvelle variable appel�e LGIT qui comprends le logarithme en 
# base 10 (fonction log10()) de la variable myD$AVIT. A l'aide de la fonction as.factor(), 
# convertissez ensuite la variable myD$SUP en facteur.
##################################################################################
myD$LOGIT = log10(myD$AVIT + 1)
myD$SUP = as.factor(myD$SUP)

# 3.	Nous allons tout d'abord cartographier les sites de capture � l'aide des coordonn�es. 
#La seconde ligne de commande repr�sente des points avec une taille proportionnelle � la variable LGIT
##################################################################################
plot(Y_COORD ~ X_COORD, myD, pch = 16, col = rgb(0.5,0.5,1,0.3)) 
plot(Y_COORD ~ X_COORD, myD, pch = 16, col = rgb(0.5,0.5,1,0.3), cex = myD$LOGIT)

# 4.  A l'aide de la fonction lm(), construisez un mod�le de r�gression multiple 
# qui pr�dit le nombre d'ips (variable AVIT) en fonction de toutes les variable 
# pr�dictives, � l'exception de SUP et des coordonn�es X_COORD et Y_COORD. Appelez 
# ce mod�le myFullReg et affichez le r�sum� de ce mod�le. Ce mod�le est-il satisfaisant ? Pourquoi ? 
##################################################################################
myReg = lm(AVIT ~ ACCQT + CLCC + CLCM + CLCF + OUVQL + EPIQLP + EPIQLD + MARR04 + MARR05, data = myD)
summary(myReg)

# Ce mod�le n'est pas satisfaisant car il comprends de nombreuses variables non significatives
# qui ne contribuent donc pas utilement � la pr�diction du nombre de scolytes.

# 5.	Les fonctions suivantes vous permettent d'afficher le graphique quantile-quantile 
# des r�sidus, et le graphique des r�sidus. Les r�sidus se distribuent-il de mani�re normale ? 
# Sont-ils homog�nes ?
##################################################################################
plot(myReg, which = 1)
plot(myReg, which = 2)

# Les r�sidus ne suivent clairement pas une distribution normale, puisqu'ils ne s'alignent
# pas du tout le long d'une ligne d'�quivalence entre quantiles des r�sidus et quantiles d'une
# distribution normale. Par ailleurs, nous ne sommes pas non plus dans des conditions d'homosc�dasticit�,
# en effet, la variabilit� des r�sidus augmente en m�me temps que les valeur pr�dite (forme de c�ne du 
# graphique des r�sidues).

# 6.	Construisez � pr�sent le m�me mod�le, mais en mod�lisant cette fois le 
# logarithme des captures (LGIT) et v�rifiez � l'aide des deux graphiques illustr�s 
# au point pr�c�dent si les conditions d'application ont �t� am�lior�es.
##################################################################################
myReg = lm(LOGIT ~ ACCQT + CLCC + CLCM + CLCF + OUVQL + EPIQLP + EPIQLD + MARR04 + MARR05, data = myD)
summary(myReg)
plot(myReg, which = 1)
plot(myReg, which = 2)
# La transformation log10 a clairement am�lior� les choses du point de vue de l'homosc�dasticit�
# et de la normalit� des donn�es. Le graphique des r�sidus pr�sente maintenant une r�partition 
# plus homog�ne au fur et � mesure que les valeurs pr�dites augmentent. Pour v�rifier la normailit� 
# des r�sidus de mani�re plus formelle, nous pourrions r�aliser un test de Shapiro.

# 7.	Simplifiez le mod�le en enlevant successivement, pas � pas, les variables les moins 
# significatives (variables qui ont la valeur de t la plus faible en valeur absolue, et la 
# valeur de p la plus grande), jusqu'� aboutir � un mod�le dans lequel toutes les variables 
# sont significatives. A quel mod�le aboutissez-vous ? Pensez-vous qu'il s'agisse d'un bon mod�le ?
##################################################################################
myFullReg = lm(LOGIT ~ ACCQT + CLCC + CLCM + CLCF + OUVQL + EPIQLP + EPIQLD + MARR04 + MARR05, data = myD)
summary(myFullReg)
myReg = lm(LOGIT ~ ACCQT + CLCC + CLCM + CLCF + OUVQL + EPIQLP + EPIQLD + MARR05, data = myD)
summary(myReg)
myReg = lm(LOGIT ~ ACCQT + CLCM + CLCF + OUVQL + EPIQLP + EPIQLD + MARR05, data = myD)
summary(myReg)
myReg = lm(LOGIT ~ CLCM + CLCF + OUVQL + EPIQLP + EPIQLD + MARR05, data = myD)
summary(myReg)
myReg = lm(LOGIT ~ CLCM + OUVQL + EPIQLP + EPIQLD + MARR05, data = myD)
summary(myReg)
myReg = lm(LOGIT ~ CLCM + OUVQL + EPIQLP + MARR05, data = myD)
summary(myReg)
# Oui et non. Le mod�le est le meilleurs que nous puissions avoir avec les variables dont nous
# disposons puisque toutes les variables du mod�le sont significatives. Le mod�le est globalement significatif,
# mais la proportion de variabilit� pr�dite est relativement faible, avec seulement 33.3%.

# 8.	La fonction step() permet d'automatiser la proc�dure de s�lection des variables. Reprenez 
# le mod�le de r�gression myFullReg du point 4, et utilisez ensuite la fonction suivante. 
# L'algorithme a-t-il abouti au m�me mod�le que vous ?
##################################################################################
myStepReg = step(myFullReg, direction = "both")
summary(myStepReg)
# Non, la proc�dure step a �t� plus prudente dans l'exclusion des variables et nous pr�sente
# un mod�le avec certaines variables qui sont proches du seuil de significativit�. Nous aurions 
# int�r�t � simplifier encore ce mod�le en enlevant les variables OUVQL et EPIQL (pour autant 
# que cette derni�re ne soit toujours pas significative apr�s avoir enlev� OUVQL).

# 9.	Ajoutez � pr�sent la variable support (SUP) � votre mod�le trouv� au point 7, et 
# appelez ce mod�le myFinalReg. Comme vous l'avez vu au point 1, il s'agit d'une variable 
# qualitative � trois niveaux. En examinant le summary() de votre mod�le, comment cette 
# variable a-t-elle �t� incorpor�e ?
##################################################################################
myFinalReg = lm(LOGIT ~ SUP + CLCM + OUVQL + EPIQLP + MARR05, data = myD)
summary(myFinalReg)
plot(myFinalReg, which = 1)
plot(myFinalReg, which = 2)
# La variable SUP a �t� incorpor�e via l'ajout de 2 nouvelles variables binaires (0/1)
# qui d�crivent si l'on est un support de type 2 (SUP2), ou de type 3 (SUP3), sachant
# que si l'on est ni SUP2, ni SUP3, on est forc�ment SUP1.

# 10.	La ligne de commande suivante vous permet d'afficher une analyse de variance 
# sur votre r�gression. Quelle diff�rence pouvez-vous observer par rapport au summary() 
# de votre mod�le.
##################################################################################
summary(aov(myFinalReg))
# Cette analyse nous permet de montrer que la variable SUP (tous niveaux confondus)
# est globalement significative dans le mod�le. 


# 11. Nous allons � pr�sent installer une librairie suppl�mentaire, appell�e ncf, la charger,
# puis calculer le corr�logramme des r�sidus de cette r�gression. Selon-vous, qu'est-ce qui est 
# repr�sent� ici ?
##################################################################################
install.packages("ncf")
library("ncf")
myD$res = residuals(myFinalReg)
myCorr <- correlog(myD$X_COORD, myD$Y_COORD, myD$res,na.rm=T, increment=500,resamp=0, latlon = F)
plot(myCorr$mean.of.class[1:30],myCorr$correlation[1:30], ylim = c(-0.1,1), type = "b", xlab = "distance (m)", ylab = "correlation")

# Ce corr�logramme montre comment l'autocorr�lation spatiale des r�sidus diminue en fonction 
# de la distance qui s�pare les points. Les points s�par�s par des distance de 500 m (premier point)
# du graphique ont une corr�lation de 0.5, dont les r�sidus voisins g�ographiquement ne sont 
# pas ind�pendants. En revanche, les points s�par�s par des distance > 2500 m ont une
# autocorr�lation spatiale proche de z�ro. Il y aurait donc lieu, de soit sous-�chantillonner 
# pour ne conserver que les points s�par�s par des distance > 2500 m, soit de construire un mod�le
# adapt� pour prendre en compte cette autocorr�lation spatiale (pas vu au cours).





