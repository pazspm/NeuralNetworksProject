import sys, re, argparse

if __name__ == '__main__':

    #Arguments
    parser = argparse.ArgumentParser()

    parser.add_argument('files', help = 'Paths to each file to process', type = argparse.FileType('r'), nargs = '+')
    parser.add_argument('-flag', help = 'Indicates if it is not to print the file name', action = 'store_true', default = False)

    args = parser.parse_args()

    for file_obj in args.files:
        mses = []
        index = [0, 2, 1, 3]
        aucs = [0, 0, 0, 0]
        ind = 0
        pattern = re.compile('\d+\.\d+')
        for line in file_obj:
            if 'MSE' in line or 'AUC-' in line:
                match = pattern.search(line)
                if match:
                    if 'MSE' in line:
                        mses.append(match.group())
                    else:
                        aucs[index[ind]] = match.group()
                        ind += 1
        name = [file_obj.name]
        if args.flag:
            name = []
        print('\t'.join(([str(val) for val in (name + mses + aucs)])))
