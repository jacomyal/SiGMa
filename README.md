#**SiGMa** - *the Simple Graph Mapper*

- **author**: Alexis Jacomy, *alexis* dot *jacomy* at *gmail* dot *com*
- **website**: [Of Nodes And Edges](http://www.ofnodesandedges.com)

##I. Introduction

**SiGMa** is a Web graph mapper for Flash, usable, modifiable and propagatable under the conditions of the [GPL 3.0 License](http://www.gnu.org/licenses/gpl.html "GPL 3.0 license"). This project has been initiated for two reasons:

* First of all, the current state of Web graph mapping is not that accessible. There are a lot of solutions, from other Flash widgets to SeaDragon or SVG exports, but they all require the editor to use first a Graph Visualization Software to prepare the graph before. SiGMa will allow Web users to display a graph with different views, from a simple graph file. And for editors who still want to process some first treatment of the graph, SiGMa is also conceived to use some metrics or attributes from the graph file.

* Also, the source code is easy to adapt and modify for developers. The layout classes, the button classes and the loading classes are all normalized to make easy to create or use new layouts, buttons for the interface or buttons.

Finally, SiGMa's interface will be oriented along different tools, from the simple zoom to the filters, through other visualizations, etc. The user can manage the tools with a control panel, and each tool can have a specific settings panel. This aims to make it easy to add new features, and to help users to observe the graph as you want trough developer's view.

##II. Functionalities
###1. Current state
Currently, a first version of the structure has been already implemented. Also, some first features are already implemented (a quick and efficient layout, the ForceAtlas and NodeOverlap layouts from [Gephi](http://www.gephi.org/ "Gephi, the Open Graph Viz Platform"), a *GEXF* loader), and it is already possible to visualiza a graph with SiGMa.

###2. To be done
The first priority is to finish a first version of the application, flexible for the user. That involves for example the recognition of the graph file format and of course the implementation of new loaders (*.gdf*, *.csv*, etc), or the recognition of spatial coordinates. Also, when enough tools will be implemented, a formulary to select which tools to display will be done, to make SiGMa fully customable.

##III. How to use it
(*Paragraph still to be done...*)


* * * *

For any question (bugs, ideas of new features, etc...), send me an e-mail, but **check first if there isn't already an answer on the related [wiki](http://wiki.github.com/jacomyal/SiGMa/ "SiGMa GitHub wiki")**