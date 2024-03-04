
from typing import Iterable, List
import csv


def read_cd(path: str) -> Iterable[List[str]]:
    """Opens a file."""
    with open(path, "r") as source:
        for line in source:
            yield line.rstrip()


def main() -> None:
    celex = read_cd("data/epw.cd")
    celex_dict = {}
    for line in celex:
        word = line.split("\\")[1]
        pron = line.split("\\")[6]
        celex_dict[word] = pron

    nettalk = read_cd("data/nettalk/nettalk.data")
    nettalk_dict = {}
    for line in nettalk:
        myline = line.split("\t")
        if len(myline) != 4:
            continue
        word = line.rstrip().split("\t")[0]
        pron = line.rstrip().split("\t")[1]
        nettalk_dict[word] = pron

    with open("data/celex_nettalk.tsv", "w") as sink:
        for word in celex_dict.keys():
            if word in nettalk_dict.keys():
                row = f"[grapheme]{word}", f"[celex]{celex_dict[word]}", f"[nettalk]{nettalk_dict[word]}"
                writer = csv.writer(sink, delimiter="\t")
                writer.writerow(row)


if __name__ == "__main__":
    main()
