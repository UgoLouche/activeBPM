# activeBPM

Source code for the experiments presented in the paper 'From Cutting Planes Algorithms to Compression Schemes and Active Learning' (Ugo Louche and Liva Ralaivola at IJCNN 2015). 

#####Dependencies
The provided code requires the following MatLab Libraries
- libSVM: https://www.csie.ntu.edu.tw/~cjlin/libsvm/
- Minka's Lightspeed toolbox: http://research.microsoft.com/en-us/um/people/minka/software/lightspeed/
- Minka's Bayes Point Machine toolbox: http://research.microsoft.com/en-us/um/people/minka/papers/ep/bpm/

These libraries can be found in the libs directory

#####Dataset
The datasets used in the publication come from three datasets: Gunnar Raesch, Reuter and Newsgroup datasets. For simplicity sake, and because some code directly reference said dataset, the files are included in the src repository. 

#####Content
The src folder contains the original Matlab source code. This includes both the source code for the core Active-BPM algorithm as well as the specific code for the published experiments of the aforementioned paper. Additional, experimental, implementations of the discussed algorithms are also available although they may not work at all in its current state.

The File 'MinkaVsTong.m' should contain sufficient code to reproduce most of the result presented in our publication. Additionally, this file should give a good overview of which source files belong to the final build and which don't.

###TODO
- Separate Dataset From source / modify sources to reflect that
- Clean / sort src folder and rework files name
- Ensure libraries import correctly on a new Matlab environment.

