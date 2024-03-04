#!/usr/bin/env python

import pandas as pd
from sklearn.model_selection import train_test_split


def main() -> None:

    # Read the TSV file
    file_path = 'data/celex_nettalk.tsv'
    df = pd.read_csv(file_path, sep='\t')

    # Split the data into train, dev, and test sets
    train, temp = train_test_split(df, test_size=0.2, random_state=42)
    dev, test = train_test_split(temp, test_size=0.5, random_state=42)

    # Save the splits to new TSV files
    train.to_csv('data/celex_nettalk/train.tsv', sep='\t', index=False)
    dev.to_csv('data/celex_nettalk/dev.tsv', sep='\t', index=False)
    test.to_csv('data/celex_nettalk/test.tsv', sep='\t', index=False)


if __name__ == "__main__":
    main()