
""" 
Set up the plot figures, axes, and items to be done for each frame.

This module is imported by the plotting routines and then the
function setplot is called to set the plot parameters.
    
""" 

import setrun
rundata = setrun.setrun()
#--------------------------
def setplot(plotdata):
#--------------------------
    
    """ 
    Specify what is to be plotted at each frame.
    Input:  plotdata, an instance of clawpack.visclaw.data.ClawPlotData.
    Output: a modified version of plotdata.
    
    """ 


    plotdata.clearfigures()  # clear any old figures,axes,items data



    # Figure for q[0]
    plotfigure = plotdata.new_plotfigure(name='rho[t]', figno=1)

    # Set up for axes in this figure:
    plotaxes = plotfigure.new_plotaxes(name='Solution')
    plotaxes.xlimits = [-2,2]
    plotaxes.ylimits = [-0.1, 1.1]
    plotaxes.title = 'rho[t]'

    # Set up for item on these axes:
    plotitem = plotaxes.new_plotitem(name='solution', plot_type='1d')
    plotitem.plot_var = 0
    plotitem.plotstyle = '-o'
    plotitem.color = 'b'
    plotaxes.afteraxes = plot_true_soln
    plotitem.show = True       # show on plot?
    
    # Parameters used only when creating html and/or latex hardcopy
    # e.g., via clawpack.visclaw.frametools.printframes:

    plotdata.printfigs = True                # print figures
    plotdata.print_format = 'png'            # file format
    plotdata.print_framenos = 'all'          # list of frames to print
    plotdata.print_fignos = 'all'            # list of figures to print
    plotdata.html = True                     # create html files of plots?
    plotdata.latex = True                    # create latex file of plots?
    plotdata.latex_figsperline = 2           # layout of plots
    plotdata.latex_framesperline = 1         # layout of plots
    plotdata.latex_makepdf = False           # also run pdflatex?
    
    return plotdata


#-------------------
def plot_true_soln(current_data):
#-------------------
    import numpy as np
    from pylab import plot

    xlower = rundata.clawdata.lower[0]
    xupper = rundata.clawdata.upper[0]
    rhom = 0.5
    gamma = 0.5

    ql = rundata.probdata.ql
    qr = rundata.probdata.qr
    t = current_data.t
    if qr < rhom and ql > rhom:
        s = (gamma*(1.-ql)-0.5)/(ql-rhom)
        plot([-2,s*t,s*t,t,t,2],[ql,ql,rhom,rhom,qr,qr],'-r',linewidth=2.)
    elif ql < rhom and qr > rhom and ql > gamma/(1.+gamma):
        s = (gamma*(1.-rhom)-ql)/(rhom-ql)
        plot([-2,s*t,s*t,-gamma*t,-gamma*t,2],[ql,ql,rhom,rhom,qr,qr],'-r',linewidth=2.)
    elif ql < rhom and qr > rhom and ql <= gamma/(1.+gamma):
        s = (gamma*(1.-qr)-ql)/(qr-ql)
        plot([-2,s*t,s*t,2],[ql,ql,qr,qr],'-r',linewidth=2.)
    else:
        print 'Not valid ql qr value!'
