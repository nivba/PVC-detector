# PVC-detector
Premature ventricular contraction detection tool, Created for the benefit of a course project at Ben Gurion University.
PVC detection, using KNN applied to features extracted from one-lead ECG Signal.

you can run the project easily from 'main.m' file with MATLAB 2020. Note that the database and program folders should have the same path.


Graphs are avirable in the repository Wiki.
#
"A premature ventricular contraction (PVC) is a relatively common event where the heartbeat is initiated by Purkinje fibers in the ventricles rather than by the sinoatrial node. PVCs may cause no symptoms or may be perceived as a "skipped beat" or felt as palpitations in the chest. Single beat PVCs do not usually pose a danger" (Wikipedia)
#
Steps: 
1) preprocessing.
2) bit detection (QRS detection).
3) features extraction.
4) features selection.
5) 2 class bit classification (pvc and non-pvc).

DATA-BASE:
10 ECG recordings drawn from MIT-BIH Arrhythmia Database: https://www.physionet.org/content/mitdb/1.0.0/


