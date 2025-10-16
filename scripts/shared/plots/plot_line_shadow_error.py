########################
#
# Plot different measures using the standard error of the mean as shadow behind the mean
#
# 05/10/2025
# Federico Ramírez Toraño
########################

# Imports
import os
from pathlib import Path

import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import font_manager as fm

# Load Sora font
font_path = os.path.join('excel', 'Sora-VariableFont_wght.ttf')  # tu ruta
fm.fontManager.addfont(font_path)
sora = fm.FontProperties(fname=font_path)
plt.rcParams['font.family'] = sora.get_name()

#########################################
# Global PLV

# Look for all the Excels to plot
folder = Path(os.path.join('excel','for_python_plot','global_plv'))
exts = (".xlsx", ".xls")
files = [p for p in folder.iterdir() if p.suffix.lower() in exts and not p.name.startswith("~$")]

for f in files:

    # Remove the first rom (header)
    df = pd.read_excel(f,header=None,skiprows=1).iloc[:,:5]
    df.columns = ["c1","c2","c3","c4","group"]

    # Mean and SEM
    mean = df.groupby("group")[["c1","c2","c3","c4"]].mean()
    sem = df.groupby("group")[["c1","c2","c3","c4"]].sem()

    # Create the figure
    WIDTH_PX = 3840
    HEIGHT_PX = 2160
    DPI = 200  # resolución de guardado
    fig = plt.figure(figsize=(WIDTH_PX / DPI, HEIGHT_PX / DPI), constrained_layout=True)
    ax = fig.gca()

    for group,color,group_name in zip([0, 1],
                                      [(161 / 255, 198 / 255, 235 / 255), (230 / 255, 132 / 255, 129 / 255)],
                                      ['No conversor', 'Conversor']):

        # Data to
        x = [1, 2, 3, 4]
        y = mean.loc[group]
        yerr = sem.loc[group]

        # Mean +- SEM shadow
        plt.plot(x, y, label=group_name, marker='o', markersize=8, color=color, linewidth=3)
        plt.fill_between(x,y - yerr,y + yerr,color=color,alpha=0.2)

    # Enhance the plot
    plt.xticks(x,["Visita 1","Visita 2","Visita 3","Visita 4"],fontsize=25)
    plt.yticks(fontsize=25)
    plt.ylabel("PLV",fontsize=25,labelpad=20)
    plt.legend(fontsize=25,frameon=False)

    # Remove top and right line
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    # Force everything to be inside the plot area
    plt.tight_layout()

    # Save and close
    out_png = f.with_suffix(".png")  # mismo nombre, extensión .png
    fig.savefig(out_png, dpi=DPI, bbox_inches="tight", pad_inches=0.05)
    plt.close(fig)


#########################################
# Global POW

# Look for all the Excels to plot
folder = Path(os.path.join('excel','for_python_plot','global_pow'))
exts = (".xlsx", ".xls")
files = [p for p in folder.iterdir() if p.suffix.lower() in exts and not p.name.startswith("~$")]

for f in files:

    # Remove the first rom (header)
    df = pd.read_excel(f,header=None,skiprows=1).iloc[:,:5]
    df.columns = ["c1","c2","c3","c4","group"]

    # Mean and SEM
    mean = df.groupby("group")[["c1","c2","c3","c4"]].mean()
    sem = df.groupby("group")[["c1","c2","c3","c4"]].sem()

    # Create the figure
    WIDTH_PX = 3840
    HEIGHT_PX = 2160
    DPI = 200  # resolución de guardado
    fig = plt.figure(figsize=(WIDTH_PX / DPI, HEIGHT_PX / DPI), constrained_layout=True)
    ax = fig.gca()

    for group,color,group_name in zip([0, 1],
                                      [(161 / 255, 198 / 255, 235 / 255), (230 / 255, 132 / 255, 129 / 255)],
                                      ['No conversor', 'Conversor']):

        # Data to plot
        x = [1, 2, 3, 4]
        y = mean.loc[group]
        yerr = sem.loc[group]

        # Mean +- SEM shadow
        plt.plot(x, y, label=group_name, marker='o', markersize=8, color=color, linewidth=3)
        plt.fill_between(x,y - yerr,y + yerr,color=color,alpha=0.2)

    # Enhance the plot
    plt.xticks(x,["Visita 1","Visita 2","Visita 3","Visita 4"],fontsize=25)
    plt.yticks(fontsize=25)
    plt.ylabel("Pow",fontsize=25,labelpad=20)
    plt.legend(fontsize=25,frameon=False)

    # Remove top and right line
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    # Force everything to be inside the plot area
    plt.tight_layout()

    # Save
    out_png = f.with_suffix(".png")  # mismo nombre, extensión .png
    fig.savefig(out_png, dpi=DPI, bbox_inches="tight", pad_inches=0.05)
    plt.close(fig)

