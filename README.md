Playground for turning BLASTDBs into Parquet

gs://camacho-test/nr/nr.parquet: 54.52GB
gs://camacho-test/nr/nr.*-meta.csv: 170.93GB

Notes
-----

Using 4 node cluster (4x n1-std-16 (16vCPU, 60GB RAM), 1 emphemeral)
Took ~6 mins to convert. Note: only 8 executors were used
JobId: ec4daf8de71347f2bcd79d606c1f9208

Searching for residues
nr.parquet
* split into 649 partitions
* 174 secs to scan 1st time, 112 second times (158, 86,86)

JobId:  3b5bd93dedc548359d544b56883524af
 6598d2ae3d0948ca8ef2454f6a777d95
