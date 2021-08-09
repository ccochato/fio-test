#!/usr/bin/env python
# coding: utf-8

# # FIO plots

# In[1]:


import os
import json
import numpy as np
import matplotlib as mpl
from matplotlib import cm
import matplotlib.pyplot as plt


# In[2]:


def bw_ios3(filename, fiorw, option):
    '''
    Function to read BW or IOPS from a json file
    
    Input:
        filaname :: json name file (include the path)
        fio      :: read, write, etc.
        option   :: iops, bw_bytes, runtime, etc. 
    NOTE: All the inputs are str type.
    '''
    with open(filename) as f:
        data = json.load(f)
    return data['jobs'][0][fiorw][option]


# In[3]:


def plot_bw_iops(HOME, fiobs, fiojobs):
    '''
    Function to plot total BW & IOPS using HOME files for n nodes and n fio_jobs
    '''
    #Plot environment
    fig, ax = plt.subplots(nrows = 1, ncols = 2, figsize=(18, 6))

    dataset = [{"data": []}]
    
    histo = []
    for fjob in fiojobs:
        total_flow = []
        total_fio_bw = []
        total_fio_iops = []
        
        for bs in fiobs:
            path=HOME+str(bs)+'k_bs/'
            content=os.listdir(path)
            fiojob = [s for s in content if str(fjob)+'_fiojob' in s]
            
            if len(fiojob)>1:
                if len(fiojob[0])<len(fiojob[1]): fiojob=fiojob[0]
                else: fiojob = fiojob[1]
            else:
                fiojob= fiojob[0]
            
            fio_bw= bw_ios3(path+fiojob+"/output.json","read", 'bw_bytes')*1e-6 #in Mb/s
            fio_iops= bw_ios3(path+fiojob+"/output.json", "read", 'iops')*1e-3      #in k
            #fio_jobs+= bw_ios3(path+fiojob+"/"+folder+"/output.json", " ", 'numjobs')*1e-3      #in k
            fio_jobs=fjob
                
            total_fio_bw.append(fio_bw)
            total_fio_iops.append(fio_iops)
            histo.append(fio_bw)

        #plt.plot(nodes,total_flow, '--',label='fio_tjob='+str(fjob))
        ax[0].plot(fiobs,total_fio_bw,'o--',label='fio_job='+str(fjob))
        ax[1].plot(fiobs,total_fio_iops,'o--',label='fio_job='+str(fjob))                 
        
    ax[0].legend()
    ax[0].set_xticks(fiobs)
    ax[0].set_xlabel('bs', size=16)
    ax[0].set_ylabel('MB/s', size=16)
    ax[0].set_title("Total Bandwidth vs. n bs", size=20)

    ax[1].legend()
    ax[1].set_xticks(fiobs)
    ax[1].set_xlabel('bs')
    ax[1].set_ylabel('kIOPS')
    ax[1].set_title("Total IOPS vs. n nodes")
    plt.savefig('seqread.png')
    
    plot_3d(fiobs, fiojobs, histo)


# In[4]:



def plot_3d(nodes, numjobs, data):
    """This function is responsible for plotting the entire 3D plot."""


    iodepth = nodes
    numjobs = fiojobs
    z_axis_label = 'Bandwidth MB/s'
    
    fig = plt.figure()
    ax1 = fig.add_subplot(projection="3d", elev=25)
    fig.set_size_inches(15, 10)
    ax1.set_box_aspect((4, 4, 3), zoom=1.2)

    lx = len(nodes)
    ly = len(numjobs)

    n = np.array(data, dtype=float)

    if lx < ly:
        size = ly * 0.03  # thickness of the bar
    else:
        size = lx * 0.05  # thickness of the bar

    xpos_orig = np.arange(0, lx, 1)
    ypos_orig = np.arange(0, ly, 1)

    xpos = np.arange(0, lx, 1)
    ypos = np.arange(0, ly, 1)
    xpos, ypos = np.meshgrid(xpos - (size / lx), ypos - (size * (ly / lx)))

    xpos_f = xpos.flatten()  # Convert positions to 1D array
    ypos_f = ypos.flatten()

    zpos = np.zeros(lx * ly)

    # Positioning and sizing of the bars
    dx = size * np.ones_like(zpos)
    dy = size * (ly / lx) * np.ones_like(zpos)
    dz = n.flatten(order="F")
    values = dz / (dz.max() / 1)

    # Create the 3D chart with positioning and colors
    cmap = plt.get_cmap("rainbow", xpos.ravel().shape[0])
    colors = cm.rainbow(values)
    ax1.bar3d(xpos_f, ypos_f, zpos, dx, dy, dz, color=colors, zsort="max")

    # Create the color bar to the right
    norm = mpl.colors.Normalize(vmin=0, vmax=dz.max())
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm)
    sm.set_array([])
    res = fig.colorbar(sm, fraction=0.046, pad=0.19)
    res.ax.set_title(z_axis_label)

    # Set tics for x/y axis
    float_x = [float(x) for x in (xpos_orig)]

    ax1.w_xaxis.set_ticks(float_x)
    ax1.w_yaxis.set_ticks(ypos_orig)
    ax1.w_xaxis.set_ticklabels(iodepth)
    ax1.w_yaxis.set_ticklabels(numjobs)

    # axis labels
    fontsize = 16
    ax1.set_xlabel("bs", fontsize=fontsize)
    ax1.set_ylabel("fiojob", fontsize=fontsize)
    ax1.set_zlabel(z_axis_label, fontsize=fontsize)

    [t.set_verticalalignment("center_baseline") for t in ax1.get_yticklabels()]
    [t.set_verticalalignment("center_baseline") for t in ax1.get_xticklabels()]

    ax1.zaxis.labelpad = 25

    tick_label_font_size = 12
    for t in ax1.xaxis.get_major_ticks():
        t.label.set_fontsize(tick_label_font_size)

    for t in ax1.yaxis.get_major_ticks():
        t.label.set_fontsize(tick_label_font_size)

    ax1.zaxis.set_tick_params(pad=10)
    for t in ax1.zaxis.get_major_ticks():
        t.label.set_fontsize(tick_label_font_size)


    plt.savefig('seqread_3d.png')


# # SEQREAD plots

# In[5]:


# SEQ_READ
HOME_seqread = "/home/ccochato/Desktop/Computing/HPC/PROJECT/CONTAINER/iotest/"
fiobs = [4, 8, 16]
fiojobs = [1, 2, 4, 8, 16]
plot_bw_iops(HOME_seqread, fiobs, fiojobs)