#########################################
# Ratio PLV

# Look for all the Excels to plot
folder = Path(os.path.join('excel','for_python_plot','baseline_plv'))
exts = (".xlsx", ".xls")
files = [p for p in folder.iterdir() if p.suffix.lower() in exts and not p.name.startswith("~$")]

for f in files:

    # Remove the first rom (header)
    df = pd.read_excel(f,header=None,skiprows=1).iloc[:,:3]
    df.columns = ["c1","c2","group"]

    # Mean and SEM
    mean = df.groupby("group")[["c1","c2"]].mean()
    sem = df.groupby("group")[["c1","c2"]].sem()

    # Create the figure
    WIDTH_PX = 3840
    HEIGHT_PX = 2160
    DPI = 200  # resolución de guardado
    fig = plt.figure(figsize=(WIDTH_PX / DPI, HEIGHT_PX / DPI), constrained_layout=True)
    ax = fig.gca()

    for group,color,group_name in zip([0, 1],
                                      [(161/255,198/255,235/255),(230/255,132/255,129/255)],
                                      ['No conversor', 'Conversor']):

        # Data to plot
        x = [1,2]
        y = mean.loc[group]
        yerr = sem.loc[group]

        # Mean +- SEM shadow
        plt.plot(x, y, label=group_name, marker='o', markersize=8, color=color, linewidth=3)
        plt.fill_between(x,y - yerr,y + yerr,color=color,alpha=0.2)

    # Enhance the plot
    plt.xticks(x,["Visita 1","Última visita"],fontsize=25)
    plt.yticks(fontsize=25)
    plt.ylabel("Pow",fontsize=25,labelpad=20)
    plt.legend(fontsize=25,frameon=False)

    # Remove top and right line
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    # Force everything to be inside the plot area
    plt.tight_layout()

    # Save
    out_png = f.with_suffix(".png")  # mismo nombre, extensión .png
    fig.savefig(out_png, dpi=DPI, bbox_inches="tight", pad_inches=0.05)
    plt.close(fig)


#########################################
# Power spectrum

# Look for all the Excels to plot
folder = Path(os.path.join('excel','for_python_plot','pow_spectrum'))
exts = (".xlsx", ".xls")
files = [p for p in folder.iterdir() if p.suffix.lower() in exts and not p.name.startswith("~$") and not p.name.startswith('freqs')]

for f in files:

    # Remove the first rom (header)
    df = pd.read_excel(f,header=None,skiprows=1).iloc[:,:173]
    freqs = [f"c{i + 1}" for i in range(172)]
    c = freqs + ['group']
    df.columns = c

    # Mean and SEM
    mean = df.groupby("group")[freqs].mean()
    sem = df.groupby("group")[freqs].sem()

    # Create the figure
    WIDTH_PX = 3840
    HEIGHT_PX = 2160
    DPI = 200  # resolución de guardado
    fig = plt.figure(figsize=(WIDTH_PX / DPI, HEIGHT_PX / DPI), constrained_layout=True)
    ax = fig.gca()

    for group,color,group_name in zip([0, 1],
                                      [(161/255,198/255,235/255),(230/255,132/255,129/255)],
                                      ['No conversor', 'Conversor']):

        # Data to plot
        x = range(172)
        y = mean.loc[group]
        yerr = sem.loc[group]

        # Mean +- SEM shadow
        plt.plot(x, y, label=group_name, color=color, linewidth=3)
        plt.fill_between(x,y - yerr,y + yerr,color=color,alpha=0.2)

    # Enhance the plot
    plt.ylim(0, 0.045)
    plt.xticks([0,171],["2","45"],fontsize=25)
    plt.yticks(fontsize=25)
    plt.ylabel("Pow",fontsize=25,labelpad=20)
    plt.xlabel('Hz',fontsize=25,labelpad=20)
    plt.legend(fontsize=25,frameon=False)

    # Remove top and right line
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    # Force everything to be inside the plot area
    plt.tight_layout()

    # Save
    out_png = f.with_suffix(".png")  # mismo nombre, extensión .png
    fig.savefig(out_png, dpi=DPI, bbox_inches="tight", pad_inches=0.05)
    plt.close(fig)
