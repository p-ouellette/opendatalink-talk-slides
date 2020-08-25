---
author: Paul Ouellette and Justin Fargnoli
title: Open Data Link
subtitle: A dataset search engine for open data
---

## Open Data Link

- Dataset search engine for open data.

- Search methods:

    - Semantic keyword search

    - Joinable table search

    - Unionable table search

## Motivation

- Governments and other organizations publish a lot of open data, but discovery
  is still difficult.

- Data scientists can identify ways to integrate datasets.

- Data publishers can see the wider context of their data.

## Demo

## Outline

\tableofcontents

# System overview

## System overview

\begin{figure}
\includegraphics[scale=0.35]{system_overview.png}
\end{figure}

## Dataset crawl

- 10k of 42k datasets on Socrata.

- 172k columns.

- Most datasets are small.

- Largest datasets have over 100 million rows.

# Joinable table search

## Joinable table search

\begin{figure}
\includegraphics[scale=0.43]{join_example.png}
\end{figure}

## Joinable table search

- Attributes are treated as sets.

- Sets are encoded with minhash data sketches.

- A table T is joinable with the query U if
  $Containment(X \in T, Q \in U) \geq t$.

- We use an LSH index for fast querying.

## Minhash[^broder]

- Data sketch for estimating Jaccard similarity of sets.

$$J(S, T)=\frac{|S \cap T|}{|S \cup T|}$$

- A minhash signature is composed of the results of a number of minhashes.

- The probability that the minhashes for two sets are the same equals the
  Jaccard similarity of the sets[^mmds].

- Minhash LSH hashes similar signatures to the same bucket.

[^broder]: A. Broder, "On the Resemblance and Containment of Documents",
  Compression and Complexity of Sequences 1997.
[^mmds]: Mining of Massive Datasets, Chapter 3.

## LSH Ensemble[^zhu]

- Set containment is a better measure for computing joinability.

$$C(Q, X)=\frac{|Q \cap X|}{|Q|}$$

- We can convert Jaccard similarity to containment, given the sizes of the
  domains.

- The size of the indexed domain is not constant, so domains are partitioned by
  cardinality.

- A minhash LSH index is constructed for each partition.

[^zhu]: Erkang Zhu, Fatemeh Nargesian, Ken Q. Pu, Renée J. Miller, "LSH
  Ensemble: Internet-Scale Domain Search", VLDB 2016.

# Unionable table search

## Unionable table search

\begin{figure}
\includegraphics[scale=0.43]{union_example.png}
\end{figure}

## Unionable table search

- The LSH Ensemble index is queried for each column of the query table.

- Candidate tables are those that appear in $\geq{40\%}$ of the joinability
  queries.

- Candidates are ranked by alignment: the fraction of candidate columns that are
  unionable with a query column.

# Semantic Keyword Search

## Semantic Keyword Search

 - Problem: Given a list of keywords, return top-k similar datasets

 - Motivation: Data scientists want a simple way to find new and insightful 
 datasets

## Our Approach

- Search on the metadata, not on the data in the dataset
  - Data in dataset is too noisy

- Metadata that we have:

  - Dataset description

  - Column description

  - Datasets tags

## Our Approach (Cont.)

- Use semantic similarity 

  - Example: Fish & Seafood

  - Example: Coronavirus & Respitory System

## Others Approach

 - Google Dataset Search

\begin{figure}
\includegraphics[scale=0.2]{google_dataset_search.png}
\end{figure}

## System Overview

- FastText: word in dataset's metadata -> embedding vector

- SimHash: embedding vector -> bit vector

- Locality Sensitive Hashing (LSH): build index on the bit vector of each word

## FastText[^fastText]

- Word in dataset's metadata -> embedding vector

- Embedding vector represent the semantics of words

- Embedding vectors are learned from wikipedia articles

[^fastText]: A. Joulin, E. Grave, P. Bojanowski, T. Mikolov, [*Bag of Tricks for Efficient Text Classification*](https://arxiv.org/abs/1607.01759)

## FastText (Cont.)

- closeness or similarity of vectors := Cosine-Similarity

- Closer a pair of vectors, closer the semantics of the two words

- Example: King and Queen have high cosine similarity

\begin{figure}
\includegraphics[scale=0.35]{cosine_similarity.png}
\end{figure}

## Simhash

- Embedding Vector -> Bit Vector

- Word: [puple, blue, green]

  - Neighbor: [1, 1, 0]

  - Family: [1, 0, 0]

  - King: [0, 0, 0]

  - Queen: [0, 0, 0]

\begin{figure}
\includegraphics[scale=0.35]{sim_hash.png}
\end{figure}

## Locality Sensitive Hashing (LSH)

- Underlying data structure: Hash Table

  - Predefined # of buckets

- Insert SimHashed embedding vectors into hash table

- Collitions in hash table buckets are candidate pairs. 

## SimHash LSH (Cont.)

- Predefined # of hash tables

- Query each hash table for M candidates

  - $M \geq k$

- Order M candidates into a top-k list by the cosine similairty of embedding 
vectors

## Problem with SimHash LSH

- The # of hash tables and # of buckets in each hash table must be 
**hand tuned**

- Must be retuned when data size significantly changes

\begin{figure}
\includegraphics[scale=0.6]{lsh_problem.png}
\end{figure}

## LSH Forest[^lshforest]

- Underlying data structure: Prefix Tree or Trie

- Similar to LSH

  - Predefined # of prefix trees

  - Ascend each prefix tree for M candidates

    - $M \geq k$

[^lshforest]: Mayank Bawa, Tyson Condie, and Prasanna Ganesan. 2005. [*LSH forest: self-tuning indexes for similarity search*](https://doi.org/10.1145/1060745.1060840)

## LSH Forest (Cont.)

- Variable length hashing in prefix tree solves LSH's problems

\begin{figure}
\includegraphics[scale=0.4]{prefix_tree.png}
\end{figure}

  - Add Bit Vector: [0, 0, 1, ...]

\begin{figure}
\includegraphics[scale=0.4]{prefix_tree_add.png}
\end{figure}

- Prefix Tree expands and contracts to account for # of embedding vectors

  - Thus, no hand tuning

## Review

- FastText: Word in Metadata -> Embedding vector

- SimHash: Embedding Vector -> Bit Vector

- LSH Forest: Index on Bit Vectors 

## Answering Queries

- Query the index with each keyword in the keyword list

- Add the results to a list

- Rank datasets by how often they appear in the list

## Problems

- No semantic relationships **between** words

  - Example: Keyword List := "traffic violations"

    - Produces good results for "traffic" and "violations", but not 
    "traffic violations"

# Future work

## Future work

- Improve ability to see semantic relationships between words

- Organize datasets into a directory structure

- Use semantic similarity of column names in unionable table search.

- Similar dataset search based on metadata similarity.

- Keyword search over data values.
