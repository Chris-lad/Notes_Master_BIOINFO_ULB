##################################################################################
## Travaux pratiques: 3�me s�ance: rappel sur les tests d'hypoth�se et le test
## de Student
##################################################################################

#1) Chargez le jeu de donn�es iris
##################################################################################
data(iris)
str(iris)

#2) Calculez i) la moyenne de la longueur de s�pales (que vous appellerez SepMn), 
# l'�cart-type de cette moyenne (SepSd) et les bornes sup�rieures (SepMnUpperCI) 
# et inf�rieures (SepMnLowerCI) de l'intervalle de confiance de cette moyenne.  
# Calcul de la Moyenne
##################################################################################
SepMn = mean(iris$Sepal.Length)
# Calcul de l'�cart-type
SepSd = sd(iris$Sepal.Length)
# Calcul de l'intervalle de confiance avec t de Student
myIC = qt(0.975, 149)* SepSd/(150^0.5)
# Calcul de la borne sup�rieure de l'intervalle de confiance
SepMnUpperCI = SepMn + myIC
# Calcul de la borne inf�rieure de l'intervalle de confiance
SepMnLowerCI = SepMn - myIC

#3) Selon vous, cette moyenne diff�re-t-elle significativement de 0, pourquoi ? 
##################################################################################
# Oui, cette moyenne diff�re signiticativement de z�ro puisque 
# l'intervalle de confiance � 95% n'inclu pas z�ro 

# 4)	R�alisez une boite de dispersion de la longueur de s�pales en fonction de l'esp�ce. 
# Les longueurs de s�pale sont-elles semblables entre les esp�ces ?
##################################################################################
boxplot(Sepal.Length ~ Species, data = iris)
# Non, les m�dianes des longueurs de s�pale sont diff�rentes selon les esp�ces
# En outre, les bornes des boites de dispersion (permier et troisi�me quartiles)
# de l'esp�ce setosa et versicolor ne se recoupent pas, il est donc tr�s probable
# que ces diff�rences soient significatives. Il y a un faible recouvement entre les limites
# des boites de dispersion de versicolor et virginica, et la diff�rence entre ces deux esp�ces 
# semble donc moins importante.

#5) Construisez un jeux de donn�e par esp�ce, � l'aide de la fonction subset(). 
##################################################################################
Ver = subset(iris, Species == "versicolor")
Set = subset(iris, Species == "setosa")
Vir = subset(iris, Species == "virginica")

#6)	Calculez la moyenne, l'�cart-type, et les bornes sup�rieures et inf�rieures 
# de l'intervalle de confiance pour la longueur de s�pales des individus de l'esp�ce 
# I. versicolor, et de l'esp�ce I. setosa. 
##################################################################################
# Versicolor
VerMean = mean(Ver$Sepal.Length)
VerSD = sd(Ver$Sepal.Length)
VerIC = qt(0.975, 49)* VerSD/(50^0.5)
VerUpperIC = VerMean + VerIC
VerLowerIC = VerMean - VerIC
# Setosa
SetMean = mean(Set$Sepal.Length)
SetSD = sd(Set$Sepal.Length)
SetIC = qt(0.975, 50)* SetSD/(50^0.5)
SetUpperIC = SetMean + SetIC
SetLowerIC = SetMean - SetIC

# 7)	Selon vous, les moyennes de longueur de s�pale de ces deux esp�ces peuvent-elles
# �tre �gales ? Justifiez votre r�ponse sur base des valeurs estim�es au point 6)
##################################################################################
# Lorsque l'on construit les intervalle des confiance autour de ces deux
# moyennes, on constate qu'il n'y a pas de recouvrement, il est donc extr�mement 
# peu probable que ces moyennes soient �gales.

# 8)	La fonction t.test() permet de faire un test t de comparaison de moyenne entre 
# deux s�ries d'observations. A l'aide des jeux de donn�es cr��s au point 5) faites les 
# tests suivants pour comparer les longueurs de s�pales:
#a.	Comparaison de moyenne de  I. versicolor et de I. setosa, test bilat�ral
#b.	Comparaison de moyenne de  I. versicolor et de I. setosa, test unilat�ral
#c.	Comparaison de moyenne de  I. versicolor et de I. virginica, test bilat�ral
#d.	Comparaison de moyenne de  I. virgnica et de I. setosa, test bilat�ral
##################################################################################
#8.1) Test t de comparaison de moyennes
t.test(Ver$Sepal.Length, Set$Sepal.Length)
# On rejette H0 au profit de H1: les moyennes sont diff�rentes
#8.2)
t.test(Ver$Sepal.Length, Set$Sepal.Length, alternative = "greater")
# On rejette H0 au profit de H1: la moyenne des longueurs de s�pales de Versicolor 
# est sup�rieure � celle de Setosa
#8.3)
t.test(Ver$Sepal.Length, Vir$Sepal.Length)
# On rejette H0 au profit de H1: les moyennes sont diff�rentes
#8.4)
t.test(Vir$Sepal.Length, Set$Sepal.Length)
# On rejette H0 au profit de H1: les moyennes sont diff�rentes

# 9) Tapez les commandes suivantes
##################################################################################
myseq = seq(from = -15, to = 15,by = 0.1)
plot(myseq, dt(myseq, 86.538), type = "l",
ylim = c(0,0.5), xlim = c(-15,15),
ylab = "Density", xlab = "Quantile")

# 10)	Selon vous, qu'est-ce qui est repr�sent� ici ?  
##################################################################################
# Ce qui est repr�sent� ici, c'est la distribution des valeurs prises par la
# distribution t de Student sous H0 pour le premier des tests t r�alis�s ci-dessus. 
# On peut reporter la valeur de la statistiques observ�e pour ce test t = 10.521
# sur l'axe des x, et constater qu'obtenir une telle valeur de t sous H0 est hautement 
# improbable, et bien � droite de la valeur de t correspondant � un seuil alpha de 0.05,
# ce qui confirme que l'on a bien une diff�rence significative entre les deux moyennes.
 

# 11)  A l�aide de la fonction �power.t.test()� faite un calcul de puissance du test t, 
# pour une diff�rence de moyenne de 1, et un �cart-type correpondant � la moyenne des 
# �cart-types des 3 esp�ces. La puissance du test vous semble-t-elle bonne ? 
##################################################################################
# Calcul de la moyenne des trois �cart-types
meansd = mean(sd(Vir$Sepal.Length),sd(Set$Sepal.Length),sd(Ver$Sepal.Length))
# Calcul de la puissance avec 50 observations par �chantillon, et un effet de 1
power.t.test(50, delta = 1, sd = meansd)
# Oui, on a une puissance qui vaut 1, donc il serait impossible de passer � c�t� d'un tel
# effet.

# Quelle serait cette puissance s�il n�y avait que 5 mesures par esp�ce ?
##################################################################################
power.t.test(5, delta = 1, sd = meansd)
# La puissance serait r�duite � 0.58, donc il y aurait une assez grande probabilit�
# (p = 0.411) de se tromper en concluant � l'absence d'effet avec un �chantillon de
# si petite taille.



