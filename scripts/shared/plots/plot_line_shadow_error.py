import os
import pandas as pd
from pathlib import Path
import matplotlib.pyplot as plt
from matplotlib import font_manager as fm

# Load Sora font
font_path = os.path.join('excel', 'Sora-VariableFont_wght.ttf')  # tu ruta
fm.fontManager.addfont(font_path)
sora = fm.FontProperties(fname=font_path)
plt.rcParams['font.family'] = sora.get_name()

# Look for all the Excels to plot
folder = Path(os.path.join('excel','for_python_plot'))
exts = (".xlsx", ".xls")
files = [p for p in folder.iterdir() if p.suffix.lower() in exts and not p.name.startswith("~$") and not p.name.startswith("converter")]

for f in files:

    df = pd.read_excel(f,header=None,skiprows=1).iloc[:,:5]
    df.columns = ["c1","c2","c3","c4","grupo"]

    # === 2) Calcular medias y SEM por grupo ===
    media = df.groupby("grupo")[["c1","c2","c3","c4"]].mean()
    sem = df.groupby("grupo")[["c1","c2","c3","c4"]].sem()

    # === 3) Plot ===
    x = [1,2,3,4]  # eje x: c1..c4
    labels = ["Visita 1","Visita 2","Visita 3","Visita 4"]

    # Create the figure
    WIDTH_PX = 3840
    HEIGHT_PX = 2160
    DPI = 200  # resolución de guardado
    fig = plt.figure(figsize=(WIDTH_PX / DPI, HEIGHT_PX / DPI), constrained_layout=True)
    ax = fig.gca()

    for grupo,color,nombre in zip([0,1],
                                  [(230/255,132/255,129/255),(161/255,198/255,235/255)],
                                  ['No conversor', 'Conversor']):

        y = media.loc[grupo]
        yerr = sem.loc[grupo]

        # Línea gruesa
        plt.plot(x,y,label=nombre,marker='o', markersize=8,color=color,linewidth=3)

        # Sombra con error
        plt.fill_between(x,y - yerr,y + yerr,color=color,alpha=0.2)

    plt.xticks(x,labels,fontsize=25)
    plt.yticks(fontsize=25)
    plt.ylabel("PLV",fontsize=25,labelpad=20)
    plt.legend(fontsize=25,frameon=False)

    # Quitar línea superior y derecha
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    plt.tight_layout()

    out_png = f.with_suffix(".png")  # mismo nombre, extensión .png
    fig.savefig(out_png, dpi=DPI, bbox_inches="tight", pad_inches=0.05)
    plt.close(fig)


files = [p for p in folder.iterdir() if p.suffix.lower() in exts and not p.name.startswith("~$") and p.name.startswith("converter")]

for f in files:

    df = pd.read_excel(f,header=None,skiprows=1).iloc[:,:3]
    df.columns = ["c1","c2","grupo"]

    # === 2) Calcular medias y SEM por grupo ===
    media = df.groupby("grupo")[["c1","c2",]].mean()
    sem = df.groupby("grupo")[["c1","c2",]].sem()

    # === 3) Plot ===
    x = [1,2]  # eje x: c1..c4
    labels = ["Pre Conversion","Post Conversion"]

    # Create the figure
    WIDTH_PX = 3840
    HEIGHT_PX = 2160
    DPI = 200  # resolución de guardado
    fig = plt.figure(figsize=(WIDTH_PX / DPI, HEIGHT_PX / DPI), constrained_layout=True)
    ax = fig.gca()

    for grupo,color,nombre in zip([0,1],
                                  [(230/255,132/255,129/255),(161/255,198/255,235/255)],
                                  ['No conversor', 'Conversor']):

        y = media.loc[grupo]
        yerr = sem.loc[grupo]

        # Línea gruesa
        plt.plot(x,y,label=nombre,marker='o', markersize=8,color=color,linewidth=3)

        # Sombra con error
        plt.fill_between(x,y - yerr,y + yerr,color=color,alpha=0.2)

    plt.xticks(x,labels,fontsize=25)
    plt.yticks(fontsize=25)
    plt.ylabel("PLV",fontsize=25,labelpad=20)
    plt.legend(fontsize=25,frameon=False)

    # Quitar línea superior y derecha
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    plt.tight_layout()

    out_png = f.with_suffix(".png")  # mismo nombre, extensión .png
    fig.savefig(out_png, dpi=DPI, bbox_inches="tight", pad_inches=0.05)
    plt.close(fig)