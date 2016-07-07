import os, argparse, operator, random, copy

LIMIT = 30

def get_dist(v1, v2):
    dist = 0
    for i in range(len(v1)-1):
        dist += ((v1[i]-v2[i])*(v1[i]-v2[i]))
    return dist

def get_k_neighbors(k, v, all_data):
    chossen = []
    cur_set = copy.copy(all_data)
    cur_set.remove(v)

    while len(chossen) < k:

        mini_dist = float("inf")
        cur_chossen = None

        for u in cur_set:

            dst = get_dist(v, u)

            if dst < mini_dist:

                mini_dist = dst
                cur_chossen = u

        chossen.append(cur_chossen)
        cur_set.remove(cur_chossen)

    return chossen

def interpolate(v, nei):
    vec = map(operator.sub, nei[:-1], v[:-1])
    if nei[-1] == v[-1]:
        rnd = random.random()
    else:
        rnd = random.uniform(0, 0.5)

    npoint = map(operator.add, v[:-1], map(operator.mul, [rnd for i in range(len(v)-1)], vec))
    npoint.append(v[-1])
    return tuple(npoint)

def define_new_points(c2_set, all_data, c1_len, k):
    extra = c1_len - len(c2_set)

    extra_c2 = []

    cnt = 0

    while extra > 0:
        rnd_v = random.choice(c2_set)

        k_neighbors = get_k_neighbors(k, rnd_v, all_data)

        while True:
            rnd_neighbor = random.choice(k_neighbors)
            npoint = interpolate(rnd_v, rnd_neighbor)
            if npoint not in extra_c2:
                print(npoint)
                extra_c2.append(npoint)
                extra -= 1
                break
            elif cnt > LIMIT:
                break
            else:
                cnt += 1
        cnt = 0

    return extra_c2

if __name__ == '__main__':

    #Arguments
    parser = argparse.ArgumentParser()

    parser.add_argument('C1', help = 'Class 1 file name', type = str)
    parser.add_argument('C2', help = 'Class 2 file name', type = str)
    parser.add_argument('K', help = 'The K for the k-neighbors', type = int)

    args = parser.parse_args()

    c1_file = open(args.C1)
    c2_file = open(args.C2)
    c2_extra = open('c2_adapted_smote.csv', 'w')
    c1_set = []
    c2_set = []

    for line in c1_file:
        data = tuple([float(val) for val in line.split(',')])
        c1_set.append(data)
    for line in c2_file:
        data = tuple([float(val) for val in line.split(',')])
        c2_set.append(data)

    all_data = c1_set + c2_set

    new_c2_set = c2_set + define_new_points(c2_set, all_data, len(c1_set), args.K)

    c1_file.close()
    c2_file.close()

    each_row_str = []
    for row in new_c2_set:
        each_row_str.append(','.join([str(val) for val in row]))

    c2_extra.write('\n'.join(each_row_str))
    c2_extra.close()
