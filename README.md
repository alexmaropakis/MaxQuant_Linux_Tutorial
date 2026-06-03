# MaxQuant for Linux Tutorial 

Due to sparse official documentation, Albert Chen wrote a [Guide to MaxQuant in Linux](https://github.com/atc3/maxquant_linux_guide/tree/master) in 2019 for beginner users. It has been many years since then, so this guide is targeted toward more recent beginners planning to run more recent versions of MaxQuant in Linux. This tutorial is optimized for [Northeastern University's Research Computing Cluster](https://rc.northeastern.edu/), which is hosted at the [Massachusetts Green High-Performance Computing Center (MGHPCC)](https://mghpcc.org/) in Holyoke, MA. 

## Pipeline
1. Download MaxQuant version into home directory
2. Download software framework dependencies into home directory
3. Create template mqpar.xml files in the MaxQuant GUI
4. Move FASTA files into Linux instance
5. Run ```gen_mqXML.py``` script to generate mqpar.xml 
6. Run MaxQuant! 

## Setting up MaxQuant in Linux 

The most recent MaxQuant version can be accessed via an academic license [here](https://maxquant.org/download_asset/maxquant/latest). See their YouTube channel for [tutorials](https://maxquant.org/youtube/) on how to use MaxQuant. Older MaxQuant versions can be accessed [here](https://drive.google.com/drive/u/1/folders/1Ja9iaCQ6mM66VQEeaS36hqq77bnsmxQF). 

Download the wanted zip file and put it into your desired directory. 

Run these commands:
```
mkdir /home/maropakis.a/MQ
cd MQ
unzip MaxQuant_v2.8.0.0.zip
rm MaxQuant_v2.8.0.0.zip

MQ_2_8_0_0="/home/maropakis.a/MQ/MaxQuant_v2.8.0.0/bin/MaxQuantCmd.dll"
source ~/.bashrc 
```

## Setting up Software Frameworks 

MaxQuant is built in C# and relies entirely on software infrastructures such as mono or .NET to handle massive computations and data processing.

### Mono 

If your computing environment is equipped with [Mono](https://www.mono-project.com/download/stable/#download-lin), a cross-platform implementation of the .NET framework, you should be able to run MaxQuant with the simple command:

```
srun mono </path/to/MaxQuantCmd.exe> (or *.dll for more recent MQ versions) </path/to/mqpar.xml>
```

This requires Mono Framework >= v5.4.1. Version can be checked using ``` mono --version ``` on the terminal. 

### .NET 

If your computing environment is not equipped with Mono, it is easier to install the .NET version needed for your chosen MaxQuant version and install that into your environment instead. When you download and unzip your MaxQuant version, it will contain instructions for what .NET version is required. 

Here is an example SLURM script ```dotnet.sh``` for downloading .NET into your home directory: 

```
#!/bin/bash 

mkdir /home/maropakis.a/dotnet
cd /home/maropakis.a/dotnet
wget https://builds.dotnet.microsoft.com/dotnet/Sdk/2.1.818/dotnet-sdk-2.1.818-linux-x64.tar.gz
tar -xzf dotnet-sdk-2.1.818-linux-x64.tar.gz
rm dotnet-sdk-2.1.818-linux-x64.tar.gz

export DOTNET_ROOT_2.1=$HOME/dotnet
export PATH=$DOTNET_ROOT_2.1:$PATH
source ~/.bashrc

echo dotnet --version

```
Run MaxQuant with this command: 

```
srun dotnet </path/to/MaxQuantCmd.exe> (or *.dll for more recent MQ versions) </path/to/mqpar.xml>
```


## Generating mqpar.xml files 

In his original tutorial, Albert Chen provided a Python script ```gen_mqpar.py``` which took a mqpar.xml template and filled it in depending on your parameters. I have slightly altered this script for my needs to produce ```gen_mqXML.py```, which takes more arguments and affords a bit more flexibility. 

To run ```gen_mqXML.py```, you must have created a template ```mqpar.xml``` file representing the configuration for a specific MaxQuant search. You should first generate these in MaxQuant GUI as it is easier to verify the validity of the .xml file before moving it into the Linux instance. 

I have added some template .xml files in the ```templates/``` folder. The generation script is in ```generation_scripts/```.

Run ```gen_mqXML.py``` like this:

```
python gen_mqXML.py </path/to/template/mqpar.xml> </path/to/raw/file/folder> -o mqpar_file_name.xml -e Experiment_name -s sample_name
```

All arguments available include:
```
parser.add_argument('input_xml', type=argparse.FileType('r', encoding='UTF-8'))
parser.add_argument('raw_file_folders', type=str, nargs='+')
parser.add_argument('-o', '--outfile', type=str, required=True)
parser.add_argument('-e', '--experiment', type=str, required=True, help='Experiment name, e.g. Takasugi_2024')
parser.add_argument('-s', '--sample', type=str, required=True, help='Sample / MQ experiment label, e.g. S3 or 3')
parser.add_argument('-mq', '--mq-version', type=str, default='1_6_17_0', help='MaxQuant version, e.g. 1_6_17_0')
parser.add_argument('-t', '--threads', type=int, default=8, help='Number of threads to use')
parser.add_argument('--species', choices=['human', 'mouse'], default='human', help='Species used to choose default FASTA path')
parser.add_argument('--fasta-path', type=str, default=None, help='Optional FASTA path. Overrides --species default.')
parser.add_argument('--search-type', type=str, default='DP', choices=['DP', 'Val'], help='MQ output search type')
parser.add_argument('--partition', type=str, default='slavov', help='SLURM partition')
parser.add_argument('--mem', type=str, default='16Gb', help='SLURM memory')
```
This will also output a SLURM script that you can then submit with ```sbatch filename.sh``` to run MaxQuant. 
