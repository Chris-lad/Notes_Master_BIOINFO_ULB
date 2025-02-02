##################################################################################
## Travaux pratiques: 9�me s�ance: statistiques non param�triques
##################################################################################

# 1) Etude de groupes sanguins aux USA. Les distributions de groupes sanguins sont-elles 
# identiques dans les trois �tats �tudi�s ? 
##################################################################################
# Nous allons faire un test de Chi2
# Cet exercice est plus facile a effectuer dans un tableur
# Voici cependant une solution...

# Stockons d'abord les donn�es dans une matrice
myMObs = matrix(c(122,117,19,244,1781, 1351, 289, 3301,353, 269, 60, 713), 4,3)
# On doit maintenant calculer les fr�quences attendues
myMAtt = myMObs
for (i in 1:3){
for (j in 1:4){
myMAtt[j,i] = sum(myMObs[j,])*sum(myMObs[,i])/sum(myMObs)
}
} 
# Maitenant on calcule le Chi-2
myChi = sum(((myMObs-myMAtt)^2)/myMAtt)
myddl = (3-1)*(4-1)
pchisq(myChi, myddl, lower.tail = F)

# On obtient une valeur de p de 0.536, on ne rejette donc pas H0 et on peut consid�rer
# que la distribution des groupes sanguins est homog�ne aux USA.

# Une autre possibilit� encore, utiliser la fonction chisq.test de R;
chisq.test(myMObs)



# 2) Etudiez cette question � l'aide d'un test de Wilcoxon-Mann-Whitney (appari� 
# ou non-appari� ? Pourquoi ?). Vous pouvez ici utiliser soit la technique vue au 
# cours et calculer vos percentiles avec la fonction pwilcox(), soit utiliser la 
# fonction wilcox.test().
##################################################################################
tol = c(3.420,2.314,1.911,2.464,2.781,2.803)
tem = c(1.820,1.843,1.397,1.803,2.539,1.990)

wilcox.test(c(3.420,2.314,1.911,2.464,2.781,2.803),c(1.820,1.843,1.397,1.803,2.539,1.990))

# L'analyse montre qu'on peut rejetter H0 � un seuil alpha de 5%, car on obtient un 
# une statistique W = 32 associ�e � une valeur de p de 0.0259. On peut donc conclure
# que les deux populations n'ont pas le m�me taux de dopamine. On a utilis� un test 
# non appari� car les mesures on �t� effectu�es sur des individus diff�rents.

# Etude d'un coupe-faim (mCPP) : diminution de poids de sujets apr�s 2 semaines avec 
# mCPP et avec un plac�bo (exp�rience men�e en double aveugle). Etudiez cette question � 
# l'aide d'un test de Wilcoxon-Mann-Whitney (appari� ou non-appari� ? Pourquoi ?). 
##################################################################################
wilcox.test(c(0.0,-1.1,-1.6,-0.3,-1.1,-0.9,-0.5,0.7,-1.2),c(-1.1,0.5,0.5,0.0,-0.5,1.3,-1.4,0.0,-0.8), paired = T)
# On a utilis� un test appari� puisque les observations on �t� effectu�es sur les m�mes
# individus. Ici en revanche, on ne peut pas rejetter H0, puisque la probabilit� associ�e 
# � la statistique V est sup�rieure au seuil alpha de 5%. Il n'y a donc pas de diff�rence
# de perte de poids entre les populations ayant re�u un coupe faim et celles ayant re�u un
# placebo.

