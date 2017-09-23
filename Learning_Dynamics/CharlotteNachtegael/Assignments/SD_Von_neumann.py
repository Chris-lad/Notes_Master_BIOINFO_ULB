"""
Snowdrift game with Von Neumann neighbours
"""

import matplotlib.pyplot as plt
import numpy as np
import random


def make_lattice(n):
    lattice = []
    strategy = []
    for i in range(n):
        line_L = []
        line_R = []
        for j in range(n):
            line_L.append(0)
            # 0 for C and 1 for D
            line_R.append(np.random.choice([0,1],p=[0.5,0.5]))
        lattice.append(line_L)
        strategy.append(line_R)
    lattice = np.array(lattice)
    strategy = np.array(strategy)
    return lattice,strategy


def show_plot(strategy):
    plt.imshow(strategy,interpolation='nearest')
    plt.axis('off')
    plt.show()


def get_neighbours_von_neuman(row,col,size):
    x = row
    y = col
    up = x - 1
    right = (y + 1) % size
    down = (x + 1) % size
    left = y - 1

    u = (up, y)
    r = (x, right)
    d = (down, y)
    l = (x, left)

    return [u,r,d,l]


def score(pos, strategy, neighbours, payoff):
    """
    Score for each player, sum of all the payoff of all the neighbours
    :param pos: position of player
    :param strategy: arrays of strategy of the players
    :param neighbours: list of tuples of positions for neighbours
    :param payoff: matrix of payoff
    :return: score
    """
    R = payoff[0]
    S = payoff[1]
    T = payoff[2]
    P = payoff[3]
    x,y = pos
    score = 0

    if strategy[x][y] == 0:
        for neighbour in neighbours:
            a,b = neighbour
            if strategy[a][b] == 0:
                score += R
            else:
                score += S
    else:
        for neighbour in neighbours:
            a,b = neighbour
            if strategy[a][b] == 0:
                score += T
            else:
                score += P

    return score


def update_scores_von_neuman(lattice,strategy,payoff,size):
    """
    Update the lattice with von neumann neighbours
    """
    for i in range(size):
        for j in range(size):
            neighbours = get_neighbours_von_neuman(i,j,size)
            lattice[i][j] = score((i,j),strategy,neighbours,payoff)


def update_strat_von_neuman(lattice,strategy,size):
    new_strategy = np.zeros((size,size))
    for i in range(size):
        for j in range(size):
            a, b = random.choice(get_neighbours_von_neuman(i, j, size))
            prob_to_update = (1 + (lattice[a][b] - lattice[i][j]) / (
            4 * (max(payoff) - min(payoff)))) / 2
            # print(prob_to_update)
            if prob_to_update > 1 or prob_to_update < 0:
                print(lattice[a][b])
                print(lattice[i][j])
            new_strategy[i][j] = np.random.choice([strategy[a][b], strategy[i][j]],
                                                  p=[prob_to_update, 1 - prob_to_update])
    return new_strategy


def plot_coop(cooperation_level,size):
    fig = plt.figure()
    fig.suptitle("Cooperation level Snowdrift game with Von Neumann neighbours\nLattice of "
                 "size %sx%s & Replicator" % (size,size), fontsize=14,
                 fontweight='bold')

    ax = fig.add_subplot(111)

    ax.set_xlabel('Turns')
    ax.set_ylabel('Cooperation level averaged over 100 runs')
    x = np.arange(501)
    cooperation_level_up = np.array(cooperation_level)
    y = np.mean(cooperation_level_up,axis=0)
    ax.plot(x,y)
    ax.set_ylim([0,1])

    plt.show()


def final_distribution(final_coop,size):
    fig = plt.figure()
    fig.suptitle("Distribution of final cooperation levels of\n Snowdrift game with Von "
                 "Neumann Neighbours\nLattice of size %sx%s & Replicator" % (size,size),
                 fontsize=14,
                 fontweight='bold')

    ax = fig.add_subplot(111)

    ax.set_xlabel('Cooperation levels')
    ax.set_ylabel('Number of runs')

    x = np.array(final_coop)

    ax.hist(x,5)
    ax.set_ylim([0,100])
    ax.set_xlim([0,1])

    plt.show()


def main(size,payoff):
    #initiate lattices
    lattice,strategy = make_lattice(size)
    #show_plot(strategy)

    cooperation_level = [((size*size) - np.sum(strategy))/(size*size)]

    #100 turns
    for i in range(500):
        update_scores_von_neuman(lattice,strategy,payoff,size)
        strategy = update_strat_von_neuman(lattice,strategy,size)
        cooperation_level.append(((size*size) - np.sum(strategy))/(size*size))

        #if i == 1 or i == 5 or i == 10 or i == 20 or (i%50)==0:
            #show_plot(strategy)

    return cooperation_level


if __name__ == "__main__":
    #size = int(input("Size of the Lattice: "))
    size = str(input("Size of the lattice: "))
    payoff = str(input("Reward, Sucker's payoff, Temptation to Defect, Punition : "))
    payoff = payoff.strip().split(',')
    for i in range(4):
        payoff[i] = int(payoff[i])

    size = size.strip().split(',')
    for i in range(len(size)):
        size[i] = int(size[i])

    for lattice in size:
        cooperation_level = []
        final_cooperation_level = []
        for i in range(100):
            current = main(lattice, payoff)
            cooperation_level.append(current)
            final_cooperation_level.append(current[-1])
            print(i)
        plot_coop(cooperation_level, lattice)
        final_distribution(final_cooperation_level, lattice)
    #main(size,payoff)