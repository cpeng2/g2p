#!/usr/bin/env python

import argparse
from typing import Iterable, List
import logging
import re


def read_cd(path: str) -> Iterable[List[str]]:
    """Opens a file."""
    with open(path, "r") as source:
        for line in source:
            yield line.strip()


def main(args: argparse.Namespace) -> None:
    """
    Compares test data and predictions and
    computes word error rate.
    """
    correct = 0
    incorrect = 0
    test_data = read_cd(args.test)
    # "data/ady/ady_test.tsv"
    prediction = read_cd(args.pred)
    # "results/ady_attentive_lstm_144/pred_attentive_lstm_144"
    for label, pred in zip(test_data, prediction):
        match = re.match(r"(^\w+)(.+)", label)
        pron = match.group(2).lstrip()
        if pron == pred:
            correct += 1
        else:
            incorrect += 1
            logging.info(pron)
            logging.info(pred)
    wer = incorrect/(correct + incorrect)
    logging.info(f"Word Error Rate: {wer:.4f}")


if __name__ == "__main__":
    logging.basicConfig(level="INFO", format="%(levelname)s: %(message)s")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("test", help="input test file path")
    parser.add_argument("pred", help="input prediction file path")
    main(parser.parse_args())
